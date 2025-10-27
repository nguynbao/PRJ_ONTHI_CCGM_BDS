const express = require('express');
const router = express.Router();
const userSettingCtl = require('../controllers/userSetting.controller');
router.get('/me', auth, wrap(ctrl.getMe));
router.put('/me', auth, wrap(ctrl.upsertMe));
router.patch('/me', auth, wrap(ctrl.upsertMe));
router.delete('/me', auth, wrap(ctrl.removeMe));

module.exports = router;