const express = require('express');
const router = express.Router();

router.use('/auth', require('./auth.router')); // /api/auth/register
router.use('/lessons', require('./lesson.router')); // /api/lesson/create
router.use('/topics', require('./topic.router')); // /api/topic/create
router.use('/topic-contents', require('./topic_content.router')); // /api/topic-contents/
router.use('/user-settings', require('./user_settings.routes'));

module.exports = router;
