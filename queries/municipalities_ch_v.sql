.mode   column
.width  11 35 12 12 12 12 4
select
  rel_id,
  name,
  min_lat,
  min_lon,
  max_lat,
  max_lon,
  bfs_no
from
  municipalities_ch_v
order by
  name, bfs_no;
