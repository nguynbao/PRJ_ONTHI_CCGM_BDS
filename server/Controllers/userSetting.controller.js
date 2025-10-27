const httpStatus = {
  OK: 200,
  CREATED: 201,
  BAD: 400,
  UNAUTHORIZED: 401,
  server: 500,
};

const { upsertSchema } = require("../validators/userSettings.validator");
const svc = require("../services/userSettings.service");

async function getMe({ req, res }) {
  const userId = req.user.id;
  const found = await svc.getByUserId(userId);
  return res.json(
    found || {
      user: userId,
      userName: null,
      BOD: null,
      gender: null,
      notifyPush: true,
      notifyEmail: true,
      darkMode: false,
      language: "vi",
    }
  );
}
async function upsertMe(req, res) {
  const userId = req.user.id;
  const { value, error } = upsertSchema.validate(req.body);
  if (error) throw createError(400, error.message);

  const saved = await svc.upsertByUserId(userId, value);
  return res.json(saved);
}
async function removeMe(req, res) {
  const userId = req.user.id;
  await svc.removeByUserId(userId);
  return res.status(204).send();
}
module.exports = { getMe, upsertMe, removeMe, getByUserIdAdmin };
