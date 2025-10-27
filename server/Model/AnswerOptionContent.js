const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const AnswerOptionContentSchema = new Schema({
    answer: { type: Types.ObjectId, ref: 'AnswerOption', required: true, unique: true },
    contentMd: { type: String }
}, { timestamps: true });

module.exports = mongoose.model('AnswerOptionContent', AnswerOptionContentSchema);
