const { Schema, model } = require('mongoose');

const UserNotificationSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  notification: { type: Schema.Types.ObjectId, ref: 'Notification', required: true },
  isRead: { type: Boolean, default: false },
  deliveredAt: { type: Date, default: Date.now }
}, { timestamps: true });

UserNotificationSchema.index({ user: 1, notification: 1 }, { unique: true });
module.exports = model('UserNotification', UserNotificationSchema);
