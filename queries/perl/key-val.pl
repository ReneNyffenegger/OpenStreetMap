#!/usr/bin/perl
#
#
use warnings;
use strict;
use utf8;
use osm_queries;

my $dbh = osm_queries::open_db();

# key_val('shop', 'supermarket');
# key_val('shop', 'hairdresser');
# key_val('shop', 'convenience');
# key_val('shop', 'clothes');
# key_val('shop', 'bakery');
# key_val('shop', 'kiosk');
# key_val('shop', 'car_repair');
# key_val('shop', 'car');
# key_val('shop', 'bicycle');
# key_val('shop', 'florist');
# key_val('shop', 'butcher');
# key_val('shop', 'shoes');
# key_val('shop', 'sports');
# key_val('shop', 'jewelry');
# key_val('shop', 'farm');
# key_val('shop', 'optician');
# key_val('shop', 'furniture');
# key_val('shop', 'electronics');
# key_val('shop', 'beauty');
# key_val('shop', 'books');
# key_val('shop', 'travel_agency');
# key_val('shop', 'doityourself');
  key_val('shop', 'gift');
# key_val('shop', 'mall');
# key_val('shop', 'chemist');
# key_val('shop', 'mobile_phone');
# key_val('shop', 'garden_centre');
# key_val('shop', 'alcohol');
# key_val('shop', 'boutique');
# key_val('shop', 'motorcycle');
# key_val('shop', 'department_store');
# key_val('shop', 'toys');
# key_val('shop', 'stationary');
# key_val('shop', 'interior_decoration');
# key_val('shop', 'computer');
# key_val('shop', 'hardware');
# key_val('shop', 'beverages');
# key_val('shop', 'second_hand');
# key_val('shop', 'hifi');
# key_val('shop', 'outdoor');
# key_val('shop', 'confectionary');
# key_val('shop', 'wine');
# key_val('shop', 'dry_cleaning');
# key_val('shop', 'laundry');
# key_val('shop', 'pet');
# key_val('shop', 'art');
# key_val('shop', 'fashion');
# key_val('shop', 'dairy');
# key_val('shop', 'cheese');
# key_val('shop', 'cosmetics');
# key_val('shop', 'no');
# key_val('shop', 'copyshop');
# key_val('shop', 'musical_instrument');
# key_val('shop', 'ticket');
# key_val('shop', 'photo');
# key_val('shop', 'hearing_aids');
# key_val('shop', 'deli');
#
# key_val('amenity' , 'cafe' );
# key_val('amenity' , 'fast_food' );
# key_val('tourism' , 'hotel');
# key_val('takeaway', 'yes' );

sub key_val { #_{

  my $key_ = shift;
  my $val_ = shift;

  my $html = osm_queries::start_html("$key_-$val_", "key = $key_ / val = $val_", "key = $key_ / val = $val_");
  
  my $sql_stmt = "
  select
    gt.nod_id,
    gt.way_id,
    gt.rel_id,
      coalesce(gt.nod_id, '') || '-' || 
      coalesce(gt.way_id, '') || '-' ||
      coalesce(gt.rel_id, '')             id_,
    gt.key,
    gt.val,
    pc.city
  from
    tag              tg                              join
    tag              gt on tg.nod_id = gt.nod_id or
                           tg.way_id = gt.way_id or
                           tg.rel_id = gt.rel_id     left join
    postcode_city_ch pc on gt.key = 'addr:postcode' and
                           gt.val =    pc.postcode
  where
  --tg.key = 'amenity' and tg.val = 'fuel'
    tg.key = '$key_'    and tg.val = '$val_'
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
  while (my $r = $sth->fetchrow_hashref) { #_{
    if ($last_id_ ne $r->{id_ }) {
      emit_record($key_, $val_, \%val, $html) if $last_id_;
      %val = ();
      $last_id_ = $r->{id_};
      $val{nod_id} = $r->{nod_id};
      $val{way_id} = $r->{way_id};
      $val{rel_id} = $r->{rel_id};
  
  
  #   $osm_id->{nod_id} = $r->{nod_id};
  #   $osm_id->{way_id} = $r->{way_id};
    }
    if (defined $r->{'city'}) {
  #   print join "\n", keys %$r;
  #   print "$r->{city}\n";
      $val{'x:city'} = $r->{city};
    }
    $val{$r->{key}}=$r->{val};
  } #_}
  emit_record($key_, $val_, \%val, $html);
  print $html "</table>\n";
  osm_queries::end_html($html);

} #_}

sub emit_record { #_{
  my $key_ = shift;
  my $val_ = shift;
  my $val  = shift;
  my $html = shift;

  my $cnt_val = join " - ", (keys %$val);
# my $cnt_val = scalar (keys %$val);

  print $html "\n<tr class='nextRow'>";
  print $html "<td>" . osm_queries::html_a_way_nod_id($val) . "</td>";

  # if (exists $val->{'x:city'} and $val->{'addr:city'}) {
#     print  $val->{'x:city'} . '< - >' . $val->{'addr:city'} . "<\n" if
#            $val->{'x:city'} ne $val->{'addr:city'};
# }

  print $html "<td><table>";
    if (defined $val->{name}) { #_{
      if (defined $val->{alt_name}) { #_{
        my $name     = $val->{name};
        my $alt_name = $val->{alt_name};
        if ($alt_name =~ /$name/i) {
          print $html "<tr><td>" . osm_queries::html_escape($alt_name) . "</td></tr>";
#         print $html "<tr><td>1) alt_name: " . osm_queries::html_escape($alt_name) . "</td></tr>";
#         print $html "<tr><td>1) name: "     . osm_queries::html_escape($name    ) . "</td></tr>";
        }
        elsif ($name =~ /$alt_name/i) {
          print $html "<tr><td>" . osm_queries::html_escape($name) . "</td></tr>";
        }
        else {
          print $html "<tr><td>" . osm_queries::html_escape($alt_name) . "<br>" .
                                   osm_queries::html_escape($name)     . "</td></tr>";
#         print $html "<tr><td>2) alt_name: " . osm_queries::html_escape($alt_name) . "</td></tr>";
#         print $html "<tr><td>2) name:"     . osm_queries::html_escape($name    ) . "</td></tr>";
        }
#       print $html "<tr><td>" . osm_queries::html_escape($val->{name    }) . "</td></tr>" if defined $val->{name};
      } #_}
      else {
        print $html "<tr><td>" . osm_queries::html_escape($val->{name    }) . "</td></tr>" if defined $val->{name};
      }
    } #_}
    if (defined $val->{'name_1'}) { #_{
      print $html "<tr><td>" . osm_queries::html_escape(delete $val->{name_1}) . "</td></tr>";
    } #_}
#   else { #_{
#     die;
#     print $html "<tr><td>" . osm_queries::html_escape($val->{name    }) . "</td></tr>" if defined $val->{name};
#   } #_}
    if (defined $val->{'old_name'}) { #_{
      print $html "<tr><td>Ehemals: " . osm_queries::html_escape($val->{old_name}) . "</td></tr>";
    } #_}
    print $html "<tr><td>" . osm_queries::html_escape($val->{operator}) . "</td></tr>" if defined $val->{operator} and $val->{operator} ne ($val->{name} // '?');
    print $html "<tr><td>" . osm_queries::html_escape($val->{brand   }) . "</td></tr>" if defined $val->{brand}    and $val->{brand}    ne ($val->{name} // '?') and $val->{brand} ne ($val->{operator} // '?');
  print $html "</table></td>";

  print $html "<td><table>";
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:housename'}) .                                                              "</td></tr>" if defined $val->{'addr:housename'};
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:place '   }) .                                                              "</td></tr>" if defined $val->{'addr:place'   };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:street'   }) . ' ' . osm_queries::html_escape($val->{'addr:housenumber'}) . "</td></tr>" if defined $val->{'addr:street'   };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:suburb'   }) . "</td></tr>" if defined $val->{'addr:suburb'   };


# print $html "<tr><td>" . osm_queries::html_country_zip_city($val) . "</td></tr>" if defined $val->{'addr:city'} ;
  print $html "<tr><td>" . osm_queries::html_country_zip_city($val) . "</td></tr>"; #  if defined $val->{'addr:postcode'} ;
# print $html "<tr><td>" . osm_queries::html_escape($val->{'addr:postcode' }) . ' ' . osm_queries::html_escape($val->{'addr:city'       }) . "</td></tr>" if defined $val->{'addr:city'     };

  my $floor;
  if ($floor = delete $val->{'floor'} or $floor = delete $val->{'addr:floor'} or $floor = delete $val->{level} or $floor = delete $val->{layer}) {
     if ($floor eq '0') {
       print $html "<tr><td>Erdgeschoss</td></tr>"
     }
     elsif ($floor =~ /^-?\d+$/) {

       if ($floor > 0) {
         print $html "<tr><td>$floor. Etage</td></tr>"
       }
       else {
         printf $html "<tr><td>%d. Untergeschoss</td></tr>", -$floor;
       }

     }
     else {
       $floor =~ s/;/ und /;
       print $html "<tr><td>Etagen $floor</td></tr>";
     }
  }

  print $html "<tr><td>" . osm_queries::html_escape($val->{'phone'         }) . "</td></tr>" if defined $val->{'phone'         };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:phone' }) . "</td></tr>" if defined $val->{'contact:phone' };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:mobile' }) . "</td></tr>" if defined $val->{'contact:mobile' };
  print $html "<tr><td>" . osm_queries::html_escape(delete $val->{'phone:mobile'   }) . "</td></tr>" if defined $val->{'phone' };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'mobile'         }) . "</td></tr>" if defined $val->{'mobile' };

  print $html "<tr><td>Fax: " . osm_queries::html_escape($val->{'fax'         })                                                              . "</td></tr>" if defined $val->{'fax'         };
  print $html "<tr><td>Fax: " . osm_queries::html_escape($val->{'contact:fax'         })                                                              . "</td></tr>" if defined $val->{'contact:fax'         };

  print $html "<tr><td>" . osm_queries::html_email  ($val->{'contact:email'  })  . "</td></tr>" if defined $val->{'contact:email'};
  print $html "<tr><td>" . osm_queries::html_email  ($val->{'email'          })  . "</td></tr>" if defined $val->{'email'        };
# print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:email' })                                                              . "</td></tr>" if defined $val->{'contact:email' };

  print $html "<tr><td>" . osm_queries::html_website($val->{'website'         }) . "</td></tr>" if defined $val->{'website'};
  print $html "<tr><td>" . osm_queries::html_website($val->{'contact:website' }) . "</td></tr>" if defined $val->{'contact:website'};
  print $html "<tr><td>" . osm_queries::html_website($val->{'url'             }) . "</td></tr>" if defined $val->{'url'}; 
  print $html "<tr><td>" . osm_queries::html_website($val->{'contact:facebook'}) . "</td></tr>" if defined $val->{'contact:facebook'};
  print $html "<tr><td>" . osm_queries::html_website(delete $val->{'facebook' }) . "</td></tr>" if defined $val->{'facebook'};
# print $html "<tr><td>" . osm_queries::html_escape($val->{'website'       })                                                              . "</td></tr>" if defined $val->{'website'       };
# print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:website'       })                                                              . "</td></tr>" if defined $val->{'contact:website'       };


  print $html "</table></td>";

  my $opening_hours = $val->{opening_hours} // '';
  $opening_hours = osm_queries::html_escape($opening_hours);
  $opening_hours =~ s/[;]/<br>/g;
  print $html "<td>" . $opening_hours . "</td>";
 

  delete $val->{nod_id};
  delete $val->{way_id};
  delete $val->{rel_id};

  delete $val->{$key_};
  delete $val->{source};
  delete $val->{created_by};

  delete $val->{name};
  delete $val->{alt_name};
  delete $val->{old_name};
  delete $val->{operator};
  delete $val->{brand};
  delete $val->{'addr:place'};
  delete $val->{'addr:street'};
  delete $val->{'addr:housename'};
  delete $val->{'addr:housenumber'};
  delete $val->{'addr:suburb'};
# delete $val->{'addr:postcode'};
# delete $val->{'addr:city'};
  delete $val->{'phone'};
  delete $val->{'contact:phone'};
  delete $val->{'mobile'};
  delete $val->{'contact:mobile'};
  delete $val->{'fax'};
  delete $val->{'contact:fax'};
  delete $val->{'website'};
  delete $val->{'contact:website'};
  delete $val->{'contact:facebook'};
  delete $val->{'url'};
  delete $val->{'email'};
  delete $val->{'contact:email'};
  delete $val->{'opening_hours'};
  delete $val->{'x:city'};

  if (exists $val->{'building'}) {
    delete $val->{building} and goto DEL_BUILDING if $val->{'building'} eq 'yes';
    delete $val->{building} if $key_ eq 'tourism' and $val_ eq 'hotel' and $val->{building} eq 'hotel'; 
  }
  DEL_BUILDING:


  print $html "<td><table>";

  print $html tr_td_if_key_val($val, 'takeaway'                , 'yes'      , 'Take-Away');
  print $html tr_td_if_key_val($val, 'delivery'                , 'yes'      , 'Zustelldienst');
  print $html tr_td_if_key_val($val, 'delivery'                , 'no'       , 'kein Zustelldienst');
  print $html tr_td_if_key_val($val, 'delivery'                , 'only'     , 'nur mit Zustelldienst');

  print $html tr_td_if_key_val($val, 'wheelchair'              , 'yes'      , 'rollstuhlgängig');
  print $html tr_td_if_key_val($val, 'wheelchair'              , 'limited'  , 'begrenzt rollstuhlgängig');
  print $html tr_td_if_key_val($val, 'wheelchair'              , 'no'       , 'nicht rollstuhlgängig');
  print $html tr_td_if_key_val($val, 'toilets:wheelchair'      , 'no'       , 'keine rollstuhlgängige Toiletten');
  print $html tr_td_if_key_val($val, 'toilets:wheelchair'      , 'yes'      , 'rollstuhlgängige Toiletten');
  if (exists $val->{'wheelchair:description'}) {
    my $wheelchair_description = delete $val->{'wheelchair:description'};
    print $html "<tr><td>" . osm_queries::html_escape("Rollstuhlinformation: $wheelchair_description") . "</td></tr>";
  }


  print $html tr_td_if_key_val($val, 'beauty'                  , 'nails'    , 'Nägeldesign');

  print $html tr_td_if_key_val($val, 'diet:gluten_free'        , 'yes'      , 'glutenfrei');
  print $html tr_td_if_key_val($val, 'diet:vegetarian'         , 'no'       , 'nicht vegetarisch');
  print $html tr_td_if_key_val($val, 'gluten_free'             , 'yes'      , 'glutenfrei');
  print $html tr_td_if_key_val($val, 'organic'                 , 'yes'      , 'biologisch');
  print $html tr_td_if_key_val($val, 'organic'                 , 'no'       , 'nicht biologisch');
  print $html tr_td_if_key_val($val, 'organic'                 , 'only'     , 'nur Bio');
  print $html tr_td_if_key_val($val, 'outdoor_seating'         , 'yes'      , 'Aussenbestuhlung');
  print $html tr_td_if_key_val($val, 'outdoor_seating'         , 'no'       , 'keine Aussenbestuhlung');
  print $html tr_td_if_key_val($val, 'smoking'                 , 'no'       , 'nichtraucher');
  print $html tr_td_if_key_val($val, 'smokefree'               , 'yes'      , 'nichtraucher');
  print $html tr_td_if_key_val($val, 'smoking:outside'         , 'yes'      , 'rauchen: draussen');
  print $html tr_td_if_key_val($val, 'smoking'                 , 'outside'  , 'rauchen: draussen');
  print $html tr_td_if_key_val($val, 'smoking'                 , 'separated', 'Fumoir');
  print $html tr_td_if_key_val($val, 'payment:cash'            , 'yes'      , 'Bargeldbezahlung');
  print $html tr_td_if_key_val($val, 'payment:coins'           , 'yes'      , 'Münzbezahlung');
  print $html tr_td_if_key_val($val, 'payment:bitcoin'         , 'yes'      , 'Bitcoinbezahlung');
  print $html tr_td_if_key_val($val, 'payment:notes'           , 'yes'      , 'Banknotenbezahlung');
  print $html tr_td_if_key_val($val, 'payment:maestro'         , 'yes'      , 'akzeptiert Maestro');
  print $html tr_td_if_key_val($val, 'payment:visa'            , 'yes'      , 'akzeptiert VISA');
  print $html tr_td_if_key_val($val, 'payment:mastercard'      , 'yes'      , 'akzeptiert Master Card');
  print $html tr_td_if_key_val($val, 'payment:american_express', 'yes'      , 'akzeptiert American Express');

  print $html tr_td_if_key_val($val, 'amenity'            , 'cafe'         , 'Café');
  print $html tr_td_if_key_val($val, 'cafe'               , 'yes'          , 'Café');
  print $html tr_td_if_key_val($val, 'amenity'            , 'restaurant'   , 'Restaurant');
  print $html tr_td_if_key_val($val, 'amenity'            , 'fast_food'    , 'Fast-Food');
  print $html tr_td_if_key_val($val, 'restaurant'         , 'yes'          , 'Restaurant');
  print $html tr_td_if_key_val($val, 'shop'               , 'bakery'       , 'Bäckerei');
  print $html tr_td_if_key_val($val, 'shop'               , 'pastry'       , 'Konditorei');

  print $html tr_td_if_key_val($val, 'internet_access'    , 'yes'          , 'Internetzugang');
  print $html tr_td_if_key_val($val, 'internet_access'    , 'wlan'         , 'WLAN');
  print $html tr_td_if_key_val($val, 'wlan'               , 'free'         , 'gratis WLAN');
  print $html tr_td_if_key_val($val, 'internet_access:fee', 'no'           , 'gratis Internet');
  print $html tr_td_if_key_val($val, 'internet_access:fee', 'yes'          , 'kostenpflichtiges Internet');
  print $html tr_td_if_key_val($val, 'wifi'               , 'no'           , 'kein WIFI');

  print $html tr_td_if_key_val($val, 'self_service'       , 'yes'          , 'Selbstbedienung');
  print $html tr_td_if_key_val($val, 'amenity'            , 'vending_machine', 'Verkaufsautomat'); # od. Warenautomat?

  print $html tr_td_if_key_val($val, 'service:bicycle:repair'    , 'yes'                   , 'Veloreperatur');
  print $html tr_td_if_key_val($val, 'amenity'                   , 'bicycle_repair_station', 'Veloreperatur');
  print $html tr_td_if_key_val($val, 'service:bicycle:retail'    , 'yes'         , 'Veloverkauf');
  print $html tr_td_if_key_val($val, 'service:bicycle:pump'      , 'yes'         , 'Velos pumpen');
  print $html tr_td_if_key_val($val, 'service:bicycle:rental'    , 'yes'         , 'Velos mieten');
  print $html tr_td_if_key_val($val, 'amenity'                   , 'bicycle_rental', 'Velos mieten');
  print $html tr_td_if_key_val($val, 'service:bicycle:sportswear', 'yes'         , 'Velosport-Bekleidung');
  print $html tr_td_if_key_val($val, 'service:bicycle:cleaning'  , 'yes'         , 'Velos reinigen');
  print $html tr_td_if_key_val($val, 'service:bicycle:parts'     , 'yes'         , 'Velo-Ersatzteile');
  print $html tr_td_if_key_val($val, 'service:bicycle:dealer'    , 'yes'         , 'Velohändler');
  print $html tr_td_if_key_val($val, 'service:bicycle:diy'       , 'yes'         , 'Velo do-it-yourself');
  print $html tr_td_if_key_val($val, 'service:bicycle:second_hand', 'yes'         , 'Occasionsvelos');
  print $html tr_td_if_key_val($val, 'vending'                    , 'bicycle_tube', 'Veloschlauch-Verkauf');

  print $html tr_td_if_key_val($val, 'amenity'                    , 'solarium'    , 'Solarium');

  print $html tr_td_if_key_val($val, 'drive_through'      , 'no'           , 'kein Drive-Through');

  print $html tr_td_if_key_val($val, 'craft'              , 'key_cutter'   , 'Schlüsselservice');

  my $stars;
  if ($stars = delete $val->{stars} or $stars = delete $val->{'stars:hotel'}) {
    if ($stars eq '1') {
      print $html "<tr><td>1 Stern</td</tr>";
    }
    else {
      print $html "<tr><td>$stars Sterne</td</tr>";
    }
  }
  my $rooms;
  if ($rooms = delete $val->{rooms }) {
    print $html "<tr><td>$rooms Zimmer</td</tr>";
  }
  my $beds;
  if ($beds = delete $val->{beds }) {
    print $html "<tr><td>$beds Betten</td</tr>";
  }

  if (my $cuisine = delete $val->{cuisine}) {
       if ($cuisine eq 'german'       ) { print $html "<tr><td>deutsche Küche</td</tr>" }
    elsif ($cuisine eq 'italian'      ) { print $html "<tr><td>italienische Küche</td</tr>" }
    elsif ($cuisine eq 'thai'         ) { print $html "<tr><td>thailändische Küche</td</tr>" }
    elsif ($cuisine eq 'asian'        ) { print $html "<tr><td>asiatische Küche</td</tr>" }
    elsif ($cuisine eq 'chinese'      ) { print $html "<tr><td>chinesische Küche</td</tr>" }
    elsif ($cuisine eq 'indian'       ) { print $html "<tr><td>indische Küche</td</tr>" }
    elsif ($cuisine eq 'french'       ) { print $html "<tr><td>französische Küche</td</tr>" }
    elsif ($cuisine eq 'japanese'     ) { print $html "<tr><td>japanische Küche</td</tr>" }
    elsif ($cuisine eq 'mexican'      ) { print $html "<tr><td>mexikanische Küche</td</tr>" }
    elsif ($cuisine eq 'turkish'      ) { print $html "<tr><td>türkische Küche</td</tr>" }
    elsif ($cuisine eq 'swiss'        ) { print $html "<tr><td>schweizer Küche</td</tr>" }
    elsif ($cuisine eq 'vegetarian'   ) { print $html "<tr><td>vegetarische Küche</td</tr>" }
    elsif ($cuisine eq 'falafel'      ) { print $html "<tr><td>Falafel</td</tr>" }
    elsif ($cuisine eq 'greek'        ) { print $html "<tr><td>griechische Küche</td</tr>" }
    elsif ($cuisine eq 'spanish'      ) { print $html "<tr><td>spanische Küche</td</tr>" }
    elsif ($cuisine eq 'vietnamese'   ) { print $html "<tr><td>spanische Küche</td</tr>" }
    elsif ($cuisine eq 'international') { print $html "<tr><td>internationale Küche</td</tr>" }
    elsif ($cuisine eq 'sandwich'     ) { print $html "<tr><td>Sandwiches</td</tr>" }
    elsif ($cuisine eq 'pizza'        ) { print $html "<tr><td>Pizza</td</tr>" }
    elsif ($cuisine eq 'burger'       ) { print $html "<tr><td>Hamburger</td</tr>" }
    elsif ($cuisine eq 'crepe'        ) { print $html "<tr><td>Crêpes</td</tr>" }
    elsif ($cuisine eq 'ice_cream'    ) { print $html "<tr><td>Glacé</td</tr>" }
    elsif ($cuisine eq 'steak_house'  ) { print $html "<tr><td>Steak House</td</tr>" }
    elsif ($cuisine eq 'kebab'        ) { print $html "<tr><td>Kebab</td</tr>" }
    elsif ($cuisine eq 'regional'     ) { print $html "<tr><td>regionale Küche</td</tr>" }
    elsif ($cuisine eq 'chicken'      ) { print $html "<tr><td>Poulets</td</tr>" }
    elsif ($cuisine eq 'seasonal'     ) { print $html "<tr><td>saisonale Küche</td</tr>" }
    elsif ($cuisine eq 'coffee_shop'  ) { print $html "<tr><td>Kaffeehaus</td</tr>" }
    else                                { print $html "<tr><td>$cuisine cuisine</td</tr>" }
  }

  if (exists $val->{ele}) {
    printf $html "<tr><td>%d M.ü.M</td></tr>", int(delete $val->{ele});
  }


  for my $key (keys %$val) {
     print $html "<tr><td>$key: " . $val->{$key} . "</td></tr>";
  }

# printf $html "<tr><td>cnt val:</td><td>$cnt_val</td></tr>";

  print $html "</table></td>";

  print $html "</tr>";
} #_}

sub tr_td_if_key_val { #_{
  my $val = shift;
  my $k   = shift;
  my $v   = shift;
  my $txt = shift;

  if (exists $val->{$k}) {
    if ($val->{$k} eq $v) {
       delete $val->{$k};
       return "<tr><td>$txt</td></tr>";
    }
  }
  return "";
} #_}
