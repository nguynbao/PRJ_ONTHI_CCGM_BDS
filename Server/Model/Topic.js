const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const TopicSchema = new Schema({
    parent: { type: Types.ObjectId, ref: 'Topic' },
    isDeleted: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('Topic', TopicSchema);
