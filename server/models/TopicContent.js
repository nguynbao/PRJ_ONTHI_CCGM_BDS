const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const TopicContentSchema = new Schema({
    topic: { type: Types.ObjectId, ref: 'Topic', required: true, unique: true },
    contentMd: { type: String, required: true }
}, { timestamps: true });

module.exports = mongoose.model('TopicContent', TopicContentSchema);
