.mode column
.width 7 70

select
  count(*),
  val
from
  tag
where
  key = 'addr:housename'
group by
  val
order by
  count(*);
