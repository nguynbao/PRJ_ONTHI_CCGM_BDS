const { Schema, model } = require('mongoose');

const DeckI18nSchema = new Schema({
  lang: { type: String, required: true },
  title: String,
  description: String
}, { _id: false });

const FlashcardDeckSchema = new Schema({
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
  code: { type: String, required: true, unique: true, trim: true },
  isActive: { type: Boolean, default: true },
  translations: { type: [DeckI18nSchema], default: [] }
}, { timestamps: true });

FlashcardDeckSchema.index({ topic: 1, isActive: 1 });
module.exports = model('FlashcardDeck', FlashcardDeckSchema);
