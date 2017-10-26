.mode  column
.width 5 7 50

drop   table if exists postcode_city_cnt;
create table postcode_city_cnt as
select
  count(*) cnt,
  pc.val   postcode,
  cy.val   city
from
  tag pc     join
  tag cy on pc.nod_id = cy.nod_id or
            pc.way_id = cy.way_id or
            pc.rel_id = cy.rel_id
where
  pc.key = 'addr:postcode'   and
  cy.key = 'addr:city'
group by
  pc.val,
  cy.val
order by
  pc.val,
  count(*),
  cy.val;


drop   table if exists postcode_city_max;
create table postcode_city_max as
select
  max(cnt) max_,
  postcode
from
  postcode_city_cnt
group by
  postcode
;

drop   table if exists postcode_city;
create table postcode_city as
select
  c.postcode,
  c.city
from
  postcode_city_cnt c  join
  postcode_city_max m on c.postcode = m.postcode and
                         c.cnt      = m.max_;

 

