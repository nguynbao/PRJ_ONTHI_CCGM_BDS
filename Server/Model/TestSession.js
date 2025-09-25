const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const STATUS = ['pause', 'play'];

const TestSessionSchema = new Schema({
    user: { type: Types.ObjectId, ref: 'AuthUser', required: true, index: true },
    examTemplate: { type: Types.ObjectId, ref: 'ExamTemplate', required: true, index: true },
    status: { type: String, enum: STATUS, default: 'play' },
    startedAt: { type: Date, default: Date.now },
    submittedAt: { type: Date },
    durationSec: { type: Number },
    score: { type: Number },
    passed: { type: Boolean },
    seed: { type: Number }
}, { timestamps: true });

module.exports = mongoose.model('TestSession', TestSessionSchema);
