--
--  See also tourism-alpine_hut.sql, shelter_type-basic_hut.sql
--

.mode column
.width 11 11 30 30 30 30 7 30

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
)
select
   hut.nod_id,
   hut.way_id,
   nam.val    name,
   nmd.val    name_de,
   nmf.val    name_fe,
   nme.val    name_en,
   hut.elev   elev,
   url.val    url
from
            hut /* indexed by tag_ix_key_val */                                                     left join
   tag      url on  url.key    ='url'      and (hut.nod_id = url.nod_id or hut.way_id = url.way_id) left join
   tag      nam on  nam.key    ='name'     and (hut.nod_id = nam.nod_id or hut.way_id = nam.way_id) left join
   tag      nmd on  nmd.key    ='name:de'  and (hut.nod_id = nmd.nod_id or hut.way_id = nmd.way_id) left join
   tag      nmf on  nmf.key    ='name:fr'  and (hut.nod_id = nmf.nod_id or hut.way_id = nmf.way_id) left join
   tag      nme on  nmf.key    ='name:en'  and (hut.nod_id = nme.nod_id or hut.way_id = nme.way_id) 
order
  by printf("%4d", hut.elev)
--by coalesce(nmd.val, nam.val)
