.mode column
.width 7 40
.header on

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
