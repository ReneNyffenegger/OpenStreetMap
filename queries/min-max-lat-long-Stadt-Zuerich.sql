.mode column
.headers on


.print
.print tags of relation
.print ----------------
.print

.width 40 50
select
  key,
  val
from
  tag
where
  rel_id = 1682248 and
  key    not like 'name:%'  -- exclude all translations
;

.print
.print Nodes of relation
.print -----------------
.print

.width 10 10 10 10 40 50
select
  n.lat,
  n.lon,
  r.nod_id,
  r.rol,
  t.key,
  t.val
from
  nod_rel r                        join
  nod     n on r.nod_id = n.id     join
  tag     t on r.nod_id = t.nod_id
where
  r.rel_of = 1682248 and
  t.key not like 'name:%' -- exclude all translations
order by
  n.id;

--  .print
--  .print Tags of relation
--  .print ----------------
--  .print
--  
--  .width 40 50
--  select
--    key, val
--  from
--    tag
--  where
--    nod_id = 240025182 and
--    key    not like 'name:%'  -- exclude all the translations
--  order by
--    key;


-- select * from way_rel where rel_of = 1682248;
-- 
-- select * from rel_rel where rel_of = 1682248;
-- select * from rel_rel where rel_id = 1682248;
