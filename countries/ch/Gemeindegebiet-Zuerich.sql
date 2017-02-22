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

.width 12 12 10 10 40 50
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


.print
.print Ways of relation
.print -----------------
.print

.width 10 10 40 50
select
--n.lat,
--n.lon,
  r.way_id,
  r.rol,
  t.key,
  t.val
from
  way_rel r                        join
--way     w on r.way_id = w.id     join
  tag     t on r.way_id = t.way_id
where
  r.rel_of = 1682248
--t.key not like 'name:%' -- exclude all translations
order by
  r.way_id,
  t.key;

.print
.print Relations of relation (none expected!)
.print --------------------------------------
.print

select * from rel_rel r
where
  r.rel_of = 1682248;

