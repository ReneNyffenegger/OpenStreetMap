.mode   column
.width  6 30 70  6

select
  count(*),
  key,
  count(distinct val)
from
  tag
where
  key not like 'addr:%' and
  key not like 'name%'
group by
  key
having
  count(*)            > 10 and
  count(distinct val) < 40
order by
  count(*);
