.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'shelter_type'
group by
  val
order by
  count(*);
