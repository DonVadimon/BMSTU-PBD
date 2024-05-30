COPY face_info TO '/volumes/face_info_raw.xml';
select table_to_xml('regular_user', true, true, '');
COPY (
    SELECT table_to_xml('face_info', true, true, '')
) TO '/volumes/face_info_table_to_xml.xml';
select query_to_xml('select * from regular_user', true, true, 'k');
COPY (
    SELECT query_to_xml('select * from regular_user', true, true, '')
) TO '/volumes/regular_user_query_to_xml.xml';
SELECT xmlelement(name user, xmlattributes(username, password))
FROM regular_user;
SELECT xmlelement(
        name users,
        xmlelement(name user, xmlattributes(username, password))
    )
FROM regular_user;
SELECT xmlelement(name user, xmlattributes(username, password))
FROM regular_user;
SELECT xmlelement(
        name user,
        xmlattributes(username as nickname, password as pwd)
    )
FROM regular_user;
SELECT xmlelement(
        name user,
        xmlelement(name nickname, username),
        xmlelement(name pwd, password)
    )
FROM regular_user;
SELECT xmlforest(
        id,
        username,
        password,
        email,
        name,
        created_at,
    )
FROM regular_user;
SELECT xmlroot(
        xmlelement(name user, xmlforest(id, username, password)),
        version '1.1',
        standalone yes
    )
FROM regular_user;
SELECT xmlelement(
        name root,
        xmlagg(
            xmlelement(name user, xmlforest(id, username, password))
        )
    )
FROM regular_user;
-- вложенная структура
copy (
    select xmlelement(
            name rootelem,
            xmlagg(
                xmlelement(
                    name chat,
                    xmlattributes(name),
                    xmlconcat(
                        (
                            select xmlagg(
                                    xmlelement(
                                        name msg,
                                        xmlattributes(
                                            content as text
                                        )
                                    )
                                )
                            from chat_message
                            where "chat_message".chat_id = "chat".id
                        )
                    )
                )
            )
        )
    from chat
) to '/volumes/join.xml';
-- //div[@class="Constructor-PartList"]//div[@class="ConstructorForm-TopicDesc"]/u/text()
SELECT xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'));
-- exist
SELECT xpath_exists(
        '//ZONE[@c]',
        xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))
    );
-- not exist
SELECT xpath_exists(
        '//ZONE[@c="123"]',
        xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))
    );
SELECT unnest(
        xpath(
            '//ZONE[..//COMMON[@a=3]]',
            xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))
        )
    );
SELECT unnest(
        xpath(
            '//COMMON[@b][@a=3]/@b',
            xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))
        )
    );
SELECT unnest(
        xpath(
            '//COMMON/text()',
            xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))
        )
    );
SELECT unnest(
        xpath(
            'count(//COMMON)',
            xmlparse(DOCUMENT pg_read_file('/volumes/example.xml'))
        )
    );
SELECT unnest(
        xpath(
            'count(//p)',
            xmlparse(DOCUMENT pg_read_file('/volumes/html.xml'))
        )
    );
SELECT unnest(
        xpath(
            '//p//img/@src',
            xmlparse(DOCUMENT pg_read_file('/volumes/html.xml'))
        )
    );
select unset(
        table_to_xml_and_xmlschema('regular_user', true, true, '')
    );
-- ! habr
select unnest(
        xpath(
            '//body//article//div[1]//h2//a//span[contains(text(), "ChatGPT")]',
            xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))
        )
    );
select unnest(
        xpath(
            '//body//article//div[1]//h2//a//span[not (contains(text(), "Яндекс"))]',
            xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))
        )
    );
select unnest(
        xpath(
            '//body//article//div[2]//button//span[2]/text()',
            xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))
        )
    );
select unnest(
        xpath(
            'count(//body//article//div[2]//button//span[2][text()>10])',
            xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))
        )
    );
select unnest(
        xpath(
            '//body//article//div[2]//button//span[2][text()>10]/text()',
            xmlparse(DOCUMENT pg_read_file('/volumes/habr.xml'))
        )
    );
-- ! habr
