.mode column
.width 5 30 50

select
  count(*),
  key,
  val
from
  tag
where
  key like '%gluten%'  or
  key like '%lactose%' or
  key like '%laktos%'
group by
  key,
  val
order by
  count(*);
