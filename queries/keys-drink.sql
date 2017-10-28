.mode column
.width 7 30
select
  count(*),
  key
from
  tag
where
  key like 'drink%'
group by
  key
order by
  count(*);
