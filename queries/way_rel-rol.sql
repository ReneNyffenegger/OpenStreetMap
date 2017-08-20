.mode column
.width 7 50
select
  count(*),
  rol
from
  way_rel
group by
  rol
order by
  count(*);
