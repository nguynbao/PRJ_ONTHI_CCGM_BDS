const { Schema, model } = require('mongoose');

const AnnI18nSchema = new Schema({
  lang: { type: String, required: true },
  title: String,
  content: String
}, { _id: false });

const AnnouncementSchema = new Schema({
  type: { type: String, enum: ['exam_update','policy','news'], required: true },
  publishedAt: { type: Date, default: Date.now },
  isPinned: { type: Boolean, default: false },
  translations: { type: [AnnI18nSchema], default: [] }
}, { timestamps: true });

AnnouncementSchema.index({ type: 1, publishedAt: -1 });
module.exports = model('Announcement', AnnouncementSchema);
