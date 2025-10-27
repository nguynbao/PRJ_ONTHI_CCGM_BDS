const bcrypt = require('bcrypt');
const { AuthUser } = require('../models');
const jwt = require('jsonwebtoken');

async function register(email, password) {
    const existing = await AuthUser.findOne({ email });
    if (existing) throw new Error('EMAIL_EXISTS');

    const passwordHash = password ? await bcrypt.hash(password, 10) : undefined;
    const user = await AuthUser.create({ email, passwordHash, isActive: true });
    return { id: user._id, email: user.email };
}
async function login(email, password) {
    const user = await AuthUser.findOne({ email });
    if (!user || !user.passwordHash) throw new Error('INVALID_CREDENTIALS');

    const ok = await bcrypt.compare(password, user.passwordHash);
    if (!ok) throw new Error('INVALID_CREDENTIALS');


    return { id: user._id, email: user.email };
}

function verifyToken(token) {
    const secret = process.env.JWT_SECRET || 'dev-secret-change-me';
    return jwt.verify(token, secret);
}

module.exports = { register, login, verifyToken };