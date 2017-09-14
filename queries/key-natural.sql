.mode  column
.width 7 100
.header on

select
count(*),
  val
from
  tag
where
  key = 'natural'
group by
  val
order by
  count(*);
