#!/usr/bin/perl
use warnings;
use strict;
use osm_queries;

my $dbh = osm_queries::open_db();

my $html = osm_queries::start_html("shop-supermarket", "key = shop / val = supermarket",
"key = shop / val = supermarket");

my $sql_stmt = "
select
  gt.nod_id,
  gt.way_id,
  gt.rel_id,
    coalesce(gt.nod_id, '') || '-' || 
    coalesce(gt.way_id, '') || '-' ||
    coalesce(gt.rel_id, '')             id_,
  gt.key,
  gt.val
from
  tag tg                              join
  tag gt on tg.nod_id = gt.nod_id or
            tg.way_id = gt.way_id or
            tg.rel_id = gt.rel_id
where
--tg.key = 'amenity' and tg.val = 'fuel'
  tg.key = 'shop'    and tg.val = 'supermarket'
--tg.val = 'parking'
order by
  tg.rel_id,
  tg.way_id,
  tg.nod_id
";

my $sth = $dbh->prepare($sql_stmt);
$sth -> execute;

my $last_id_ = '';
# my $osm_id;
my %val;
print $html "<table>\n";
while (my $r = $sth->fetchrow_hashref) {
  if ($last_id_ ne $r->{id_}) {
#   print "new id: $r->{id_}\n";

    emit_record(\%val) if $last_id_;
    %val = ();
    $last_id_ = $r->{id_};
    $val{nod_id} = $r->{nod_id};
    $val{way_id} = $r->{way_id};
    $val{rel_id} = $r->{rel_id};
#   $osm_id->{nod_id} = $r->{nod_id};
#   $osm_id->{way_id} = $r->{way_id};
  }
  $val{$r->{key}}=$r->{val};
}
emit_record(\%val);
print $html "</table>\n";
osm_queries::end_html($html);

exit;

sub emit_record {
  my $val = shift;
  print $html "\n<tr class='nextRow'>";

  print $html "<td>" . osm_queries::html_a_way_nod_id($val) . "</td>";

  print $html "<td><table>";
    print $html "<tr><td>" . osm_queries::html_escape($val->{name    }) . "</td></tr>" if defined $val->{name};
    print $html "<tr><td>" . osm_queries::html_escape($val->{operator}) . "</td></tr>" if defined $val->{operator} and $val->{operator} ne ($val->{name} // '?');
    print $html "<tr><td>" . osm_queries::html_escape($val->{brand   }) . "</td></tr>" if defined $val->{brand}    and $val->{brand}    ne ($val->{name} // '?') and $val->{brand} ne ($val->{operator} // '?');
  print $html "</table></td>";

  print $html "<td><table>";
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:street'   }) . ' ' . osm_queries::html_escape($val->{'addr:housenumber'}) . "</td></tr>" if defined $val->{'addr:street'   };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:postcode' }) . ' ' . osm_queries::html_escape($val->{'addr:city'       }) . "</td></tr>" if defined $val->{'addr:city'     };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:housename'}) . ' ' . osm_queries::html_escape($val->{'addr:city'       }) . "</td></tr>" if defined $val->{'addr:housename'};
  print $html "<tr><td>" . osm_queries::html_escape($val->{'phone'         })                                                              . "</td></tr>" if defined $val->{'phone'         };
  print $html "<tr><td>Fax: " . osm_queries::html_escape($val->{'fax'         })                                                              . "</td></tr>" if defined $val->{'fax'         };
  print $html "<tr><td>Fax: " . osm_queries::html_escape($val->{'contact:fax'         })                                                              . "</td></tr>" if defined $val->{'contact:fax'         };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:phone' })                                                              . "</td></tr>" if defined $val->{'contact:phone' };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:email' })                                                              . "</td></tr>" if defined $val->{'contact:email' };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'website'       })                                                              . "</td></tr>" if defined $val->{'website'       };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:website'       })                                                              . "</td></tr>" if defined $val->{'contact:website'       };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'url'           })                                                              . "</td></tr>" if defined $val->{'url'           };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'email'         })                                                              . "</td></tr>" if defined $val->{'email'         };
  print $html "</table></td>";

  my $opening_hours = $val->{opening_hours} // '';
  $opening_hours = osm_queries::html_escape($opening_hours);
  $opening_hours =~ s/[;]/<br>/g;
  print $html "<td>" . $opening_hours . "</td>";


  delete $val->{nod_id};
  delete $val->{way_id};
  delete $val->{rel_id};

  delete $val->{shop};
  delete $val->{source};
  delete $val->{created_by};

  delete $val->{name};
  delete $val->{operator};
  delete $val->{brand};
  delete $val->{'addr:street'};
  delete $val->{'addr:housenumber'};
  delete $val->{'addr:postcode'};
  delete $val->{'addr:city'};
  delete $val->{'phone'};
  delete $val->{'contact:phone'};
  delete $val->{'fax'};
  delete $val->{'contact:fax'};
  delete $val->{'website'};
  delete $val->{'contact:website'};
  delete $val->{'url'};
  delete $val->{'email'};
  delete $val->{'contact:email'};
  delete $val->{'opening_hours'};

  print $html "<td><table>";

  for my $key (keys %$val) {
     print $html "<tr><td>$key:</td><td>" . $val->{$key} . "</td></tr>";
  }

  print $html "</table></td>";

  print $html "</tr>";
}
