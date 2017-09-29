--
--  See also tourism-alpine_hut.sql, shelter_type-basic_hut.sql
--

.mode column
.width 11 11 10 10 40 30 30 30 7 30

with hut as (
  select distinct
    hut.nod_id,
    hut.way_id,
    ele.val     elev
  from
    tag hut                                                         left join
    tag ele on ( hut.nod_id = ele.nod_id or
                 hut.way_id = ele.way_id ) and
                 ele.key = 'ele'
  where
   ( hut.key = 'tourism'      and hut.val = 'alpine_hut'                         ) or
   ( hut.key = 'shelter_type' and hut.val = 'basic_hut'  and ele.val is not null )
),
cnd as (
  select
    hut.nod_id,
    hut.way_id,
    hut.elev,
    nod.lat,
    nod.lon
  from
    hut left join
    nod on   hut.nod_id = nod.id 
),
cwy as (
  select
    cnd.nod_id,
    cnd.way_id,
    cnd.elev,
    coalesce(cnd.lat, (max(nod.lat) + min(nod.lat)) / 2) lat,
    coalesce(cnd.lon, (max(nod.lon) + min(nod.lon)) / 2) lon
  from
    cnd                                    left join
    nod_way on cnd.way_id = nod_way.way_id left join
    nod     on nod.id     = nod_way.nod_id
  group by
    cnd.nod_id,
    cnd.way_id,
    cnd.elev
)
select
   cwy.nod_id,
   cwy.way_id,
   cwy.lat,
   cwy.lon,
   nam.val    name,
   nmd.val    name_de,
   nmf.val    name_fe,
   nme.val    name_en,
   cwy.elev   elev,
   url.val    url
from
            cwy                                                                                     left join
   tag      url on  url.key    ='url'      and (cwy.nod_id = url.nod_id or cwy.way_id = url.way_id) left join
   tag      nam on  nam.key    ='name'     and (cwy.nod_id = nam.nod_id or cwy.way_id = nam.way_id) left join
   tag      nmd on  nmd.key    ='name:de'  and (cwy.nod_id = nmd.nod_id or cwy.way_id = nmd.way_id) left join
   tag      nmf on  nmf.key    ='name:fr'  and (cwy.nod_id = nmf.nod_id or cwy.way_id = nmf.way_id) left join
   tag      nme on  nmf.key    ='name:en'  and (cwy.nod_id = nme.nod_id or cwy.way_id = nme.way_id) 
order
  by printf("%4d", cwy.elev)
--by coalesce(nmd.val, nam.val)
