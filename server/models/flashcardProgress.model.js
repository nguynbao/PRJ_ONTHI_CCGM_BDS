const { Schema, model } = require('mongoose');

const FlashcardProgressSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
  card: { type: Schema.Types.ObjectId, ref: 'Flashcard', required: true, index: true },
  lastReviewedAt: { type: Date },
  easeFactor: { type: Number, default: 2.5 },
  intervalDays: { type: Number, default: 0 },
  streak: { type: Number, default: 0 }
}, { timestamps: true });

FlashcardProgressSchema.index({ user: 1, card: 1 }, { unique: true });
module.exports = model('FlashcardProgress', FlashcardProgressSchema);
