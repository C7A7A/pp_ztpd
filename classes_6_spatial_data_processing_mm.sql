-- SPATIAL DATA PROCESSING SQL MM --

-- 1 --
-- A
select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
and prior t.owner = t.owner;

-- B 
select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

-- C
create table myst_major_cities (
    fips_cntry varchar(2),
    city_name varchar2(40),
    stgeom st_point
);

desc myst_major_cities;

-- D
desc major_cities;

insert into myst_major_cities(fips_cntry, city_name, stgeom)
select mc.FIPS_CNTRY, mc.CITY_NAME, st_point(mc.GEOM)
from major_cities mc;

select * from myst_major_cities;

-- 2 --
insert into myst_major_cities
values (
    'PL',
    'Szczyrk',
    st_point(19.036107, 49.718655, 8307)
);

select * from myst_major_cities where city_name like 'Szczyrk';

-- 3 --
-- A
create table MYST_COUNTRY_BOUNDARIES (
    FIPS_CNTRY VARCHAR2(2),
    CNTRY_NAME VARCHAR2(40),
    STGEOM ST_MULTIPOLYGON
);

desc MYST_COUNTRY_BOUNDARIES;

-- B
desc COUNTRY_BOUNDARIES;

insert into MYST_COUNTRY_BOUNDARIES(FIPS_CNTRY, CNTRY_NAME, STGEOM)
select cb.FIPS_CNTRY, cb.CNTRY_NAME, ST_MULTIPOLYGON(cb.GEOM)
from COUNTRY_BOUNDARIES cb;

select * from MYST_COUNTRY_BOUNDARIES;

-- C
select B.STGEOM.ST_GEOMETRYTYPE() STGTYPE, count(*) as count
from MYST_COUNTRY_BOUNDARIES B
group by B.STGEOM.ST_GEOMETRYTYPE();

-- D
select B.STGEOM.ST_GEOMETRYTYPE() STGTYPE, B.STGEOM.ST_ISSIMPLE() IS_SIMPLE
from MYST_COUNTRY_BOUNDARIES B;

-- 4 --
-- A
select cb.cntry_name, count(*) as count
from myst_major_cities mc,
     myst_country_boundaries cb
where cb.stgeom.st_contains(mc.stgeom) = 1
group by cb.cntry_name;

-- B
select  cb1.cntry_name, cb2.cntry_name
from    myst_country_boundaries cb1,
        myst_country_boundaries cb2
where   cb1.stgeom.st_touches(cb2.stgeom) = 1
and     cb1.cntry_name = 'Czech Republic';

-- C
descr rivers;

select  distinct cb.cntry_name, r.name
from    myst_country_boundaries cb,
        rivers r
where   cb.stgeom.st_intersects(st_linestring(r.geom)) = 1
and     cb.cntry_name = 'Czech Republic';

-- D
select  round(treat(cb1.stgeom.st_union(cb2.stgeom) as st_polygon).st_area()) as czechoslovakia_area
from    myst_country_boundaries cb1,
        myst_country_boundaries cb2
where   cb1.cntry_name = 'Czech Republic'
and     cb2.cntry_name = 'Slovakia';

-- E
descr water_bodies;

select  cb.stgeom as hungary,
        cb.stgeom.st_geometrytype() as hungary_geomtype,
        cb.stgeom.st_difference(st_geometry(wb.geom)) as hungary_without_balaton,
        cb.stgeom.st_difference(st_geometry(wb.GEOM)).st_geometrytype() as hungary_without_balaton_geomtype
from    myst_country_boundaries cb,
        water_bodies wb
where   cb.cntry_name = 'Hungary'
and     wb.name = 'Balaton';

-- 5 --
-- A
explain plan for
select      cb.cntry_name, count(*) count_cities
from        myst_country_boundaries cb,
            myst_major_cities mc
where       cb.cntry_name = 'Poland'
            and sdo_within_distance(
                cb.stgeom, 
                mc.stgeom,
                'distance=100 unit=km'
            ) = 'TRUE'
group by    cb.cntry_name;

select plan_table_output from table(dbms_xplan.display('plan_table',null,'basic'));

-- B
select * from all_sdo_geom_metadata;

insert into user_sdo_geom_metadata
select 'myst_major_cities', 'stgeom', T.diminfo, T.srid
from all_sdo_geom_metadata T
where table_name = 'MAJOR_CITIES';

select * from user_sdo_geom_metadata;

--delete from user_sdo_geom_metadata where table_name = 'MYST_MAJOR_CITIES';

-- C
-- drop index myst_major_cities_idx;

create index myst_major_cities_idx on myst_major_cities(stgeom)
indextype is mdsys.spatial_index;

-- D
explain plan for
select      cb.cntry_name, count(*) count_cities
from        myst_country_boundaries cb,
            myst_major_cities mc
where       cb.cntry_name = 'Poland'
            and sdo_within_distance(
                cb.stgeom, 
                mc.stgeom,
                'distance=100 unit=km'
            ) = 'TRUE'
group by    cb.cntry_name;

select plan_table_output from table(dbms_xplan.display);