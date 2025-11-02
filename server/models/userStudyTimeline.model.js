const { Schema, model } = require('mongoose');

const UserStudyTimelineSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', index: true, required: true },
  session: { type: Schema.Types.ObjectId, ref: 'TestSession', required: true },
  topic: { type: Schema.Types.ObjectId, ref: 'Topic' },
  scorePercent: { type: Number, default: 0 }
}, { timestamps: true });

UserStudyTimelineSchema.index({ user: 1, createdAt: -1 });
module.exports = model('UserStudyTimeline', UserStudyTimelineSchema);
