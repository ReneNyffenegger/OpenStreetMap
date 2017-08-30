.mode column
.width 6 30
select
  count(*),
  key
from
  tag
where
  key =    'ele'   or
  key like 'ele:%' or
  key =    'alt'   or
  key like 'alt:%'
group by
  key
order by
  count(*)
;
