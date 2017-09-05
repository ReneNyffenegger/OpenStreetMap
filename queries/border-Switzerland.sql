.mode column
.header on
.width  4 4 11 11 15 12 12

select
  rm.order_      order_rm,
  nw.order_      order_nd,
  rm.way_id,
  nw.nod_id,
  rm.rol,
  nd.lat,
  nd.lon
from
  rel_mem  rm                              join
  nod_way  nw on rm.way_id = nw.way_id     join
  nod      nd on nw.nod_id = nd.id
where
  rm.rel_of = (select rel_id from tag where rel_id is not null and key = 'ISO3166-1'  and val = 'CH')
order by
  rm.order_,
  nw.order_
;
