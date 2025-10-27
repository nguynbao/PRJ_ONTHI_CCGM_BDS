const httpStatus = { OK: 200, CREATED: 201, BAD: 400, UNAUTHORIZED: 401, SERVER: 500 };
const topicContentService = require('../services/topic_content.service');

exports.createTopicContent = async (req, res) => {
    try {
        const { topicId, contentMd } = req.body || {};
        if (!topicId || !contentMd) {
            return res.status(httpStatus.BAD).json({ error: 'topicId and contentMd are required' });
        }
        const topicContent = await topicContentService.createTopicContent({ topicId, contentMd });
        return res.status(httpStatus.CREATED).json(topicContent);
    } catch (error) {
        if (error.message === 'TOPIC_REQUIRED' || error.message === 'CONTENT_REQUIRED') {
            return res.status(httpStatus.BAD).json({ error: error.message });
        }
        if (error.message === 'TOPIC_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic not found' });
        }
        console.error('Error creating topic content:', error);
        return res.status(httpStatus.SERVER).json({ error: error.message || 'INTERNAL_SERVER_ERROR' });
    }
};
exports.getTopicContentByTopicId = async (req, res) => {
    try {
        const { topicId } = req.params || {};
        if (!topicId) {
            return res.status(httpStatus.BAD).json({ error: 'topicId is required' });
        }
        const topicContent = await topicContentService.getTopicContentByTopicId(topicId);
        return res.status(httpStatus.OK).json(topicContent);
    } catch (error) {
        if (error.message === 'TOPIC_REQUIRED') {
            return res.status(httpStatus.BAD).json({ error: error.message });
        }
        if (error.message === 'TOPIC_CONTENT_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic content not found' });
        }
        console.error('Error fetching topic content:', error);
        return res.status(httpStatus.SERVER).json({ error: error.message || 'INTERNAL_SERVER_ERROR' });
    }
};
exports.updateTopicContent = async (req, res) => {
    try {
        const { topicId } = req.params || {};
        const { contentMd } = req.body || {};
        if (!topicId) {
            return res.status(httpStatus.BAD).json({ error: 'topicId is required' });
        }
        if (contentMd === undefined) {
            return res.status(httpStatus.BAD).json({ error: 'contentMd is required' });
        }
        const topicContent = await topicContentService.updateTopicContent(topicId, { contentMd });
        return res.status(httpStatus.OK).json(topicContent);
    } catch (error) {
        if (error.message === 'TOPIC_REQUIRED') {
            return res.status(httpStatus.BAD).json({ error: error.message });
        }
        if (error.message === 'TOPIC_CONTENT_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic content not found' });
        }
        console.error('Error updating topic content:', error);
        return res.status(httpStatus.SERVER).json({ error: error.message || 'INTERNAL_SERVER_ERROR' });
    }
};
exports.deleteTopicContent = async (req, res) => {
    try {
        const { topicId } = req.params || {};
        if (!topicId) {
            return res.status(httpStatus.BAD).json({ error: 'topicId is required' });
        }
        const result = await topicContentService.deleteTopicContent(topicId);
        return res.status(httpStatus.OK).json(result);
    } catch (error) {
        if (error.message === 'TOPIC_REQUIRED') {
            return res.status(httpStatus.BAD).json({ error: error.message });
        }
        if (error.message === 'TOPIC_CONTENT_NOT_FOUND') {
            return res.status(httpStatus.BAD).json({ error: 'Topic content not found' });
        }
        console.error('Error deleting topic content:', error);
        return res.status(httpStatus.SERVER).json({ error: error.message || 'INTERNAL_SERVER_ERROR' });
    }
};  