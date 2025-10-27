const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const QuestionContentSchema = new Schema({
    question: { type: Types.ObjectId, ref: 'Question', required: true, unique: true },
    contentMd: { type: String, required: true }
}, { timestamps: true });

module.exports = mongoose.model('QuestionContent', QuestionContentSchema);
