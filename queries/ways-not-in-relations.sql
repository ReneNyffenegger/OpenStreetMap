.mode column
.headers on
.width 11 30 14 12 14 8 10 20 8 20 20 20

create temporary table way as select distinct way_id as id from nod_way;

select
  way.id,
  nam.val name,
  bui.val building,
  hiw.val highway,
  lan.val landuse,
  trk.val tracktype,
  bar.val barrier,
  nat.val natural_,
  wat.val waterway,
  ame.val amenity,
  lei.val leisure
from
  way way                                                      left join
  tag     nam on way.id = nam.way_id and nam.key = 'name'      left join
  tag     bui on way.id = bui.way_id and bui.key = 'building'  left join
  tag     hiw on way.id = hiw.way_id and hiw.key = 'highway'   left join
  tag     lan on way.id = lan.way_id and lan.key = 'landuse'   left join
  tag     trk on way.id = trk.way_id and trk.key = 'tracktype' left join
  tag     bar on way.id = bar.way_id and bar.key = 'barrier'   left join
  tag     nat on way.id = nat.way_id and nat.key = 'natural'   left join
  tag     wat on way.id = wat.way_id and wat.key = 'waterway'  left join
  tag     ame on way.id = ame.way_id and ame.key = 'amenity'   left join
  tag     lei on way.id = lei.way_id and lei.key = 'leisure'
where
  way.id not in (select way_id from rel_mem where way_id is not null)
order by
  coalesce(nam.val, bui.val, hiw.val, lan.val, trk.val, bar.val, nat.val, wat.val, ame.val, lei.val)
