--
--  Which nodes, ways and relations have the
--  most tags?
--

.mode column
.width 6 10

select
  count(*),
  nod_id
from
  tag
where
  nod_id is not null
group by
  nod_id
order by
  count(*) desc
limit 10;

select
  count(*),
  way_id
from
  tag
where
  way_id is not null
group by
  way_id
order by
  count(*) desc
limit 10;

select
  count(*),
  rel_id
from
  tag
where
  rel_id is not null
group by
  rel_id
order by
  count(*) desc
limit 10;

.width 30 150
select
  key,
  val
from
  tag
where
  nod_id =    1504546320 -- Schweiz
           -- 240025182  -- Zürich
order by
  key;


select
  key,
  val
from
  tag
where
  way_id = 310046324 -- Large Hadron Collider
order by
  key;


select
  key,
  val
from
  tag
where
  rel_id = 51477 -- Germany
order by
  key;
