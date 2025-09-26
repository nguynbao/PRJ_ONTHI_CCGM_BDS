const { Lesson } = require('../Model');

async function createLesson(userId, title) {
    const lesson = await Lesson.create({ user: userId, title });
    return lesson;
}

async function getLessonsByUser(userId) {
    return Lesson.find({ user: userId }).sort({ createdAt: -1 });
}

async function getLessonById(lessonId) {
    return Lesson.findById(lessonId);
}
async function updateLesson(lessonId, userId, title) {
    return Lesson.findOneAndUpdate({ _id: lessonId, user: userId }, { title }, { new: true });
}

async function deleteLesson(lessonId, userId) {
    const lesson = await Lesson.findOneAndDelete({ _id: lessonId, user: userId });
    if (!lesson) throw new Error('LESSON_NOT_FOUND_OR_UNAUTHORIZED');
    return lesson;
}

module.exports = { createLesson, getLessonsByUser, getLessonById, updateLesson, deleteLesson };