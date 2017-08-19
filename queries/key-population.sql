.mode column
.width   7 40
.headers on

select
  count(*),
  key
from
  tag
where
  lower(key) like '%population%'
group by
  key
order by
  count(*);

.width   30 100
-- select
--   key,
--   val
-- from
--   tag
-- where
--   lower(key) like '%population%';
