.mode column
.width 7 50

select
  count(*),
  val
from
  tag
where
  key = 'geological'
group by
  val
order by
  count(*);
