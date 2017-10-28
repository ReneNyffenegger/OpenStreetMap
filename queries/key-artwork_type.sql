.mode column
.width 7 50

select
  count(*),
  val
from
  tag
where
  key = 'artwork_type'
group by
  val
order by
  count(*);
