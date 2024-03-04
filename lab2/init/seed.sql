-- seed user
INSERT INTO regular_user (
        username,
        password,
        email,
        name
    ) -- 1
VALUES ('vadim', 'pwd', 'email@mail.ru', 'Vadim'),
    -- 2
    ('sanya', 'pwd', 'sanya@mail.ru', 'Sanya'),
    -- 3
    ('pavel', 'pwd', 'pavel@mail.ru', 'Pavel'),
    -- 4
    ('ivan', 'pwd', 'ivan@mail.ru', 'Ivan');
-- seed admin user
INSERT INTO admin_user (
        id,
        username,
        password,
        email,
        name,
        created_by
    )
VALUES (
        5,
        'admin',
        'pwd',
        'admin@mail.ru',
        'Admin Adminovich',
        1
    );
-- seed chat
INSERT INTO chat (
        name,
        tags,
        box,
        json,
        range
    ) -- 1
VALUES (
        'Ivan Pavel',
        '{ "tag" }',
        '((1, 2),(3, 4))',
        '{ "num": 123 }',
        '(1, 5]'
    ),
    -- 2
    (
        'Ivan Vadim',
        '{ "cool tag" }',
        '((1, 2),(3, 4))',
        '{ "nums": [1, 2, 3] }',
        '(1, 5]'
    ),
    -- 3
    (
        'Vadim Pavel',
        '{ "mega cool tag" }',
        '((1, 2),(3, 4))',
        '{ "str": "value" }',
        '(1, 5]'
    ),
    -- 4
    (
        'Vadim Sanya',
        '{ "giga cool tag" }',
        '((1, 2),(3, 4))',
        '{ "obj": { "a": "b" } }',
        '(1, 5]'
    );
-- seed chat to users
INSERT INTO chat_to_user (user_id, chat_id)
VALUES -- ('Ivan Pavel')
    (3, 1),
    (4, 1),
    -- ('Ivan Vadim')
    (4, 2),
    (1, 2),
    -- ('Vadim Pavel')
    (1, 3),
    (3, 3),
    -- ('Vadim Sanya')
    (1, 4),
    (2, 4);
-- seed messages
INSERT INTO chat_message (content, chat_id, author_id)
VALUES ('Hello, Ivan!', 1, 3),
    ('Hello, Pavel! How are you?', 1, 4),
    ('Hello, my dear friend, Ivan!', 2, 1),
    ('Hello, my dear friend, Pavel!', 3, 1),
    ('Hello, my dear friend, Sanya!', 4, 1);
-- seed face info
INSERT INTO face_info (
        age,
        gender,
        eyes_info,
        hair_color,
        skin_color,
        user_id
    )
VALUES (
        22,
        'Male',
        ROW('blue', 'blue'),
        'green',
        'gold',
        1
    ),
    (
        21,
        'Female',
        ROW('green', 'green'),
        'brown',
        'gold',
        4
    ),
    (
        25,
        'Male',
        ROW('blue', 'blue'),
        'gold',
        'gold',
        3
    ),
    (
        21,
        'Male',
        ROW('red', 'brown'),
        'white',
        'pale',
        2
    );