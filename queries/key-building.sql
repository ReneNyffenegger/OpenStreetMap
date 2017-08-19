.mode columns
.width 7 100
select
  count(*),
  val
from
  tag
where
  key = 'building'
group by
  val
order by
  count(*) desc
limit 100;
