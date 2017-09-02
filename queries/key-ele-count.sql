.header on
.mode column
.width 7 7 7 7 30
select
  count(*     ) cnt,
  count(nod_id) cnt_nod,
  count(way_id) cnt_way,
  count(rel_id) cnt_rel,
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
