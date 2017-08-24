#!/usr/bin/python
#import urllib
import urllib.request # python 3
import time

t_0 = time.time()
urllib.request.urlretrieve  ('http://download.geofabrik.de/europe/switzerland-latest.osm.pbf'  , '../pbf/ch.pbf'  )
print("Download took {:d} seconds".format(int(time.time() - t_0)))
