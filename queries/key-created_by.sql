.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'created_by'
group by
  val
order by
  count(*)
limit 100;
