const { Schema, model } = require('mongoose');

const TopicTranslationSchema = new Schema({
  lang: { type: String, required: true },
  title: String,
  description: String
}, { _id: false });

const TopicSchema = new Schema({
  parent: { type: Schema.Types.ObjectId, ref: 'Topic', default: null },
  code: { type: String, required: true, unique: true, trim: true },
  level: { type: Number, default: 1 },
  isActive: { type: Boolean, default: true },
  translations: { type: [TopicTranslationSchema], default: [] }
}, { timestamps: true });

TopicSchema.index({ parent: 1 });
TopicSchema.index({ 'translations.lang': 1 });
module.exports = model('Topic', TopicSchema);
