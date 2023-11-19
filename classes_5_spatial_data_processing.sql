-- PROCESSING SPATIAL DATA --

-- 1 --
-- A
insert into user_sdo_geom_metadata
values(
    'figury', 'ksztalt', mdsys.sdo_dim_array(
        mdsys.sdo_dim_element('x', 0, 10, 0.01),
        mdsys.sdo_dim_element('y', 0, 10, 0.01)
   ), null
);

select * from user_sdo_geom_metadata;

-- B
select sdo_tune.estimate_rtree_index_size(3000000, 8192, 10, 2, 0)
from figury;

-- C
create index figury_spatial_idx
on figury(ksztalt)
indextype is mdsys.spatial_index_v2;

-- D
select id
from figury
where sdo_filter(ksztalt, sdo_geometry(
        2001, null, sdo_point_type(3, 3, null), null, null
    )
) = 'TRUE';

-- E
select id
from figury
where sdo_relate(ksztalt, sdo_geometry(
        2001, null, sdo_point_type(3, 3, null), null, null
    ), 'mask=anyinteract'
) = 'TRUE';

-- 2 --
-- A
select a.city_name miasto, sdo_nn_distance(1) distance
from major_cities a, major_cities b
where 
a.city_name <> 'Warsaw' 
and b.city_name = 'Warsaw'
and sdo_nn(
    a.geom, 
    b.geom,
    'sdo_num_res=10 unit=km',
    1
) = 'TRUE';


-- B
select a.city_name miasto
from major_cities a, major_cities b
where 
a.city_name <> 'Warsaw' 
and b.city_name = 'Warsaw'
and sdo_within_distance(
    a.geom, 
    b.geom,
    'distance=100 unit=km'
) = 'TRUE';

-- C
select a.cntry_name, b.city_name
from country_boundaries a, major_cities b
where sdo_relate(
    b.geom, 
    a.geom,
    'mask=INSIDE'
) = 'TRUE'
and a.cntry_name = 'Slovakia';

-- D
select b.cntry_name, sdo_geom.sdo_distance(a.geom, b.geom, 1, 'unit=km')
from country_boundaries a, country_boundaries b
where 
a.cntry_name = 'Poland' 
and sdo_relate(
    b.geom, 
    a.geom,
    'mask=ANYINTERACT'
) <> 'TRUE';

-- 3 --
-- A
select a.cntry_name, sdo_geom.sdo_length(sdo_geom.sdo_intersection(a.geom, b.geom, 1), 1, 'unit=km') len
from country_boundaries a,  country_boundaries b
where sdo_filter(a.geom, b.geom) = 'TRUE'
and b.cntry_name = 'Poland'
and a.cntry_name <> 'Poland';

-- B
select a.cntry_name, sdo_geom.sdo_area(a.geom, 1, 'unit=SQ_KM') area
from country_boundaries a
where sdo_geom.sdo_area(a.geom) = (
    select max(sdo_geom.sdo_area(geom)) from country_boundaries
);

-- C
select sdo_geom.sdo_area(
    sdo_geom.sdo_mbr(
        sdo_geom.sdo_union(a.geom, b.geom, 0.01)
    ), 1, 'unit=SQ_KM'
) min_mbr_area
from major_cities a, major_cities b
where a.city_name = 'Warsaw'
and b.city_name = 'Lodz';

-- D
select sdo_geom.sdo_union(a.geom, b.geom, 0.01).sdo_gtype geom_type
from major_cities a, country_boundaries b
where a.city_name = 'Prague'
and b.cntry_name = 'Poland';

-- E
select a.city_name, b.cntry_name
from major_cities a,  country_boundaries b
where sdo_geom.sdo_distance(
    sdo_geom.sdo_centroid(b.geom, 1),
    a.geom, 
    1, 'unit=km'
) =  (
    select min(sdo_geom.sdo_distance(
            sdo_geom.sdo_centroid(b.geom, 1),
            a.geom, 
            1, 'unit=km'
        )
    )
    from major_cities a,  country_boundaries b
);

-- F
select c.name, sum(c.len) as sum_len
from (
    select a.name, sdo_geom.sdo_length(sdo_geom.sdo_intersection(b.geom, a.geom, 1), 1, 'unit=km') as len
    from rivers a, country_boundaries b
    where b.cntry_name = 'Poland' 
    and sdo_relate(
        a.geom, 
        b.geom,
        'mask=ANYINTERACT'
    ) = 'TRUE'
) c
group by c.name;

