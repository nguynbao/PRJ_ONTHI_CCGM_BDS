const express = require('express');
const router = express.Router();
const topicContentController = require('../Controllers/topic_content.controller');

// tạo nội dung cho topic
router.post('/', topicContentController.createTopicContent);
// lấy nội dung của topic theo topicId
router.get('/:topicId', topicContentController.getTopicContentByTopicId);
// cập nhật nội dung của topic theo topicId
router.put('/:topicId', topicContentController.updateTopicContent);
// xoá nội dung của topic theo topicId
router.delete('/:topicId', topicContentController.deleteTopicContent);

module.exports = router;