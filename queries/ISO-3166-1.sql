

.mode column
.header off

.print | 
.print |     Select values for key = ISO3166-1
.print | 

.headers on

.width 3 11 11

--
-- Note: apparently, some countries can occur with multiple
--       relation IDs. For example, Germany (DE) comes 
--       with three.
--
select
  val,
  rel_id,
  nod_id
from
  tag
where
  key = 'ISO3166-1';

.print |  
.print |     Examimine the notes of the three German ISO3166-1:
.print |  

.width 11 10 150
select
  rel_id,
  key,
  val
from
  tag
where
  rel_id in (
      select
        rel_id
      from
        tag
      where
        key = 'ISO3166-1' and
        val = 'DE'
  ) and
  key like 'note%'
order by
  rel_id,
  key
;
