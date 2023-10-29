-- === BLOB ===
set serveroutput on size 30000;

-- 1.
create table movies as select * from ztpd.movies;

-- 2.
select * from movies;
descr movies;

-- 3.
select id, title
from movies 
where cover is null;

-- 4.
select id, title, dbms_lob.getlength(cover) as filesize
from movies
where cover is not null;

-- 5.
select id, title, dbms_lob.getlength(cover) as filesize
from movies
where cover is null;

-- 6.
select * from ALL_DIRECTORIES;

-- 7.
update movies
set 
    cover = empty_blob(),
    mime_type = 'image/jpeg'
where id = 66;

select * from movies where id = 66;

-- 8.
select id, title, dbms_lob.getlength(cover) as filesize
from movies
where id in (65, 66);

-- 9.
declare
    -- 1)
    bl blob;
    img_file bfile := bfilename('TPD_DIR', 'escape.jpg');
begin
    -- 2)
    select cover 
    into bl
    from movies 
    where id = 66
    for update;
    
    -- 3)
    dbms_lob.fileopen(img_file, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(bl, img_file, dbms_lob.getlength(img_file));
    dbms_lob.fileclose(img_file);
    
    -- 4)
    commit;
end;

select id, title, dbms_lob.getlength(cover) as filesize
from movies
where id = 66;

-- 10.
create table temp_covers (
    movie_id number(12),
    image bfile,
    mime_type varchar2(50)
);

descr temp_covers;

-- 11.
declare
    bl blob;
    img_file bfile := bfilename('TPD_DIR', 'eagles.jpg');
begin
    insert into temp_covers
    VALUES (65, img_file, 'image/jpeg');

    commit;
end;

-- 12.
select movie_id, dbms_lob.getlength(image), mime_type
from temp_covers
where movie_id = 65;

-- 13.
declare
    bl blob;
    img_file bfile;
    mime varchar2(100);
begin
    select image into img_file
    from temp_covers 
    where movie_id = 65;
    
    select mime_type into mime
    from temp_covers
    where movie_id = 65;
    
    dbms_lob.createtemporary(bl, true);
    
    dbms_lob.fileopen(img_file, dbms_lob.file_readonly);
    dbms_lob.loadfromfile(bl, img_file, dbms_lob.getlength(img_file));
    dbms_lob.fileclose(img_file);
    
    update movies
    set cover = bl, mime_type = mime
    where id = 65;
    
    dbms_lob.freetemporary(bl);
    
    commit;
end;


-- 14.
select id, dbms_lob.getlength(cover), mime_type
from movies
where id in (65, 66);

-- 15.
drop table movies;
