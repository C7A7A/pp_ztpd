-- CONTAINS --
-- 1
CREATE TABLE CYTATY_C AS
SELECT * FROM ZTPD.CYTATY;

DESCR CYTATY_C;

-- 2
SELECT * FROM CYTATY_C
WHERE lower(tekst) like '%optymista%' AND lower(tekst) like '%pesymista%';

-- 3
CREATE INDEX idx_fulltext_cytaty
ON CYTATY_C(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;

-- 4
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'optymista AND pesymista') > 0; 

-- 5
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'pesymista NOT optymista') > 0; 

-- 6
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'NEAR((optymista, pesymista), 3)') > 0;

-- 7
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'NEAR((optymista, pesymista), 10)') > 0;

-- 8
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, '?yci%') > 0;

-- 9
SELECT score(1) FROM CYTATY_C
WHERE CONTAINS(tekst, '?yci%', 1) > 0;

-- 10
SELECT score(1) FROM CYTATY_C
WHERE CONTAINS(tekst, '?yci%', 1) > 0
ORDER BY score(1) DESC
FETCH FIRST 1 ROW ONLY;

-- 11
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'fuzzy(probelm)', 1) > 0;

-- 12
INSERT INTO CYTATY_C
VALUES(39, 'Bertrand Russell', 'To smutne, ?e g?upcy s? tacy pewni siebie, a ludzie rozs?dni tacy pe?ni w?tpliwo?ci.');

COMMIT;

-- 13
SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'g?upcy', 1) > 0;

-- 14
SELECT token_text FROM DR$IDX_FULLTEXT_CYTATY$I
WHERE token_text = 'G?UPCY';

-- 15
DROP INDEX idx_fulltext_cytaty;

CREATE INDEX idx_fulltext_cytaty
ON CYTATY_C(tekst)
INDEXTYPE IS CTXSYS.CONTEXT;

-- 16
SELECT token_text FROM DR$IDX_FULLTEXT_CYTATY$I
WHERE token_text = 'G?UPCY';

SELECT * FROM CYTATY_C
WHERE CONTAINS(tekst, 'g?upcy', 1) > 0;

-- 17
DROP INDEX idx_fulltext_cytaty;

DROP TABLE CYTATY_C;

-- ADVANCED INDEXING AND SEARCHING --
-- 1
CREATE TABLE QUOTES AS
SELECT * FROM ZTPD.QUOTES;

DESCR QUOTES;

-- 2
CREATE INDEX idx_fulltext_quotes
ON QUOTES(text)
INDEXTYPE IS CTXSYS.CONTEXT;

-- 3
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'work', 1) > 0;

SELECT * FROM QUOTES
WHERE CONTAINS(text, '$work', 1) > 0;

SELECT * FROM QUOTES
WHERE CONTAINS(text, 'working', 1) > 0;

SELECT * FROM QUOTES
WHERE CONTAINS(text, '$working', 1) > 0;

-- 4
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'it', 1) > 0;

-- 5
SELECT * FROM CTX_STOPLISTS;

-- 6
SELECT * FROM CTX_STOPWORDS;

-- 7
DROP INDEX idx_fulltext_quotes;

CREATE INDEX idx_fulltext_quotes
ON QUOTES(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST');

-- 8
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'it', 1) > 0;

-- 9
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'fool AND humans', 1) > 0;

-- 10
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'fool AND computer', 1) > 0;

-- 11
SELECT * FROM QUOTES
WHERE CONTAINS(text, '(fool AND humans) within sentence', 1) > 0;

-- 12
DROP INDEX idx_fulltext_quotes;

-- 13
BEGIN
    ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
    ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
    ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
END;

-- 14
CREATE INDEX idx_fulltext_quotes
ON QUOTES(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup');

-- 15
SELECT * FROM QUOTES
WHERE CONTAINS(text, '(fool AND humans) within sentence', 1) > 0;

SELECT * FROM QUOTES
WHERE CONTAINS(text, '(fool AND computer) within sentence', 1) > 0;

-- 16
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'humans', 1) > 0;

-- 17
DROP INDEX idx_fulltext_quotes;

BEGIN
    ctx_ddl.create_preference('dash_lexer', 'BASIC_LEXER');
    ctx_ddl.set_attribute('dash_lexer', 'printjoins', '-');
    ctx_ddl.set_attribute ('dash_lexer', 'index_text', 'YES');
END;

CREATE INDEX idx_fulltext_quotes
ON QUOTES(text)
INDEXTYPE IS CTXSYS.CONTEXT
PARAMETERS ('stoplist CTXSYS.EMPTY_STOPLIST section group nullgroup lexer dash_lexer');

-- 18
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'humans', 1) > 0;

-- 19
SELECT * FROM QUOTES
WHERE CONTAINS(text, 'non\-humans', 1) > 0;

-- 20
DROP TABLE QUOTES;

BEGIN
    CTX_DDL.DROP_SECTION_GROUP('nullgroup');
    CTX_DDL.DROP_PREFERENCE('dash_lexer');
END;
