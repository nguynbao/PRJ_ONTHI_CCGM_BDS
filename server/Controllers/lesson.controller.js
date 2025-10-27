const httpStatus = { OK: 200, CREATED: 201, BAD: 400, UNAUTHORIZED: 401, SERVER: 500 };
const lessonService = require('../Services/lesson.service');


exports.createLesson = async (req, res) => {
    try {
        const { title } = req.body || {};
        if (!title) {
            return res.status(httpStatus.BAD).json({ error: 'Title is required' });
        }
        const userId = req.user && req.user.id;
        if (!userId) {
            return res.status(httpStatus.UNAUTHORIZED).json({ error: 'Unauthorized' });
        }
        const lesson = await lessonService.createLesson(userId, title);
        return res.status(httpStatus.CREATED).json({ message: 'Lesson created', lesson });
    } catch (err) {
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};


exports.getLessons = async (req, res) => {
    try {
        const userId = req.user && req.user.id;
        if (!userId) {
            return res.status(httpStatus.UNAUTHORIZED).json({ error: 'Unauthorized' });
        }
        const lessons = await lessonService.getLessonsByUser(userId);
        return res.status(httpStatus.OK).json({ lessons });
    } catch (err) {
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};

exports.getLesson = async (req, res) => {
    try {
        const lessonId = req.params.id;
        const lesson = await lessonService.getLessonById(lessonId);
        if (!lesson) {
            return res.status(httpStatus.BAD).json({ error: 'Lesson not found' });
        }
        return res.status(httpStatus.OK).json({ lesson });
    } catch (err) {
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};

exports.updateLesson = async (req, res) => {
    try {
        const lessonId = req.params.id;
        const { title } = req.body || {};
        if (!title) {
            return res.status(httpStatus.BAD).json({ error: 'Title is required' });
        }
        const userId = req.user && req.user.id;
        if (!userId) {
            return res.status(httpStatus.UNAUTHORIZED).json({ error: 'Unauthorized' });
        }
        const lesson = await lessonService.updateLesson(lessonId, userId, title);
        if (!lesson) {
            return res.status(httpStatus.BAD).json({ error: 'Lesson not found' });
        }
        return res.status(httpStatus.OK).json({ message: 'Lesson updated', lesson });
    }
    catch (err) {
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};

exports.deleteLesson = async (req, res) => {
    try {
        const lessonId = req.params.id;
        const userId = req.user && req.user.id;
        if (!userId) {
            return res.status(httpStatus.UNAUTHORIZED).json({ error: 'Unauthorized' });
        }
        await lessonService.deleteLesson(lessonId, userId);
        return res.status(httpStatus.OK).json({ message: 'Lesson deleted' });
    } catch (err) {
        if (err.message === 'LESSON_NOT_FOUND_OR_UNAUTHORIZED') {
            return res.status(httpStatus.UNAUTHORIZED).json({ error: 'Lesson not found or unauthorized' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
}; 