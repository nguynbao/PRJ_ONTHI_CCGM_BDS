const { Schema, model } = require('mongoose');

const TermI18nSchema = new Schema({
  lang: { type: String, required: true },
  term: String,
  definition: String
}, { _id: false });

const GlossaryTermSchema = new Schema({
  slug: { type: String, required: true, unique: true, trim: true },
  isActive: { type: Boolean, default: true },
  translations: { type: [TermI18nSchema], default: [] }
}, { timestamps: true });

GlossaryTermSchema.index({ 'translations.lang': 1 });
module.exports = model('GlossaryTerm', GlossaryTermSchema);
