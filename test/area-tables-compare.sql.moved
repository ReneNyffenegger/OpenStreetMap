
create table nod_id_expected (id integer primary key); -- {
--
insert into nod_id_expected values ( 10);
insert into nod_id_expected values ( 11);
insert into nod_id_expected values ( 12);
insert into nod_id_expected values ( 13);
--
insert into nod_id_expected values ( 20);
insert into nod_id_expected values ( 23);
insert into nod_id_expected values ( 22);
insert into nod_id_expected values ( 21);
--
insert into nod_id_expected values ( 30);
insert into nod_id_expected values ( 31);
insert into nod_id_expected values ( 32);
insert into nod_id_expected values ( 33);
insert into nod_id_expected values ( 34);
insert into nod_id_expected values ( 35);
insert into nod_id_expected values ( 36);
insert into nod_id_expected values ( 37);
--
insert into nod_id_expected values ( 40);
insert into nod_id_expected values ( 41);
--
insert into nod_id_expected values ( 50);
--
insert into nod_id_expected values ( 60);
insert into nod_id_expected values ( 61);
insert into nod_id_expected values ( 62);
--
insert into nod_id_expected values ( 70);
insert into nod_id_expected values ( 71);
--
insert into nod_id_expected values ( 80);
insert into nod_id_expected values ( 81);
insert into nod_id_expected values ( 82);
--
insert into nod_id_expected values ( 90);
--



------------------------------------------------- -- }

create table nod_way_expected (way_id, nod_id, order_); -- {
insert into nod_way_expected values (  2, 10, 0);
insert into nod_way_expected values (  2, 11, 1);
insert into nod_way_expected values (  2, 12, 2);
insert into nod_way_expected values (  2, 13, 3);
insert into nod_way_expected values (  2, 10, 4);

insert into nod_way_expected values (  3, 20, 0);
insert into nod_way_expected values (  3, 21, 1);
insert into nod_way_expected values (  3, 22, 2);
insert into nod_way_expected values (  3, 23, 3);
insert into nod_way_expected values (  3, 20, 4);

insert into nod_way_expected values (  4, 30, 0);
insert into nod_way_expected values (  4, 31, 1);
insert into nod_way_expected values (  4, 32, 2);
insert into nod_way_expected values (  4, 33, 3);
insert into nod_way_expected values (  4, 34, 4);
insert into nod_way_expected values (  4, 35, 5);
insert into nod_way_expected values (  4, 36, 6);
insert into nod_way_expected values (  4, 37, 7);
insert into nod_way_expected values (  4, 30, 8);

insert into nod_way_expected values (  5, 40, 0);
insert into nod_way_expected values (  5, 41, 1);

insert into nod_way_expected values (  6, 62, 0);
insert into nod_way_expected values (  6, 61, 1);
insert into nod_way_expected values (  6, 60, 2);

insert into nod_way_expected values (  7, 62, 0);
insert into nod_way_expected values (  7, 70, 1);
insert into nod_way_expected values (  7, 71, 2);
insert into nod_way_expected values (  7, 80, 3);

insert into nod_way_expected values (  8, 80, 0);
insert into nod_way_expected values (  8, 81, 1);
insert into nod_way_expected values (  8, 82, 2);

insert into nod_way_expected values (  9, 82, 0);
insert into nod_way_expected values (  9, 90, 1);
insert into nod_way_expected values (  9, 60, 2);

 -- }

create table nod_rel_expected(nod_id, rel_of, rol); -- {
insert into nod_rel_expected values (50, 19, null);
 -- }
create table way_rel_expected(way_id, rel_of, rol); -- {
insert into way_rel_expected values (6, 19, 'Rel 19: South');
insert into way_rel_expected values (7, 19, 'Rel 19: East' );
insert into way_rel_expected values (8, 19, 'Rel 19: North');
insert into way_rel_expected values (9, 19, 'Rel 19: West' );
 -- }
create table rel_rel_expected(rel_id, rel_of, rol); -- {
-- }
create table tag_expected(nod_id, way_id, rel_id, key, val);

insert into tag_expected values (   22, null, null, 'key-22-1'        , 'val-22-1'      );
insert into tag_expected values (   22, null, null, 'key-22-2'        , 'val-22-2'      );
insert into tag_expected values (   40, null, null, 'key-40-1'        , 'val-40-1'      );
insert into tag_expected values (   40, null, null, 'key-40-2'        , 'val-40-2'      );
insert into tag_expected values (   50, null, null, 'label'           , 'Relation 19'   );

insert into tag_expected values ( null,    2, null, 'building'        , 'yes'           );
insert into tag_expected values ( null,    2, null, 'addr:street'     , 'Foostr'        );
insert into tag_expected values ( null,    2, null, 'addr:housenumber', '42'            );
insert into tag_expected values ( null,    2, null, 'addr:postcode'   , '9999'          );
insert into tag_expected values ( null,    2, null, 'addr:city'       , 'Dorfikon'      );

insert into tag_expected values ( null,    3, null, 'building'        , 'house'         );

insert into tag_expected values ( null, null,   19, 'name'            , 'Relation 19'   );
insert into tag_expected values ( null, null,   19, 'key-rel-19'      , 'val-rel-19'    );

attach database '../db/area_test.db' as gotten;


-- nod -- {
select 'nod.id not expected: ' || id from (
  select id from gotten.nod       except
  select id from nod_id_expected
);
   
select 'nod.id expected: ' || id from (
  select id from nod_id_expected  except
  select id from gotten.nod
);
 -- }
-- nod_way -- {
select 'nod_way not expected',  nod_id, way_id from (
  select * from gotten.nod_way   except
  select * from nod_way_expected
);
   
select 'nod_way expected', nod_id, way_id from (
  select * from nod_way_expected  except
  select * from gotten.nod_way
);
 -- }
-- nod_rel -- {
select 'nod_rel not expectedated',  nod_id, rel_of, rol from (
  select * from gotten.nod_rel   except
  select * from nod_rel_expected
);
   
select 'nod_rel expected', nod_id, rel_of, rol from (
  select * from nod_rel_expected  except
  select * from gotten.nod_rel
);
 -- }
-- way_rel -- {
select 'way_rel not expectedated',  way_id, rel_of, rol from (
  select * from gotten.way_rel   except
  select * from way_rel_expected
);
   
select 'way_rel expected', way_id, rel_of, rol from (
  select * from way_rel_expected  except
  select * from gotten.way_rel
);
 -- }
-- rel_rel -- {

select 'rel_rel not expectedated',  rel_id, rel_of, rol from (
  select * from gotten.rel_rel   except
  select * from rel_rel
);
   
select 'rel_rel expected', rel_id, rel_of, rol from (
  select * from rel_rel  except
  select * from gotten.rel_rel
);
-- }
-- tag {

select 'tag not expectedated', nod_id, way_id, rel_id, key, val from (
  select * from gotten.tag   except
  select * from tag_expected
);
   
select 'tag expected'        , nod_id, way_id, rel_id, key, val from (
  select * from tag_expected  except
  select * from gotten.tag
);
-- }
