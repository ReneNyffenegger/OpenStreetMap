.mode  column
.width 7 7 7 7
.header on

select
  count(nod_id) cnt_nod,
  count(way_id) cnt_way,
  count(rel_id) cnt_rel,
  count(*     ) cnt_tot
from
  tag
where
  key = 'natural' and
  val = 'glacier';
