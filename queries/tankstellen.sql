.mode   column
.header on
.width  11 11 30 20 10 30 3 3 3 3 3 3 20 5 4 20 50

select
             tnk.nod_id,
             tnk.way_id,
             nam.val     name,
             opr.val     operator,
             brd.val     brand,
             shp.val     shop,
--'Bui: ' || bui.val     building,
             dsl.val     diesel,
             o98.val     oct98,
             o95.val     oct95,
             o91.val     oct91,
             o10.val     oct100,
             bio.val     biodiesel,
             str.val     street,
             hno.val     nr,
             zip.val     zip,
             cty.val     city,
             opn.val     open
from
  tag tnk                                                                                          left join
  tag nam on nam.key = 'name'             and (tnk.nod_id = nam.nod_id or tnk.way_id = nam.way_id) left join
  tag opr on opr.key = 'operator'         and (tnk.nod_id = opr.nod_id or tnk.way_id = opr.way_id) left join
  tag brd on brd.key = 'brand'            and (tnk.nod_id = brd.nod_id or tnk.way_id = brd.way_id) left join
--tag bui on bui.key = 'building'         and (tnk.nod_id = bui.nod_id or tnk.way_id = bui.way_id) left join
  tag dsl on dsl.key = 'diesel'           and (tnk.nod_id = dsl.nod_id or tnk.way_id = dsl.way_id) left join
  tag o98 on o98.key = 'fuel:octane_98'   and (tnk.nod_id = o98.nod_id or tnk.way_id = o98.way_id) left join
  tag o95 on o95.key = 'fuel:octane_95'   and (tnk.nod_id = o95.nod_id or tnk.way_id = o95.way_id) left join
  tag o91 on o91.key = 'fuel:octane_91'   and (tnk.nod_id = o91.nod_id or tnk.way_id = o91.way_id) left join
  tag o10 on o10.key = 'fuel:octane_100'  and (tnk.nod_id = o10.nod_id or tnk.way_id = o10.way_id) left join
  tag bio on bio.key = 'fuel:biodiesel'   and (tnk.nod_id = bio.nod_id or tnk.way_id = bio.way_id) left join
  tag shp on shp.key = 'shop'             and (tnk.nod_id = shp.nod_id or tnk.way_id = shp.way_id) left join
  tag str on str.key = 'addr:street'      and (tnk.nod_id = str.nod_id or tnk.way_id = str.way_id) left join
  tag hno on hno.key = 'addr:housenumber' and (tnk.nod_id = hno.nod_id or tnk.way_id = hno.way_id) left join
  tag zip on zip.key = 'addr:postcode'    and (tnk.nod_id = zip.nod_id or tnk.way_id = zip.way_id) left join
  tag cty on cty.key = 'addr:city'        and (tnk.nod_id = cty.nod_id or tnk.way_id = cty.way_id) left join
  tag opn on opn.key = 'opening_hours'    and (tnk.nod_id = opn.nod_id or tnk.way_id = opn.way_id)
where
  tnk.key = 'amenity' and tnk.val = 'fuel'
;
