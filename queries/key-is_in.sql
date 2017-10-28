.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'is_in'
group by
  val
order by
  count(*) desc
;
