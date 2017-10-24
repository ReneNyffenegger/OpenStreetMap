.mode   column
.width  11 11 11 20 50

select
  gt.nod_id,
  gt.way_id,
  gt.rel_id,
  gt.key,
  gt.val
from
  tag tg                              join
  tag gt on tg.nod_id = gt.nod_id or
            tg.way_id = gt.way_id or
            tg.rel_id = gt.rel_id
where
--tg.key = 'amenity' and tg.val = 'fuel'
  tg.key = 'shop'    and tg.val = 'supermarket'
--tg.val = 'parking'
order by
  tg.nod_id,
  tg.way_id,
  tg.rel_id
