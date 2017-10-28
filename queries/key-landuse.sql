.mode column
.width 7 50

select
  count(*),
  val
from
  tag
where
  key = 'landuse'
group by
  val
order by
  count(*);
