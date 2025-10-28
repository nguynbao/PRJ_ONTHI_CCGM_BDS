const { Schema, model } = require('mongoose');

const OfficialExamScheduleSchema = new Schema({
  city: { type: String, required: true },
  venue: { type: String, required: true },
  examDate: { type: Date, required: true },
  note: { type: String }
}, { timestamps: true });

OfficialExamScheduleSchema.index({ examDate: 1 });
module.exports = model('OfficialExamSchedule', OfficialExamScheduleSchema);
