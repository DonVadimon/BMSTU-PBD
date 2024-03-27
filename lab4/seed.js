// users
db.users.insertMany([
    {
        _id: 1,
        username: "vadim",
        password: "pwd",
        age: 22,
        email: "email@mail.ru",
        name: "Vadim",
        about: {
            work: "Mail.ru",
            job: "Frontend engineer",
        },
    },
    {
        _id: 2,
        username: "sanya",
        password: "pwd",
        age: 22,
        email: "sanya@mail.ru",
        name: "Sanya",
        about: {
            work: "Sber",
            job: "Frontend engineer",
        },
    },
    {
        _id: 3,
        username: "pavel",
        password: "pwd",
        age: 21,
        email: "pavel@mail.ru",
        name: "Pavel",
    },
    {
        _id: 4,
        username: "ivan",
        password: "pwd",
        age: 23,
        email: "ivan@mail.ru",
        name: "Ivan",
        about: {
            work: "Yandex",
            job: "Разноработчик",
        },
    },
]);

// chats

db.chat.insertMany([
    {
        _id: 1,
        name: "Ivan Pavel",
        tags: ["cool", "chat"],
        mamberIds: [4, 3],
    },
    {
        _id: 2,
        name: "Ivan Vadim",
        tags: ["cool", "good"],
        mamberIds: [4, 1],
    },
    {
        _id: 3,
        name: "Vadim Sanya",
        tags: ["cool", "wow"],
        mamberIds: [1, 2],
    },
    {
        _id: 4,
        name: "Vadim Pavel",
        tags: ["tag", "chat"],
        mamberIds: [1, 3],
    },
]);

// messages
db.chatMessage.insertMany([
    { content: "Hello, Pavel! How are you?", chatId: 1, authorId: 4 },
    { content: "Hello, my dear friend, Ivan!", chatId: 2, authorId: 1 },
    { content: "Hello, my dear friend, Pavel!", chatId: 3, authorId: 1 },
    { content: "Hello, my dear friend, Sanya!", chatId: 4, authorId: 1 },
]);
