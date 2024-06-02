DROP TABLE IF EXISTS chat_message CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
-- Тема: Чат с 3D-аватаром
CREATE TABLE chat (
    id INTEGER PRIMARY KEY,
    name TEXT,
    score POINT
);
CREATE TABLE chat_message (
    id INTEGER PRIMARY KEY,
    content TEXT,
    chat_id INTEGER NOT NULL,
    FOREIGN KEY (chat_id) REFERENCES chat (id)
);
