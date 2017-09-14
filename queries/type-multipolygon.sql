.mode column
.width 11 20 30
.header on

select
  rel.rel_id,
  ----------
    coalesce(lnd.val,'')                                 || 
      case when lnd.val is not null and
                nat.val is not null then '/' else '' end ||
    coalesce(nat.val, '') landuse_natural,
  ----------
  nam.val     name
from
  tag rel                                                     left join
  tag lnd on rel.rel_id = lnd.rel_id and lnd.key = 'landuse'  left join
  tag nam on rel.rel_id = nam.rel_id and nam.key = 'name'     left join
  tag nat on rel.rel_id = nat.rel_id and nat.key = 'natural'
where
  rel.rel_id is not null   and
  rel.key = 'type'         and
  rel.val = 'multipolygon';
