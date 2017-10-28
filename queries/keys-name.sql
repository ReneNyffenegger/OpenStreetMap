.mode  column
.width 7 100
.header on

select
count(*),
  key
from
  tag
where
  key like '%name%'
group by
  key
order by
  count(*);
