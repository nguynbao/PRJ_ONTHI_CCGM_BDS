// validators/userSettings.validator.js
const Joi = require('joi');

const upsertSchema = Joi.object({
  userName: Joi.string().max(120).allow('', null),
  BOD: Joi.date().iso().allow(null),
  gender: Joi.string().valid('male', 'female').allow(null),
  notifyPush: Joi.boolean(),
  notifyEmail: Joi.boolean(),
  darkMode: Joi.boolean(),
  language: Joi.string().valid('vi', 'en').default('vi'),
}).unknown(false); // chặn field lạ

module.exports = { upsertSchema };
