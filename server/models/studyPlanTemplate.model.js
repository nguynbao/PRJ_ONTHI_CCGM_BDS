const { Schema, model } = require('mongoose');

const PlanItemSchema = new Schema({
  dayIndex: { type: Number, required: true, min: 1 },
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
  activityType: { type: String, enum: ['read','questions','flashcards','mock_exam'], required: true },
  targetCount: { type: Number, default: 0 }
}, { _id: true });

const StudyPlanTemplateSchema = new Schema({
  code: { type: String, required: true, unique: true, trim: true },
  title: { type: String, required: true },
  durationDays: { type: Number, default: 14 },
  isActive: { type: Boolean, default: true },
  items: { type: [PlanItemSchema], default: [] }
}, { timestamps: true });

module.exports = model('StudyPlanTemplate', StudyPlanTemplateSchema);
