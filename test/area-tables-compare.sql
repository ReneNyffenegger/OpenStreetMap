
create table nod_id_expected (id integer primary key); -- {
--
insert into nod_id_expected values (10);
insert into nod_id_expected values (11);
insert into nod_id_expected values (12);
insert into nod_id_expected values (13);
--
insert into nod_id_expected values (20);
insert into nod_id_expected values (23);
insert into nod_id_expected values (22);
insert into nod_id_expected values (21);
--
insert into nod_id_expected values (30);
insert into nod_id_expected values (31);
insert into nod_id_expected values (32);
insert into nod_id_expected values (33);
insert into nod_id_expected values (34);
insert into nod_id_expected values (35);
insert into nod_id_expected values (36);
insert into nod_id_expected values (37);
--
insert into nod_id_expected values (40);
insert into nod_id_expected values (41);

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
 -- }


attach database '../db/area_test.db' as gotten;

---------------------------------------------------

select 'nod.id not expected: ' || id from (
  select id from gotten.nod       except
  select id from nod_id_expected
);
   
select 'nod.id expected: ' || id from (
  select id from nod_id_expected  except
  select id from gotten.nod
);

--

select 'nod_way not expectedated',  nod_id, way_id from (
  select * from gotten.nod_way   except
  select * from nod_way_expected
);
   
select 'nod_way expected', nod_id, way_id from (
  select * from nod_way_expected  except
  select * from gotten.nod_way
);


