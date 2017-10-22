#!/usr/bin/perl
use warnings;
use strict;
use utf8;

use DBI;
use osm_queries;

create_pivot_sql();

exit;

my $dbh = DBI->connect('dbi:SQLite:dbname=../../db/ch.db',  '', '', { sqlite_unicode => 1 }) or die "Could not create the.db";

my $sth = $dbh->prepare(<<SQL);
select
  m.rel_id rel_id,
  m.name   name_municipality,
  p.*
from
  parkplaetze          p join
  municipalities_ch_v  m on p.lat between m.lat_min and m.lat_max and
                            p.lon between m.lon_min and m.lon_max
order by
  m.name
SQL

$sth->execute;
my $last_rel_id = 0;
my $kml;
my $html = osm_queries::start_html("Parkplaetze/index", "Parkplätze in Gemeinden der Schweiz", "Parkplätze der Schweiz für Google Earth aus OpenStreetMap<br>
  Ist der Pin rot, hat der Parkplatz <code>access=private</code>; wenn gelb, dann <code>access=customers</code>, wenn grün, dann <code>fee=no</code>, wenn violett (purple? dunkelpink?), dann <code>fee=yes</code>.
");
while (my $r = $sth->fetchrow_hashref) {#_{

# print join "\n", keys %{$r};
# exit;

# print $r->{rel_id}, "\n";
# next;

  if ($last_rel_id != $r->{rel_id}) {

    if ($last_rel_id) {
       osm_queries::end_kml ($kml );
    }

    my $name_municipality = "$r->{name_municipality}-$r->{rel_id}";
    $name_municipality =~ s/ /_/g;
    $name_municipality =~ s/ä/ae/g;
    $name_municipality =~ s/ö/oe/g;
    $name_municipality =~ s/ü/ue/g;
    $name_municipality =~ s/Ä/Ae/g;
    $name_municipality =~ s/Ö/Oe/g;
    $name_municipality =~ s/Ü/Ue/g;
    $name_municipality =~ s/ë/e/g;
    $name_municipality =~ s/è/e/g;
    $name_municipality =~ s/é/e/g;
    $name_municipality =~ s/à/a/g;
    $name_municipality =~ s/á/a/g;
    $name_municipality =~ s/'//g;
    $name_municipality =~ s/\//_/g;

    $kml  = osm_queries::start_kml("Parkplaetze/$name_municipality");
    print $html " / <a href='$name_municipality.kml'>$r->{name_municipality}</a>";
#   $html = osm_queries::start_html("Parkplaetze/$name_municipality", $r->{name_municipality});

    $last_rel_id = $r->{rel_id};

  }

  my $name_tag = '';
  if (defined $r->{name}) {
    my $name = $r->{name};
    $name =~ s/&/&amp;/g;
    $name_tag = "<name>$name</name>";
  }

  my $style_url;
  if (defined $r->{access} and $r->{access} eq 'private') {
     $style_url = '#red-pin';
  }
  elsif (defined $r->{access} and $r->{access} eq 'customers') {
     $style_url = '#yellow-pin';
  }
  elsif (defined $r->{fee}) {
    if ($r->{fee} eq 'no') {
       $style_url = '#green-pin';
    }
    elsif ($r->{fee} eq 'yes') {
       $style_url = '#purple-pin';
    }
    else {
       $style_url = '#white-pin';
    }
  }
  else {
       $style_url = '#white-pin';
  }


  my $trs = '';


  if ($r->{parking          } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Parking:'        , $r->{parking          }); }
  if ($r->{access           } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Access:'         , $r->{access           }); }
  if ($r->{fee              } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Fee:'            , $r->{fee              }); }
  if ($r->{capacity         } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Capacity:'       , $r->{capacity         }); }
  if ($r->{surface          } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Surface:'        , $r->{surface          }); }
  if ($r->{source           } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Source:'         , $r->{source           }); }
  if ($r->{park_ride        } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Park &amp; ride:', $r->{park_ride        }); }
  if ($r->{supervise        } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Supervised:'     , $r->{supervised       }); }
  if ($r->{wheelchair       } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Wheelchair:'     , $r->{wheelchair       }); }
  if ($r->{description      } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Description'     , $r->{description      }); }
  if ($r->{addr_street      } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Street:'         , $r->{addr_street      }); }
  if ($r->{addr_housuenumber} ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'Street:'         , $r->{addr_housuenumber}); }
  if ($r->{addr_postcode    } ) { $trs .= sprintf("<tr><td>%s</td><td>%s</td></tr>", 'PLZ:'            , $r->{addr_postcode    }); }


  my $table = '';

  if ($trs) {
    $table = "<description> <![CDATA[ <table>$trs</table> ]]> </description>";
  }



     print $kml "<Placemark>
		<styleUrl>$style_url</styleUrl>
     $name_tag
     $table
     <Point><coordinates>$r->{lon},$r->{lat}</coordinates></Point>

  </Placemark>";

  osm_queries::end_kml($kml );
  osm_queries::end_html($html);
} #_}

sub create_pivot_sql { #_{

  my @cols = (
    { key => 'parking'          , w =>    12},
    { key => 'access'           , w =>    13},
    { key => 'fee'              , w =>    10},
    { key => 'capacity'         , w =>     4},
#   { key => 'name'             , w =>    30},
    { key => 'surface'          , w =>    10},
    { key => 'source'           , w =>    10},
    { key => 'park_ride'        , w =>     3},
    { key => 'supervised'       , w =>     3},
    { key => 'wheelchair'       , w =>     3},
#   { key => 'addr:street'      , w =>    30},
#   { key => 'addr:housenumber' , w =>     4},
#   { key => 'addr:postcode'    , w =>     4},
    { key => 'description'      , w =>    10},
  );

  print osm_queries::create_pivot_sql(
    'amenity', # key
    'parking', # val
    \@cols);


} #_}
