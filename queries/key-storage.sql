.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'storage'
group by
  val
order by
  count(*) desc
limit 100;
