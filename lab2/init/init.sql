DROP TABLE IF EXISTS chat_message CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
DROP TABLE IF EXISTS chat_to_user CASCADE;
DROP TABLE IF EXISTS chat CASCADE;
DROP TABLE IF EXISTS admin_user CASCADE;
DROP TABLE IF EXISTS regular_user CASCADE;
-- Тема: Чат с 3D-аватаром
CREATE TABLE regular_user (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    name TEXT,
    created_at TIMESTAMP DEFAULT now() + interval '3 hours' NOT NULL
);
CREATE TABLE admin_user (
    created_by INTEGER NOT NULL,
    FOREIGN KEY (created_by) REFERENCES regular_user (id)
) INHERITS (regular_user);
CREATE TYPE EyesInfo AS (
    left_color VARCHAR(64),
    right_color VARCHAR(64)
);
CREATE TYPE Gender AS ENUM('Male', 'Female');
CREATE TABLE face_info (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    age INTEGER NOT NULL CHECK (age > 0) DEFAULT 20,
    gender Gender NOT NULL,
    eyes_info EyesInfo NOT NULL,
    hair_color VARCHAR(64),
    skin_color VARCHAR(64),
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES regular_user (id)
);
CREATE TABLE chat (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT,
    tags TEXT [],
    box BOX,
    json JSON,
    range int4range
);
CREATE TABLE chat_message (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    content TEXT,
    chat_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    FOREIGN KEY (chat_id) REFERENCES chat (id),
    FOREIGN KEY (author_id) REFERENCES regular_user (id)
);
CREATE TABLE chat_to_user (
    user_id INTEGER NOT NULL,
    chat_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES regular_user (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (chat_id) REFERENCES chat (id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE UNIQUE INDEX "chat_to_user_unique" ON chat_to_user(user_id, chat_id);