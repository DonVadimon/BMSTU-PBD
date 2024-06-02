-- clear
TRUNCATE TABLE chat_message;
TRUNCATE TABLE chat CASCADE;

DO $$
BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO chat (id, name, score)
        VALUES
        (i, 'chat_' || i, point(random() * 5000, 1));
    END LOOP;
END $$;


DO $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO chat_message (id, content, chat_id)
        VALUES (i, 'msg_' || i, 1);
    END LOOP;
    FOR i IN 1..90 LOOP
        INSERT INTO chat_message (id, content, chat_id)
        VALUES (i + 10, 'msg_' || i, (random() * 99)::int + 1);
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