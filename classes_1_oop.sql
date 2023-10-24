-- Skrypty tworz?ce tabele pracownicy, etaty i zespoly
DROP TABLE PRACOWNICY cascade constraints;
DROP TABLE ZESPOLY cascade constraints;
DROP TABLE ETATY cascade constraints;

CREATE TABLE ZESPOLY
	(ID_ZESP NUMBER(4) CONSTRAINT PK_ZESP PRIMARY KEY,
	NAZWA VARCHAR2(20),
	ADRES VARCHAR2(20) );

CREATE TABLE ETATY
      ( NAZWA VARCHAR2(10) CONSTRAINT PK_ETAT PRIMARY KEY,
	PLACA_MIN NUMBER(6,2),
	PLACA_MAX NUMBER(6,2));

CREATE TABLE PRACOWNICY
       (ID_PRAC NUMBER(6) CONSTRAINT PK_PRAC PRIMARY KEY,
	NAZWISKO VARCHAR2(15),
	ETAT VARCHAR2(10) CONSTRAINT FK_ETAT REFERENCES ETATY(NAZWA),
	ID_SZEFA NUMBER(6) CONSTRAINT FK_ID_SZEFA REFERENCES PRACOWNICY(ID_PRAC),
	ZATRUDNIONY DATE,
	PLACA_POD NUMBER(6,2) CONSTRAINT MIN_PLACA_POD CHECK(PLACA_POD>100),
	PLACA_DOD NUMBER(6,2),
	ID_ZESP NUMBER(4) CONSTRAINT FK_ID_ZESP REFERENCES ZESPOLY(ID_ZESP));

INSERT INTO ZESPOLY VALUES (10,'ADMINISTRACJA',      'PIOTROWO 3A');
INSERT INTO ZESPOLY VALUES (20,'SYSTEMY ROZPROSZONE','PIOTROWO 3A');
INSERT INTO ZESPOLY VALUES (30,'SYSTEMY EKSPERCKIE', 'STRZELECKA 14');
INSERT INTO ZESPOLY VALUES (40,'ALGORYTMY',          'WLODKOWICA 16');
INSERT INTO ZESPOLY VALUES (50,'BADANIA OPERACYJNE', 'MIELZYNSKIEGO 30');

INSERT INTO ETATY VALUES ('PROFESOR'  ,800.00,1500.00);
INSERT INTO ETATY VALUES ('ADIUNKT'   ,510.00, 750.00);
INSERT INTO ETATY VALUES ('ASYSTENT'  ,300.00, 500.00);
INSERT INTO ETATY VALUES ('STAZYSTA'  ,150.00, 250.00);
INSERT INTO ETATY VALUES ('SEKRETARKA',270.00, 450.00);
INSERT INTO ETATY VALUES ('DYREKTOR' ,1280.00,2100.00);
 
INSERT INTO PRACOWNICY VALUES (100,'WEGLARZ'    ,'DYREKTOR'  ,NULL,to_date('01-01-1968','DD-MM-YYYY'),1730.00,420.50,10);
INSERT INTO PRACOWNICY VALUES (110,'BLAZEWICZ'  ,'PROFESOR'  ,100 ,to_date('01-05-1973','DD-MM-YYYY'),1350.00,210.00,40);
INSERT INTO PRACOWNICY VALUES (120,'SLOWINSKI'  ,'PROFESOR'  ,100 ,to_date('01-09-1977','DD-MM-YYYY'),1070.00,  NULL,30);
INSERT INTO PRACOWNICY VALUES (130,'BRZEZINSKI' ,'PROFESOR'  ,100 ,to_date('01-07-1968','DD-MM-YYYY'), 960.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (140,'MORZY'      ,'PROFESOR'  ,130 ,to_date('15-09-1975','DD-MM-YYYY'), 830.00,105.00,20);
INSERT INTO PRACOWNICY VALUES (150,'KROLIKOWSKI','ADIUNKT'   ,130 ,to_date('01-09-1977','DD-MM-YYYY'), 645.50,  NULL,20);
INSERT INTO PRACOWNICY VALUES (160,'KOSZLAJDA'  ,'ADIUNKT'   ,130 ,to_date('01-03-1985','DD-MM-YYYY'), 590.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (170,'JEZIERSKI'  ,'ASYSTENT'  ,130 ,to_date('01-10-1992','DD-MM-YYYY'), 439.70, 80.50,20);
INSERT INTO PRACOWNICY VALUES (190,'MATYSIAK'   ,'ASYSTENT'  ,140 ,to_date('01-09-1993','DD-MM-YYYY'), 371.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (180,'MAREK'      ,'SEKRETARKA',100 ,to_date('20-02-1985','DD-MM-YYYY'), 410.20,  NULL,10);
INSERT INTO PRACOWNICY VALUES (200,'ZAKRZEWICZ' ,'STAZYSTA'  ,140 ,to_date('15-07-1994','DD-MM-YYYY'), 208.00,  NULL,30);
INSERT INTO PRACOWNICY VALUES (210,'BIALY'      ,'STAZYSTA'  ,130 ,to_date('15-10-1993','DD-MM-YYYY'), 250.00,170.60,30);
INSERT INTO PRACOWNICY VALUES (220,'KONOPKA'    ,'ASYSTENT'  ,110 ,to_date('01-10-1993','DD-MM-YYYY'), 480.00,  NULL,20);
INSERT INTO PRACOWNICY VALUES (230,'HAPKE'      ,'ASYSTENT'  ,120 ,to_date('01-09-1992','DD-MM-YYYY'), 480.00, 90.00,30);

COMMIT;

-- Zadanie 1
create type Samochod as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produ date,
    cena number(10, 2)
);

desc samochod;

create table samochody 
of samochod;

insert into samochody values
    (
        new samochod(
            'fiat', 
            'brava', 
            60000, 
            date '1999-11-30', 
            25000)
    );

insert into samochody values   
    (new samochod('ford', 'mondeo', 80000, date '1997-05-10', 45000));
    
insert into samochody values
    (new samochod('mazda', '323', 12000, date '2000-09-22', 52000));

select * from samochody;

-- Zadanie 2
create type Wlasciciel as object (
    imie varchar2(100),
    nazwisko varchar2(100),
    auto samochod
);

desc wlasciciel;

create table wlasciciele of wlasciciel;

insert into wlasciciele values
    (new wlasciciel(
        'Jan', 
        'Kowalski', 
        new samochod('fiat', 'seicento', 30000, date '2010-12-02', 19500)
    ));
    
insert into wlasciciele values
    (new wlasciciel(
        'Adam', 
        'Nowak', 
        new samochod('opel', 'astra', 34000, date '2009-06-01', 33700)
    ));

select * from wlasciciele;

-- Zadanie 3
alter type samochod replace as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produ date,
    cena number(10, 2),
    member function wartosc return number
);

create or replace type body samochod as
    member function wartosc return number is
    begin
        return round(cena * power(0.9, extract(year from current_date) - extract(year from data_produ)), 2);
    end wartosc;
end;

select s.marka, s.model, s.cena, s.data_produ, s.wartosc()
from samochody s;

-- Zadanie 4
alter type samochod add map member function odwzoruj
return number cascade including table data;

create or replace type body samochod as
    member function wartosc return number is
    begin
        return round(cena * power(0.9, extract(year from current_date) - extract(year from data_produ)), 2);
    end wartosc;
    
    map member function odwzoruj return number is
    begin
        return round(extract(year from current_date) - extract(year from data_produ) + (kilometry / 10000), 2);
    end odwzoruj;
end;

select * from samochody s 
order by value(s);

-- Zadanie 5
create type wlasciciel2 as object (
    imie varchar2(100),
    nazwisko varchar2(100)
);

create table wlasciciele2 of wlasciciel2;
insert into wlasciciele2 values (new wlasciciel2('Jan', 'Kowalski'));

create type samochod2 as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produ date,
    cena number(10, 2),
    wlasciciel ref wlasciciel2
);

create table samochody2 of samochod2;
insert into samochody2 values   
    (new samochod2('ford', 'mondeo', 80000, date '1997-05-10', 45000, null));
insert into samochody2 values   
    (new samochod2('mazda', '323', 12000, date '2000-09-22', 52000, null));
insert into samochody2 values   
     (new samochod2('fiat', 'brava', 60000, date '1999-11-30', 25000, null));
     
update samochody2 s
set s.wlasciciel = (
    select ref(w) from wlasciciele2 w
    where w.imie = 'Jan'
);
select * from samochody2;

-- Zadanie 6
set serveroutput on size 30000;

DECLARE
    TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
    moje_przedmioty t_przedmioty := t_przedmioty('');
    
BEGIN
    moje_przedmioty(1) := 'MATEMATYKA';
    moje_przedmioty.EXTEND(9);
    
    FOR i IN 2..10 LOOP
        moje_przedmioty(i) := 'PRZEDMIOT_' || i;
    END LOOP;
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    moje_przedmioty.TRIM(2);
    
    FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.EXTEND();
    moje_przedmioty(9) := 9;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
    
    moje_przedmioty.DELETE();
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

-- Zadanie 7
declare
    type t_ksiazki is varray(5) of varchar2(50);
    moje_ksiazki t_ksiazki := t_ksiazki('title');
begin
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());
    
    moje_ksiazki.extend(4);
    moje_ksiazki(2) := 'Król Szczurów';
    for i in 3..5 loop
        moje_ksiazki(i) := 'Book_' || i;
    end loop;
    
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());
    
    moje_ksiazki.trim(1);
    for i in moje_ksiazki.first()..moje_ksiazki.last() loop
        dbms_output.put_line(moje_ksiazki(i));
    end loop;
    dbms_output.put_line('Limit: ' || moje_ksiazki.limit());
    dbms_output.put_line('Liczba elementow: ' || moje_ksiazki.count());

end;

-- Zadanie 8
DECLARE
    TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
    moi_wykladowcy t_wykladowcy := t_wykladowcy();

BEGIN
    moi_wykladowcy.EXTEND(2);
    moi_wykladowcy(1) := 'MORZY';
    moi_wykladowcy(2) := 'WOJCIECHOWSKI';
    moi_wykladowcy.EXTEND(8);
    
    FOR i IN 3..10 LOOP
        moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
    END LOOP;
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.TRIM(2);
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
    END LOOP;
    
    moi_wykladowcy.DELETE(5,7);
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    moi_wykladowcy(5) := 'ZAKRZEWICZ';
    moi_wykladowcy(6) := 'KROLIKOWSKI';
    moi_wykladowcy(7) := 'KOSZLAJDA';
    
    FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
        IF moi_wykladowcy.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
    DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

-- Zadanie 9
declare
    type t_miesiace is table of varchar2(20);
    moje_miesiace t_miesiace := t_miesiace();

begin
    moje_miesiace.extend(12);
    moje_miesiace(1) := 'styczen';
    moje_miesiace(2) := 'luty';
    moje_miesiace(3) := 'marzec';
    moje_miesiace(4) := 'kwiecien';
    moje_miesiace(5) := 'maj';
    moje_miesiace(6) := 'czerwiec';
    
    for i in 7..12 loop
        moje_miesiace(i) := 'Miesiac_' || i;
    end loop;
    
    for i in moje_miesiace.first()..moje_miesiace.last() loop
        if moje_miesiace.exists(i) then
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        end if;
    end loop;
    
    moje_miesiace.delete(7, 12);
    moje_miesiace(7) := 'lipiec';
    
    for i in moje_miesiace.first()..moje_miesiace.last() loop
        if moje_miesiace.exists(i) then
            DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
        end if;
    end loop;

end;

-- Zadanie 10
CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/

CREATE TYPE stypendium AS OBJECT (
    nazwa VARCHAR2(50),
    kraj VARCHAR2(30),
    jezyki jezyki_obce 
);
/

CREATE TABLE stypendia OF stypendium;

INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));

SELECT * FROM stypendia;

SELECT s.jezyki FROM stypendia s;

UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';

CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/

CREATE TYPE semestr AS OBJECT (
    numer NUMBER,
    egzaminy lista_egzaminow );
/

CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;

INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));

SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;

SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;

SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );

INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');

UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';

DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

-- Zadanie 11
create type koszyk_produktow as table of varchar2(20); 

create type zakup as object (
    osoba varchar2(50),
    produkty koszyk_produktow
);
/

create table zakupy of zakup
nested table produkty store as tab_produkty;

insert into zakupy values
(zakup('Mateusz Czajka', koszyk_produktow('maslo', 'chleb', 'banan')));
insert into zakupy values
(zakup('Jan Kowalski', koszyk_produktow('kowadlo', 'stal', 'zelazo')));
insert into zakupy values
(zakup('Antoni Nowak', koszyk_produktow('maslo')));

select * from zakupy;

delete from zakupy 
where osoba in (
    select osoba
    from zakupy z, table(z.produkty) p
    where p.column_value = 'maslo'
);

-- Zadanie 12
CREATE TYPE instrument AS OBJECT (
    nazwa VARCHAR2(20),
    dzwiek VARCHAR2(20),
    MEMBER FUNCTION graj RETURN VARCHAR2 
) NOT FINAL;

CREATE TYPE BODY instrument AS
    MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN dzwiek;
    END;
END;
/

CREATE TYPE instrument_dety UNDER instrument (
    material VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2,
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 
);

CREATE OR REPLACE TYPE BODY instrument_dety AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'dmucham: '||dzwiek;
    END;
    MEMBER FUNCTION graj(glosnosc VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN glosnosc||':'||dzwiek;
    END;
END;
/

CREATE TYPE instrument_klawiszowy UNDER instrument (
    producent VARCHAR2(20),
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 
);
    
CREATE OR REPLACE TYPE BODY instrument_klawiszowy AS
    OVERRIDING MEMBER FUNCTION graj RETURN VARCHAR2 IS
    BEGIN
        RETURN 'stukam w klawisze: '||dzwiek;
    END;
END;
/

DECLARE
    tamburyn instrument := instrument('tamburyn','brzdek-brzdek');
    trabka instrument_dety := instrument_dety('trabka','tra-ta-ta','metalowa');
    fortepian instrument_klawiszowy := instrument_klawiszowy('fortepian','ping-ping','steinway');
BEGIN
    dbms_output.put_line(tamburyn.graj);
    dbms_output.put_line(trabka.graj);
    dbms_output.put_line(trabka.graj('glosno'));
    dbms_output.put_line(fortepian.graj);
END;

-- Zadanie 13
CREATE TYPE istota AS OBJECT (
    nazwa VARCHAR2(20),
    NOT INSTANTIABLE MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR 
) NOT INSTANTIABLE NOT FINAL;

CREATE TYPE lew UNDER istota (
    liczba_nog NUMBER,
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR 
);

CREATE OR REPLACE TYPE BODY lew AS
    OVERRIDING MEMBER FUNCTION poluj(ofiara CHAR) RETURN CHAR IS
    BEGIN
        RETURN 'upolowana ofiara: '||ofiara;
    END;
END;

DECLARE
    KrolLew lew := lew('LEW',4);
--    InnaIstota istota := istota('JAKIES ZWIERZE');
BEGIN
    DBMS_OUTPUT.PUT_LINE( KrolLew.poluj('antylopa') );
END;

-- Zadanie 14
DECLARE
    tamburyn instrument;
    cymbalki instrument;
    trabka instrument_dety;
    saksofon instrument_dety;
BEGIN
    tamburyn := instrument('tamburyn','brzdek-brzdek');
    cymbalki := instrument_dety('cymbalki','ding-ding','metalowe');
    trabka := instrument_dety('trabka','tra-ta-ta','metalowa');
--    saksofon := instrument('saksofon','tra-taaaa');
--    saksofon := TREAT( instrument('saksofon','tra-taaaa') AS instrument_dety);
END;

-- Zadanie 15
CREATE TABLE instrumenty OF instrument;

INSERT INTO instrumenty VALUES ( instrument('tamburyn','brzdek-brzdek') );
INSERT INTO instrumenty VALUES ( instrument_dety('trabka','tra-ta-ta','metalowa'));
INSERT INTO instrumenty VALUES ( instrument_klawiszowy('fortepian','ping-ping','steinway'));

SELECT i.nazwa, i.graj() FROM instrumenty i;

-- Zadanie 16
CREATE TABLE PRZEDMIOTY (
    NAZWA VARCHAR2(50),
    NAUCZYCIEL NUMBER REFERENCES PRACOWNICY(ID_PRAC)
);

INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',100);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',100);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',110);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',110);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',120);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',120);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',130);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',140);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',140);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',140);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',150);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',150);
INSERT INTO PRZEDMIOTY VALUES ('BAZY DANYCH',160);
INSERT INTO PRZEDMIOTY VALUES ('SYSTEMY OPERACYJNE',160);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',170);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',180);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',180);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',190);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',200);
INSERT INTO PRZEDMIOTY VALUES ('GRAFIKA KOMPUTEROWA',210);
INSERT INTO PRZEDMIOTY VALUES ('PROGRAMOWANIE',220);
INSERT INTO PRZEDMIOTY VALUES ('SIECI KOMPUTEROWE',220);
INSERT INTO PRZEDMIOTY VALUES ('BADANIA OPERACYJNE',230);

-- Zadanie 17
CREATE TYPE ZESPOL AS OBJECT (
    ID_ZESP NUMBER,
    NAZWA VARCHAR2(50),
    ADRES VARCHAR2(100)
);
/

-- Zadanie 18
CREATE OR REPLACE VIEW ZESPOLY_V OF ZESPOL
WITH OBJECT IDENTIFIER(ID_ZESP)
AS SELECT ID_ZESP, NAZWA, ADRES FROM ZESPOLY;

-- Zadanie 19
CREATE TYPE PRZEDMIOTY_TAB AS TABLE OF VARCHAR2(100);
/

CREATE TYPE PRACOWNIK AS OBJECT (
    ID_PRAC NUMBER,
    NAZWISKO VARCHAR2(30),
    ETAT VARCHAR2(20),
    ZATRUDNIONY DATE,
    PLACA_POD NUMBER(10,2),
    MIEJSCE_PRACY REF ZESPOL,
    PRZEDMIOTY PRZEDMIOTY_TAB,
    MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY PRACOWNIK AS
    MEMBER FUNCTION ILE_PRZEDMIOTOW RETURN NUMBER IS
    BEGIN
        RETURN PRZEDMIOTY.COUNT();
    END ILE_PRZEDMIOTOW;
END;

-- Zadanie 20
CREATE OR REPLACE VIEW PRACOWNICY_V OF PRACOWNIK
WITH OBJECT IDENTIFIER (ID_PRAC)
AS SELECT ID_PRAC, NAZWISKO, ETAT, ZATRUDNIONY, PLACA_POD,
    MAKE_REF(ZESPOLY_V,ID_ZESP),
    CAST(MULTISET( SELECT NAZWA FROM PRZEDMIOTY WHERE NAUCZYCIEL=P.ID_PRAC ) AS PRZEDMIOTY_TAB )
FROM PRACOWNICY P;

-- Zadanie 21
SELECT *
FROM PRACOWNICY_V;

SELECT P.NAZWISKO, P.ETAT, P.MIEJSCE_PRACY.NAZWA
FROM PRACOWNICY_V P;

SELECT P.NAZWISKO, P.ILE_PRZEDMIOTOW()
FROM PRACOWNICY_V P;

SELECT *
FROM TABLE( SELECT PRZEDMIOTY FROM PRACOWNICY_V WHERE NAZWISKO='WEGLARZ' );

SELECT NAZWISKO, CURSOR( SELECT PRZEDMIOTY
FROM PRACOWNICY_V
WHERE ID_PRAC=P.ID_PRAC)
FROM PRACOWNICY_V P;

-- Zadanie 22
CREATE TABLE PISARZE (
    ID_PISARZA NUMBER PRIMARY KEY,
    NAZWISKO VARCHAR2(20),
    DATA_UR DATE 
);

CREATE TABLE KSIAZKI (
    ID_KSIAZKI NUMBER PRIMARY KEY,
    ID_PISARZA NUMBER NOT NULL REFERENCES PISARZE,
    TYTUL VARCHAR2(50),
    DATA_WYDANIE DATE 
);

INSERT INTO PISARZE VALUES(10,'SIENKIEWICZ',DATE '1880-01-01');
INSERT INTO PISARZE VALUES(20,'PRUS',DATE '1890-04-12');
INSERT INTO PISARZE VALUES(30,'ZEROMSKI',DATE '1899-09-11');

INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(10,10,'OGNIEM I MIECZEM',DATE '1990-01-05');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(20,10,'POTOP',DATE '1975-12-09');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(30,10,'PAN WOLODYJOWSKI',DATE '1987-02-15');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(40,20,'FARAON',DATE '1948-01-21');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(50,20,'LALKA',DATE '1994-08-01');
INSERT INTO KSIAZKI(ID_KSIAZKI,ID_PISARZA,TYTUL,DATA_WYDANIE) VALUES(60,30,'PRZEDWIOSNIE',DATE '1938-02-02');

create type ksiazki_tab as table of varchar2(50);

create or replace type pisarz as object (
    ID_PISARZA NUMBER,
    NAZWISKO VARCHAR2(20),
    DATA_UR DATE,
    KSIAZKI KSIAZKI_TAB,
    MEMBER FUNCTION liczba_ksiazek RETURN NUMBER
);

create or replace type body pisarz as
    member function liczba_ksiazek return number is
    begin
        return ksiazki.count();
    end;
end;

CREATE or replace type KSIAZKA as object (
    ID_KSIAZKI NUMBER,
    autor ref pisarz,
    TYTUL VARCHAR2(50),
    DATA_WYDANIE DATE,
    member function wiek return number
);

create or replace type body ksiazka as
    member function wiek return number is
    begin
        return extract(year from current_date) - extract(YEAR from data_wydanie);
    end;
end;

create or replace view pisarze_widok of pisarz with object identifier(id_pisarza)
as select id_pisarza, nazwisko, data_ur cast(multiset(
    select tytul 
    from ksiazki 
    where id_pisarza = p.id_pisarza
) as ksiazki_tab) from pisarze p;

create or replace view ksiazki_widok of ksiazka with object identifier(id_ksiazki)
as select id_ksiazki, make_ref(pisarze_widok, id_pisarza), tytul, data_wydanie from ksiazki;

select k.tytul, k.data_wydanie, k.autor, k.wiek() from ksiazki_widok k;
select * from pisarze_widok p;

-- Zadanie 23
CREATE TYPE AUTO AS OBJECT (
    MARKA VARCHAR2(20),
    MODEL VARCHAR2(20),
    KILOMETRY NUMBER,
    DATA_PRODUKCJI DATE,
    CENA NUMBER(10,2),
    MEMBER FUNCTION WARTOSC RETURN NUMBER
) not final;

CREATE OR REPLACE TYPE BODY AUTO AS
    MEMBER FUNCTION WARTOSC RETURN NUMBER IS
        WIEK NUMBER;
        WARTOSC NUMBER;
    BEGIN
        WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
        WARTOSC := CENA - (WIEK * 0.1 * CENA);
        IF (WARTOSC < 0) THEN
            WARTOSC := 0;
        END IF;
        RETURN WARTOSC;
    END WARTOSC;
END;

CREATE TABLE AUTA OF AUTO;

INSERT INTO AUTA VALUES (AUTO('FIAT','BRAVA',60000,DATE '1999-11-30',25000));
INSERT INTO AUTA VALUES (AUTO('FORD','MONDEO',80000,DATE '1997-05-10',45000));
INSERT INTO AUTA VALUES (AUTO('MAZDA','323',12000,DATE '2000-09-22',52000));

create or replace type auto_osobowe under auto (
    liczba_miejsc number,
    klimatyzacja number(1),
    overriding member function wartosc return number
);

create or replace type body auto_osobowe as 
    overriding member function wartosc return number is
        wartosc number;
    begin
        wartosc := (self as auto).wartosc();
        if (klimatyzacja > 0) then
            wartosc := wartosc * 1.5;
        end if;
        
        return wartosc;
    end;
end;

create or replace type auto_ciezarowe under auto (
    max_ladownosc number,
    overriding member function wartosc return number
);

create or replace type body auto_ciezarowe as 
    overriding member function wartosc return number is
        wartosc number;
    begin
        wartosc := (self as auto).wartosc();
        if (max_ladownosc > 10000) then
            wartosc := wartosc * 2;
        end if;
        
        return wartosc;
    end;
end;

insert into auta values (auto_osobowe('marka1', 'model1', 1000, DATE '2020-02-02', 2000, 4, 1));
insert into auta values (auto_osobowe('marka2', 'model2', 1000, DATE '2020-02-02', 2000, 4, 0));
insert into auta values (auto_ciezarowe('marka3', 'model3', 1000, DATE '2020-02-02', 2000, 10000));
insert into auta values (auto_ciezarowe('marka4', 'model4', 1000, DATE '2020-02-02', 2000, 20000));

select a.marka, a.wartosc() from auta a;

