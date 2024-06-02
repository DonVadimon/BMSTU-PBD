-- clear
TRUNCATE TABLE chat_message;
TRUNCATE TABLE chat CASCADE;
DO $$ BEGIN -- 1% same
FOR i IN 1..10 LOOP
INSERT INTO chat (id, name, score)
VALUES (i, 'chat_' || i, point(5000, 1));
END LOOP;
-- 90% different
FOR i IN 1..90 LOOP
INSERT INTO chat (id, name, score)
VALUES (i + 10, 'chat_' || i + 10, point(random() * 1000, 1));
END LOOP;
END $$;
-- check
SELECT count(*)
FROM chat;
SELECT count(*)
FROM chat
WHERE score >> point(1000, 1);
-- 1000 for outer table
DO $$ BEGIN FOR i IN 1..100 LOOP
INSERT INTO chat_message (id, content, chat_id)
VALUES (i, 'msg_' || i,  (random() * 99)::int + 1);
END LOOP;
END $$;
-- check
SELECT *
FROM chat_message
LIMIT 10;
-- analize
EXPLAIN ANALYZE
SELECT *
FROM chat_message
WHERE chat_id IN (
        SELECT id
        FROM chat
        WHERE score >> point(1000, 1)
    );