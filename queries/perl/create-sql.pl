#!/usr/bin/perl
use warnings;
use strict;

use DBI;

use osm_queries;


my $dbh = DBI->connect('dbi:SQLite:dbname=../../db/ch.db',  '', '', { sqlite_unicode => 1 }) or die "Could not create the.db";

my $kml = osm_queries::start_kml('Parklplaetze');



my $key = 'amenity';
my $val = 'parking';
my @cols = (
  { key => 'parking'          , w =>    12},
  { key => 'access'           , w =>    13},
  { key => 'fee'              , w =>    10},
  { key => 'capacity'         , w =>     4},
  { key => 'name'             , w =>    30}, # should probably be always included
  { key => 'surface'          , w =>    10},
  { key => 'source'           , w =>    10},
  { key => 'park_ride'        , w =>     3},
  { key => 'supervised'       , w =>     3},
  { key => 'wheelchair'       , w =>     3},
  { key => 'addr:street'      , w =>    30},
  { key => 'addr:housenumber' , w =>     4},
  { key => 'addr:postcode'    , w =>     4},
  { key => 'description'      , w =>    10},
);

my $dot_width = ".width 11 11 11 11";
# my $cols_stmt = 'ini.nod_id
# , ini.way_id
# , ini.rel_id';
my $cols_stmt = 'wy.nod_id
, wy.way_id
, wy.lat
, wy.lon';

# my $table_stmt = ' tag ini';
my $table_stmt = ' wy';

my $no_alias = 0;
for my $col (@cols) { #_{

  my $alias = "t$no_alias";

  my $key = $col->{key};
 (my $col_name  = $key) =~ s/:/_/g;

  $cols_stmt  .= "\n, $alias.val $col_name";
# $table_stmt .= " left join\n   tag $alias on $alias.key ='$key' and (ini.nod_id = $alias.nod_id or ini.way_id = $alias.way_id or ini.rel_id = $alias.rel_id)";
# $table_stmt .= " left join\n   tag $alias on $alias.key ='$key' and (wy.nod_id = $alias.nod_id or wy.way_id = $alias.way_id or wy.rel_id = $alias.rel_id)";
  $table_stmt .= " left join\n   tag $alias on $alias.key ='$key' and (wy.nod_id = $alias.nod_id  or wy.way_id = $alias.way_id /* or wy.rel_id = $alias.rel_id */)";

  $dot_width .= " $col->{w}";

  $no_alias ++;

} #_}

my $sql_stmt = "
with ini as (
  select
    nod_id,
    way_id
  from
    tag
  where
    key = '$key' and
    val = '$val'
),
nd as (
  select
    ini.nod_id,
    ini.way_id,
    nod.lat,
    nod.lon
  from
    ini left join
    nod on ini.nod_id = nod.id
),
wy as (
  select
    nd.nod_id,
    nd.way_id,
    coalesce(nd.lat, (max(nod.lat) + min(nod.lat)) / 2) lat,
    coalesce(nd.lon, (max(nod.lon) + min(nod.lon)) / 2) lon
  from
    nd                                    left join
    nod_way on nd.way_id = nod_way.way_id left join
    nod     on nod.id    = nod_way.nod_id
  group by
    nd.nod_id,
    nd.way_id
)
select
  $cols_stmt
from
  $table_stmt
-- where
--   ini.key = '$key' and
--   ini.val = '$val'
;";



my $sth = $dbh->prepare($sql_stmt);
$sth->execute;
while (my $r = $sth->fetchrow_hashref) {


  my $name = $r->{name} // '?';

  $name =~ s/&/&amp;/g;

     print $kml "<Placemark>
     <name>$name</name>
     <Point>
    <coordinates>$r->{lon},$r->{lat}</coordinates>
    </Point>
  </Placemark>";

#     print $kml "<Placemark>
#  <name>$name</name>
#  <styleUrl>#alphuette</styleUrl>
#  <Point>
#    <extrude>1</extrude>
#    <altitudeMode>relativeToGround</altitudeMode>
#    <coordinates>$r->{lon},$r->{lat},800</coordinates>
#  </Point></Placemark>";


}

osm_queries::end_kml($kml );

# print ".mode column\n";
# print ".header on\n";
# print ".timer on\n";
# print "$dot_width\n";
# print $sql_stmt;
