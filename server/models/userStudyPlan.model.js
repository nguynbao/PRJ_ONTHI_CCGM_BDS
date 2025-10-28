const { Schema, model } = require('mongoose');

const UserPlanItemSchema = new Schema({
  dayIndex: { type: Number, required: true, min: 1 },
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
  activityType: { type: String, enum: ['read','questions','flashcards','mock_exam'], required: true },
  targetCount: { type: Number, default: 0 },
  progressCount: { type: Number, default: 0 },
  completedAt: { type: Date }
}, { _id: true });

const UserStudyPlanSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', index: true, required: true },
  template: { type: Schema.Types.ObjectId, ref: 'StudyPlanTemplate' },
  items: { type: [UserPlanItemSchema], default: [] }
}, { timestamps: true });

UserStudyPlanSchema.index({ user: 1, createdAt: -1 });
module.exports = model('UserStudyPlan', UserStudyPlanSchema);
