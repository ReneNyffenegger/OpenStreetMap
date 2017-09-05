.mode column
.header on

.print |  
.print |    First find relation id for Switzerland
.print |  


.width 11

select
  rel_id
from
  tag -- indexed by tag_ix_key_val
where
  rel_id is not null and
  key = 'ISO3166-1'  and
  val = 'CH'
;



.print |  
.print |    Apparently, the 26 cantons are the only
.print |    relation-members for the Swizterland
.print |    relation
.print |  

.width 4 11 15 50
select
  order_,
  rel_id,
  rol,
  val
from
  rel_mem                join
  tag     using (rel_id)
where
  rel_of = (select rel_id from tag
            where
              rel_id is not null and
              key = 'ISO3166-1'  and
              val = 'CH'
            )
  and
  key = 'name'
order by
  val
;

.print |  
.print |    Node members of Switzerland-relation
.print |  

select
  order_,
  nod_id,
  rol,
  val
from
  rel_mem                join
  tag     using (nod_id)
where
  rel_of = (select rel_id from tag
            where
              rel_id is not null and
              key = 'ISO3166-1'  and
              val = 'CH'
            )
  and
  key = 'name'
order by
  val
;

.print |  
.print |    Way members of Switzerland-relation
.print |    Note: inner ways (Campione) seem not to be
.print |    selected (Compare border-Switzerland.sql)
.print |  

select
  order_,
  way_id,
  rol,
  val
from
  rel_mem                join
  tag     using (way_id)
where
  rel_of = (select rel_id from tag
            where
              rel_id is not null and
              key = 'ISO3166-1'  and
              val = 'CH'
            )
  and
  key = 'name'
order by
  order_
;
