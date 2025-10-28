const { Schema, model } = require('mongoose');

const ExamSectionSchema = new Schema({
  topic: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
  numQuestions: { type: Number, required: true, min: 1 },
  weight: { type: Number, default: 0 }
}, { _id: true });

const ExamSchema = new Schema({
  code: { type: String, required: true, unique: true, trim: true },
  title: { type: String, required: true },
  durationMinutes: { type: Number, default: 90 },
  mode: { type: String, enum: ['fixed_pool','randomized'], default: 'randomized' },
  isActive: { type: Boolean, default: true },
  sections: { type: [ExamSectionSchema], default: [] },
  questionPool: [{ question: { type: Schema.Types.ObjectId, ref: 'Question' } }]
}, { timestamps: true });

ExamSchema.index({ isActive: 1 });
module.exports = model('Exam', ExamSchema);
