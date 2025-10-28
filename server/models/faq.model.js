const { Schema, model } = require('mongoose');

const FaqI18nSchema = new Schema({
  lang: { type: String, required: true },
  question: String,
  answer: String
}, { _id: false });

const FAQSchema = new Schema({
  category: { type: String, default: 'General' },
  isActive: { type: Boolean, default: true },
  translations: { type: [FaqI18nSchema], default: [] }
}, { timestamps: true });

FAQSchema.index({ category: 1, isActive: 1 });
module.exports = model('FAQ', FAQSchema);
