const { UserSettings } = require("../models");

async function getByUserId(userId) {
  return UserSettings.findOne({ user: userId }).lean();
}
async function createByUserId(userId, payload = {}) {
  // tránh tạo trùng do unique
  const existed = await UserSettings.findOne({ user: userId }).lean();
  if (existed) {
    const err = new Error("ALREADY_EXISTS");
    err.status = 409;
    throw err;
  }

  const allowed = [
    "userName",
    "BOD",
    "gender",
    "notifyPush",
    "phone",
    "notifyEmail",
    "darkMode",
    "language",
  ];
  const data = { user: userId };
  for (const k of allowed) if (payload[k] !== undefined) data[k] = payload[k];

  const doc = await UserSettings.create(data);
  return doc.toObject();
}

async function upsertByUserId(userId, payload) {
  const allowed = [
    "userName",
    "BOD",
    "gender",
    "notifyPush",
    "phone",
    "notifyEmail",
    "darkMode",
    "language",
  ];
  const data = {};
  for (const k of allowed) if (payload[k] !== undefined) data[k] = payload[k];

  const doc = await UserSettings.findOneAndUpdate(
    { user: userId },
    { $set: { ...data, user: userId } },
    { new: true, upsert: true, setDefaultsOnInsert: true }
  );
  return doc.toObject();
}

async function removeByUserId(userId) {
  return UserSettings.findOneAndDelete({ user: userId });
}
module.exports = {
  getByUserId,
  createByUserId,
  upsertByUserId,
  removeByUserId,
};
