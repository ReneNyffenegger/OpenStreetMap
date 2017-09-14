.mode column
.width 11 50
.header on

select
  rel.rel_id,
  nam.val
from
  tag rel                             join
  tag nam on rel.rel_id = nam.rel_id and nam.key = 'name'
where
  rel.rel_id is not null and
  rel.key = 'type' and
  rel.val = 'associatedStreet';
  
