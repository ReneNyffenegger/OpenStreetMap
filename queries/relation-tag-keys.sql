.mode column
.width 7 30

select
  count(*),
  key
from
  tag
where
  rel_id is not null
group by
  key
order by
  count(*);
