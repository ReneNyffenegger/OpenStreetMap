.mode column
.width 11 100

--
-- Node id 1378949424 has the role "admin_center" in
-- two relations: 1682243 and 1691239
--

select
  rel_of,
  rol
from
  nod_rel
where
  nod_id = 1378949424;

.width 11 100
--
-- These two relations are "Winterthur" and "Bezirk Winterthur"
--
select
  rel_id,
  val
from
  tag
where
  rel_id in (1682243, 1691239) and
  key = 'name';

--
-- TODO
--   The order_ (sequence) of this admin center is 1 for the 1691239 relation and
--   at the end for the 1682243 relation
-- 
--     http://www.openstreetmap.org/relation/1691239#map=12/47.5422/8.8483
--     http://www.openstreetmap.org/relation/1682243#map=12/47.5422/8.8483
--
