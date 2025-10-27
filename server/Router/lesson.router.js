const express = require('express');
const router = express.Router();
const lessonController = require('../controllers/lesson.controller');
const { verifyToken } = require('../services/auth.service');

// auth middleware for lesson routes
router.use((req, res, next) => {
    const header = req.headers && req.headers.authorization;
    if (!header || !header.startsWith('Bearer ')) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
    const token = header.slice('Bearer '.length);
    try {
        const payload = verifyToken(token);
        req.user = { id: payload.id, email: payload.email };
        return next();
    } catch (e) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
});

router.post('/', lessonController.createLesson);
router.get('/', lessonController.getLessons);
router.get('/:id', lessonController.getLesson);
router.put('/:id', lessonController.updateLesson);
router.delete('/:id', lessonController.deleteLesson);

module.exports = router;
