const mongoose = require('mongoose');
const { Schema } = mongoose;

const TagSchema = new Schema({
    code: { type: String, required: true, unique: true, trim: true, max_length: 64 }
}, { timestamps: true });

module.exports = mongoose.model('Tag', TagSchema);
