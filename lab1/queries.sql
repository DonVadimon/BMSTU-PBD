-- select items
SELECT id,
	tags [1],
	box [0],
	range,
	json->'num'
FROM public.chat WHERE id = 1;
-- add to array https://www.postgresql.org/docs/current/functions-array.html
UPDATE public.chat
SET tags = ARRAY_APPEND(tags, 'pbd')
WHERE id = 1;
-- remove from array https://www.postgresql.org/docs/current/functions-array.html
UPDATE public.chat
SET tags = ARRAY_REMOVE(tags, 'pbd')
WHERE id = 1;
-- box contains https://www.postgresql.org/docs/9.5/functions-geometry.html
SELECT *
FROM public.chat
WHERE box @> point('(1,2)');
-- box contains https://www.postgresql.org/docs/9.5/functions-geometry.html
SELECT area(box)
FROM public.chat
WHERE id = 1;
-- range overlap https://www.postgresql.org/docs/9.3/functions-range.html
SELECT *
FROM public.chat
WHERE range <> '(2,6]';
-- range overlap https://www.postgresql.org/docs/9.3/functions-range.html
SELECT *
FROM public.chat
WHERE range @> '(3,4]';