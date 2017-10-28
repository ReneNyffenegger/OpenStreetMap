.mode columns
.width 7 100
select
  count(*),
  substr(val, 1, 7) sub_1_7
from
  tag
where
  key = 'site'
group by
  substr(val, 1, 7)
order by
  count(*) desc
limit 100;
