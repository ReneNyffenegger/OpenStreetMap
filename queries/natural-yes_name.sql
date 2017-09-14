--
--  Show names of tags with key = 'natural' and val = 'yes'.
--
.mode  column
.width 7 7 7 7 40 11 11
.header on

select
  count(nat.nod_id) cnt_nod,
  count(nat.way_id) cnt_way,
  count(nat.rel_id) cnt_rel,
  count(*         ) cnt_tot,
  nam.val,
  min  (nat.nod_id) min_nod_id,
  min  (nat.way_id) min_way_id
from
  tag nat                                    left join
  tag nam on (nat.nod_id = nam.nod_id or
              nat.way_id = nam.way_id or
              nat.rel_id = nam.rel_id)   and
              nam.key = 'name'
where
  nat.key = 'natural' and
  nat.val = 'yes'
group by
  nam.val;
