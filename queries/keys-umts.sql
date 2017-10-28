.mode column
.width 7 50

select
  count(*),
  key
from
  tag
where
  key like 'umts%'
group by
  key
order by
  count(*);

