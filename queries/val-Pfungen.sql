.mode  column
.width 10 10 10 40 150
select
  nod_id,
  way_id,
  rel_id,
  key,
  val
from
  tag
where
  val like '%Pfungen%' and
  key not in ('addr:city')
;

--
--  Possibly interesting
--  nodes:
--      115105475
--      476512606
--     1307210183
--     2482900821
--  ways:
--       46955200
--      122945253
--      122946428
--      122946691
--  relations:
--        1630944
--        1682188
--

.mode column
.width 10 10 10 40 150
select
  nod_id,
  way_id,
  rel_id,
  key,
  val
from
  tag
where
  nod_id in (115105475, 476512606, 1307210183/*, 2482900821*/) or
  way_id in (/* 46955200,*/ 122945253,  122946428,  122946691) or
  rel_id in (/*  1630944,*/   1682188)
order by
  nod_id,
  way_id,
  rel_id,
  key;

.mode column
.width 10 40 100

select 
  rel.way_id,
  tag.key,
  tag.val
from
  way_rel rel                            join
  tag     tag on rel.way_id = tag.way_id
where
  rel.rel_of = 1682188
;

.mode  column
.width 10 12 12 40 100

select 
  n2w.nod_id,
  nod.lat,
  nod.lon,
  tag.key,
  tag.val
from
  way_rel rel                                     join
  nod_way n2w on rel.way_id = n2w.way_id          join
  nod     nod on n2w.nod_id = nod.id         left join
  tag     tag on n2w.nod_id = tag.nod_id
where
  rel.rel_of = 1682188
;

select
  nod.id,
  nod.lat,
  nod.lon,
  tag.key,
  tag.val
from
  nod_rel   rel                                 join
  nod       nod on rel.nod_id = nod.id     left join
  tag       tag on nod.id     = tag.nod_id
where
  rel.rel_of = 1682188;
