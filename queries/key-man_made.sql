.mode column
.width 7 50

select
  count(*),
  val
from
  tag
where
  key = 'man_made'
group by
  val
order by
  count(*);
