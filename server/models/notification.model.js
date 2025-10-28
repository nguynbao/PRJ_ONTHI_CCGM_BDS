const { Schema, model } = require('mongoose');

const NotificationSchema = new Schema({
  type: { type: String, enum: ['new_exam','new_policy','progress_tip','system'], required: true },
  payload: { type: Schema.Types.Mixed }, // ví dụ { examId, announcementId, ... }
  createdAt: { type: Date, default: Date.now }
}, { timestamps: false });

NotificationSchema.index({ type: 1, createdAt: -1 });
module.exports = model('Notification', NotificationSchema);
