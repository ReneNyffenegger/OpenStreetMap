package osm_queries;

sub start_kml { #_{

  my $filename_no_suffix = shift;
  my $title              = shift;

  open (my $kml, '>:utf8', "../../web/$filename_no_suffix.kml") or die "$filename_no_suffix - $!";

  print $kml qq{<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
<name>$title</name>

	<Style id="blue-pin"      ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/blue-pushpin.png  </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="blue-light-pin"><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/ltblu-pushpin.png </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="green-pin"     ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/grn-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="pink-pin"      ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/pink-pushpin.png  </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="purple-pin"    ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/purple-pushpin.png</href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="red-pin"       ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/red-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="white-pin"     ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/wht-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 
	<Style id="yellow-pin"    ><IconStyle><scale>1.1</scale><Icon><href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png   </href></Icon><hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/></IconStyle><ListStyle></ListStyle></Style> 

<!--

	<Style id="alphuette">
		<IconStyle><Icon></Icon>
		</IconStyle>
		<LabelStyle>
			<color>ffc341ff</color>
		</LabelStyle>
		<ListStyle>
		</ListStyle>
		<LineStyle>
			<color>ffc341ff</color>
			<width>3</width>
		</LineStyle>
	</Style>

	<Style id="alphuette_normal">
		<IconStyle>
			<Icon>
			</Icon>
		</IconStyle>
		<LabelStyle>
			<color>ffc341ff</color>
		</LabelStyle>
		<ListStyle>
		</ListStyle>
		<LineStyle>
			<color>ffc341ff</color>
			<width>3</width>
		</LineStyle>
	</Style>

	<Style id="alphuette_highlight">
		<IconStyle>
			<Icon>
			</Icon>
		</IconStyle>
		<LabelStyle>
			<color>ff00aaff</color>
		</LabelStyle>
		<ListStyle>
		</ListStyle>
		<LineStyle>
			<color>ff0000ff</color>
			<width>3</width>
		</LineStyle>
	</Style>

	<StyleMap id="alphuette">
		<Pair><key>normal</key>   <styleUrl>#alphuette_normal</styleUrl>   </Pair>
		<Pair><key>highlight</key><styleUrl>#alphuette_highlight</styleUrl></Pair>
	</StyleMap>
  -->

};

  return $kml;

} #_}
sub end_kml { #_{
  my $kml = shift;

  print $kml "</Document>
</kml>";
  close $kml;
} #_}

1;