.mode column
.width 100

select
  distinct val
from
  tag
where
  key = 'website';

select
  count(distinct val)
from
  tag
where
  key = 'website';

.width 6 300
select
  count(*),
  replace(replace(val, char(10), ' '), char(13), ' ')
from
  tag
where
  lower(val) like '%www.%' or
  val like '%://%'
group by
  val
order by
  count(*);

select
  count(*),
  key
from
  tag
where
  val like '%www.%' or
  val like '%://%'
group by
  key
order by
  count(*);
