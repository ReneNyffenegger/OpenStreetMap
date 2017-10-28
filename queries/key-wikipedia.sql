.mode column
.width 7 50

select
  count(*),
  substr(val, 1, 3) val_1_3
from
  tag
where
  key = 'wikipedia'
group by
  substr(val, 1, 3)
order by
  count(*);
