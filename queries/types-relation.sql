.mode column
.width 7 50
.header on

select
  count(*),
  rel.val
from
  tag rel
where
  rel.rel_id is not null
group by
  rel.val
order by count(*);

