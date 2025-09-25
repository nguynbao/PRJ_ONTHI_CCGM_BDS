const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const UserSettingsSchema = new Schema({
    user: { type: Types.ObjectId, ref: 'AuthUser', required: true, unique: true },
    notifyPush: { type: Boolean, default: true },
    notifyEmail: { type: Boolean, default: true },
    darkMode: { type: Boolean, default: false },
    language: { type: String, default: 'vi' }
}, { timestamps: true });

module.exports = mongoose.model('UserSettings', UserSettingsSchema);
