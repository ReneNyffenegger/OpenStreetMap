.mode  column
.width 7 10 100

select
  count(*),
  max  (rel_id) rel_id_ex,
  val
from
  tag
where
  key = 'admin_level'
group by
  val
order by
  count(*)
limit 100;

