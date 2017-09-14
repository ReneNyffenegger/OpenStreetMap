.mode column
.headers on
.width 11 50 30 10 20 20 20 20 20

select
  nod.id,
  nam.val name,
  ame.val amenity,
  nat.val natural_,
  inf.val info,
  eme.val emergency,
  lei.val leisure,
  man.val man_made,
  shp.val shop
from
  nod                                                         left join
  tag nam on nod.id = nam.nod_id and nam.key = 'name'         left join
  tag ame on nod.id = ame.nod_id and ame.key = 'amenity'      left join
  tag nat on nod.id = nat.nod_id and nat.key = 'natural'      left join
  tag inf on nod.id = inf.nod_id and inf.key = 'information'  left join
  tag eme on nod.id = eme.nod_id and eme.key = 'emergency'    left join
  tag lei on nod.id = lei.nod_id and lei.key = 'leisure'      left join
  tag man on nod.id = man.nod_id and man.key = 'man_made'     left join
  tag shp on nod.id = shp.nod_id and shp.key = 'shop'
where
  nod.id not in (select nod_id from nod_way) and
  coalesce(nat.val, '?') != 'tree'
order by
  coalesce(nam.val, ame.val, nat.val, inf.val, eme.val, lei.val, man.val, shp.val)
;
