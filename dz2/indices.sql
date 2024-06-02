-- Удаляем активные сеансы
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'vadim_db' AND pid <> pg_backend_pid();
-- Завершаем текущую транзакцию
COMMIT;
-- Копируем БД
CREATE DATABASE "vadim_db_copy" WITH TEMPLATE = "vadim_db" OWNER = "vadim_user";

-- Создаем индекс B-дерево для таблицы chat_message
CREATE INDEX chat_message_chat_id ON chat_message(chat_id);

-- Создаем индекс SP-GIST для таблицы chat
CREATE INDEX chat_score_spgist_index ON chat USING SPGIST (score);
