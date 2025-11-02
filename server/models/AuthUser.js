const mongoose = require('mongoose');
const { Schema } = mongoose;

const AuthUserSchema = new Schema({
    email: { type: String, required: true, unique: true, trim: true, max_length: 254 },
    passwordHash: { type: String },                  // null nếu OTP-only
    isActive: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('AuthUser', AuthUserSchema);
