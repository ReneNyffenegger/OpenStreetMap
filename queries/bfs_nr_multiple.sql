.mode column
.width 11 4 50

select
  rel_id,
  bfs_no,
  name
from
  municipalities_ch_v
where
  bfs_no in (
  select
    bfs_no
  from
    municipalities_ch_v
  group by
    bfs_no
  having
    count(*) > 1
)
order by
  bfs_no;
