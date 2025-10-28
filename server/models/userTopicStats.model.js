const { Schema, model } = require('mongoose');

const UserTopicStatsSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
  attempts: { type: Number, default: 0 },
  correct: { type: Number, default: 0 },
  lastAttemptAt: { type: Date },
  masteryPercent: { type: Number, default: 0 }
}, { timestamps: true });

UserTopicStatsSchema.index({ user: 1, topic: 1 }, { unique: true });
module.exports = model('UserTopicStats', UserTopicStatsSchema);
