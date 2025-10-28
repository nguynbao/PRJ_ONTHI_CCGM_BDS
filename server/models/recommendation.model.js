const { Schema, model } = require('mongoose');

const RecommendationSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', index: true, required: true },
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
  reason: { type: String, enum: ['low_mastery','recent_drop','inactive'], required: true }
}, { timestamps: true });

RecommendationSchema.index({ user: 1, topic: 1, reason: 1 });
module.exports = model('Recommendation', RecommendationSchema);
