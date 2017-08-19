.mode   column
.width  40 200
select
  key,
  val
from
  tag
where
  val like '%ffnungszeit%';
