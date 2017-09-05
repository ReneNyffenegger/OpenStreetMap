.mode column
.header on

.width 7 30

select
  count(*),
  rol
from
  rel_mem
group by
  rol
order by
  count(*);
