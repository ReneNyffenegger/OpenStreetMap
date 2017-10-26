.mode  column
.width 80 80 

select
  nm.val,
  an.val
from
  tag nm     join
  tag an on nm.nod_id = an.nod_id or
            nm.way_id = an.way_id or
            nm.rel_id = an.rel_id
where
  nm.key = 'name'   and
  an.key = 'alt_name'
order by
  nm.val;
