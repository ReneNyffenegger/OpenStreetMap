#!/usr/bin/python3
import urllib.request   
import time

t_0 = time.time()
urllib.request.urlretrieve  ('http://download.geofabrik.de/europe/liechtenstein-latest.osm.pbf'  , '../pbf/li.pbf'  )
print("Download took {:d} seconds".format(int(time.time() - t_0)))
