.mode  column
.width 7 100

select
  count(*),
  val
from
  tag
where
  key = 'operator'
-- and ( val like '%SAC%' or val like '%CAS%' )
group by
  val
order by
  count(*);
