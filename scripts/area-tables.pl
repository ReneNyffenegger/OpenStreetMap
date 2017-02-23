#!/usr/bin/perl
use warnings;
use strict;
use Time::HiRes qw(time);

use DBI;

my $db         = shift or die;
my $area_name  = shift or die;
my $lat_min    = shift or die;
my $lat_max    = shift or die;
my $lon_min    = shift or die;
my $lon_max    = shift or die;


unlink "../db/${area_name}.db" if -e "../db/${area_name}.db";

die unless -e $db;
my $dbh = DBI->connect("dbi:SQLite:dbname=$db") or die "$db does not exist";

$dbh->do("attach database '../db/${area_name}.db' as area_db");
$dbh->{AutoCommit} = 0;


create_area_tables($dbh);

fill_area_nod_table    ($dbh);
fill_area_nod_way_table($dbh);
fill_area_nod_rel_table($dbh);
fill_area_way_rel_table($dbh);
fill_area_rel_rel_table($dbh);
fill_area_tag_table    ($dbh);

$dbh->commit;
$dbh->{AutoCommit} = 1;
$dbh->do("detach database area_db");

sub create_area_tables { #_{

  my $dbh = shift;

  my @base_tables = qw(nod nod_way nod_rel way_rel rel_rel tag);
  clone_table($dbh, $_) for (@base_tables);

} #_}

sub fill_area_nod_table { #_{
  my $dbh       = shift;

# my $f = '%16.13f';
  my $f = '%s';

  my $stmt = sprintf("
  
    insert into area_db.nod
    select * from nod
    where 
      lat between $f and $f and
      lon between $f and $f

  ", $lat_min, $lat_max, $lon_min, $lon_max);

  do_sql_stmt($dbh, $stmt, "area_db.nod filled");
  
} #_}

sub fill_area_nod_way_table { #_{
  my $dbh       = shift;

  my $stmt = sprintf("
  
    insert into area_db.nod_way
    select * from nod_way
    where 
       nod_id in (
        select
          id
        from
          area_db.nod
    )
   ");

  do_sql_stmt($dbh, $stmt, "area_db.nod_way filled");
  
} #_}

sub fill_area_nod_rel_table { #_{
  my $dbh       = shift;

  my $stmt = sprintf("
  
    insert into area_db.nod_rel
    select * from nod_rel
    where 
       nod_id in (
        select
          id
        from
          area_db.nod
    )
   ");

  do_sql_stmt($dbh, $stmt, "area_db.nod_rel filled");
  
} #_}

sub fill_area_way_rel_table { #_{
  my $dbh       = shift;

  my $stmt = sprintf("
  
    insert into area_db.way_rel
    select * from way_rel
    where 
       way_id in (
        select
          way_id
        from
          area_db.nod_way
       )

   ");

  do_sql_stmt($dbh, $stmt, "area_db.way_rel filled");
  
} #_}

sub fill_area_rel_rel_table { #_{
  my $dbh       = shift;

  my $stmt = sprintf("
  
    insert into area_db.rel_rel
    select * from rel_rel
    where 
       rel_id in (
        select
          rel_id
        from
          area_db.nod_rel
        UNION
        select
          rel_id
        from
          area_db.rel_rel
       )

   ");

  do_sql_stmt($dbh, $stmt, "area_db.way_rel filled");
  
} #_}

sub fill_area_tag_table { #_{

  my $dbh       = shift;

  my $stmt = sprintf("
  
    insert into area_db.tag
    select * from tag
    where 
       nod_id in (select id from area_db.nod)

   ");

  do_sql_stmt($dbh, $stmt, "area_db.tag (1) filled");

  $stmt = sprintf("
  
    insert into area_db.tag
    select * from tag
    where 
       way_id in (select distinct way_id from area_db.nod_way)

   ");

  do_sql_stmt($dbh, $stmt, "area_db.tag (2) filled");

  $stmt = sprintf("
  
    insert into area_db.tag
    select * from tag
    where 
       rel_id in (select distinct rel_of from area_db.nod_rel union
                  select distinct rel_of from area_db.way_rel)

   ");

  do_sql_stmt($dbh, $stmt, "area_db.tag (3) filled");

} #_}

sub clone_table { #_{
  my $dbh        = shift;
  my $table_name = shift;

  # /r modifier: http://stackoverflow.com/a/1461242/180275
  #
  for my $sql_stmt (map { s/^(create\s+\w+)/$1 area_db\./igr  }  create_statements_for_table($dbh, $table_name)) {
#   do_sql_stmt($dbh, $sql_stmt, "$table_name cloned");
    $dbh->do($sql_stmt);
  }

} #_}

sub do_sql_stmt { #_{

  my $dbh  = shift;
  my $stmt = shift;
  my $desc = shift;

  my $t0 = time;
  $dbh->do($stmt);
  my $t1 = time;

  printf("$desc, took %6.3f seconds\n", $t1-$t0);

} #_}

sub table_exists { #_{
  my $dbh        = shift;
  my $table_name = shift;

  my ($cnt) = $dbh -> selectrow_array("select count(*) from sqlite_master where type = 'table' and name = ?", {}, $table_name);

  return $cnt;

} #_}

sub create_statements_for_table { #_{
  my $dbh        = shift;
  my $table_name = shift;

  return @{ 
    $dbh->selectcol_arrayref ("
      select
        sql
      from
        sqlite_master
      where
        tbl_name = ?
      order by
        case when type = 'table' then 0 else 1 end
    ", {}, $table_name)
  };

} #_}
