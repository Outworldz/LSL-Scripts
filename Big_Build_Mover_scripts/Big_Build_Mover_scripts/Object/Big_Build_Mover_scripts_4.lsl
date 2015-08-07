// :CATEGORY:Building
// :NAME:Big_Build_Mover_scripts
// :AUTHOR:Poppet McGimsie
// :CREATED:2010-11-18 20:51:48.930
// :EDITED:2013-09-18 15:38:48
// :ID:89
// :NUM:124
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Script 2:
// :CODE:

//BIG BUILD IMPORTER COMPONENT script
//based on Builders' Buddy from http://www.lslwiki.com/lslwiki/wakka.ph ... ldersBuddy
//very very stripped down from the original

//this script is free to use and must remain so


integer PRIMCHAN = 111;



vector vOffset;
rotation rRotation;

key owner;
key controller;

vector vBase;
rotation rBase;




default
{
//////////////////////////////////////////////////////////////////////////////////////////
state_entry()
{


llListen(PRIMCHAN, "", NULL_KEY, "");
}

//////////////////////////////////////////////////////////////////////////////////////////
on_rez(integer iStart)
{



vBase = llGetPos();
rBase = llGetRot();



}

//////////////////////////////////////////////////////////////////////////////////////////
listen(integer iChan, string sName, key kID, string sCmd)
{




//////////////////////////////////////////////////////////////////////////////////////////
if( sCmd == "MOVE" )
{



list posl = llParseString2List(llGetObjectName(), [], []);
list rotl = llParseString2List(llGetObjectDesc(), [], []);
llSay(0,(string)posl);
llSay(0,(string)rotl);
vOffset = (vector)llList2String(posl, 0);
rRotation = (rotation)llList2String(rotl, 0);



vector vDestPos = (vOffset * rBase) + vBase;
rotation rDestRot = rRotation * rBase;


integer i = 0;
vector vLastPos = ZERO_VECTOR;
while( (i < 5) && (llGetPos() != vDestPos) )
{
list lParams = [];

//If we're not there....
if( llGetPos() != vDestPos )
{
//We may be stuck on the ground...
//Did we move at all compared to last loop?
if( llGetPos() == vLastPos )
{
//Yep, stuck...move straight up 10m (attempt to dislodge)
lParams = [ PRIM_POSITION, llGetPos() + <0, 0, 10.0> ];
//llSetPos(llGetPos() + <0, 0, 10.0>);
} else {
//Record our spot for 'stuck' detection
vLastPos = llGetPos();
}
}


integer iHops = llAbs(llCeil(llVecDist(llGetPos(), vDestPos) / 10.0));
integer x;
for( x = 0; x < iHops; x++ ) {
lParams += [ PRIM_POSITION, vDestPos ];
}
llSetPrimitiveParams(lParams);

i++;
}


llSetRot(rDestRot);
return;
}


if( sCmd == "DONE" )
{
//We are done, remove script

llRemoveInventory(llGetScriptName());
return;
}


if( sCmd == "CLEAN" )
{


//Clean up
llDie();
return;
}



}



}
