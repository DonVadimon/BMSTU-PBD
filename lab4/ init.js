// use vadim;
// db;
// show dbs;
// db.dropDatabase();

db.createCollection("users");
db.createCollection("chat");
db.createCollection("chatMessage");
db.runCommand({ listCollections: 1 });

db.users.insertOne({
    _id: 1,
    username: "admin",
    password: "admin",
    email: "admin@admin.com",
});

// seed here

// вывести все
db.users.find();
db.users.findOne();
db.users.find().pretty();

// операторы сравнения
db.users.find({ username: { $eq: "sanya" } }); // eq - равенство
db.users.find({ username: { $ne: "sanya" } }); // ne - неравенство

// логические операторы
db.users.find({
    $and: [{ username: "pavel" }, { age: 21 }],
});
db.users.find({
    $or: [{ username: "pavel" }, { age: 23 }],
});

// операторы для работы с массивами
db.chat.find({
    tags: {
        // all - полное совавдение массива
        $all: ["cool", "wow"],
    },
});

db.chat.find({
    tags: {
        // elemMatch - частичное совпадение елементов
        $elemMatch: { $eq: "cool" },
    },
});

db.chat.find({
    tags: {
        // size - совпадение по кол-ву элементов массива
        $size: 2,
    },
});

db.chat.find({
    tags: {
        $in: [
            // in - нахождение элементов в массиве
            "wow",
            "good",
        ],
    },
});

db.chat.find({
    tags: {
        // nin - не нахождение элемента в массиве
        $nin: ["wow"],
    },
});

// условие на наличия поля
db.users.find({
    about: {
        $exists: true,
    },
});
// условие на отсутствие поля
db.users.find({
    about: {
        $exists: false,
    },
});

// проекция вывода
db.users.find({ age: { $gte: 20 } }, { _id: 0, username: 1, about: 1 });

// условия на поля вложенных структур
db.users.find({ "about.work": { $eq: "Mail.ru" } });

// изменение документов коллекции
db.users.insertOne({
    username: "Test",
    password: "pwd",
    age: 1,
    email: "test@mail.ru",
    name: "Testik",
    about: {
        work: "None",
        job: "Testing",
    },
});
db.users.find({ age: 1 });

// Сетим поле имеющееся
db.users.updateOne(
    { username: "Test" },
    {
        $set: {
            name: "tastyk",
        },
    }
);
db.users.find({ age: 1 });

db.users.updateOne(
    { name: "Facceless Void" },
    {
        $set: {
            username: "fac3less_v0iDDD",
        },
    },
    {
        // Создать если нету
        upsert: true,
    }
);
db.users.find({ name: "Facceless Void" });

// удаление поля
db.users.updateOne(
    { name: "Facceless Void" },
    {
        $unset: { username: "" },
    }
);
db.users.find({ name: "Facceless Void" });

// изменение элемента массива
db.chat.updateOne(
    { name: "Ivan Pavel" },
    {
        $set: {
            "tags.1": "super",
        },
    }
);
db.chat.find({ name: "Ivan Pavel" });

// Удалит первый попавшийся
db.users.deleteOne();
// Удалит по фильтру
db.users.deleteMany({ name: "Facceless Void" });
db.tasks.find();

// sort
db.users.find().sort({ age: 1 }); // по возрастанию
db.users.find().sort({ age: -1 }); // по убыванию

// кол-во документов
db.users.count();
db.users.count({
    age: {
        $lte: 21,
    },
});

// skip
db.users.count(
    {},
    {
        skip: 3,
    }
);

// уникальные кортежи
db.users.distinct("name");

// ограничение limit
db.users.find().limit(3);

// relations
const chatOwnerId = ObjectId();
const chatSlaveId = ObjectId();
db.users.insertMany([
    {
        _id: chatOwnerId,
        username: "Chat Owner User",
    },
]);

db.chat.insertMany([
    {
        _id: chatSlaveId,
        username: "Slave Chat",
    },
]);

db.createCollection("chatOwners");
db.chatOwners.insertOne({
    chat: {
        $ref: "chat",
        $id: chatSlaveId,
    },
    owner: {
        $ref: "users",
        $id: chatOwnerId,
    },
});

// Выборка сообщений с автором
db.chatMessage.aggregate([
    {
        $lookup: {
            from: "users",
            localField: "authorId",
            foreignField: "_id",
            as: "author",
        },
    },
]);

// Выборка юзеров с инфой о себе и их сообщениями
db.users.aggregate([
    { $match: { password: { $exists: true } } },
    {
        $lookup: {
            from: "chatMessage",
            localField: "_id",
            foreignField: "authorId",
            as: "messages",
        },
    },
]);

// Возраста пользаков и их количество
db.users.aggregate([
    {
        $group: {
            _id: "$age",
            count: { $count: {} },
        },
    },
]);

// индексы
db.users.createIndex({ username: 1 }, { unique: true });

// управление индексами
db.users.getIndexes(); // получение индекса
db.users.dropIndex("username_1"); // удаление индекса
db.users.find().explain();

// добавление элемента в массив
db.chat.updateOne({ _id: 1 }, { $push: { tags: "new" } });
db.chat.find({ _id: 1 });

db.users.insertMany([
    {
        name: "Duplicate",
    },
    {
        name: "Duplicate",
    },
    {
        name: "Duplicate",
    },
    {
        name: "Duplicate",
    },
]);

db.users.find({ name: "Duplicate" });

// Удаление дубликатов по имени
db.users.aggregate([
        {
            $group: {
                _id: { name: "$name" },
                dups: { $addToSet: "$_id" },
                count: { $sum: 1 },
            },
        },
        {
            $match: {
                count: { $gt: 1 },
            },
        },
    ]).forEach(function (doc) {
        doc.dups.shift();
        db.users.deleteOne({
            _id: { $in: doc.dups },
        });
    });

db.users.find({ name: "Duplicate" });
