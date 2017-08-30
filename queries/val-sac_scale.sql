.mode column
.width 7 15 50
.header on

select
  count(*),
  key,
  val
from
  tag
where
  key like 'sac_scale%'
group by
  val
order by
  count(*);
