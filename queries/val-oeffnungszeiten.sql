.mode   column
.width  40 200
select
  key,
  val
from
  tag
where
  key like 'opening_hours%' or
  val like '%ffnungszeit%'
