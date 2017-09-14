.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'information'
group by
  val
order by
  count(*);
