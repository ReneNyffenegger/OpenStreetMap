--
--  See also tourism-alpine_hut.sql
--

.mode  column
.width 11 11 30 7

select
  shl.nod_id,
  shl.way_id,
  nam.val,
  ele.val
from
  tag shl                                 left join
  tag nam on nam.key    = 'name' and
            (nam.nod_id = shl.nod_id or
             nam.way_id = shl.way_id)     left join
  tag ele on ele.key    = 'ele'  and
            (ele.nod_id = shl.nod_id or
             ele.way_id = shl.way_id)
where
  shl.key = 'shelter_type' and
  shl.val = 'basic_hut'
order by
  printf("%4d", ele.val);
