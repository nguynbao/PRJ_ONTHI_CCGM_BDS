const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const TopicSchema = new Schema({
    lesson: { type: Types.ObjectId, ref: 'Lesson', required: true }, // liên kết topic với lesson
    title: { type: String, required: true, trim: true },             // nên có tên chủ đề
    isDeleted: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('Topic', TopicSchema);
