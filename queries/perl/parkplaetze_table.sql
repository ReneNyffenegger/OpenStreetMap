create table parkplaetze as
with ini as (
  select
    nod_id,
    way_id
  from
    tag
  where
    key = 'amenity' and
    val = 'parking'
),
nd as (
  select
    ini.nod_id,
    ini.way_id,
    nod.lat,
    nod.lon
  from
    ini left join
    nod on ini.nod_id = nod.id
),
wy as (
  select
    nd.nod_id,
    nd.way_id,
    coalesce(nd.lat, (max(nod.lat) + min(nod.lat)) / 2) lat,
    coalesce(nd.lon, (max(nod.lon) + min(nod.lon)) / 2) lon
  from
    nd                                    left join
    nod_way on nd.way_id = nod_way.way_id left join
    nod     on nod.id    = nod_way.nod_id
  group by
    nd.nod_id,
    nd.way_id
)
select
  wy.nod_id
, wy.way_id
, wy.lat
, wy.lon
, t0.val parking
, t1.val access
, t2.val fee
, t3.val capacity
, t4.val name
, t5.val surface
, t6.val source
, t7.val park_ride
, t8.val supervised
, t9.val wheelchair
, t10.val addr_street
, t11.val addr_housenumber
, t12.val addr_postcode
, t13.val description
from
   wy left join
   tag t0 on t0.key ='parking' and (wy.nod_id = t0.nod_id  or wy.way_id = t0.way_id /* or wy.rel_id = t0.rel_id */) left join
   tag t1 on t1.key ='access' and (wy.nod_id = t1.nod_id  or wy.way_id = t1.way_id /* or wy.rel_id = t1.rel_id */) left join
   tag t2 on t2.key ='fee' and (wy.nod_id = t2.nod_id  or wy.way_id = t2.way_id /* or wy.rel_id = t2.rel_id */) left join
   tag t3 on t3.key ='capacity' and (wy.nod_id = t3.nod_id  or wy.way_id = t3.way_id /* or wy.rel_id = t3.rel_id */) left join
   tag t4 on t4.key ='name' and (wy.nod_id = t4.nod_id  or wy.way_id = t4.way_id /* or wy.rel_id = t4.rel_id */) left join
   tag t5 on t5.key ='surface' and (wy.nod_id = t5.nod_id  or wy.way_id = t5.way_id /* or wy.rel_id = t5.rel_id */) left join
   tag t6 on t6.key ='source' and (wy.nod_id = t6.nod_id  or wy.way_id = t6.way_id /* or wy.rel_id = t6.rel_id */) left join
   tag t7 on t7.key ='park_ride' and (wy.nod_id = t7.nod_id  or wy.way_id = t7.way_id /* or wy.rel_id = t7.rel_id */) left join
   tag t8 on t8.key ='supervised' and (wy.nod_id = t8.nod_id  or wy.way_id = t8.way_id /* or wy.rel_id = t8.rel_id */) left join
   tag t9 on t9.key ='wheelchair' and (wy.nod_id = t9.nod_id  or wy.way_id = t9.way_id /* or wy.rel_id = t9.rel_id */) left join
   tag t10 on t10.key ='addr:street' and (wy.nod_id = t10.nod_id  or wy.way_id = t10.way_id /* or wy.rel_id = t10.rel_id */) left join
   tag t11 on t11.key ='addr:housenumber' and (wy.nod_id = t11.nod_id  or wy.way_id = t11.way_id /* or wy.rel_id = t11.rel_id */) left join
   tag t12 on t12.key ='addr:postcode' and (wy.nod_id = t12.nod_id  or wy.way_id = t12.way_id /* or wy.rel_id = t12.rel_id */) left join
   tag t13 on t13.key ='description' and (wy.nod_id = t13.nod_id  or wy.way_id = t13.way_id /* or wy.rel_id = t13.rel_id */)
-- where
--   ini.key = 'amenity' and
--   ini.val = 'parking'
;
