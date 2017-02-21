.mode column

.width 10 10 10 50
select
  n.lat,
  n.lon,
  r.nod_id,
  r.rol
from
  nod_rel r     join
  nod     n on r.nod_id = n.id
where
  r.rel_of = 1682248;

.width 40 50
select
  key, val
from
  tag
where
  nod_id = 240025182 and
  key    not like 'name:%'  -- exclude all the translations
order by
  key;


-- select * from way_rel where rel_of = 1682248;
-- 
-- select * from rel_rel where rel_of = 1682248;
-- select * from rel_rel where rel_id = 1682248;
