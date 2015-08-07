// :CATEGORY:Building
// :NAME:Big_Build_Mover_scripts
// :AUTHOR:Poppet McGimsie
// :CREATED:2010-11-18 20:51:48.930
// :EDITED:2013-09-18 15:38:48
// :ID:89
// :NUM:122
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Second script:
// :CODE:
//BIG BUILD EXPORTER COMPONENT script
//This script is made available for free use, and it must remain that way. Poppet McGimsie, November 2008.

//for SL side: Place this script in the root prim of each component of a build, to ready it for export from SL using a utility like Second Inventory.

integer PRIMCHAN = 111;


default
{

state_entry()
{


llListen(PRIMCHAN, "", NULL_KEY, "");
}



listen(integer iChan, string sName, key kID, string sText)
{

list lParams = llParseString2List(sText, [ "|" ], []);
vector vBase = (vector)llList2String(lParams, 0);
rotation rBase = (rotation)llList2String(lParams, 1);

vector vOffset = (llGetPos() - vBase) / rBase;
llSay(0,(string)vOffset);
rotation rRotation = llGetRot() / rBase;
llSay(0,(string)rRotation);


llSetObjectName( (string) vOffset);
llSetObjectDesc ( (string) rRotation);


}


}
