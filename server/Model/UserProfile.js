const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const UserProfileSchema = new Schema({
    user: { type: Types.ObjectId, ref: 'AuthUser', required: true, unique: true },
    fullName: { type: String, trim: true },
    dob: { type: Date },
    locale: { type: String, default: 'vi-VN' },
    avatarUrl: { type: String, trim: true }
}, { timestamps: true });

module.exports = mongoose.model('UserProfile', UserProfileSchema);
