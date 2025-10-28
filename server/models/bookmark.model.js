const { Schema, model } = require('mongoose');

const BookmarkSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  question: { type: Schema.Types.ObjectId, ref: 'Question', required: true, index: true },
  createdAt: { type: Date, default: Date.now }
}, { timestamps: false });

BookmarkSchema.index({ user: 1, question: 1 }, { unique: true });
module.exports = model('Bookmark', BookmarkSchema);
