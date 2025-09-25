const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const QUESTION_TYPES = ['single_choice', 'true_false', 'short_text'];

const QuestionSchema = new Schema({
    topic: { type: Types.ObjectId, ref: 'Topic', required: true, index: true },
    difficulty: { type: Number, min: 1, max: 5, required: true },
    type: { type: String, enum: QUESTION_TYPES, required: true },
    explanationMd: { type: String },
    isActive: { type: Boolean, default: true },
    isDeleted: { type: Boolean, default: false },
    tags: [{ type: Types.ObjectId, ref: 'Tag', index: true }]
}, { timestamps: true });

module.exports = mongoose.model('Question', QuestionSchema);
