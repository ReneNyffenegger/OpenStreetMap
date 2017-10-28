.mode column
.width 7 50

select
  count(*),
  key
from
  tag
where
  val = 'station'
group by
  key
order by
  count(*);
