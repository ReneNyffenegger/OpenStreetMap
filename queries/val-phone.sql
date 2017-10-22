.mode column
.width 7 50
.header on

select
  count(*),
  key
from
  tag
where
  val like '+41%'  or
  val like '%076%' or
  val like '%078%' or
  val like '%079%'
group by
  key
order by
  count(*);

