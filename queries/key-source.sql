.mode column
.width 8 100
select
  count(*),
  val
from
  tag
where
  key = 'source'
group by
  val
order by
  count(*);
