
create table nod_id_expected (id integer primary key);
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

attach database '../db/area_test.db' as gotten;

select 'nod.id not expected: ' || id from (
  select id from gotten.nod       except
  select id from nod_id_expected
);
   
select 'nod.id expected: ' || id from (
  select id from nod_id_expected  except
  select id from gotten.nod
);
