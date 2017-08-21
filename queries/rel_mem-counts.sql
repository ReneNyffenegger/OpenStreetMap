.mode   column
.header on
.width  7 7 7 7 7

select
  cnt,
  cnt_nod + cnt_way + cnt_rel cnt_sum,
  cnt_nod,
  cnt_way,
  cnt_rel
from (
  select
    count(*     ) cnt,
    count(nod_id) cnt_nod,
    count(way_id) cnt_way,
    count(rel_id) cnt_rel
  from
    rel_mem
);
