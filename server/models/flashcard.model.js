const { Schema, model } = require('mongoose');

const CardI18nSchema = new Schema({
  lang: { type: String, required: true },
  front: { type: String, required: true },
  back: { type: String, required: true }
}, { _id: false });

const FlashcardSchema = new Schema({
  deck: { type: Schema.Types.ObjectId, ref: 'FlashcardDeck', required: true, index: true },
  order: { type: Number, default: 1 },
  translations: { type: [CardI18nSchema], default: [] }
}, { timestamps: true });

FlashcardSchema.index({ deck: 1, order: 1 });
module.exports = model('Flashcard', FlashcardSchema);
