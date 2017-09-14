.mode column
.width 11 11 11 20 50

--create table pot_sac as
--select distinct
--  nod_id,
--  way_id,
--  rel_id
--from tag where (
--    upper(val) like 'SAC%'   or
--    upper(val) like '%SAC-%' or
--    upper(val) like '% SAC'  or
--    upper(val) like 'SAC %'  or
--    upper(val) like '%ALPINE HUT%'
--) and
--  upper(val) not like '%SACK%' and
--  upper(val) not like '%SACL%' and
--  upper(val) not like '%SACH%';

-- select
--   count(*),
--   key
-- from
--   pot_sac join
--   tag     using (nod_id)
-- group by
--   key
-- order by count(*);

delete from pot_sac where nod_id in (select nod_id from tag where key = 'tourism' and val = 'alpine_hut');
delete from pot_sac where way_id in (select way_id from tag where key = 'tourism' and val = 'alpine_hut');
  
.width 11 15 50
select
  nod_id,
  key,
  val
from
  pot_sac join
  tag using (nod_id)
;  
