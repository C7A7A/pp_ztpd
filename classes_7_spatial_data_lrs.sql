-- SPATIAL DATA LRS --

-- 1 --
-- A
create table A6_LRS (
    Geom SDO_GEOMETRY
);

descr A6_LRS;

-- B
select * from STREETS_AND_RAILROADS;
descr STREETS_AND_RAILROADS;

select  sr.id,
        sdo_geom.sdo_length(sr.geom, 1, 'unit=km') distance
from    STREETS_AND_RAILROADS sr, MAJOR_CITIES mj
where   sdo_relate(
            sr.geom,
            sdo_geom.sdo_buffer(
                mj.geom,
                10,
                1,
                'unit=km'
            ),
            'MASK=ANYINTERACT'
        ) = 'TRUE'
and     mj.city_name = 'Koszalin';

insert into A6_LRS
select      sr.geom
from        STREETS_AND_RAILROADS sr
where       sr.id = 56;

select * from A6_LRS;

-- C
-- streets nad railroads
select  sdo_geom.sdo_length(geom, 1, 'unit=km') distance,
        st_linestring(geom).st_numpoints() st_numpoionts
from    STREETS_AND_RAILROADS
where   id = 56;

-- A6_lrs
select  sdo_geom.sdo_length(geom, 1, 'unit=km') distance,
        st_linestring(geom).st_numpoints() st_numpoionts
from    A6_lrs;

-- D
update  A6_LRS
set     geom = sdo_lrs.convert_to_lrs_geom(geom, 0, 276.681);

-- E
insert into user_sdo_geom_metadata
values      (
                'A6_LRS',
                'Geom',
                mdsys.sdo_dim_array(
                    MDSYS.SDO_DIM_ELEMENT('X', 12.603676, 26.369824, 1),
                    MDSYS.SDO_DIM_ELEMENT('Y', 45.8464, 58.0213, 1),
                    MDSYS.SDO_DIM_ELEMENT('M', 0, 300, 1)
                ),
                8307
            );

-- F
create index    A6_LRS_idx 
on              A6_LRS(Geom) 
indextype is    mdsys.spatial_index;

-- 2 -- 
-- A
select  SDO_LRS.VALID_MEASURE(GEOM, 1000) VALID_1000,
        SDO_LRS.VALID_MEASURE(GEOM, 500) VALID_500
from    A6_LRS;

-- B
select  SDO_LRS.GEOM_SEGMENT_END_PT(GEOM) END_PT
from    A6_LRS;

-- C
select  sdo_lrs.locate_pt(geom, 150, 0) km_150
from    A6_LRS;

-- D
select  sdo_lrs.clip_geom_segment(geom, 120, 160) seg_120_to_160
from    A6_LRS;

-- E
select  sdo_lrs.get_next_shape_pt(A6.geom, mc.geom) a6_entry
from    A6_LRS A6, major_cities mc
where   mc.city_name = 'Slupsk';

-- F
select  sdo_geom.sdo_length(
                sdo_lrs.offset_geom_segment(
                A6.geom, 
                m.diminfo, 
                50, 
                200, 
                50,
                'unit=m arc_tolerance=1'
            ), 
            1, 
            'unit=km'
        )  cost
from    A6_LRS A6, user_sdo_geom_metadata m
where   m.table_name = 'A6_LRS'
and     m.column_name = 'GEOM';