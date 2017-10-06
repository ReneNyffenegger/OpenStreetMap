.mode column
.width 6 6 6 6 70

select
  count(nod_id),
  count(way_id),
  count(rel_id),
  count(*),
  val
from
  tag
where
  key = 'amenity'
group by
  val
order by
  count(*);
