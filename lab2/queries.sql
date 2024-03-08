-- скалярная функция
CREATE OR REPLACE FUNCTION count_users() returns int as 'SELECT count(*) FROM regular_user' LANGUAGE SQL volatile;
SELECT count_users();
-- скалярная функция с использованием переменной
CREATE OR REPLACE FUNCTION count_messages() returns int as $$
declare messages_count int;
begin
SELECT count(*) into messages_count
FROM chat_message;
return messages_count;
end;
$$ LANGUAGE plpgsql;
SELECT count_messages();
-- табличные функции inline
CREATE OR REPLACE FUNCTION get_user_eyes_color(find_user_id int) returns table(
		left_eye_color VARCHAR(64),
		right_eye_color VARCHAR(64)
	) as $$
SELECT (eyes_info).left_color as left_eye_color,
	(eyes_info).right_color as right_eye_color
from face_info
where user_id = find_user_id;
$$ language sql;
SELECT *
from get_user_eyes_color(1);
-- табличные функции multi-statement
CREATE OR REPLACE FUNCTION get_all_usernames() returns setof TEXT as $$
declare r TEXT;
begin for r in
SELECT username
from regular_user loop return next r;
end loop;
return;
end $$ LANGUAGE plpgsql;
SELECT get_all_usernames();
-- хранимая процедура
-- Создать хранимую процедуру, содержащую запросы, вызов и перехват исключений. 
-- Вызвать процедуру из окна запроса. Проверить перехват и создание исключений.
create or replace procedure delete_message(m_id int) as $$
declare m_content VARCHAR(256);
begin
SELECT content into m_content
from chat_message
where id = m_id;
if m_content is NULL then raise exception using errcode = 'E0001',
hint = 'error',
message = format(
	'row in chat_message where id = %s not found',
	m_id
);
else EXECUTE format(
	'delete from chat_message where id = %L;',
	m_id
);
end if;
end;
$$ LANGUAGE plpgsql;
-- call delete_message(1);
-- перехват исключений
CREATE OR REPLACE FUNCTION get_username_by_id(x int) RETURNS SETOF VARCHAR(256) AS $$ BEGIN RETURN QUERY
SELECT username
from regular_user
where id = $1;
IF NOT FOUND THEN RAISE EXCEPTION 'Нет такого пользователя!';
END IF;
RETURN;
END;
$$ LANGUAGE plpgsql;
SELECT get_username_by_id(1);
-- Продемонстрировать в функциях и процедурах работу условных операторов и выполнение динамического запроса
create or replace function delete_face_by_id(d_id int) returns int as $$
declare owner_id int;
begin
select user_id into owner_id
from face_info
where id = d_id;
if owner_id is NULL then raise exception using errcode = 'E0001',
hint = 'error',
message = format('row in face_info where id = %s not found', d_id);
else EXECUTE format('delete from face_info where id = %L;', d_id);
return owner_id;
end if;
end;
$$ LANGUAGE plpgsql;
-- select delete_face_by_id(1);
-- обработка ошибок
create or replace function dividing_by_zero(x int, y int) returns int as $$
declare res int;
begin res := x / y;
RETURN res;
EXCEPTION
WHEN division_by_zero THEN RAISE NOTICE 'перехватили ошибку division_by_zero';
end;
$$ LANGUAGE plpgsql;
-- select dividing_by_zero(4, 2);
-- select dividing_by_zero(4, 0);
-- Продемонстрировать в функциях и процедурах работу условных операторов и выполнение динамического запроса.
-- БЫЛО!
-- рекурсивный
WITH RECURSIVE r AS (
	-- стартовая часть рекурсии
	SELECT 1 AS i,
		1 AS factorial
	UNION
	-- рекурсивная часть
	SELECT i + 1 AS i,
		factorial * (i + 1) as factorial
	FROM r
	WHERE i < 10
)
SELECT *
FROM r;
DROP TABLE IF EXISTS directory CASCADE;
CREATE TABLE IF NOT EXISTS directory (
	id int not null primary key,
	parent_id int references directory(id),
	name varchar(1000)
);
INSERT INTO directory (id, parent_id, name)
VALUES (1, null, '/var'),
	(2, 1, '/var/lib'),
	(3, 1, '/var/node'),
	(4, 2, '/var/lib/qwe'),
	(5, 4, '/var/lib/qwe/asd'),
	(6, 4, '/var/lib/qwe/zxc'),
	(7, 5, '/var/lib/qwe/asd/seven'),
	(8, 5, '/var/lib/qwe/asd/eight'),
	(9, 6, '/var/lib/qwe/zxc/nine');
create or replace function get_dir_content(dir_id int default 1) RETURNS table (
		id int,
		parent_id int,
		name varchar(1000)
	) language sql as $$ WITH RECURSIVE r AS (
		SELECT id,
			parent_id,
			name
		FROM directory
		WHERE parent_id = dir_id
		UNION
		SELECT directory.id,
			directory.parent_id,
			directory.name
		FROM directory
			JOIN r ON directory.parent_id = r.id
	)
SELECT *
FROM r;
$$;
select *
from get_dir_content();
-- LIMIT
select *
from regular_user
LIMIT 2;
-- returning
INSERT INTO regular_user (username, password, email, name) -- 1
VALUES ('jora', 'pwd', 'jora@mail.ru', 'jora')
RETURNING *;
INSERT INTO regular_user (username, password, email, name) -- 1
VALUES ('zheka', 'pwd', 'zheka@mail.ru', 'zheka')
RETURNING (id, username);
-- ранжированние оконные функции
DROP TABLE IF EXISTS public.range CASCADE;
CREATE TABLE IF NOT EXISTS public.range (
	id integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name text,
	price integer
);
insert into public.range (name, price)
values ('a', 1),
	('a', 5),
	('a', 6),
	('a', 7),
	('b', 8),
	('b', 2),
	('b', 3),
	('b', 1);
SELECT id,
	name,
	price,
	rank() OVER (
		PARTITION BY name
		ORDER BY price
	),
	--DESC
	row_number() OVER (
		ORDER BY price
	),
	--DESC
	dense_rank() OVER (
		ORDER BY price
	),
	--DESC
	ntile(4) OVER (
		ORDER BY price
	) --DESC
FROM public.range;
-- курсор
CREATE OR REPLACE FUNCTION func_with_cursor_user(
		OUT email varchar(256),
		OUT pwd varchar(256)
	) RETURNS SETOF RECORD AS $$
DECLARE edges_cursor CURSOR FOR
SELECT regular_user.email,
	regular_user.password
FROM regular_user;
edge_record RECORD;
BEGIN -- Open cursor
OPEN edges_cursor;
-- Fetch rows and return
LOOP FETCH NEXT
FROM edges_cursor INTO edge_record;
EXIT
WHEN NOT FOUND;
email := edge_record.email;
pwd := edge_record.password;
RETURN NEXT;
END LOOP;
-- Close cursor
CLOSE edges_cursor;
END;
$$ LANGUAGE PLPGSQL;
select func_with_cursor_user();
-- встроенная функция
select *
from regular_user
where substring(regular_user.email for 2) = 'em';
select *
from regular_user
where substring(regular_user.email, '.*@mail\.ru$') <> '';
-- cursor + системная функция получить пользователя
CREATE OR REPLACE FUNCTION read_user_from_disk() RETURNS void LANGUAGE 'plpgsql' COST 100 VOLATILE PARALLEL UNSAFE AS $BODY$
DECLARE user_cursor CURSOR FOR
SELECT current_user;
user_name VARCHAR;
BEGIN OPEN user_cursor;
FETCH user_cursor INTO user_name;
IF FOUND THEN RAISE NOTICE 'Current user: %',
user_name;
ELSE RAISE NOTICE 'User not found';
END IF;
CLOSE user_cursor;
END;
$BODY$;
select read_user_from_disk();
-- для работы с диском
CREATE OR REPLACE FUNCTION read_directory(user_directory text) RETURNS void LANGUAGE 'plpgsql' COST 100 VOLATILE PARALLEL UNSAFE AS $BODY$
DECLARE file_name VARCHAR;
dir_cursor CURSOR FOR
SELECT *
FROM pg_ls_dir(user_directory);
BEGIN OPEN dir_cursor;
LOOP FETCH dir_cursor INTO file_name;
EXIT
WHEN NOT FOUND;
RAISE NOTICE 'File in directory %: %',
user_directory,
file_name;
END LOOP;
CLOSE dir_cursor;
END;
$BODY$;
select read_directory('//var/lib')