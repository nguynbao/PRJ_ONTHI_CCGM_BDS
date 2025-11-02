const { Schema, model } = require('mongoose');

const AuthUserSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  provider: { type: String, enum: ['email_password','otp'], required: true, default: 'email_password' },
  email: { type: String, lowercase: true, trim: true, index: true, sparse: true },
  passwordHash: { type: String },
  lastLoginAt: { type: Date }
}, { timestamps: true });

// Duy nhất theo (provider,email) – cho đăng nhập mật khẩu
AuthUserSchema.index({ provider: 1, email: 1 }, { unique: true, sparse: true });

module.exports = model('AuthUser', AuthUserSchema);
