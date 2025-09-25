const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const LessonSchema = new Schema({
    user: { type: Types.ObjectId, ref: 'AuthUser', required: true, index: true },
    topic: { type: Types.ObjectId, ref: 'Topic', required: true, index: true },
    title: { type: String, required: true }
}, { timestamps: true });

module.exports = mongoose.model('Lesson', LessonSchema);
