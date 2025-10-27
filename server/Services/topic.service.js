const { Topic, Lesson } = require('../Model');

async function createTopic({ lessonId, title }) {
    if (!lessonId) throw new Error('LESSON_REQUIRED');
    if (!title) throw new Error('TITLE_REQUIRED');

    const lesson = await Lesson.findById(lessonId).select('_id');
    if (!lesson) throw new Error('LESSON_NOT_FOUND');

    const doc = await Topic.create({ lesson: lessonId, title });
    return doc;
}


async function getTopics({
    lessonId,
    search,
    page = 1,
    limit = 20,
    includeDeleted = false,
} = {}) {
    const filter = {};
    if (lessonId) filter.lesson = lessonId;
    if (!includeDeleted) filter.isDeleted = { $ne: true };
    if (search) filter.title = new RegExp(search.trim().replace(/\s+/g, '.*'), 'i');

    const skip = (Math.max(page, 1) - 1) * Math.max(limit, 1);

    const [items, total] = await Promise.all([
        Topic.find(filter)
            .sort({ createdAt: -1 })
            .skip(skip)
            .limit(limit)
            .populate('lesson', '_id title'),
        Topic.countDocuments(filter),
    ]);

    return {
        items,
        pagination: {
            page: Number(page),
            limit: Number(limit),
            total,
            pages: Math.ceil(total / Math.max(limit, 1)) || 1,
        },
    };
}

/**
 * Lấy 1 topic theo id
 */
async function getTopicById(id) {
    const doc = await Topic.findById(id).populate('lesson', '_id title');
    if (!doc) throw new Error('TOPIC_NOT_FOUND');
    return doc;
}


async function updateTopic(id, data = {}) {
    const update = {};

    if (typeof data.title === 'string' && data.title.trim()) {
        update.title = data.title.trim();
    }
    if (typeof data.isDeleted === 'boolean') {
        update.isDeleted = data.isDeleted;
    }
    if (data.lessonId) {
        const lesson = await Lesson.findById(data.lessonId).select('_id');
        if (!lesson) throw new Error('LESSON_NOT_FOUND');
        update.lesson = data.lessonId;
    }

    const doc = await Topic.findByIdAndUpdate(id, update, { new: true });
    if (!doc) throw new Error('TOPIC_NOT_FOUND');
    return doc;
}


async function deleteTopic(id, { soft = true } = {}) {
    if (soft) {
        const doc = await Topic.findByIdAndUpdate(id, { isDeleted: true }, { new: true });
        if (!doc) throw new Error('TOPIC_NOT_FOUND');
        return { softDeleted: true, topic: doc };
    }
    const res = await Topic.findByIdAndDelete(id);
    if (!res) throw new Error('TOPIC_NOT_FOUND');
    return { deleted: true };
}


async function getTopicsByLesson(lessonId) {
    const lesson = await Lesson.findById(lessonId).select('_id');
    if (!lesson) throw new Error('LESSON_NOT_FOUND');
    const items = await Topic.find({ lesson: lessonId, isDeleted: { $ne: true } })
        .sort({ createdAt: -1 });
    return items;
}

module.exports = {
    createTopic,
    getTopics,
    getTopicById,
    updateTopic,
    deleteTopic,
    getTopicsByLesson,
};
