const express = require('express');
const router = express.Router();
const topicController = require('../Controllers/topic.controller');

// tạo topic mới
router.post('/', topicController.createTopic);
// lấy danh sách topic (có filter, phân trang)
router.get('/', topicController.getTopics);
// lấy tất cả topic của một lesson
router.get('/lesson/:lessonId', topicController.getTopicsByLesson);
// lấy chi tiết topic
router.get('/:id', topicController.getTopic);
// cập nhật topic
router.put('/:id', topicController.updateTopic);
// xoá topic
router.delete('/:id', topicController.deleteTopic);

module.exports = router;