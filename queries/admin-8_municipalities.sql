.mode column
.width 10 50 4 4 4
.timer on

-- .width 3 3 3 90
-- explain query plan
select
   admi.rel_id rel_id,
   name.val    name,
   count(distinct relm.way_id)   cnt_ways,
   count(distinct node.id    )   cnt_nodes,
/* cnt_nodes_verification: 
      Must/should be 0 because each way counts one node that another way already counted.
      Borders that are not 100 % in the database return -1 or so.
*/
   count(*                   ) -
   count(distinct relm.way_id) -
   count(distinct node.id    )   cnt_nodes_verification
from
  tag     admi                                   join
  tag     name on admi.rel_id = name.rel_id      join
  rel_mem relm on admi.rel_id = relm.rel_of      join
  nod_way nodw on relm.way_id = nodw.way_id      join
  nod     node on nodw.nod_id = node.id
where
  admi.key = 'admin_level' and
  admi.val =  8            and
  name.key = 'name'  /* and
  name.val = 'Pfungen' */
group by
  admi.rel_id,
  name.val
 order by
--   relm.way_id,
--   node.id
  cnt_nodes_verification,
  name
  ;

.timer off
