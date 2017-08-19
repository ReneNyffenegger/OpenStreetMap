--
--  Which tags are available for addr:*
--

.mode  column
.width 7 100
select
  count(*),
  key
from
  tag
where
  key like 'addr:%'
group by
  key
order by
  count(*) desc
limit 100;



.mode column
.width 9 9 9 100
select
  nod_id,
  way_id,
  rel_id,
  val
from
  tag
where
--key = 'addr:place'
--key = 'addr:suburb'
--key = 'addr:hamlet'
--key = 'addr:interpolation'
--key = 'addr:floor'
  key = 'addr:province'
--key = 'addr:region'
--key = 'addr:county'
limit
  50
;
