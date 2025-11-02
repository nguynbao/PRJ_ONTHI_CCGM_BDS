const express = require("express");
const userController = require("../controllers/user.controller");
const auth = require("../middlewares/auth");
// Giả định bạn có middleware xác thực

const router = express.Router();

// PUT để cập nhật toàn bộ profile của user có ID là :userId
router.put("/me", auth, userController.updateMe);
router.get("/me", auth, userController.getDisplayName);

module.exports = router;
