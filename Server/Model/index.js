module.exports = {
    // Auth & User
    AuthUser: require('./AuthUser'),
    UserProfile: require('./UserProfile'),
    UserSettings: require('./UserSettings'),
    OtpLog: require('./OtpLog'),

    // Catalog
    Topic: require('./Topic'),
    TopicContent: require('./TopicContent'),
    Tag: require('./Tag'),

    // Question Bank
    Question: require('./Question'),
    QuestionContent: require('./QuestionContent'),
    AnswerOption: require('./AnswerOption'),
    AnswerOptionContent: require('./AnswerOptionContent'),

    // Exam & Test
    ExamTemplate: require('./ExamTemplate'),
    TestSession: require('./TestSession'),
    TestQuestion: require('./TestQuestion'),

    // Others
    Notification: require('./Notification'),
    Lesson: require('./Lesson'),
};
