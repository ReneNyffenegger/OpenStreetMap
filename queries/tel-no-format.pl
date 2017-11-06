#!/usr/bin/perl
use warnings;
use strict;
use utf8;

# use Geo::OSM::API;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=$ENV{github_root}OpenStreetMap/db/ch.db", '', '', { sqlite_unicode => 1 }) or die "Could not open the db;";

$dbh -> sqlite_create_function('digit_to_X', 1, sub {
  my $val = shift;
  $val =~ s/\d/X/g;
  return $val;
});

$dbh -> do("create temp table tel_no_format_temp as
  select
    digit_to_X(val) tel_no
  from
    tag
  where
    key in ('phone', 'contact:phone', 'contact:fax', 'fax', 'contact:mobile')
") or die;

$dbh -> do("create table tel_no_format as
  select
    count(*) cnt,
    tel_no
  from
    tel_no_format_temp
  group by
    tel_no
") or die;
