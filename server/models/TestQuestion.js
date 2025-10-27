const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const TestQuestionSchema = new Schema({
    testSession: { type: Types.ObjectId, ref: 'TestSession', required: true, index: true },
    question: { type: Types.ObjectId, ref: 'Question', required: true, index: true },
    orderNo: { type: Number, required: true },
    answeredAt: { type: Date },
    isCorrect: { type: Boolean },
    responseText: { type: String },
    answer: { type: Types.ObjectId, ref: 'AnswerOption' } // chỉ 1 đáp án
}, { timestamps: true });

module.exports = mongoose.model('TestQuestion', TestQuestionSchema);
