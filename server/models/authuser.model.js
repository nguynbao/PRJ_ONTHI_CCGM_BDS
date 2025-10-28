const { Schema, model } = require('mongoose');

const AuthUserSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  provider: { type: String, enum: ['email_password','otp'], required: true },
  email: { type: String, index: true, sparse: true, lowercase: true, trim: true },
  passwordHash: { type: String },
  lastLoginAt: { type: Date }
}, { timestamps: true });

AuthUserSchema.index({ provider: 1, email: 1 }, { unique: true, sparse: true });
module.exports = model('AuthUser', AuthUserSchema);
