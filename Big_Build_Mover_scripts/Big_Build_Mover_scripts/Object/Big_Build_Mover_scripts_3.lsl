// :CATEGORY:Building
// :NAME:Big_Build_Mover_scripts
// :AUTHOR:Poppet McGimsie
// :CREATED:2010-11-18 20:51:48.930
// :EDITED:2013-09-18 15:38:48
// :ID:89
// :NUM:123
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// OSgrid side importer scripts (two scripts)// // Script 1:
// :CODE:

//BIG BUILD IMPORTER BASE script

//based on Builder's Buddy from http://www.lslwiki.com/lslwiki/wakka.ph ... ldersBuddy

//Free to use and must remain so.

//Place this script in the rez box with the components (after adding component script to them) to assemble the imported build.
//leftclick rez box and select BUILD to assemble the components
//to move the build, leftclick rez box and select CLEAN then move the rez box and re-rezz the build.
//when you are done, leftclick rez box and pick DONE to remove the compoenent scripts from the components.


integer PRIMCHAN = 111;

string optBuild = "Build";
string optClean = "Clean";
string optDone = "Done";
string descBuild = " : Spawn inv. items and position them\n";
string descClean = " : De-Rez all pieces\n";
string descDone = " : Remove all BB scripts and make the parts permanent.\n";
string title = "";

list optionlist;


default {

state_entry()
{
llListen(112,"","","");
optionlist = [optBuild, optClean, optDone];

title += optBuild + descBuild;

title += optClean + descClean;
title += optDone + descDone;
}

touch_start (integer total_number) {







llDialog(llDetectedKey(0), title, optionlist, 112);



}


listen(integer channel, string name, key id, string message) {


if ( message == optBuild ) {
vector vThisPos = llGetPos();
rotation rThisRot = llGetRot();
integer i;
integer iCount = llGetInventoryNumber(INVENTORY_OBJECT);

//Loop through backwards (safety precaution in case of inventory change)
llOwnerSay("Rezzing build pieces...");
for( i = iCount - 1; i >= 0; i-- )
{
llRezObject(llGetInventoryName(INVENTORY_OBJECT, i), vThisPos, ZERO_VECTOR, rThisRot, PRIMCHAN);

}

llSay(0,"Still building -- please wait 20 sec until I say I'm done....");
llSleep(20);
llSay(0,"Positioning");
llShout(PRIMCHAN, "MOVE");
llSay(0,"Done!");

}


if ( message == optClean ) {
llShout(PRIMCHAN, "CLEAN");
return;
}
if ( message == optDone ) {
llShout(PRIMCHAN, "DONE");
//llDie();
llOwnerSay("Removing mover scripts.");
return;
}
}



on_rez(integer iStart)
{
PRIMCHAN = iStart;
llShout(PRIMCHAN, "CLEAN");
//Reset ourselves
//llResetScript();
}
}
