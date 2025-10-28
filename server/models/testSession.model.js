const { Schema, model } = require('mongoose');

const SnapshotOptionSchema = new Schema({
  _id: { type: Schema.Types.ObjectId, required: true },
  label: { type: String, required: true },
  order: { type: Number, default: 1 }
}, { _id: false });

const TestSessionQuestionSnapshotSchema = new Schema({
  questionId: { type: Schema.Types.ObjectId, ref: 'Question' },
  topic: { type: Schema.Types.ObjectId, ref: 'Topic' },
  order: { type: Number, default: 1 },
  type: { type: String },
  difficulty: { type: String },
  stem: { type: String, required: true },
  options: { type: [SnapshotOptionSchema], default: [] },
  userAnswers: { type: [Schema.Types.ObjectId], default: [] },
  isCorrect: { type: Boolean, default: false },
  answeredAt: { type: Date }
}, { _id: true });

const TestSessionSchema = new Schema({
  user: { type: Schema.Types.ObjectId, ref: 'User', index: true, required: true },
  exam: { type: Schema.Types.ObjectId, ref: 'Exam' },
  mode: { type: String, enum: ['practice','mock_exam','quick_topic'], default: 'mock_exam' },
  startedAt: { type: Date },
  submittedAt: { type: Date },
  durationSeconds: { type: Number },
  scoreRaw: { type: Number, default: 0 },
  scorePercent: { type: Number, default: 0 },
  passed: { type: Boolean, default: false },
  questionsSnapshot: { type: [TestSessionQuestionSnapshotSchema], default: [] }
}, { timestamps: true });

TestSessionSchema.index({ user: 1, createdAt: -1 });
TestSessionSchema.index({ exam: 1 });
module.exports = model('TestSession', TestSessionSchema);
