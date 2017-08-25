.mode  column
.width 7 100

select
  count(*),
  key
from
  tag
where
  key like 'ISO%'
group by
  key
order by
  count(*) desc
limit 100;
