const { Schema, model } = require('mongoose');

const OptionI18nSchema = new Schema({
  lang: { type: String, required: true },
  label: { type: String, required: true }
}, { _id: false });

const QuestionOptionSchema = new Schema({
  isCorrect: { type: Boolean, default: false },
  order: { type: Number, default: 1 },
  translations: { type: [OptionI18nSchema], default: [] }
}, { _id: true });

const QuestionI18nSchema = new Schema({
  lang: { type: String, required: true },
  stem: { type: String, required: true },
  explanation: { type: String }
}, { _id: false });

const QuestionSchema = new Schema({
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', index: true, required: true },
  type: { type: String, enum: ['single_choice','multiple_choice','true_false'], required: true },
  difficulty: { type: String, enum: ['easy','medium','hard'], default: 'medium' },
  isActive: { type: Boolean, default: true },
  explanationMedia: Schema.Types.Mixed, // { url, type, ... }
  translations: { type: [QuestionI18nSchema], default: [] },
  options: { type: [QuestionOptionSchema], default: [] }
}, { timestamps: true });

QuestionSchema.index({ isActive: 1, topic: 1, difficulty: 1 });
QuestionSchema.index({ 'translations.lang': 1 });
module.exports = model('Question', QuestionSchema);
