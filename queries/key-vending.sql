.mode column
.width 7 50

select
  count(*),
  val
from
  tag
where
  key = 'vending'
group by
  key
order by
  count(*);
