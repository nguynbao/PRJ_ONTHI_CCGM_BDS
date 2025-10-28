const express = require("express");
const router = express.Router();
const userSettingCtl = require("../Controllers/userSetting.controller");
const { verifyToken } = require("../services/auth.service");
router.use((req, res, next) => {
  const header = req.headers && req.headers.authorization;
  if (!header || !header.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  const token = header.slice("Bearer ".length);
  try {
    const payload = verifyToken(token);
    req.user = { id: payload.id, email: payload.email };
    return next();
  } catch (e) {
    return res.status(401).json({ error: "Unauthorized" });
  }
});
router.get("/me", userSettingCtl.getMe);
router.put("/me", userSettingCtl.upsertMe);
router.patch("/me", userSettingCtl.upsertMe);
router.delete("/me", userSettingCtl.removeMe);

module.exports = router;
