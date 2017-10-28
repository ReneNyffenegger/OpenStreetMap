.mode column
.width 7 50
select
  count(*),
  val
from
  tag
where
  key = 'uic_name'
group by
  val
order by
  count(*);
