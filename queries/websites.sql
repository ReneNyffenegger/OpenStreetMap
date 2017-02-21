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
