begin transaction;

drop table if exists tag;
drop table if exists rel_rel;
drop table if exists way_rel;
drop table if exists nod_rel;
drop table if exists nod_way;
drop table if exists nod;

CREATE TABLE nod (
          id  integer primary key,
          lat real not null,
          lon real not null
        );

CREATE TABLE nod_way (
          way_id         integer not null,
          nod_id         integer not null,
          order_         integer not null
        );

CREATE TABLE nod_rel (
          nod_id         integer not null,
          rel_of         integer null,
          rol            text
        );

CREATE TABLE way_rel (
          way_id         integer not null,
          rel_of         integer null,
          rol            text
        );

CREATE TABLE rel_rel (
          rel_id         integer not null,
          rel_of         integer null,
          rol            text
        );

CREATE TABLE tag(
          nod_id      integer null,
          way_id      integer null,
          rel_id      integer null,
          key         text not null,
          val         text not null
        );

CREATE INDEX nod_way_ix_way_id on nod_way (way_id);
CREATE INDEX tag_ix_val        on tag     (     val);
CREATE INDEX tag_ix_key_val    on tag     (key, val);
CREATE INDEX tag_ix_nod_id     on tag     (nod_id);
CREATE INDEX tag_ix_way_id     on tag     (way_id);
CREATE INDEX tag_ix_rel_id     on tag     (rel_id);

insert into nod values (  1, 47.9, 6.1);
insert into nod values (  2, 47.9, 6.2);
insert into nod values (  3, 47.8, 6.3);
insert into nod values (  4, 47.7, 6.3);
insert into nod values (  5, 47.7, 6.2);
insert into nod values (  6, 47.8, 6.1);

insert into nod values ( 10, 47.6, 7.3);
insert into nod values ( 11, 47.6, 7.4);
insert into nod values ( 12, 47.5, 7.4);
insert into nod values ( 13, 47.5, 7.3);

insert into nod values ( 20, 47.5, 7.6);
insert into nod values ( 21, 47.4, 7.6);
insert into nod values ( 22, 47.4, 7.7);
insert into nod values ( 23, 47.5, 7.7);

insert into nod values ( 30, 47.8, 8.3);
insert into nod values ( 31, 47.8, 8.4);
insert into nod values ( 32, 47.7, 8.5);
insert into nod values ( 33, 47.6, 8.6);
insert into nod values ( 34, 47.5, 8.6);
insert into nod values ( 35, 47.5, 8.5);
insert into nod values ( 36, 47.6, 8.4);
insert into nod values ( 37, 47.7, 8.3);

insert into nod values ( 40, 47.3, 8.8);
insert into nod values ( 41, 47.4, 8.9);
insert into nod values ( 42, 47.4, 9.1);
insert into nod values ( 43, 47.5, 9.2);

--------------------------------------

insert into nod_way values (  1,  1, 0);
insert into nod_way values (  1,  2, 1);
insert into nod_way values (  1,  3, 2);
insert into nod_way values (  1,  4, 3);
insert into nod_way values (  1,  5, 4);
insert into nod_way values (  1,  6, 5);
insert into nod_way values (  1,  1, 6);

insert into nod_way values (  2, 10, 0);
insert into nod_way values (  2, 11, 1);
insert into nod_way values (  2, 12, 2);
insert into nod_way values (  2, 13, 3);
insert into nod_way values (  2, 10, 4);

insert into nod_way values (  3, 20, 0);
insert into nod_way values (  3, 21, 1);
insert into nod_way values (  3, 22, 2);
insert into nod_way values (  3, 23, 3);
insert into nod_way values (  3, 20, 4);

insert into nod_way values (  4, 30, 0);
insert into nod_way values (  4, 31, 1);
insert into nod_way values (  4, 32, 2);
insert into nod_way values (  4, 33, 3);
insert into nod_way values (  4, 34, 4);
insert into nod_way values (  4, 35, 5);
insert into nod_way values (  4, 36, 6);
insert into nod_way values (  4, 37, 7);
insert into nod_way values (  4, 30, 8);

insert into nod_way values (  5, 40, 0);
insert into nod_way values (  5, 41, 1);
insert into nod_way values (  5, 42, 2);
insert into nod_way values (  5, 43, 3);


commit;
