const httpStatus = { OK: 200, CREATED: 201, BAD: 400, UNAUTHORIZED: 401, SERVER: 500 };
const topicService = require('../Services/topic.service');

exports.createTopic = async (req, res) => {
    try {
        const { lessonId, title } = req.body || {};
        if (!lessonId || !title) {
            return res.status(httpStatus.BAD).json({ error: 'lessonId and title are required' });
        }
        const topic = await topicService.createTopic({ lessonId, title });
        return res.status(httpStatus.CREATED).json({ message: 'Topic created', topic });
    } catch (err) {
        if (err.message === 'LESSON_REQUIRED' || err.message === 'TITLE_REQUIRED') {
            return res.status(httpStatus.BAD).json({ error: err.message });
        }
        if (err.message === 'LESSON_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Lesson not found' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};
exports.getTopics = async (req, res) => {
    try {
        const { lessonId, search, page = 1, limit = 20, includeDeleted = 'false' } = req.query || {};
        const topics = await topicService.getTopics({
            lessonId,
            search,
            page: parseInt(page, 10),
            limit: parseInt(limit, 10),
            includeDeleted: includeDeleted === 'true',
        });
        return res.status(httpStatus.OK).json({ topics });
    } catch (err) {
        if (err.message === 'LESSON_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Lesson not found' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};
exports.getTopic = async (req, res) => {
    try {
        const topicId = req.params.id;
        const topic = await topicService.getTopicById(topicId);
        return res.status(httpStatus.OK).json({ topic });
    } catch (err) {
        if (err.message === 'TOPIC_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic not found' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};
exports.updateTopic = async (req, res) => {
    try {
        const topicId = req.params.id;
        const { title, isDeleted, lessonId } = req.body || {};
        if (!title && typeof isDeleted === 'undefined' && !lessonId) {
            return res.status(httpStatus.BAD).json({ error: 'Nothing to update' });
        }
        const topic = await topicService.updateTopic(topicId, { title, isDeleted, lessonId });
        return res.status(httpStatus.OK).json({ message: 'Topic updated', topic });
    }
    catch (err) {
        if (err.message === 'TOPIC_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic not found' });
        }
        if (err.message === 'LESSON_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Lesson not found' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};
exports.deleteTopic = async (req, res) => {
    try {
        const topicId = req.params.id;
        const { soft = 'true' } = req.query || {};
        const result = await topicService.deleteTopic(topicId, { soft: soft === 'true' });
        return res.status(httpStatus.OK).json({ message: 'Topic deleted', result });
    }


    catch (err) {
        if (err.message === 'TOPIC_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic not found' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};
exports.getTopicsByLesson = async (req, res) => {
    try {
        const lessonId = req.params.lessonId;
        const topics = await topicService.getTopicsByLesson(lessonId);
        return res.status(httpStatus.OK).json({ topics });
    } catch (err) {
        if (err.message === 'LESSON_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Lesson not found' });
        }
        return res.status(httpStatus.SERVER).json({ error: 'Internal error' });
    }
};  
