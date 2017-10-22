#!/usr/bin/perl
use warnings;
use strict;

use utf8;
use osm_queries;

# create_pivot_sql();
create_html_kml();

exit;

sub create_pivot_sql { #_{

  my @cols = (
    { key => 'operator'         , w =>    12},
    { key => 'brand'            , w =>    20},
    { key => 'diesel'           , w =>     3},
    { key => 'fuel:octane_80'   , w =>     3},
    { key => 'fuel:octane_92'   , w =>     3},
    { key => 'fuel:octane_95'   , w =>     3},
    { key => 'fuel:octane_98'   , w =>     3},
    { key => 'fuel:octane_91'   , w =>     3},
    { key => 'fuel:octane_99'   , w =>     3},
    { key => 'fuel:octane_100'  , w =>     3},
    { key => 'fuel:e10'         , w =>     3},
    { key => 'fuel:e85'         , w =>     3},
    { key => 'fuel:lpg'         , w =>     3},
    { key => 'fuel:cng'         , w =>     3},
    { key => 'fuel:biogas'      , w =>     3},
    { key => 'fuel:biodiesel'   , w =>     3},
    { key => 'fuel:GTL_diesel'  , w =>     3},
    { key => 'fuel:HGV_diesel'  , w =>     3},
    { key => 'fuel:1_25'        , w =>     3},
    { key => 'fuel:1_50'        , w =>     3},
    { key => 'fuel:electricity' , w =>     3},
#   { key => 'fuel:buione_100'  , w =>     3},
    { key => 'shop'             , w =>     3},
    { key => 'opening_hours'    , w =>     3},
#   { key => 'description'      , w =>    30},
    { key => 'contact:website'  , w =>    50},
    { key => 'website'          , w =>    50},
    { key => 'contact:phone'    , w =>    50},
    { key => 'phone'            , w =>    50},
    { key => 'note'             , w =>    50},
  );

  my $sql_stmt = osm_queries::create_pivot_sql(
    'amenity', # key
    'fuel'   , # val
    \@cols);

  my $dbh = osm_queries::open_db();

  $dbh -> do ("drop   table tankstellen");
  $dbh -> do ("create table tankstellen as $sql_stmt");

} #_}
sub create_html_kml { #_{

  my $kml  = osm_queries::start_kml ("Tankstellen", "Tankstellen in der Schweiz");
  my $html = osm_queries::start_html("Tankstellen", "Tankstellen in der Schweiz",
     "Tankstellen der Schweiz für Google Earth aus OpenStreetMap Daten"
  );

  my $dbh = osm_queries::open_db();

  my $sth = $dbh->prepare(<<SQL) or die;
  select t.*
  from   tankstellen t
  order by
    coalesce(t.name, 'ZZZZZZZZZZZZ')
SQL

  $sth->execute or die;
  print $html "<table>\n";
  while (my $r = $sth->fetchrow_hashref) {#_{

#   if ($r->{notes}) {
#     print $html "<tr>";
#   }
#   else {
      print $html "<tr class='nextRow'>";
#   }

    print $html "<td>" . osm_queries::html_a_way_nod_id($r) . "</td>";

    print $html "<td><table>";
    print $html "<tr><td>" . osm_queries::html_escape($r->{name    }) . "</td></tr>" if defined $r->{name};
    print $html "<tr><td>" . osm_queries::html_escape($r->{operator}) . "</td></tr>" if defined $r->{operator} and $r->{operator} ne ($r->{name} // '?');
    print $html "<tr><td>" . osm_queries::html_escape($r->{brand   }) . "</td></tr>" if defined $r->{brand}    and $r->{brand}    ne ($r->{name} // '?') and $r->{brand} ne ($r->{operator} // '?');
    print $html "</table></td>";

#   print $html "<td>" . osm_queries::html_escape($r->{operator}) . "</td>";
#   print $html "<td>" . osm_queries::html_escape($r->{brand}) . "</td>";

    print $html "<td>" . osm_queries::html_escape($r->{shop}) . "</td>";

    print $html "<td>" . osm_queries::html_escape($r->{opening_hours}) . "</td>";

    my $table_fuel_trs = '';
    for my $col_name (qw( fuel_octane_80 fuel_octane_92 fuel_octane_95 fuel_octane_98 fuel_octane_91 fuel_octane_99 fuel_octane_100 fuel_e10 fuel_e85 fuel_lpg fuel_cng fuel_biogas fuel_biodiesel fuel_GTL_diesel fuel_HGV_diesel fuel_1_25 fuel_1_50 fuel_electricity)) { #_{

      if (defined $r->{$col_name}) {

        my ($col_name_) = $col_name =~ /^fuel_(.*)/;
        $col_name_ =~ s/_/ /g;
        $table_fuel_trs .= sprintf "<tr><td>%s</td><td>%s</td></tr>", $col_name_, $r->{$col_name};

      }
    } #_}
    if ($table_fuel_trs) {
      print $html "<td><table>$table_fuel_trs</table></td>";
    }
    else {
      print $html "<td></td>";
    }

#   print $html "<td>" . osm_queries::html_escape($r->{fuel_octane_95}) . "</td>";
#   print $html "<td>" . osm_queries::html_escape($r->{fuel_octane_98}) . "</td>";
#   print $html "<td>" . osm_queries::html_escape($r->{fuel_octane_91}) . "</td>";
#   print $html "<td>" . osm_queries::html_escape($r->{fuel_octane_100}) . "</td>";

#   print $html "<td>" . osm_queries::html_escape($r->{fuel_buione_100}) . "</td>";

    print $html "<td><table>";
    print $html "<tr><td>" . osm_queries::html_escape($r->{addr_street    }) . ' ' . osm_queries::html_escape($r->{addr_housenumber}) . "</td></tr>" if defined $r->{addr_street};
    print $html "<tr><td>" . osm_queries::html_escape($r->{addr_postcode    }) . ' ' . osm_queries::html_escape($r->{addr_city}) . "</td></tr>" if defined $r->{addr_city};
    print $html "<tr><td>" . osm_queries::html_escape($r->{contact_phone}) . "</td></tr>" if defined $r->{contact_phone};
    print $html "<tr><td>" . osm_queries::html_escape($r->{phone}) . "</td></tr>" if defined $r->{phone};
    print $html "<tr><td>" . osm_queries::html_escape($r->{website}) . "</td></tr>" if defined $r->{website};
    print $html "<tr><td>" . osm_queries::html_escape($r->{contact_website}) . "</td></tr>" if defined $r->{contact_website};
    print $html "</table></td>";

    print $html "<td>" . osm_queries::html_escape($r->{addr_street}) . ' ' .
                         osm_queries::html_escape($r->{addr_housenumber}) . "</td>";

    print $html "<td>" . osm_queries::html_escape($r->{note}) . "</td>";
    print $html "</tr>\n";

    osm_queries::kml_placemark($kml, $r);
  } #_}
  print $html "</table>";

  osm_queries::end_html($html);
  osm_queries::end_kml ($kml);

} #_}
