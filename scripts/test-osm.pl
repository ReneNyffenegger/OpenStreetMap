#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use Geo::OSM::DBI::CH;

# my $dbh = DBI->connect("dbi:SQLite:dbname=../db/Pfungen.db") or die "does not exist";
my $dbh = DBI->connect("dbi:SQLite:dbname=../db/ch.db") or die "does not exist";

my $osm_db = Geo::OSM::DBI::CH->new($dbh);

$osm_db->create_table_municipalities();

# my @gemeinden = $osm_db -> gemeinden;
# print "nof gemeinden = ", scalar @gemeinden;
