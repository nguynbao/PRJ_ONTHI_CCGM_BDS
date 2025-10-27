const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const NotificationSchema = new Schema({
    user: { type: Types.ObjectId, ref: 'AuthUser' }, // null = broadcast
    title: { type: String, required: true },
    body: { type: String },
    deepLink: { type: String },
    scheduledAt: { type: Date },
    sentAt: { type: Date }
}, { timestamps: true });

module.exports = mongoose.model('Notification', NotificationSchema);
