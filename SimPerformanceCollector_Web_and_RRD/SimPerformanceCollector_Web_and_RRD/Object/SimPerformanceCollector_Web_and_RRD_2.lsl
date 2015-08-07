// :CATEGORY:Presentations
// :NAME:SimPerformanceCollector_Web_and_RRD
// :AUTHOR:denise
// :CREATED:2011-03-08 01:38:19.877
// :EDITED:2013-09-18 15:39:02
// :ID:756
// :NUM:1041
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
On your server lets create the rrd's (Round Robin Databases) --> http://www.mrtg.org/rrdtool/// Here are the commands to create a rrd. Let me first say, that I have very less knowledge on rrd's what I have created is an overview for a day. if somebody is able to make it much much better, PLEASE let me know! // IMPORTANT: The synonym "nameofyoursim" has to be replaced exactly with the simname! The php-script get's the simname and adds only a "_dilfps.rrd" so watch 
// :CODE:
/usr/bin/rrdtool create nameofyoursim_dilfps.rrd --step 600 DS:dil:GAUGE:600:0:1 DS:fps:GAUGE:600:0:50 \
 RRA:AVERAGE:0.5:1:5040 RRA:AVERAGE:0.5:12:9600

The ping-database will be created with:

/usr/bin/rrdtool create NDL_FeEseGrimLa_ping.rrd --step 300 DS:ping:GAUGE:300:0:1 RRA:AVERAGE:0.5:1:5040 RRA:AVERAGE:0.5:12:9600
