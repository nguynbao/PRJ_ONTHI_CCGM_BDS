const mongoose = require('mongoose');
const { Schema } = mongoose;

const ExamTemplateSchema = new Schema({
    code: { type: String, required: true, unique: true, trim: true, max_length: 64 },
    title: { type: String, trim: true },
    durationSec: { type: Number, required: true },
    totalQuestions: { type: Number, required: true },
    randomize: { type: Boolean, default: true },
    passScore: { type: Number, required: true },
    isDeleted: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('ExamTemplate', ExamTemplateSchema);
