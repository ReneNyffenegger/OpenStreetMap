#!/usr/bin/perl
use warnings;
use strict;

use DBI;
use Geo::OSM::DBI::CH;
use File::Compare;

my $dbh = DBI->connect("dbi:SQLite:dbname=../db/ch.db", '', '', {sqlite_unicode=>1}) or die "does not exist";
$dbh->{AutoCommit} = 0;

my $osm_db = Geo::OSM::DBI::CH->new($dbh);


tests();
# municipalities();
# municipalities_area_tables();

sub municipalities { #_{
  $osm_db->create_table_municipalities_ch();
  $dbh->commit;

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

  if (@rel_ids_de == 3) { #_{

     my @rel_ids_de_sorted = sort {$a->{id} <=> $b->{id}} @rel_ids_de;
     printf "first rel_id_de should be 51477 but is %d\n", $rel_ids_de_sorted[0]->{id}   unless $rel_ids_de_sorted[0]->{id} == 51477;
     printf "first rel_id_de should be 62781 but is %d\n", $rel_ids_de_sorted[1]->{id}   unless $rel_ids_de_sorted[1]->{id} == 62781;
     printf "first rel_id_de should be 1111111 but is %d\n", $rel_ids_de_sorted[2]->{id}   unless $rel_ids_de_sorted[2]->{id} == 1111111;

  } #_}
  else { #_{
    print "3 rel_ids_de expected\n";
  } #_}

  my $rel_id_ch = $osm_db->rel_id_ch;
  printf "rel_id_ch should be 51701 but is %d\n" unless $rel_id_ch->{id} == 51701;

  my $name_ch = $rel_id_ch->name;
  printf "Name of rel_id_ch is $name_ch\n" unless $name_ch eq 'Schweiz/Suisse/Svizzera/Svizra';

  my $name_ch_de = $rel_id_ch->name_in_lang('de');
  printf "Name of rel_id_ch_de is $name_ch_de\n" unless $name_ch_de eq 'Schweiz';

  my $name_ch_fr = $rel_id_ch->name_in_lang('fr');
  printf "Name of rel_id_ch_fr is $name_ch_fr\n" unless $name_ch_fr eq 'Suisse';

  my $name_ch_it = $rel_id_ch->name_in_lang('it');
  printf "Name of rel_id_ch_it is $name_ch_it\n" unless $name_ch_it eq 'Svizzera';

  my $name_ch_rm = $rel_id_ch->name_in_lang('rm');
  printf "Name of rel_id_ch_rm is $name_ch_rm\n" unless $name_ch_rm eq 'Svizra';
 
}
