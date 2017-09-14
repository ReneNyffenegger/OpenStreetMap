.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'sac_scale'
group by
  val
order by
  count(*);
