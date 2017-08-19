.mode  column
.width 7 100

select
  count(*),
  key
from
  tag
where
  lower(key) like 'opengeodb%'
group by
  key
order by
  count(*);
