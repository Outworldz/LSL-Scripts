// :CATEGORY:Presentations
// :NAME:SimPerformanceCollector_Web_and_RRD
// :AUTHOR:denise
// :CREATED:2011-03-08 01:38:19.877
// :EDITED:2013-09-18 15:39:02
// :ID:756
// :NUM:1043
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And last but not least, we have to build the graph from the data. it's a bash-script (Linux) which create the graphs.
// :CODE:
#!/bin/bash
#
RRDFILE=/home/n/ndlsim.de/php/cms/php/yoursimnamehere_dilfps.rrd
RRDPING=/home/n/ndlsim.de/php/cms/php/yoursimnamehere_ping.rrd

GRAPHFILE1=/home/n/ndlsim.de/php/cms/bilder/yoursimname_DIL.png
GRAPHFILE2=/home/n/ndlsim.de/php/cms/bilder/yoursimname_FPS.png
GRAPHFILE3=/home/n/ndlsim.de/php/cms/bilder/yoursimname_ping.png

rrdtool graph $GRAPHFILE1 -v "Dilation" \
  -u 1.1 -l 0 \
  -t "Dilation Time for yoursim" \
  DEF:dil=$RRDFILE:dil:AVERAGE LINE2:dil#309030:"Dilation Time" \
  HRULE:1.0#AAAA00:"Performace best / Performance sehr gut" \
  HRULE:0.8#0000FF:"Performace ok / Performance gut" \
  HRULE:0.5#FF0000:"Lagging expected / Lag zu erwarten" \
  COMMENT:"\\n" \
  COMMENT:"(Last updated\: $(/bin/date "+%d.%m.%Y %H\:%M\:%S"))\r" \
  -w 600 -h 200 -a PNG

rrdtool graph $GRAPHFILE2 -v "FPS" \
  -u 50.0 -l 0 \
  -t "Frames Per Second for yoursim" \
  DEF:fps=$RRDFILE:fps:AVERAGE LINE2:fps#309030:"Frames Per Second" \
  HRULE:44#AAAA00:"Performace best / Performance sehr gut" \
  HRULE:35#0000FF:"Performance ok /Performance gut" \
  HRULE:20#FF0000:"Lagging / Lag" \
  HRULE:10#FF0000:"Terrible / Katastrophal" \
  COMMENT:"\\n" \
  COMMENT:"(Last updated\: $(/bin/date "+%d.%m.%Y %H\:%M\:%S"))\r" \
  -w 600 -h 200 -a PNG

rrdtool graph $GRAPHFILE3 -v "PING-Time" \
  -u 200.0 -l 60 \
  -t "PING-Time for yoursim" \
  DEF:ping=$RRDPING:ping:AVERAGE LINE2:ping#309030:"PING in ms" \
  HRULE:90#AAAA00:"Performace best / Performance sehr gut" \
  HRULE:140#0000FF:"Performance ok /Performance gut" \
  HRULE:190#FF0000:"Lagging / Lag" \
  COMMENT:"\\n" \
  COMMENT:"(Last updated\: $(/bin/date "+%d.%m.%Y %H\:%M\:%S"))\r" \
  -w 600 -h 200 -a PNG


