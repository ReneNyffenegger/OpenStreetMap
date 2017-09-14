--
--  See also shelter_type-basic_hut.sql
--

.mode column
.width 11 11 40 5 40

select
  hut.nod_id,
  hut.way_id,
  nam.val    name,
  ele.val    elev,
  rnm.val    name_relation
from
  tag      hut /* indexed by tag_ix_key_val */       left join
  tag      ele on  ele.key    ='ele'          and
                  (hut.nod_id = ele.nod_id or
                   hut.way_id = ele.way_id)          left join
  tag      nam on  nam.key    ='name'         and
                  (hut.nod_id = nam.nod_id or
                   hut.way_id = nam.way_id)          left join
  rel_mem  rel on (hut.nod_id = rel.nod_id or
                   hut.way_id = rel.way_id)          left join
  tag      rnm on  rnm.key    ='name'         and
                   rel.rel_of = rnm.rel_id
where
  hut.key = 'tourism' and
  hut.val = 'alpine_hut'
order by
  printf("%4d", ele.val);
