const { Schema, model } = require('mongoose');

const OrgMembershipSchema = new Schema({
  org: { type: Schema.Types.ObjectId, ref: 'Organization' },
  role: { type: String, enum: ['org_admin','instructor','learner'], default: 'learner' }
}, { _id: false });

const PreferencesSchema = new Schema({
  language: { type: String, default: 'vi' },
  darkMode: { type: Boolean, default: false },
  pushEnabled: { type: Boolean, default: true },
  emailNotifEnabled: { type: Boolean, default: true },
}, { _id: false });

const ProfileSchema = new Schema({
  displayName: { type: String, trim: true },
  gender: { type: String, enum: ['male','female','other'], default: 'other' },
  dob: { type: Date },
  preferences: { type: PreferencesSchema, default: () => ({}) }
}, { _id: false });

const UserSchema = new Schema({
  email: { type: String, unique: true, sparse: true, trim: true, lowercase: true },
  phone: { type: String, unique: true, sparse: true, trim: true },
  status: { type: String, enum: ['active','blocked','pending'], default: 'active' },
  profile: { type: ProfileSchema, default: () => ({}) },
  orgMemberships: { type: [OrgMembershipSchema], default: [] },
}, { timestamps: true });

UserSchema.index({ 'profile.preferences.language': 1 });
module.exports = model('User', UserSchema);
