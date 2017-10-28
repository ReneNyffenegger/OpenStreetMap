.mode column
.width 7 50

select
  count(*),
  key
from
  tag
where
  key like 'wikipedia%'
group by
  key
order by
  count(*);
