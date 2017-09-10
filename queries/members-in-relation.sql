.mode columns
.width 5 11 11 11 15 50

select
  order_,
  rm.nod_id,
  rm.way_id,
  rm.rel_id,
  rm.rol,
  coalesce(nn.val, nw.val, nr.val)
from
  rel_mem  rm                                               left join
  tag      nn  on rm.nod_id = nn.nod_id and nn.key = 'name' left join
  tag      nw  on rm.way_id = nw.way_id and nw.key = 'name' left join
  tag      nr  on rm.rel_id = nr.rel_id and nr.key = 'name'
where
  rm.rel_of = 51701
--rm.rel_of = 1690227
order by
  order_
;
