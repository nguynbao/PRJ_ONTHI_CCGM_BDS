const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const OtpLogSchema = new Schema({
    user: { type: Types.ObjectId, ref: 'AuthUser', required: true, index: true },
    otpCode: { type: String, required: true },
    expireAt: { type: Date, required: true },
    usedAt: { type: Date }
}, { timestamps: true });

module.exports = mongoose.model('OtpLog', OtpLogSchema);
