.mode column
.width 10 20 40 10 4 30
.header on

select
  bld.way_id way_id,
  bld.val    building,
  str.val    street,
  hnr.val    house_number,
  zip.val    zip_code,
  cit.val    city
from
  tag bld                                                             left join
  tag str on str.way_id = bld.way_id and str.key = 'addr:street'      left join
  tag hnr on hnr.way_id = bld.way_id and hnr.key = 'addr:housenumber' left join
  tag zip on zip.way_id = bld.way_id and zip.key = 'addr:postcode'    left join
  tag cit on cit.way_id = bld.way_id and cit.key = 'addr:city'
where
  bld.key = 'building'
order by
  zip.val,
  cit.val,
  str.val,
  hnr.val
-- limit 10
;
