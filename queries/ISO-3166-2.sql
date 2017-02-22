.mode column
.headers on

.width 6, 20, 10
select
  count(*),
  key,
  val
from
  tag
where
  lower(key) like '%iso%3166_2%' and
  val like 'CH-%'
group by
  key,
  val
order by
  count(*);
