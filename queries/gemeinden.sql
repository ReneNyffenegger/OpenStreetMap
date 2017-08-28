
.mode     column
.width    11 40 5 10 10 10 10

-- .width 2 2 2 100
-- explain query plan
-- 
-- .width 2 20 2 2 2 2 2 40
-- explain
with gemeinden as (
  select
    gemeinde.rel_id  rel_id,
    name.val         name,
    bfs_nummer.val   bfs_no
  from
    tag gemeinde                                          join
  --tag boundary   on gemeinde.rel_id = boundary  .rel_id join
    tag name       on gemeinde.rel_id = name      .rel_id join
    tag bfs_nummer on gemeinde.rel_id = bfs_nummer.rel_id  
  where
    gemeinde  .key = 'admin_level' and
    gemeinde  .val =  8            and
    name      .key = 'name'        and
    bfs_nummer.key = 'swisstopo:BFS_NUMMER'
)
select
  gem.rel_id,
  gem.name,
  gem.bfs_no,
  min(nod.lat)      min_lat,
  max(nod.lat)      max_lat,
  min(nod.lon)      min_lon,
  max(nod.lon)      max_lon
--way_rel.way_id
from
  gemeinden  gem                                          join
  rel_mem    way_rel on gem    .rel_id = way_rel.rel_of   join
  nod_way    nod_way on nod_way.way_id = way_rel.way_id   join
  nod        nod     on nod_way.nod_id = nod    .id
-- where
--   gem.name = 'Pfungen'
group by
  gem.rel_id,
  gem.name,
  gem.bfs_no
;


.mode   column
.width  10 40 5

create table gemeinden as
select
  gemeinde.rel_id  rel_id,
  name.val         name,
  bfs_nummer.val   bfs_no
from
  tag gemeinde                                          join
--tag boundary   on gemeinde.rel_id = boundary  .rel_id join
  tag name       on gemeinde.rel_id = name      .rel_id join
  tag bfs_nummer on gemeinde.rel_id = bfs_nummer.rel_id  
where
  gemeinde  .key = 'admin_level' and
  gemeinde  .val =  8            and
  name      .key = 'name'        and
  bfs_nummer.key = 'swisstopo:BFS_NUMMER'
order by
  name.val
;

.mode column
.width 10 35 5 13 13 13 13

-- .width 2 2 2 100
-- explain query plan
select
  gem.rel_id,
  gem.name,
  gem.bfs_no,
  min(nod.lat)      min_lat,
  max(nod.lat)      max_lat,
  min(nod.lon)      min_lon,
  max(nod.lon)      max_lon
--way_rel.way_id
from
  gemeinden  gem                                          join
  rel_mem    way_rel on gem    .rel_id = way_rel.rel_of   join
  nod_way    nod_way on nod_way.way_id = way_rel.way_id   join
  nod        nod     on nod_way.nod_id = nod    .id
-- where
--   gem.name = 'Pfungen'
group by
  gem.rel_id,
  gem.name,
  gem.bfs_no
;
