const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const AnswerOptionSchema = new Schema({
    question: { type: Types.ObjectId, ref: 'Question', required: true, index: true },
    isCorrect: { type: Boolean, default: false },
    orderNo: { type: Number, required: true }
}, { timestamps: true });

module.exports = mongoose.model('AnswerOption', AnswerOptionSchema);
