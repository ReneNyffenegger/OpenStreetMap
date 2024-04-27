select * from tag where
(
  lower(key) like '%täufer%'  or
  lower(val) like '%täufer%'  or
  lower(key) like '%baptist%' or
  lower(val) like '%baptist%'
)
and not (key = 'name' and val = 'Avenue de-Baptista')
and not (key = 'addr:street' and val like ('Chemin Jean-Baptiste%'))
and not (key = 'addr:street' and val like ('Rue Baptiste%'))
and not (key = 'addr:street' and val = 'Avenue de-Baptista')
and not (key = 'artist_name' and val = 'Baptist Hörbst')
;
