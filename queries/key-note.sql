.mode column
.width 7 80
select
  count(*),
  val
from
  tag
where
  key = 'note'
group by
  val
order by
  count(*);

.mode column
.width 7 7 7
select
  count(nod_id) cnt_nd,
  count(way_id) cnt_wy,
  count(rel_id) cnt_rl
from
  tag
where
  key = 'note';

.mode column
.width 10
select
  t1.nod_id
from
  tag t1    join
  tag t2 on t1.nod_id = t2.nod_id
where
  t1.key = 'note' and
  t2.key = 'note' and
  t1.rowid != t2.rowid
;

.mode column
.width 10
select
  t1.way_id
from
  tag t1    join
  tag t2 on t1.way_id = t2.way_id
where
  t1.key = 'note' and
  t2.key = 'note' and
  t1.rowid != t2.rowid
;

.mode column
.width 10
select
  t1.rel_id
from
  tag t1    join
  tag t2 on t1.rel_id = t2.rel_id
where
  t1.key = 'note' and
  t2.key = 'note' and
  t1.rowid != t2.rowid
;
