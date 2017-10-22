#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use osm_queries;

create_pivot_sql();

exit;

sub create_pivot_sql { #_{

  my @cols = (
    { key => 'operator'         , w =>    12},
    { key => 'brand'            , w =>    20},
    { key => 'diesel'           , w =>     3},
    { key => 'fuel:octane_95'   , w =>     3},
    { key => 'fuel:octane_98'   , w =>     3},
    { key => 'fuel:octane_91'   , w =>     3},
    { key => 'fuel:octane_100'  , w =>     3},
    { key => 'fuel:buione_100'  , w =>     3},
    { key => 'shop'             , w =>     3},
    { key => 'opening_hours'    , w =>     3},
    { key => 'description'      , w =>    30},
  );

  print osm_queries::create_pivot_sql(
    'amenity', # key
    'fuel'   , # val
    \@cols);


} #_}
