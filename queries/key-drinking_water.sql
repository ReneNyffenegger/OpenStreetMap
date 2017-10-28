.mode columns
.width 7 100
select
  count(*),
  val
from
  tag
where
  key = 'drinking_water'
group by
  val
order by
  count(*) desc
limit 100;
