.mode column
.headers on
.width 7, 7, 7, 6, 20, 10

--
--  ISO 3166-2 identifies subdivisions of states (of ISO 3166-1).
--  For Switzerland, those subdivisions are the cantons.
--  We expect to find one record for each canton.
--
select
  nod_id,
  way_id,
  rel_id,
  key,
  val
from
  tag
where
  key = 'ISO3166-2' and
--lower(key) like '%iso%3166_2%' and
  val like 'CH-%'
group by
  key,
  val
order by
  val
;
