.mode columns
.width 7 100

select
  count(*),
  val
--substr(val, 1, 7) sub_1_7
from
  tag
where
  key = 'site'
group by
  val
--substr(val, 1, 7)
order by
  count(*) desc
limit 100;
