const { Topic, TopicContent } = require('../Model');

async function createTopicContent({ topicId, contentMd }) {
    if (!topicId) throw new Error('TOPIC_REQUIRED');
    if (!contentMd) throw new Error('CONTENT_REQUIRED');

    const topic = await Topic.findById(topicId).select('_id');
    if (!topic) throw new Error('TOPIC_NOT_FOUND');
    const doc = await TopicContent.create({ topic: topicId, contentMd });
    return doc;
}
async function getTopicContentByTopicId(topicId) {
    if (!topicId) throw new Error('TOPIC_REQUIRED');

    const topicContent = await TopicContent.findOne({ topic: topicId }).populate('topic', '_id title');
    if (!topicContent) throw new Error('TOPIC_CONTENT_NOT_FOUND');
    return topicContent;
}
async function updateTopicContent(topicId, data = {}) {
    if (!topicId) throw new Error('TOPIC_REQUIRED');
    const update = {};
    if (data.contentMd !== undefined) update.contentMd = data.contentMd;

    const doc = await TopicContent.findOneAndUpdate(
        { topic: topicId },
        update,
        { new: true }
    ).populate('topic', '_id title');

    if (!doc) throw new Error('TOPIC_CONTENT_NOT_FOUND');
    return doc;
}
async function deleteTopicContent(topicId) {
    if (!topicId) throw new Error('TOPIC_REQUIRED');

    const doc = await TopicContent.findOneAndDelete({ topic: topicId });
    if (!doc) throw new Error('TOPIC_CONTENT_NOT_FOUND');
    return { deleted: true };
}

module.exports = {
    createTopicContent,
    getTopicContentByTopicId,
    updateTopicContent,
    deleteTopicContent
};


