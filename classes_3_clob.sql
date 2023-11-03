-- === CLOB ===
set serveroutput on size 30000;

-- 1.
create table dokumenty (
    id number primary key,
    dokument clob
)

descr dokumenty;

-- 2.
declare
    counter number := 10000;
    text_str varchar(20) := 'Oto tekst. ';
    text_final clob;
begin
    for i in 1..counter
    loop
        text_final := concat(text_final, text_str);
    end loop;
    
    insert into dokumenty 
    values (1, text_final);
end;

-- 3.
select * from dokumenty;
select id, upper(dokument) from dokumenty;
select id, length(dokument) as doc_len from dokumenty;
select id, dbms_lob.getlength(dokument) as doc_len from dokumenty;
select id, substr(dokument, 5, 1000) as doc_substr from dokumenty;
select id, dbms_lob.substr(dokument, 1000, 5) as doc_substr from dokumenty;

-- 4.
insert into dokumenty
values (2, empty_clob());

-- 5.
insert into dokumenty
values (3, null);

-- 6.
select * from dokumenty;
select id, upper(dokument) from dokumenty;
select id, length(dokument) as doc_len from dokumenty;
select id, dbms_lob.getlength(dokument) as doc_len from dokumenty;
select id, substr(dokument, 5, 1000) as doc_substr from dokumenty;
select id, dbms_lob.substr(dokument, 1000, 5) as doc_substr from dokumenty; -- null dla id=2

-- 7.
declare
    clo clob;
    bf bfile := bfilename('TPD_DIR', 'dokument.txt');
    dest_offset integer := 1;
    src_offset integer := 1;
    bfile_csid number := 0;
    lang_ctx integer := 0;
    warn integer := null;
begin
    select dokument 
    into clo 
    from dokumenty
    where id = 2
    for update;
    
    dbms_lob.fileopen(bf, dbms_lob.file_readonly);
    dbms_lob.loadclobfromfile(clo, bf, dbms_lob.lobmaxsize, dest_offset, src_offset, bfile_csid, lang_ctx, warn);
    dbms_lob.fileclose(bf);
    
    commit;
    
    dbms_output.put_line('Status operacji: ' || warn);

end;

-- 8.
update dokumenty
set dokument = to_clob(bfilename('TPD_DIR', 'dokument.txt'))
where id = 3;

-- 9.
select * from dokumenty;

-- 10.
select id, dbms_lob.getlength(dokument) as doc_len from dokumenty;

-- 11.
drop table dokumenty;

-- 12.
create or replace procedure clob_censor(cl in out clob, to_replace varchar2)
is
    dots varchar(255);
    to_replace_size integer := length(to_replace);
    position integer := 10000;
    nth_occurence integer := 1;
begin
    for i in 1..to_replace_size
    loop
        dots := concat(dots, '.');
    end loop;

    loop
        position := dbms_lob.instr(cl, to_replace, 1, nth_occurence);
        
        exit when position = 0;
        
        dbms_lob.write(cl, to_replace_size, position, dots);
        nth_occurence := nth_occurence + 1;
    end loop;
end clob_censor;

-- 13.
create table biographies
as select * from ztpd.biographies;

select * from biographies;

declare
    cl clob;
begin
    select bio
    into cl
    from biographies
    where id = 1
    for update;

    clob_censor(cl, 'Cimrman');
    
    commit;
end;

-- 14.
drop table biographies;