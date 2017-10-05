.mode  column
.width 5 50
select
  count(*),
  nam.val   name
from
  tag ame    join
  tag nam on ame.nod_id = nam.nod_id or
             ame.way_id = nam.way_id or
             ame.rel_id = nam.rel_id
where
  ame.key = 'amenity' and
  ame.val = 'fuel'    and
  nam.key = 'name'
group by
  nam.val
order by
  count(*);
