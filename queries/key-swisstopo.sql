.mode  column
.width 8 30 100 100
select
  count(*),
  key,
  min(val),
  max(val)
from
  tag
where
  key like 'swisstopo:%'
group by
  key;
