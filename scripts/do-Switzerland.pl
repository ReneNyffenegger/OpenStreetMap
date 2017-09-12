#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use Geo::OSM::DBI::CH;
use Geo::OSM::Render::Projection::CH_LV03;
use Geo::OSM::Render::Renderer::SVG;
use Geo::OSM::Render::Viewport::Clipped;

use File::Compare;


my $dbh = DBI->connect("dbi:SQLite:dbname=../db/ch.db", '', '', {sqlite_unicode=>1}) or die "does not exist";
$dbh->{AutoCommit} = 0;

my $osm_db = Geo::OSM::DBI::CH->new($dbh);


# municipalities();
# municipalities_area_tables();
tests();

sub municipalities { #_{
  $osm_db->create_table_municipalities_ch();
# $dbh->commit;

  my %municipalities = $osm_db->municipalities_ch;

  open (my $gotten, '>:utf8', 'gotten/municipalities_ch') or die;
  for my $rel_id (sort { ( $municipalities{$a}{name  } cmp $municipalities{$b}{name  } ) or
                         ( $municipalities{$a}{bfs_no} <=> $municipalities{$b}{bfs_no} )
                       } keys %municipalities )
  {
    printf $gotten "%11d %-35s %4d %11.9f %11.9f %11.9f %11.9f\n",
      $rel_id,
      $municipalities{$rel_id}{name},
      $municipalities{$rel_id}{bfs_no},
      $municipalities{$rel_id}{lat_min},
      $municipalities{$rel_id}{lat_max},
      $municipalities{$rel_id}{lon_min},
      $municipalities{$rel_id}{lon_max};

  }
  close $gotten;

  if (compare("expected/municipalities_ch", "gotten/municipalities_ch")) {
    print "! municipalities_ch differs !\n";
  }


} #_}
sub municipalities_area_tables { #_{

  my %municipalities = $osm_db->municipalities_ch;

  for my $rel_id (keys %municipalities) {

    if ($municipalities{$rel_id}{name} eq 'Pfungen') {
      print "Pfungen found: $rel_id\n";

      my $name = $municipalities{$rel_id}{name};
      $name =~ s/[(). ]/-/g;

      $name = "${name}_$municipalities{$rel_id}{bfs_no}_$rel_id";

      print $name, "\n";

      $dbh->{AutoCommit} = 1; # Why is this necessary?
#     my $dbh = DBI->connect("dbi:SQLite:dbname=$db_test") or die "Could not create $db_test";

      my $db_name = "../db/area/$name.db";
      unlink $db_name if -f $db_name;
      $dbh->do("attach database '$db_name' as area");
      $dbh->{AutoCommit} = 0; # Why is this necessary?

      $osm_db->create_area_tables({schema_name_to=>'area', municipality_rel_id=>$rel_id});

      $dbh->commit;
      $dbh->{AutoCommit} = 1; # Why is this necessary?
      $dbh->do("detach database area");
      $dbh->{AutoCommit} = 0; # Why is this necessary?

    }

  }

} #_}

sub tests {

  my @rel_ids_de = $osm_db->rel_ids_ISO_3166_1('DE');
  if (@rel_ids_de == 3) {
    print "rel_ids_de[0] = $rel_ids_de[0]\n" unless $rel_ids_de[0] == 51477;
    print "rel_ids_de[1] = $rel_ids_de[1]\n" unless $rel_ids_de[1] == 62781;
    print "rel_ids_de[2] = $rel_ids_de[2]\n" unless $rel_ids_de[2] == 1111111;

  }
  else {
    print "3 rel_ids de expected\n";
  }

  my @rels_de = $osm_db->rels_ISO_3166_1('DE');

  if (@rels_de == 3) { #_{

     my @rel_ids_de_sorted = sort {$a->{id} <=> $b->{id}} @rels_de;
     printf "first rel_id_de should be 51477 but is %d\n", $rel_ids_de_sorted[0]->{id}   unless $rel_ids_de_sorted[0]->{id} == 51477;
     printf "first rel_id_de should be 62781 but is %d\n", $rel_ids_de_sorted[1]->{id}   unless $rel_ids_de_sorted[1]->{id} == 62781;
     printf "first rel_id_de should be 1111111 but is %d\n", $rel_ids_de_sorted[2]->{id}   unless $rel_ids_de_sorted[2]->{id} == 1111111;

  } #_}
  else { #_{
    print "3 rels_de expected\n";
  } #_}

  my $rel_ch = $osm_db->rel_ch;
  printf "rel_ch should be 51701 but is %d\n" unless $rel_ch->{id} == 51701;

  my $name_ch = $rel_ch->name;
  printf "Name of rel_ch is $name_ch\n" unless $name_ch eq 'Schweiz/Suisse/Svizzera/Svizra';

  my $name_ch_de = $rel_ch->name_in_lang('de');
  printf "Name of rel_id_ch_de is $name_ch_de\n" unless $name_ch_de eq 'Schweiz';

  my $name_ch_fr = $rel_ch->name_in_lang('fr');
  printf "Name of rel_id_ch_fr is $name_ch_fr\n" unless $name_ch_fr eq 'Suisse';

  my $name_ch_it = $rel_ch->name_in_lang('it');
  printf "Name of rel_id_ch_it is $name_ch_it\n" unless $name_ch_it eq 'Svizzera';

  my $name_ch_rm = $rel_ch->name_in_lang('rm');
  printf "Name of rel_id_ch_rm is $name_ch_rm\n" unless $name_ch_rm eq 'Svizra';

# my $rel_ch = $osm_db->rel_ch();

  print "rel_ch->id != 51701\n" unless $rel_ch->{id} == 51701;

  print "$rel_ch is not a Geo::OSM::DBI::Primitive::Relation\n" unless $rel_ch -> isa('Geo::OSM::DBI::Primitive::Relation');
  print "$rel_ch is not a Geo::OSM::DBI::Primitive          \n" unless $rel_ch -> isa('Geo::OSM::DBI::Primitive'          );
  print "$rel_ch is not a Geo::OSM::Primitive::Relation     \n" unless $rel_ch -> isa('Geo::OSM::Primitive::Relation'     );
  print "$rel_ch is not a Geo::OSM::Primitive               \n" unless $rel_ch -> isa('Geo::OSM::Primitive'               );

  members_ch($rel_ch);
  border_ch ($rel_ch);
 
}
sub members_ch {

  my $rel_ch = shift;

  open (my $gotten, '>:utf8', 'gotten/members_ch') or die;
  for my $member_ch ($rel_ch->members()) {
    printf $gotten "%11d %3s %-60s %-10s\n", $member_ch->{id}, $member_ch->primitive_type, $member_ch->name // '-', $member_ch->role($rel_ch);

#   if ($member_ch->primitive_type eq 'way') {
#     my @nodes = $member_ch->nodes;
#     for my $node (@nodes) {
#       printf("%12.9f %12.9f\n", $node->lat, $node->lon);
#     }
#   }

  }
  close $gotten;

  if (compare("expected/members_ch", "gotten/members_ch")) {
    print "! members_ch differs !\n";
  }

}
sub border_ch {

  my $rel_ch = shift;

  my $projection     = Geo::OSM::Render::Projection::CH_LV03->new();

  my $viewport       = Geo::OSM::Render::Viewport::Clipped  ->new(
     x_of_map_0       =>  483_000,
     x_of_map_width   =>  834_000,
     y_of_map_0       =>  299_000,
     y_of_map_height  =>   74_000,
     max_width_height => 1000
  );

  my $renderer = Geo::OSM::Render::Renderer::SVG->new (
     'border_ch.svg',
     $projection,
     $viewport
  );

  for my $member_ch ($rel_ch->members()) {

    if ($member_ch->primitive_type eq 'way') {
      my @nodes = $member_ch->nodes;

      my ($lat_start, $lon_start, $lat_end, $lon_end) = $member_ch -> start_end_coordinates();

      $renderer->line($lat_start, $lon_start, $lat_end, $lon_end,
        styles=>{
          'stroke-width' => '1',
          'stroke'       => 'blue',
        }
      );


    }
  }

  $renderer->end();

}
