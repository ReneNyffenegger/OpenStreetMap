--
--  Are ids unique among nodes, ways and relations?
--
--  Answer: no, they're not.
--

.mode column
.width 8 8

select
  nod.id,
  nod_way.way_id
from
  nod                                 join
  nod_way on nod.id = nod_way.way_id
limit
  20;

select
  nod.id
from
  nod                                 join
  way_rel on nod.id = way_rel.rel_of
limit
  20;
