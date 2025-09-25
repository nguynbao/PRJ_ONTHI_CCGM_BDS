const express = require('express');
const router = express.Router();

router.use('/auth', require('./auth.router')); // /api/auth/register

module.exports = router;
