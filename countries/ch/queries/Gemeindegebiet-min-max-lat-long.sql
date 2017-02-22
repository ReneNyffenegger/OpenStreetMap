select
  count(*)
from
  tag
where
  key = 'swisstopo:OBJEKTART' and
  val = 'Gemeindegebiet'      and
  rel_id is not null
;


.header on
.mode   column
.width  12 12 12 12 5 30

-- explain query plan
with geb as (
  select
    rel_id
  from
    tag
  where
    key = 'swisstopo:OBJEKTART' and
    val = 'Gemeindegebiet'
--  rel_id is not null
)
select
  min(nod.lat),
  max(nod.lat),
  min(nod.lon),
  max(nod.lon),
  bfs.val,
  nam.val
from
  geb                                                                            join
  tag      bfs on geb.rel_id = bfs.rel_id and bfs.key  = 'swisstopo:BFS_NUMMER'  join
  tag      nam on geb.rel_id = nam.rel_id and nam.key  = 'name'                  join
  way_rel  w2r on geb.rel_id = w2r.rel_of                                        join
  nod_way  n2w on n2w.way_id = w2r.way_id                                        join
  nod          on nod.id     = n2w.nod_id
group by
  bfs.val,
  nam.val
order by
  nam.val;
