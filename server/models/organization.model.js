const { Schema, model } = require('mongoose');

const OrganizationSchema = new Schema({
  name: { type: String, required: true, unique: true, trim: true },
  type: { type: String, enum: ['company','training_center'], default: 'company' }
}, { timestamps: true });

module.exports = model('Organization', OrganizationSchema);
