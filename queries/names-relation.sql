.mode column
.width 11 30 50

select
--count(*),
  nam.rel_id    rel_id,
  nam.val       name,
  typ.val       typ
from
  tag nam                                                   left join
  tag typ on nam.rel_id = typ.rel_id and typ.key = 'type'
where
  nam.key = 'name' and
  nam.rel_id is not null
--group by
--  val
order by
--count(*),
  nam.val;
