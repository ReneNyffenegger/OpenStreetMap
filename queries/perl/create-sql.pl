#!/usr/bin/perl
use warnings;
use strict;


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

my $dot_width = ".width 11 11 11";
my $cols_stmt = 'ini.nod_id
, ini.way_id
, ini.rel_id';

my $table_stmt = ' tag ini';

my $no_alias = 0;
for my $col (@cols) { #_{

  my $alias = "t$no_alias";

  my $key = $col->{key};
 (my $col_name  = $key) =~ s/:/_/g;

  $cols_stmt  .= "\n, $alias.val $col_name";
  $table_stmt .= " left join\n   tag $alias on $alias.key ='$key' and (ini.nod_id = $alias.nod_id or ini.way_id = $alias.way_id or ini.rel_id = $alias.rel_id)";

  $dot_width .= " $col->{w}";

  $no_alias ++;

} #_}

my $sql_stmt = "select
  $cols_stmt
from
  $table_stmt
where
  ini.key = '$key' and
  ini.val = '$val'
";


print ".mode column\n";
print ".header on\n";
print "$dot_width\n";
print $sql_stmt;
