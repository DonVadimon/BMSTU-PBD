// Создание узла со свойствами
create (u:user{
  id: 1,
  username: 'test',
  password: 'test',
  is_male: false
})

// Изменение свойства узла
MATCH (u)
  WHERE u.id=1
  SET u.is_male=true
  RETURN u

// Удаление свойства узла
MATCH (u)
  WHERE u.id=1
  REMOVE u.username
  RETURN u

// Изменение метки
MATCH 
  (u:user{id:1}) 
  REMOVE u:user 
  SET u:admin 
  RETURN u

// Удаление метки
MATCH 
  (u:admin{id:1}) 
  REMOVE u:admin 
  RETURN u

// Создание нескольких пользователей
create (u:user{
  id: 1,
  username: '1username',
  password: 'password1',
  is_male: true
})

create (u:user{
  id: 2,
  username: '2username',
  password: 'password2',
  is_male: true
})

create (u:user{
  id: 3,
  username: '3username',
  password: 'password3',
  is_male: false
})

// Создание чатов
create (t:chat{
  id: 1,
  title: 'chat'
})

create (t:chat:cool{
  id: 2,
  title: 'chat cool'
})

create (t:chat:game{
  id: 3,
  title: 'chat game'
})

// Создание связи между существующими узлами
MATCH (u:user{id:1}), (t:chat{id:1}) MERGE (u)-[s:Membership{member: true}]->(t)
MATCH (u:user{id:1}), (t:chat:cool{id:2}) MERGE (u)-[s:Membership{member: false}]->(t)
MATCH (u:user{id:2}), (t:chat:cool{id:2}) MERGE (u)-[s:Membership{member: true}]->(t)
MATCH (u:user{id:2}), (t:chat:game{id:3}) MERGE (u)-[s:Membership{member: true}]->(t)

MATCH (u:user{id:1}), (t:chat{id:1}) MERGE (u)-[l:Muted{muted: true}]->(t)
MATCH (u:user{id:3}), (t:chat{id:1}) MERGE (u)-[l:Muted{muted: true}]->(t)
MATCH (u:user{id:3}), (t:chat:cool{id:2}) MERGE (u)-[l:Muted{muted: false}]->(t)
MATCH (u:user{id:3}), (t:chat:game{id:3}) MERGE (u)-[l:Muted{muted: false}]->(t)


// MATCH/WHERE/RETURN
MATCH (u:user) WHERE u.id=1 AND u.is_male=false RETURN u
MATCH (u:user) WHERE u.id=1 OR u.id=2 RETURN u

MATCH (u:user) WHERE u.is_male IS NOT NULL RETURN u

MATCH (u:user) RETURN u.username, u.password ORDER BY u.username DESC

MATCH (u:user)-->(t:chat) RETURN u, t
MATCH (u:user)-->(t:chat:cool) RETURN u, t

MATCH (u:user)-[s:Membership]->(c:chat) WHERE s.member=false RETURN u, c

// Создание отношения между новыми узлами
CREATE (u:user{
  id: 4,
  username: '4username',
  password: 'password4',
  is_male: false}
)-[m:Membership{member: true}]->
(c:chat:nogotochki{
  id: 4,
  title: 'nogotochki chat'
}) RETURN u, c

// Удаление всех узлов и связей
MATCH (n) DETACH DELETE n

// Удаление одного узла и всех его связей
MATCH (u:user{id:1}) DETACH DELETE u

// Удаление только связей
MATCH (u:user{id: 1})-[m:Membership]->()
DELETE m

MATCH (u:user)-[r]->(c:chat) 
WHERE u.id=1 AND c.id=1 
DELETE r

// MERGE
MERGE (u:user{username:'5username',password:'password5'})
MERGE (u:user{username:'1username',password:'password1'}) 

//UNION
MATCH (u:user) WHERE u.id=1 RETURN u
UNION
MATCH (u:user) WHERE u.id=2 RETURN u

MATCH (u:user{id:1}) RETURN u
UNION
MATCH (u:user{id:2}) RETURN u

//LIMIT
MATCH (u:user) WHERE u.is_male=true RETURN u LIMIT 2

//SKIP
MATCH (u:user) WHERE u.is_male=true RETURN u SKIP 2

//DISTINCT
MATCH (u:user) RETURN DISTINCT u.is_male

// Агрегирование
MATCH (u:user) RETURN count(u.id)

// Строковые функции
MATCH (u:user) RETURN toUpper(u.username)

// Индексы
CREATE INDEX user_is_male_index FOR (u:user) ON (u.is_male)

// Ограничение уникальности свойства
CREATE CONSTRAINT username_unique FOR (u:user) REQUIRE u.usernmae IS UNIQUE

// SELECT
MATCH (u:user)-[r]->(c:chat) RETURN u, c
MATCH (u:user), (c:chat) RETURN u, c

// Удаление узла
MATCH (u:user) WHERE u.id=1 DELETE u

// Вернуть все узлы БД
MATCH (n) RETURN n

// Вернуть все узды БД с определенной меткой
MATCH (u:user) RETURN u

// Создать узел с несколькими лейблами
CREATE (node:label1:label2{
  id: 1
})

// Вернуть узлы с несколькими лейблами
MATCH (node:label1:label2) RETURN node

// Удалить уазлы с несколькими лейблами
MATCH (node:label1:label2) DELETE node

// Вывести пользователей, у которых обозначено включение в чат, в названии которошл упоминается "chat"
MATCH (u:user)-[m:Membership]->(c:chat) WHERE m.member IS NOT NULL and c.title =~ '.*chat.*' RETURN u, c
