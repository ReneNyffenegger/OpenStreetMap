.header on
.column mode
.width  5 5 5 5 50
select
  count(*),
  count(way_id),
  count(nod_id),
  count(rel_id),
  key
from
  tag
group by
  key
order by
  count(*)
;
