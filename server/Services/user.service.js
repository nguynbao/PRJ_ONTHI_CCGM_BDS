const mongoose = require("mongoose");
const { User } = require("../models");

async function updateProfile(userId, data) {
  if (!mongoose.Types.ObjectId.isValid(userId)) {
    const e = new Error("INVALID_USER_ID");
    e.statusCode = 400;
    throw e;
  }
  const user = await User.findById(userId);
  if (!user) {
    const e = new Error("USER_NOT_FOUND");
    e.statusCode = 404;
    throw e;
  }

  const { phone, displayName, gender, dob, email } = data;

  const $set = {};
  if (typeof email === "string" && email.trim() !== "")
    $set.email = email.toLowerCase().trim();
  if (typeof phone === "string" && phone.trim() !== "")
    $set.phone = phone.trim();
  if (displayName !== undefined) $set["profile.displayName"] = displayName;
  if (gender !== undefined) $set["profile.gender"] = gender;
  if (dob !== undefined) $set["profile.dob"] = dob;

  if (Object.keys($set).length > 0 && user.status === "incomplete")
    $set.status = "active";

  const updated = await User.findByIdAndUpdate(
    userId,
    { $set },
    { new: true, runValidators: true }
  );
  return updated;
}

async function getDisplayName(userId) {
  if (!mongoose.Types.ObjectId.isValid(userId)) {
    const e = new Error("INVALID_USER_ID");
    e.statusCode = 400;
    throw e;
  }

  const doc = await User.findById(userId, {
    "profile.displayName": 1,
  }).lean();

  if (!doc) {
    const e = new Error("USER_NOT_FOUND");
    e.statusCode = 404;
    throw e;
  }

   return doc?.profile?.displayName || '';
}

module.exports = { updateProfile, getDisplayName };
