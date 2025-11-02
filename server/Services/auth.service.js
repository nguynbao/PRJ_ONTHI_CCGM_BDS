const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { AuthUser, User } = require('../models'); // export index gom các model

function signToken(payload) {
  const secret = process.env.JWT_SECRET || 'dev-secret-change-me';
  return jwt.sign(payload, secret, { expiresIn: '7d' });
}

async function register(email, password) {
  if (!email || !password) {
    const e = new Error('EMAIL_PASSWORD_REQUIRED'); e.statusCode = 400; throw e;
  }
  const lower = email.toLowerCase().trim();

  // Kiểm tra tồn tại AuthUser cho provider email_password
  const exists = await AuthUser.findOne({ provider: 'email_password', email: lower });
  if (exists) { const e = new Error('EMAIL_EXISTS'); e.statusCode = 409; throw e; }

  // Tạo User rỗng (status=incomplete). Không set phone để tránh E11000
  const user = await User.create({ email: lower, status: 'incomplete' });

  const passwordHash = await bcrypt.hash(password, 10);
  const auth = await AuthUser.create({
    user: user._id,
    provider: 'email_password',
    email: lower,
    passwordHash,
    lastLoginAt: new Date()
  });

  // 👉 Theo yêu cầu: đăng ký xong chuyển sang đăng nhập để lấy token
  // Có 2 cách:
  // A) trả về "hãy đăng nhập" (front tự gọi /auth/login)
  // B) hoặc tự động sinh token luôn (đỡ 1 call)
  // Mình chọn A theo đúng mô tả của bạn:
  return { userId: user._id, email: auth.email };
}

async function login(email, password) {
  if (!email || !password) { const e = new Error('INVALID_CREDENTIALS'); e.statusCode = 401; throw e; }
  const lower = email.toLowerCase().trim();

  const auth = await AuthUser.findOne({ provider: 'email_password', email: lower });
  if (!auth) { const e = new Error('INVALID_CREDENTIALS'); e.statusCode = 401; throw e; }

  const ok = await bcrypt.compare(password, auth.passwordHash || '');
  if (!ok) { const e = new Error('INVALID_CREDENTIALS'); e.statusCode = 401; throw e; }

  // Cập nhật lastLoginAt (không blocking)
  AuthUser.updateOne({ _id: auth._id }, { $set: { lastLoginAt: new Date() } }).catch(()=>{});

  const payload = { id: auth._id.toString(), email: auth.email, userId: auth.user.toString(), provider: auth.provider };
  const token = signToken(payload);

  return { token, user: payload };
}

function verifyToken(token) {
  const secret = process.env.JWT_SECRET || 'dev-secret-change-me';
  return jwt.verify(token, secret);
}

module.exports = { register, login, verifyToken };
