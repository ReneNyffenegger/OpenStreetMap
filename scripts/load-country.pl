#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use Geo::OSM::DBI;

my $country = shift or die;
my $db_path = "../db/${country}.db";

system ("python3 download-${COUNTRY}-pbf.py");

create_base_schema_tables();

system("python2 pbf2sqlite.v2.py ../pbf/${country}.pbf $db_path");

create_base_schema_indexes();


sub create_base_schema_tables { #_{

  unlink $db_path if -e $db_path;
  my $dbh = DBI->connect("dbi:SQLite:dbname=../db/ch.db") or die "does not exist";
  my $osm_db = Geo::OSM::DBI->new($dbh);
  $osm_db -> create_base_schema_tables();
  $dbh->disconnect;

} #_}
sub create_base_schema_indexes { #_{

  my $dbh = DBI->connect("dbi:SQLite:dbname=../db/ch.db") or die "does not exist";
  my $osm_db = Geo::OSM::DBI->new($dbh);
  $osm_db -> create_base_schema_indexes();
  $dbh->disconnect;

} #_}
