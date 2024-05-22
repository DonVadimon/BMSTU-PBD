INSERT INTO chat_message (content, chat_id, author_id)
VALUES (
        'In the intergalactic empire Bubbledom there are N planets, of which some pairs are directly connected by two-way wormholes. There are N-1 wormholes. The wormholes are of extreme religious importance in Bubbledom, a set of planets in Bubbledom consider themselves one intergalactic kingdom if and only if any two planets in the set can reach each other by traversing the wormholes. You are given that Bubbledom is one kingdom. In other words, the network of planets and wormholes is a tree.',
        1,
        3
    ),
    (
        'Ivan unexpectedly saw a present from one of his previous birthdays. It is array of n numbers from 1 to 200. Array is old and some numbers are hard to read. Ivan remembers that for all elements at least one of its neighbours ls not less than it, more formally:',
        3,
        1
    ),
    (
        'One fine day Sasha went to the park for a walk. In the park, he saw that his favorite bench is occupied, and he had to sit down on the neighboring one. He sat down and began to listen to the silence. Suddenly, he got a question: what if in different parts of the park, the silence sounds in different ways? So it was. Let''s divide the park into 1 × 1 meter squares and call them cells, and numerate rows from 1 to n from up to down, and columns from 1 to m from left to right. And now, every cell can be described with a pair of two integers (x, y), where x — the number of the row, and y — the number of the column. Sasha knows that the level of silence in the cell (i, j) equals to f_{i,j}, and all f_{i,j} form a permutation of numbers from 1 to n ⋅ m. Sasha decided to count, how many are there pleasant segments of silence?',
        1,
        3
    ),
    (
        'You are given a tree (a connected undirected graph without cycles) of n vertices. Each of the n - 1 edges of the tree is colored in either black or red.
                  You are also given an integer k. Consider sequences of k vertices. Let''s call a sequence [a_1, a_2, …, a_k] good if it satisfies the following criterion:',
        3,
        1
    ),
    (
        'Codehorses has just hosted the second Codehorses Cup. This year, the same as the previous one, organizers are giving T-shirts for the winners.',
        1,
        3
    );
SELECT to_tsvector('english', content)
from chat_message;
SELECT 'has just hosted the second Codehorses Cup'::tsvector;
SELECT to_tsquery('the & intergalactic & park');
-- SELECT id, ts_rank(to_tsvector("document_text"), plainto_tsquery('запрос'))
-- FROM documents_document
-- WHERE to_tsvector("document_text") @@ plainto_tsquery('запрос')
-- ORDER BY ts_rank(to_tsvector("document_text"), plainto_tsquery('запрос')) DESC;
SELECT content,
    ts_rank(
        to_tsvector(content),
        to_tsquery('Codehorses | number')
    ) as rank
from chat_message
where to_tsvector(content) @@ to_tsquery('Codehorses | number')
order by rank desc;
SELECT content,
    ts_rank(
        to_tsvector(content),
        to_tsquery('Codehorses <-> cup')
    ) as rank
from chat_message
where to_tsvector(content) @@ (to_tsquery('Codehorses <-> cup'))
order by rank desc;
SELECT content,
    ts_rank(
        to_tsvector(content),
        to_tsquery('Codehorses <3> hosted')
    ) as rank
from chat_message
where to_tsvector(content) @@ (to_tsquery('Codehorses <3> hosted'))
order by rank desc;
-- /usr/share/postgresql/16/tsearch_data/dict.stop
DROP TEXT SEARCH DICTIONARY IF EXISTS my_dict;
CREATE TEXT SEARCH DICTIONARY my_dict (
    TEMPLATE = pg_catalog.simple,
    stopwords = 'dict'
);
SELECT ts_lexize('my_dict', 'opa');