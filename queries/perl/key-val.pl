#!/usr/bin/perl
#
#
#    TODO:
#
#       
#      dispensing: yes/no
#        in amenity=pharmacy
#
#      http://edwardbetts.com/osm-wikidata/2014-11-24/Shopping%20malls.html
#      
#      Koordinaten auf openstreetmap.org/mlat=...&mlon=...
#
#
#    Typos:
#      operator   http://www.bienenwiese.ch
#      
#      nun numeric elevations (2039;2040  oder 2782 m)
#
#      summer_tobbogan -> summer_toboggan
#
#      tower:type: obvservation
#
#
use warnings;
use strict;
use utf8;
use osm_queries;

open (my $html_index, '>:encoding(utf-8)', '/tmp/index.html');

my @key_vals = (
 {key=>'amenity'        , val=>'bank'             , 'name' => 'Bank'},
 {key=>'amenity'        , val=>'post_office'      , 'name' => 'Postfiliale'},
 {key=>'amenity'        , val=>'restaurant'       , 'name' => 'Restaurant'},
 {key=>'amenity'        , val=>'cafe'             , 'name' => 'Café'},         # See also cuisine:coffe_shop
 {key=>'amenity'        , val=>'atm'              , 'name' => 'Geldautomat'},  # See also atm:yes

 {key=>'amenity'        , val=>'watering_place'   , 'name' => 'Brunnen'},
 {key=>'amenity'        , val=>'drinking_water'   , 'name' => 'Trinkwasser'},  # Trinkwasser: 3 Mal
 {key=>'drinking_water' , val=>'yes'              , 'name' => 'Trinkwasser'},
 {key=>'potable'        , val=>'yes'              , 'name' => 'Trinkwasser'},


 {key=>'amenity'        , val=>'vending_machine'  , 'name' => 'Verkaufsautomat'},
 {key=>'amenity'        , val=>'fast_food'        , 'name' => 'Fast-Food'},
 {key=>'amenity'        , val=>'police'           , 'name' => 'Polizeistation'},
 {key=>'amenity'        , val=>'pub'              , 'name' => 'Pub'},
 {key=>'amenity'        , val=>'bar'              , 'name' => 'Bar'},
 {key=>'amenity'        , val=>'bench'            , 'name' => 'Sitzbank'},
 {key=>'amenity'        , val=>'hospital'         , 'name' => 'Spital'},
 {key=>'amenity'        , val=>'fuel'             , 'name' => 'Tankstelle'},

 {key=>'amenity'        , val=>'bbq'              , 'name' => 'Barbecue'      },    # See also barbecue_grill: yes
 {key=>'barbecue_grill' , val=>'yes'              , 'name' => 'Barbecue-Grill'},    # See also Barbeque-Grill

 {key=>'amenity'        , val=>'fountain'         , 'name' => 'Springbrunnen/Wasserspiel'      }, 

 {key=>'cuisine'     , val=>'italian'          , 'name' => 'Italienische Küche'},
 {key=>'cuisine'     , val=>'german'           , 'name' => 'Deutsche Küche'},
 {key=>'cuisine'     , val=>'thai'             , 'name' => 'Thailändische Küche'},
 {key=>'cuisine'     , val=>'asian'            , 'name' => 'Asiatische Küche'},
 {key=>'cuisine'     , val=>'chinese'          , 'name' => 'Chinesische Küche'},
 {key=>'cuisine'     , val=>'indian'           , 'name' => 'Indische Küche'},
 {key=>'cuisine'     , val=>'french'           , 'name' => 'Französische Küche'},
 {key=>'cuisine'     , val=>'japanese'         , 'name' => 'Japanische Küche'},
 {key=>'cuisine'     , val=>'mexican'          , 'name' => 'Mexikanische Küche'},
 {key=>'cuisine'     , val=>'turkish'          , 'name' => 'Türkische Küche'},
 {key=>'cuisine'     , val=>'swiss'            , 'name' => 'Schweizer Küche'},

 {key=>'cuisine'     , val=>'vegetarian'       , 'name' => 'Vegetarische Küche'},
 {key=>'diet:vegetarian', val=>'yes'       , 'name' => 'vegetarisch'},

 {key=>'cuisine'     , val=>'falafel'          , 'name' => 'Falafel'},
 {key=>'cuisine'     , val=>'greek'            , 'name' => 'Griechische Küche'},
 {key=>'cuisine'     , val=>'spanish'          , 'name' => 'Spanische Küche'},
 {key=>'cuisine'     , val=>'vietnamese'       , 'name' => 'Spanische Küche'},
 {key=>'cuisine'     , val=>'international'    , 'name' => 'Internationale Küche'},
 {key=>'cuisine'     , val=>'sandwich'         , 'name' => 'Sandwiches'},
 {key=>'cuisine'     , val=>'pizza'            , 'name' => 'Pizza'},
 {key=>'cuisine'     , val=>'burger'           , 'name' => 'Hamburger'},
 {key=>'cuisine'     , val=>'oriental'         , 'name' => 'Orientalische Küche'},
 {key=>'cuisine'     , val=>'crepe'            , 'name' => 'Crêpes'},
 {key=>'cuisine'     , val=>'ice_cream'        , 'name' => 'Glacé'},
 {key=>'cuisine'     , val=>'steak_house'      , 'name' => 'Steak House'},
 {key=>'cuisine'     , val=>'kebab'            , 'name' => 'Kebab'},
 {key=>'cuisine'     , val=>'regional'         , 'name' => 'Regionale Küche'},
 {key=>'cuisine'     , val=>'chicken'          , 'name' => 'Poulets'},
 {key=>'cuisine'     , val=>'seasonal'         , 'name' => 'Saisonale Küche'},
 {key=>'cuisine'     , val=>'coffee_shop'      , 'name' => 'Kaffeehaus'},           # see also amenity:cafe
 {key=>'cuisine'     , val=>'korean'           , 'name' => 'Koreanische'},
 {key=>'cuisine'     , val=>'fish'             , 'name' => 'Fischspezialitäten'},
 {key=>'cuisine'     , val=>'mediterranean'    , 'name' => 'Mediterrane Küche'},
 {key=>'food'        , val=>'yes'              , 'name' => 'Essen Küche'},

 {key=>'craft'       , val=>'jeweller'         , 'name' => 'Juwelier'       },
 {key=>'craft'       , val=>'cheese_making'    , 'name' => 'Käseherstellung'}, # See also shop:dairy

 {key=>'shop'        , val=>'jewelry'          , 'name' => 'Juweliergeschäft'  },
 {key=>'shop'        , val=>'dairy'            , 'name' => 'Milchladen'  }, # See also  craft:cheese_making / shop:cheese
 {key=>'shop'        , val=>'cheese'           , 'name' => 'Käseladen'   }, # See also  craft:cheese_making / shop:dairy
 {key=>'shop'        , val=>'pastry'           , 'name' => 'Konditorei'  },
 {key=>'shop'        , val=>'art'              , 'name' => 'Kunstladen'  },
 {key=>'shop'        , val=>'kiosk'            , 'name' => 'Kiosk'  },
 {key=>'shop'        , val=>'bakery'           , 'name' => 'Bäckerei'  },
 {key=>'shop'        , val=>'convenience'      , 'name' => 'Laden'  },

 {key=>'second_hand' , val=>'yes'              , 'name' => 'Occasionen'  },

 {key=>'payment:bitcoin'  , val=>'yes'           , 'name' => 'Bitcoin-Bezahlung'   },# see also: payment:litecoin=yes
 {key=>'payment:litecoin' , val=>'yes'           , 'name' => 'Litecoin-Bezahlung'  },# see also: payment:bitcoin=yes
#

 {key=>'leisure'     , val=>'firepit'          , 'name' => 'Feuerstelle'  }, # See also fireplace:yes
 {key=>'fireplace'   , val=>'yes'              , 'name' => 'Feuerstelle'  }, # See also leisure:firepit
 {key=>'leisure'     , val=>'picnic_table'     , 'name' => 'Pick-Nick Tisch'  }, 
 {key=>'leisure'     , val=>'playground'       , 'name' => 'Kinderspielplatz'  }, 

 {key=>'natural'     , val=>'waterfall'        , 'name' => 'Wasserfall'   }, # See also waterway: waterfall
 {key=>'waterway'    , val=>'waterfall'        , 'name' => 'Wasserfall'   }, # See also natural: waterfall
 {key=>'natural'     , val=>'cave_entrance'    , 'name' => 'Höhlenzugang'   },

 {key=>'natural'     , val=>'peak'             , 'name' => 'Berggipfel'   },
 {key=>'summit:cross', val=>'yes'              , 'name' => 'Gipfelkreuz'   },

 {key=>'natural'     , val=>'rock'             , 'name' => 'Fels'                         }, # See also natural:stone
 {key=>'natural'     , val=>'stone'            , 'name' => 'Findling, Stein etc.'         }, # See also natural:rock
 {key=>'natural'     , val=>'spring'           , 'name' => 'Quelle'         },

 {key=>'tourism'     , val=>'hotel'            , 'name' => 'Hotel'  },
 {key=>'tourism'     , val=>'guest_house'      , 'name' => 'Gasthaus'  },
 {key=>'guest_house' , val=>'bed_and_breakfast', 'name' => 'Bed and Breakfast'  },
 {key=>'tourism'     , val=>'attraction'       , 'name' => 'Touristische Attraktion'  },
 {key=>'tourism'     , val=>'picnic_site'      , 'name' => 'Pick-Nick'  },
 {key=>'tourism'     , val=>'viewpoint'        , 'name' => 'Aussichtspunkt'  },

 {key=>'takeaway'    , val=>'yes'              , 'name' => 'Take-Away'  },

 {key=>'landuse'     , val=>'cemetery'         , 'name' => 'Friedhof'  }, # See also amenity: grave_yard
 {key=>'landuse'     , val=>'piste'            , 'name' => 'Piste'  },
 {key=>'piste:type'  , val=>'hike'             , 'name' => 'Wandern'  },
 {key=>'piste:type'  , val=>'skitour'          , 'name' => 'Skitour'  },

 {key=>'historic'    , val=>'building'         , 'name' => 'Historisches Gebäude'  },
 {key=>'historic'    , val=>'tomb'             , 'name' => 'Bekanntes Grab'        },    # See also tomb:tombstone

 {key=>'historic'    , val=>'memorial'         , 'name' => 'Denkmal'               },  # 2 Mal Denkmal
 {key=>'historic'    , val=>'monument'         , 'name' => 'Denkmal'               },

 {key=>'historic'    , val=>'archaeological_site', 'name' => 'Archäologisch interessant'               },
 {key=>'site_type'   , val=>'tumulus'            , 'name' => 'Hügelgrab'               },
 {key=>'site_type'   , val=>'megalith'           , 'name' => 'Megalith'                },
 {key=>'megalith_type', val=>'menhir'           , 'name' => 'Menhir'                },

 {key=>'atm'         , val=>'yes'              , 'name' => 'Geldautomat'},               # See also amenity:atm

 {key=>'tomb'        , val=>'tombstone'        , 'name' => 'Grabstein'},                 # See also historic:tomb
 {key=>'emergency'   , val=>'phone'            , 'name' => 'Notfalltelephon'},

);

my $dbh = osm_queries::open_db();

for my $key_val (@key_vals) {
  key_val($key_val->{key}, $key_val->{val}, $key_val->{name});
}

  key_val('shop', 'supermarket');
  key_val('shop', 'hairdresser');
  key_val('shop', 'clothes');
  key_val('shop', 'car_repair');
  key_val('shop', 'car');
  key_val('shop', 'bicycle');
  key_val('shop', 'florist');
  key_val('shop', 'butcher');
  key_val('shop', 'shoes');
  key_val('shop', 'sports');
# key_val('shop', 'jewelry');
  key_val('shop', 'farm');
  key_val('shop', 'optician');
  key_val('shop', 'furniture');
  key_val('shop', 'electronics');
  key_val('shop', 'beauty');
  key_val('shop', 'books');
  key_val('shop', 'travel_agency');
  key_val('shop', 'doityourself');
  key_val('shop', 'gift');
  key_val('shop', 'mall');
  key_val('shop', 'chemist');             # See also amenity=pharmacy
  key_val('shop', 'mobile_phone');
  key_val('shop', 'garden_centre');
  key_val('shop', 'alcohol');
  key_val('shop', 'boutique');
  key_val('shop', 'motorcycle');
  key_val('shop', 'department_store');
  key_val('shop', 'toys');
  key_val('shop', 'stationery');
  key_val('shop', 'interior_decoration');
  key_val('shop', 'computer');
  key_val('shop', 'hardware');
  key_val('shop', 'beverages');
  key_val('shop', 'second_hand');
  key_val('shop', 'hifi');
  key_val('shop', 'outdoor');
  key_val('shop', 'confectionery');
  key_val('shop', 'wine');            # see also craft=winery
  key_val('shop', 'dry_cleaning');
  key_val('shop', 'laundry');
  key_val('shop', 'pet');
  key_val('shop', 'fashion');
  key_val('shop', 'cosmetics');
  key_val('shop', 'no');              # Mostly gas stations
  key_val('shop', 'copyshop');
  key_val('shop', 'musical_instrument');
  key_val('shop', 'ticket');
  key_val('shop', 'photo');
  key_val('shop', 'hearing_aids');
  key_val('shop', 'deli');

 
# key_val('amenity' , 'cafe' );
# key_val('amenity' , 'doctor' );
# key_val('amenity' , 'fast_food' );
  key_val('amenity' , 'pharmacy' );     # See also shop=chemist
# key_val('takeaway', 'yes' );
# key_val('amenity', 'post_office' );
# key_val('amenity', 'vending_machine' );

  key_val('cuisine', 'italian');
 
  key_val('craft', 'brewery' );
# key_val('craft', 'jeweller' );
  key_val('drink:wine', 'yes' ); # nur 8 Einträge
  key_val('drink:beer', 'yes' ); # nur 3 Einträge
  key_val('drinking_water', 'yes'            );   # See also amenity=drinking_water / natural=spring
# key_val('amenity'       , 'drinking_water' );   # See also drinking_water=yes
  key_val('craft'         , 'winery' );           # see also shop=wine
# key_val('craft'         , 'cheese_making' );    # see also shop=diary
  key_val('craft'         , 'carpenter' );
  key_val('craft'         , 'electrician' );
  key_val('craft'         , 'shoemaker' );
  key_val('craft'         , 'brewery' );
  key_val('craft'         , 'metal_construction' );
  key_val('craft'         , 'gardener' );
  key_val('craft'         , 'painter' );
  key_val('craft'         , 'handicraft' );
  key_val('craft'         , 'photographer' );
  key_val('craft'         , 'beekeeper' );
  key_val('craft'         , 'plumber' );
# key_val('amenity'       , 'bar'    );
# key_val('vending'       , 'yes'    );
 
# key_val('natural'       , 'scree'    ); # Hangschutt - wohl nur interessant in Google Earth
# key_val('natural'       , 'glacier'  );                wohl nur interessant in Google Earth
  key_val('natural'       , 'beach'  );     # see also sport=swimming
# key_val('natural'       , 'ridge'  );  # google earth
# key_val('natural'       , 'ridge'  );   #    google earth?
# key_val('natural'       , 'heath'  );   #    google earth
# key_val('natural'       , 'valley'  );  #    google earth
# key_val('natural'       , 'crevasse'  ); #   google earth
# key_val('natural'       , 'sinkhole'  ); #   google earth
 
  key_val('amenity'       , 'toilets'  );
 
  key_val('man_made'      , 'pier'  );
# key_val('man_made'      , 'silo'  );         # google earth
  key_val('man_made'      , 'storage_tank'  );
# key_val('man_made'      , 'avalanche_protection'  ); # google earth
  key_val('man_made'      , 'tower'  );
  key_val('man_made'      , 'surveillance'  );  # Überwachungskameras?
  key_val('man_made'      , 'water_well'  );
  key_val('man_made'      , 'works'  );
  key_val('man_made'      , 'wastewater_plant'  );
  key_val('man_made'      , 'reservoir_covered'  );
  key_val('man_made'      , 'pipeline'  );
# key_val('man_made'      , 'snow_fence'  );     # google earth
  key_val('man_made'      , 'bridge'  );
  key_val('man_made'      , 'mast'  );
  key_val('man_made'      , 'survey_point'  );
  key_val('man_made'      , 'street_cabinet'  );
  key_val('man_made'      , 'breakwater'  );      # google earth
  key_val('man_made'      , 'flagpole'  );
# key_val('man_made'      , 'snow_cannon'  ); # google earth
  key_val('man_made'      , 'cross'  );
  key_val('man_made'      , 'water_works'  );
  key_val('man_made'      , 'chimney'  );
  key_val('man_made'      , 'antenna'  );
  key_val('man_made'      , 'monitoring_station'  );
  key_val('man_made'      , 'beacon'  );
  key_val('man_made'      , 'telescope'  );
# key_val('man_made'      , 'groyne'  );  # google earth
  key_val('man_made'      , 'lamp'  );
  key_val('man_made'      , 'yes'  );
  key_val('man_made'      , 'gasometer'  );
 
  key_val('fireplace'    , 'yes'  );
# key_val('food'         , 'yes'  );
 
  key_val('free_flying'         , 'takeoff'  );
  key_val('free_flying:paragliding'         , 'yes'  );
  key_val('sport'         , 'free_flying'  );
 
  key_val('sport'         , 'soccer'  );
  key_val('sport'         , 'tennis'  );
  key_val('sport'         , 'swimming'  );  # see also natural=beach
  key_val('sport'         , 'multi'  );
  key_val('sport'         , 'shooting'  ); # see also shooting=*
  key_val('sport'         , 'basketball'  );
  key_val('sport'         , 'exercise'  );
  key_val('sport'         , 'athletics'  );
  key_val('sport'         , 'equestrian'  );
  key_val('sport'         , 'table_tennis'  );
  key_val('sport'         , 'skiing'  );          # See also ski=yes
  key_val('sport'         , 'scuba_diving'  );
  key_val('sport'         , 'beachvolleyball'  );
  key_val('sport'         , 'climbing'         ); # See also: climbing:sport
  key_val('sport'         , 'golf'  );
  key_val('sport'         , 'gymnastics'  );
  key_val('sport'         , 'running'  );
  key_val('sport'         , 'skateboard'  );
  key_val('sport'         , 'volleyball'  );
  key_val('sport'         , 'boules'  );
  key_val('sport'         , 'hockey'  );
  key_val('sport'         , 'skating'  );
  key_val('sport'         , 'toboggan'  );
  key_val('sport'         , 'chess'  );
  key_val('sport'         , 'fitness'  );
  key_val('sport'         , 'football'  );
  key_val('sport'         , 'model_aerodrome'  );
  key_val('sport'         , 'hornussen'  );
  key_val('sport'         , 'handball'  );
  key_val('sport'         , 'canoe'  );
  key_val('sport'         , 'team_handball'  );
  key_val('sport'         , 'cycling'  );
  key_val('sport'         , 'baseball'  );
  key_val('sport'         , 'archery'  );
 
# key_val('tourism' , 'hotel');
# key_val('tourism' , 'attraction');
  key_val('tourism' , 'museum');
  key_val('tourism' , 'artwork');
  key_val('tourism' , 'alpine_hut');
# key_val('tourism' , 'guest_house');
  key_val('tourism' , 'camp_site');
  key_val('tourism' , 'chalet');
  key_val('tourism' , 'hostel');
  key_val('tourism' , 'zoo');
  key_val('tourism' , 'caravan_site');
  key_val('tourism' , 'wilderness_hut');
  key_val('tourism' , 'motel');
  key_val('tourism' , 'gallery');
  key_val('tourism' , 'theme_park');
# key_val('tourism' , 'information');  # Too large
 
  key_val('attraction' , 'animal');
  key_val('attraction' , 'summer_tobbogan');
  key_val('attraction' , 'summer_toboggan');
 
  key_val('amenity' , 'bbq');
  key_val('amenity' , 'shelter');
  
  key_val('historic' , 'wayside_cross');
  key_val('historic' , 'ruins');
  key_val('historic' , 'castle');
  key_val('historic' , 'memorial'); # see also memorial=*
  key_val('historic' , 'wayside_shrine');
  key_val('historic' , 'boundary_stone');
  key_val('historic' , 'yes');
# key_val('historic' , 'building');
  key_val('historic' , 'citywalls');
  key_val('historic' , 'church');
  key_val('historic' , 'tower');
  key_val('historic' , 'city_gate');
  key_val('historic' , 'monastery');
  key_val('historic' , 'battlefield');
 
  key_val('leisure'  , 'pitch');
  key_val('leisure'  , 'swimming_pool');
  key_val('leisure'  , 'garden');
  key_val('leisure'  , 'park');
  key_val('leisure'  , 'sports_centre');
  key_val('leisure'  , 'fitness_station');
  key_val('leisure'  , 'track');
  key_val('leisure'  , 'marina');
  key_val('leisure'  , 'nature_reserve');
  key_val('leisure'  , 'slipway');
  key_val('leisure'  , 'water_park');
  key_val('leisure'  , 'stadium');
  key_val('leisure'  , 'common');
  key_val('leisure'  , 'golf_course');
  key_val('leisure'  , 'miniature_golf');
  key_val('leisure'  , 'fitness_centre');
  key_val('leisure'  , 'horse_riding');
  key_val('leisure'  , 'recreation_ground');
  key_val('leisure'  , 'ice_rink');
  key_val('leisure'  , 'bird_hide');
  key_val('leisure'  , 'dog_park');
  key_val('leisure'  , 'table_tennis_table');
  key_val('leisure'  , 'beach_resort');
 
  key_val('artwork_type'  , 'statue');
  key_val('artwork_type'  , 'sculpture');
  key_val('artwork_type'  , 'mural');
 
  key_val('military'  , 'bunker');
  key_val('military'  , 'range');
  key_val('military'  , 'barracks');
  key_val('military'  , 'danger_area');

  key_val('microbrewery'  , 'yes');
 
# key_val('amenity'  , 'bank');
  key_val('amenity'  , 'public_building');
 
  key_val('storage'  , 'oil');
  key_val('site'     , 'geodesic');

  key_val('electric_car', 'yes');
  key_val('mooring', 'yes');
  key_val('surveillance:zone', 'traffic'); # see also man_made: surveillance
  key_val('surveillance:zone', 'town');
  key_val('surveillance:zone', 'building');
  key_val('surveillance:zone', 'parking');
  key_val('heritage'         , '*');
  key_val('embankment'       , 'yes');
  key_val('mountain_pass'    , 'yes');
  key_val('ski'  , 'yes'); 
  key_val('ski'  , 'cross-country');
  key_val('design'  , 'barrel');
  key_val('location'  , 'overground');
  key_val('location'  , 'underground');
  key_val('location'  , 'indoor');
  key_val('location'  , 'outdoor');
  key_val('location'  , 'lakeside');
  key_val('location'  , 'underwater');
# key_val('amenity', 'restaurant' );
  key_val('shelter_type', 'public_transport' );
  key_val('shelter_type', 'picnic_shelter' );
  key_val('shelter_type', 'wheather_shelter' );
  key_val('shelter_type', 'basic_hut' );
  key_val('shelter_type', 'rock_shelter' );

  key_val('funicular', 'yes' );
  key_val('motorboat', 'yes' );
  key_val('taxi', 'yes' );
  key_val('tourist_bus', 'yes' );
  key_val('route', 'shuttle_train' );
  key_val('toilets', 'yes' );

  key_val('ferry'  , 'yes'            ); # See also amenity=ferry_terminal
  key_val('amenity', 'ferry_terminal' ); # See also ferry=yes
  key_val('social_facility', 'group_home'      ); # See also amenity=social_facility
  key_val('social_facility', 'assisted_living' );
  key_val('social_facility', 'nursing_home'    );

  key_val('amenity', 'social_facility'    );


  key_val('emergency', 'ambulance_station'); # see also amenity=fire_station
  key_val('emergency', 'suction_point');
  key_val('emergency', 'fire_detection_system');
#?key_val('emergency', 'life_ring');
#?key_val('emergency', 'assembly_point');
#?key_val('emergency', 'key_depot');
# key_val('emergency', 'no');
  key_val('emergency', 'water_tank');
  key_val('emergency', 'siren');
  key_val('emergency', 'fire_water_pond');
  key_val('emergency', 'yes');
  key_val('emergency', 'defibrillator');
  key_val('emergency', 'fire_hydrant');

  key_val('office', 'architect');
  key_val('office', 'accountant'    );
  key_val('office', 'administrative');
  key_val('office', 'association'    );
  key_val('office', 'company');
  key_val('office', 'consulting'    );
  key_val('office', 'educational_institution');
  key_val('office', 'estate_agent');
  key_val('office', 'government');
  key_val('office', 'it');
  key_val('office', 'insurance');
  key_val('office', 'lawyer');
  key_val('office', 'newspaper'    );
  key_val('office', 'ngo');
  key_val('office', 'physician');
  key_val('office', 'research'    );
  key_val('office', 'therapist');
  key_val('office', 'travel_agent');
  key_val('office', 'yes');

  key_val('amenity', 'fire_station'    ); # see also emergency=ambulance_station
# key_val('amenity' , 'police'     );
  key_val('memorial', '*'     ); # see also historic=memorial
  key_val('hazard', 'shooting_range'     ); 

  key_val('ship', 'yes'     );  # Offenbar bezeichnet ship=yes eine Befahrbarkeit durch Schiffe an.
  key_val('island', 'yes'     ); 
  key_val('waste_basket', 'yes'     ); 
  key_val('healthcare:speciality', '*'     ); 
  key_val('healthcare', '*'     ); 
  key_val('plant', '*'     ); 

  key_val('landuse', 'garden');
  key_val('landuse', 'traffic_island');
  key_val('landuse', 'conservation');
  key_val('landuse', 'yes');
  key_val('landuse', 'greenfield');
  key_val('landuse', 'garages');
  key_val('landuse', 'brownfield');
  key_val('landuse', 'landfill');
  key_val('landuse', 'village_green');
  key_val('landuse', 'retail');
  key_val('landuse', 'recreation_ground');
  key_val('landuse', 'plant_nursery');
  key_val('landuse', 'military');
  key_val('landuse', 'greenhouse_horticulture');
  key_val('landuse', 'reservoir');
  key_val('landuse', 'railway');
  key_val('landuse', 'quarry');
  key_val('landuse', 'commercial');
  key_val('landuse', 'construction');
  key_val('landuse', 'basin');

  key_val('amenity', 'grave_yard'); # s.a . landuse = cemetery
  key_val('resource', '*');

  key_val('wpt_symbol', '*');
  key_val('demolished:building', '*');
  key_val('castle_type', '*');
  key_val('crop', '*');

  key_val('display', '*');
  key_val('thermometer', 'yes');
  key_val('lcn', 'yes');
  key_val('trailblazed', 'yes');
  key_val('shooting', '*'); # see also sport=shooting / amenity=hunting_stand / club:sport
# key_val('amenity', 'hunting_stand');
  key_val('club', 'sport'); # S.a sport=…
  key_val('club', 'Studentenverbindung');
  key_val('amenity', 'community_centre');
  key_val('amenity', 'dojo');
  key_val('substance', 'gas');
  key_val('substance', 'heat');
  key_val('substance', 'water');

# key_val('organic', 'yes');
  key_val('organic', 'only');
  key_val('organic', 'limited');

  key_val('drive_through', 'yes');
  key_val('amenity', 'atm'); # see also atm=yes
  key_val('amenity', 'post_box');

# key_val('atm', 'yes');



#
#      centralkey: eurokey
#
#       artist_name: foo ; bar ;baz
#       uic_name etc
#       key = resource
#       key = site_type
#       communication:mobile_phone=yes # Mobilfunkstation (BTS, Base Transceiver Station)

sub key_val { #_{

  my $key_ = shift;
  my $val_ = shift;
  my $name_opt = shift;

# return unless 
#  ($key_ eq 'shop'     and $val_ eq 'beauty') or
#  ($key_ eq 'guest_house' and $val_ eq 'bed_and_breakfast') or
#   1==0;

  print "$key_ $val_\n";

  # Was ist mapillary

 (my $key_html_page = $key_) =~ s/:/_/g;

  my $val_html_page;
  if ($val_ eq '*') {
     $val_html_page = '_any_';
  }
  else {
    ($val_html_page = $val_) =~ s/:/_/g;
  }

  my $html_name_without_html = "$key_html_page-$val_html_page";

  my $link_text = "$key_ = $val_";
  my $html_title = "Open Street Map key-val Paar $key_ = $val_";

  if ($name_opt) {
    $html_title = "Open Street Map Daten für: $name_opt (Schweiz)";
    $link_text = $name_opt;
  }
  print $html_index "<a href='$html_name_without_html.html'>$link_text</a><br>\n";



  my $html = osm_queries::start_html("key-val/$html_name_without_html", $html_title, "Abfrage für <code>$key_ = $val_</code> im Schweizer Open Street Map Dataset.");

  my $where_val ='';
  if ($val_ ne '*') {
     $where_val = " and tg.val = '$val_'";
  }
  
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
    postcode_city_ch pc on gt.key in ('addr:postcode', 'postcode', 'postal_code' ) and gt.val = pc.postcode
  where
  --tg.key = '$key_'    and tg.val = '$val_'
    tg.key = '$key_'    $where_val
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
      $last_id_ = $r->{id_ };
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

  my $name_used;
  print $html "<td><table>";



    if (defined $val->{name}) { #_{
      if (defined $val->{alt_name}) { #_{
        my $name     = $val->{name};
        my $alt_name = $val->{alt_name};
        if ($alt_name =~ /$name/i) {
          $name_used = $alt_name;
          print $html "<tr><td>" . osm_queries::html_escape($alt_name) . "</td></tr>";
#         print $html "<tr><td>1) alt_name: " . osm_queries::html_escape($alt_name) . "</td></tr>";
#         print $html "<tr><td>1) name: "     . osm_queries::html_escape($name    ) . "</td></tr>";
        }
        elsif ($name =~ /$alt_name/i) {
          $name_used = $name;
          print $html "<tr><td>" . osm_queries::html_escape($name) . "</td></tr>";
        }
        else {
          $name_used = $name;
          print $html "<tr><td>" . osm_queries::html_escape($alt_name) . "<br>" .
                                   osm_queries::html_escape($name)     . "</td></tr>";
#         print $html "<tr><td>2) alt_name: " . osm_queries::html_escape($alt_name) . "</td></tr>";
#         print $html "<tr><td>2) name:"     . osm_queries::html_escape($name    ) . "</td></tr>";
        }
#       print $html "<tr><td>" . osm_queries::html_escape($val->{name    }) . "</td></tr>" if defined $val->{name};
      } #_}
      else {
        $name_used = $val->{name};
        print $html "<tr><td>" . osm_queries::html_escape($val->{name    }) . "</td></tr>" if defined $val->{name};
      }
    } #_}
    if (defined $val->{'name_1'}) { #_{
      $name_used = $val->{name};
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

#   print $html "<tr><td>" . osm_queries::html_escape("name_used: $name_used") . "</td></tr>" if $name_used;


    if ($name_used) { #_{
      for my $name_XX (grep {$_ =~ /^name:/ } keys %$val) {
#     for my $name_XX (keys %$val) {
#       print "name_XX: $name_XX\n";
#
        if ($val->{$name_XX} ne $name_used) {
          print $html "<tr><td>$name_XX: " .osm_queries::html_escape($val->{$name_XX}) . "</td></tr>";
        }
        delete $val->{$name_XX};

      }
    } #_}

    if (my $description = delete $val->{description}) { #_{
        print $html "<tr><td><i>" . osm_queries::html_escape($description) . "</i></td></tr>";
    } #_}

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
  if ($floor = delete $val->{'floor'} or $floor = delete $val->{'addr:floor'} or $floor = delete $val->{level} or $floor = delete $val->{layer}) { #_{
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
  } #_}

  print $html "<tr><td>" . osm_queries::html_escape($val->{'phone'         }) . "</td></tr>" if defined $val->{'phone'         };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:phone' }) . "</td></tr>" if defined $val->{'contact:phone' };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:mobile' }) . "</td></tr>" if defined $val->{'contact:mobile' };
  print $html "<tr><td>" . osm_queries::html_escape($val->{'tel'           }) . "</td></tr>" if defined $val->{'tel' };
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
  print $html "<tr><td>" . osm_queries::html_website($val->{'web'             }) . "</td></tr>" if defined $val->{'web'}; 
  print $html "<tr><td>" . osm_queries::html_website($val->{'contact:facebook'}) . "</td></tr>" if defined $val->{'contact:facebook'};
  print $html "<tr><td>" . osm_queries::html_website(delete $val->{'website_1'}) . "</td></tr>" if defined $val->{'website_1'};
  print $html "<tr><td>" . osm_queries::html_website(delete $val->{'facebook' }) . "</td></tr>" if defined $val->{'facebook'};

  if (my $wikipedia = delete $val->{wikipedia}) {

    my $lang = substr($wikipedia, 0, 2);
    my $wiki = substr($wikipedia, 3);
    print $html "<tr><td><a href='https://$lang.wikipedia.org/wiki/" . $wiki . "'>wikipedia ($lang)</a>";


  }
  for my $wikipedia_XX (grep {$_ =~ /^wikipedia:..$/ } keys %$val) {

    my $lang = substr($wikipedia_XX, -2);
    print $html "<tr><td><a href='https://$lang.wikipedia.org/wiki/" . $val->{$wikipedia_XX} . "'>wikipedia ($lang)</a>";

    delete $val->{$wikipedia_XX};

  }

  print $html "<tr><td><a href='https://www.wikidata.org/wiki/" . (delete $val->{wikidata}) . "'>wikidata</a>" if defined $val->{wikidata};


# print $html "<tr><td>" . osm_queries::html_escape($val->{'website'       })                                                              . "</td></tr>" if defined $val->{'website'       };
# print $html "<tr><td>" . osm_queries::html_escape($val->{'contact:website'       })                                                              . "</td></tr>" if defined $val->{'contact:website'       };


  print $html "</table></td>";

  my $opening_hours = $val->{opening_hours} // '';

  if ($opening_hours) {
    $opening_hours = osm_queries::html_escape($opening_hours);
    $opening_hours =~ s/[;]/<br>/g;
    $opening_hours =~ s/\bTu\b/Di/g;
    $opening_hours =~ s/\bWe\b/Mi/g;
    $opening_hours =~ s/\bTh\b/Do/g;
    $opening_hours =~ s/\bSu\b/So/g;
    $opening_hours =~ s/\bPH\b/Feiertage/g;
    $opening_hours =~ s/\boff\b/geschlossen/g;
    $opening_hours =~ s/\bclosed\b/geschlossen/g;

  }
  print $html "<td>" . $opening_hours . "</td>";
 

  delete $val->{nod_id};
  delete $val->{way_id};
  delete $val->{rel_id};

  if ($val_ ne '*') {
    delete $val->{$key_};
  }
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
  delete $val->{'tel'};
  delete $val->{'fax'};
  delete $val->{'contact:fax'};
  delete $val->{'website'};
  delete $val->{'contact:website'};
  delete $val->{'contact:facebook'};
  delete $val->{'url'};
  delete $val->{'web'};
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

  if (my $image = delete $val->{image}) {

    if ($image =~ m!^https?://!) {
       print $html "<tr><td><a href='$image'>image</a></td></tr>";
    }
    else {
       print $html "<tr><td>image: $image</td></tr>";
    }

  }

  for my $key_val (@key_vals) {

    if (exists $val->{$key_val->{key}}) {
      if ($val->{$key_val->{key}} eq $key_val->{val}) {
         delete $val->{$key_val->{key}};
        (my $link = "$key_val->{key}-$key_val->{val}.html") =~ s/:/_/g;
         print $html "<tr><td><a href='$link'>$key_val->{name}</a></tr></td>";
      }
    }
  }

  print $html tr_td_if_key_val($val, 'fee'                     , 'yes'      , 'kostenpflichtig');
  print $html tr_td_if_key_val($val, 'fee'                     , 'no'       , 'kostenlos');

  print $html tr_td_if_key_val($val, 'access'                  , 'yes'       , 'öffentlich');
  print $html tr_td_if_key_val($val, 'access'                  , 'permissive', 'Zutritt geduldet');
  print $html tr_td_if_key_val($val, 'access'                  , 'private'   , 'nicht öffentlich');

  print $html tr_td_if_key_val($val, 'breakfast'               , 'yes'      , 'mit Frühstück');
# print $html tr_td_if_key_val($val, 'takeaway'                , 'yes'      , 'Take-Away');
  print $html tr_td_if_key_val($val, 'takeaway'                , 'no'       , 'kein Take-Away');
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

  if (my $collection_times = delete $val->{collection_times}) {
    print $html "<tr><td>Leerungszeit: " . osm_queries::html_escape($collection_times) . "</td></tr>";
  }

  print $html tr_td_if_key_val($val, 'tower:type'              , 'observation' , 'Aussichtsturm');
  print $html tr_td_if_key_val($val, 'tower:type'              , 'communication' , 'Kommunikationsturm');
  print $html tr_td_if_key_val($val, 'communication:mobile_phone', 'yes' , 'Mobilfunkstation (BTS, Base Transceiver Station)');
  print $html tr_td_if_key_val($val, 'tower:type'              , 'bell_tower' , 'Glockenturm');
  print $html tr_td_if_key_val($val, 'tower:type'              , 'lighting' , 'Beleuchtung/Flutlicht');
  print $html tr_td_if_key_val($val, 'fireplace'               , 'no' , 'keine Feuerstelle');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'horse_riding' , 'Pferdereitsport');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'fitness_station' , 'Fitnessstation');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'sports_centre' , 'Sportzentrum');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'golf_course' , 'Golfplatz');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'pitch' , 'Spielfeld');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'track' , '(Renn-)bahn');
  print $html tr_td_if_key_val($val, 'leisure'                 , 'stadium' , 'Stadium');

  print $html tr_td_if_key_val($val, 'beauty'                  , 'nails'    , 'Nägeldesign');

  print $html tr_td_if_key_val($val, 'sport'                   , 'chess'    , 'Schach');
  print $html tr_td_if_key_val($val, 'sport'                   , 'table_tennis', 'Tischtennis');
  print $html tr_td_if_key_val($val, 'sport'                   , 'swimming', 'Schimmen');
  print $html tr_td_if_key_val($val, 'sport'                   , 'soccer', 'Fussball');
  print $html tr_td_if_key_val($val, 'sport'                   , 'golf', 'Golf');
  print $html tr_td_if_key_val($val, 'sport'                   , 'gymnastics', 'Gymnastik');
  print $html tr_td_if_key_val($val, 'sport'                   , 'swiss_wrestling', 'Schwingen');
  print $html tr_td_if_key_val($val, 'sport'                   , 'tennis', 'Tennis');
  print $html tr_td_if_key_val($val, 'sport'                   , 'equestrian', 'Pferdesport');
  print $html tr_td_if_key_val($val, 'sport'                   , 'mtb', 'Mountain-Bike');
  print $html tr_td_if_key_val($val, 'sport'                   , 'cycling', 'Velosport');

  print $html tr_td_if_key_val($val, 'protected'               , 'yes'      , 'geschützt');

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
  print $html tr_td_if_key_val($val, 'payment:credit_cards'    , 'yes'      , 'akzeptiert Kreditkarten');
  print $html tr_td_if_key_val($val, 'payment:credit_cards'    , 'no'       , 'keine Kreditkarten');
  print $html tr_td_if_key_val($val, 'payment:cash'            , 'yes'      , 'Bargeldbezahlung');
  print $html tr_td_if_key_val($val, 'payment:coins'           , 'yes'      , 'Münzbezahlung');
  print $html tr_td_if_key_val($val, 'payment:notes'           , 'yes'      , 'Banknotenbezahlung');
  print $html tr_td_if_key_val($val, 'payment:maestro'         , 'yes'      , 'akzeptiert Maestro');
  print $html tr_td_if_key_val($val, 'payment:visa'            , 'yes'      , 'akzeptiert VISA');
  print $html tr_td_if_key_val($val, 'payment:mastercard'      , 'yes'      , 'akzeptiert Master Card');
  print $html tr_td_if_key_val($val, 'payment:american_express', 'yes'      , 'akzeptiert American Express');
  print $html tr_td_if_key_val($val, 'payment:diners_club'     , 'yes'      , 'akzeptiert Diner\' Club');
  print $html tr_td_if_key_val($val, 'atm'                     , 'no'       , 'kein ATM');

  print $html tr_td_if_key_val($val, 'amenity'            , 'cafe'         , 'Café');
  print $html tr_td_if_key_val($val, 'amenity'            , 'post_box'     , 'Briefeinwurf');
# print $html tr_td_if_key_val($val, 'amenity'            , 'pub'          , 'Pub');
  print $html tr_td_if_key_val($val, 'cafe'               , 'yes'          , 'Café');
# print $html tr_td_if_key_val($val, 'amenity'            , 'restaurant'   , 'Restaurant');
# print $html tr_td_if_key_val($val, 'amenity'            , 'fast_food'    , 'Fast-Food');
  print $html tr_td_if_key_val($val, 'restaurant'         , 'yes'          , 'Restaurant');
# print $html tr_td_if_key_val($val, 'shop'               , 'pastry'       , 'Konditorei');


  print $html tr_td_if_key_val($val, 'internet_access'    , 'yes'          , 'Internetzugang');
  print $html tr_td_if_key_val($val, 'internet_access'    , 'no'           , 'kein Internetzugang');
  print $html tr_td_if_key_val($val, 'internet_access'    , 'wlan'         , 'WLAN');
  print $html tr_td_if_key_val($val, 'wlan'               , 'free'         , 'gratis WLAN');
  print $html tr_td_if_key_val($val, 'internet_access:fee', 'no'           , 'gratis Internet');
  print $html tr_td_if_key_val($val, 'internet_access:fee', 'yes'          , 'kostenpflichtiges Internet');
  print $html tr_td_if_key_val($val, 'wifi'               , 'no'           , 'kein WIFI');

  print $html tr_td_if_key_val($val, 'self_service'       , 'yes'          , 'Selbstbedienung');
  print $html tr_td_if_key_val($val, 'amenity'            , 'vending_machine', 'Verkaufsautomat'); # od. Warenautomat?

  print $html tr_td_if_key_val($val, 'amenity'            , 'shelter', 'Unterstand/Schutz');
  print $html tr_td_if_key_val($val, 'shelter'            , 'yes', 'Unterstand/Schutz');
  print $html tr_td_if_key_val($val, 'covered'            , 'no', 'nicht überdeckt');
  print $html tr_td_if_key_val($val, 'covered'            , 'yes', 'überdeckt');


  print $html tr_td_if_key_val($val, 'service:bicycle:repair'    , 'yes'                   , 'Veloreperatur');
  print $html tr_td_if_key_val($val, 'amenity'                   , 'bicycle_repair_station', 'Veloreperatur');
  print $html tr_td_if_key_val($val, 'service:bicycle:retail'    , 'yes'         , 'Veloverkauf');
  print $html tr_td_if_key_val($val, 'service:bicycle:sales'     , 'yes'         , 'Veloverkauf');
  print $html tr_td_if_key_val($val, 'service:bicycle:pump'      , 'yes'         , 'Velos pumpen');
  print $html tr_td_if_key_val($val, 'service:bicycle:rental'    , 'yes'         , 'Velos mieten');
  print $html tr_td_if_key_val($val, 'amenity'                   , 'bicycle_rental', 'Velos mieten');
  print $html tr_td_if_key_val($val, 'service:bicycle:sportswear', 'yes'         , 'Velosport-Bekleidung');
  print $html tr_td_if_key_val($val, 'service:bicycle:cleaning'  , 'yes'         , 'Velos reinigen');
  print $html tr_td_if_key_val($val, 'service:bicycle:parts'     , 'yes'         , 'Velo-Ersatzteile');
  print $html tr_td_if_key_val($val, 'service:bicycle:dealer'    , 'yes'         , 'Velohändler');
  print $html tr_td_if_key_val($val, 'service:bicycle:diy'       , 'yes'         , 'Velo do-it-yourself');
  print $html tr_td_if_key_val($val, 'service:bicycle:second_hand', 'yes'         , 'Occasionsvelos');
  print $html tr_td_if_key_val($val, 'bicycle:clothes'            , 'yes'         , 'Velobekleidung');
  print $html tr_td_if_key_val($val, 'vending'                    , 'bicycle_tube', 'Veloschlauch-Verkauf');

  print $html tr_td_if_key_val($val, 'motorcycle:sales'           , 'yes'         , 'Töffverkauf'     );
  print $html tr_td_if_key_val($val, 'motorcycle:parts'           , 'yes'         , 'Toff-Ersatzteile');
  print $html tr_td_if_key_val($val, 'motorcycle:repair'          , 'yes'         , 'Toffreparatur'   );
  print $html tr_td_if_key_val($val, 'motorcycle:clothes'         , 'yes'         , 'Töffbekleidung'  );
  print $html tr_td_if_key_val($val, 'motorcycle:rental'          , 'yes'         , 'Töffvermietung'  );


  print $html tr_td_if_key_val($val, 'amenity'                    , 'solarium'    , 'Solarium');


  print $html tr_td_if_key_val($val, 'amenity'                    , 'toilets'    , 'Toilette');
  print $html tr_td_if_key_val($val, 'amenity'                    , 'water'      , 'Wasser');

  print $html tr_td_if_key_val($val, 'drive_through'      , 'no'           , 'kein Drive-Through');

  print $html tr_td_if_key_val($val, 'craft'              , 'key_cutter'   , 'Schlüsselservice');

  print $html tr_td_if_key_val($val, 'amenity'              , 'parking'    , 'Parkplatz');

  print $html tr_td_if_key_val($val, 'indoor'               , 'yes'    , 'in einem Gebäude');

# print $html tr_td_if_key_val($val, 'amenity'  , 'bank', 'Bank');

  print $html tr_td_if_key_val($val, 'surface'              , 'pebblestone', 'Kiesplatz');
  print $html tr_td_if_key_val($val, 'surface'              , 'asphalt', 'Asphaltplatz');
  print $html tr_td_if_key_val($val, 'surface'              , 'tartan', 'Tartan- od. Kunststoffbelag');

# print $html tr_td_if_key_val($val, 'tourism'              , 'hotel'  , 'Hotel');
  print $html tr_td_if_key_val($val, 'tourism'              , 'alpine_hut'  , 'Alphütte');
# print $html tr_td_if_key_val($val, 'tourism'              , 'attraction'  , 'touristische Attraktion');
  print $html tr_td_if_key_val($val, 'tourism'              , 'museum'  , 'Museum');
  print $html tr_td_if_key_val($val, 'historic'             , 'ruins', 'historische Ruinen');
  print $html tr_td_if_key_val($val, 'ruins'                , 'yes', 'Ruinen');


  print $html tr_td_if_key_val($val, 'drinkable'            , 'no', 'kein Trinkwasser');
  print $html tr_td_if_key_val($val, 'drinking_water'       , 'no', 'kein Trinkwasser');
  print $html tr_td_if_key_val($val, 'social_facility:for'  , 'senior', 'Altersheim');
  print $html tr_td_if_key_val($val, 'location'  , 'underground', 'unterirdisch');
  print $html tr_td_if_key_val($val, 'location'  , 'overground', 'überirdisch');
  print $html tr_td_if_key_val($val, 'man_made'  , 'pipeline', 'Pipeline');
  print $html tr_td_if_key_val($val, 'man_made'  , 'pumping_station', 'Pumpwerk');


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


  if (exists $val->{ele}) { #_{
    printf $html "<tr><td>%d M.ü.M</td></tr>", int(delete $val->{ele});
  } #_}
  if (my $voltage = delete $val->{voltage}) { #_{
    print $html "<tr><td>$voltage Volt</td></tr>";
  } #_}


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
