// :SHOW:1
// :CATEGORY:NPC
// :NAME:HyperGrid Story Nine
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:NPC, controller, console
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1839
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC console controller button script
// Goes into 8 buttons in a compass rose configuration
// Controls a pair of NPCS to xap 6 othert NPCs.
// each button gets a different config.

// :CODE:

string E = "<1,0,0>";
string NE = "<1,1,>";
string N = "<0,1,0>";
string NW = "<-1,1,0>";
string W = "<-1,0,0>";
string SW = "<-1,-1,0>";
string S = "<0,-1,0>";
string SE = "<1,-1,0>";
 
// chose a direction for one of 8 buttons.

default
{
    touch_start(integer total_number)
    {
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_FULLBRIGHT, ALL_SIDES,TRUE]);
        llMessageLinked(LINK_SET,4,S,"");
        llSetTimerEvent(0.5);
    }
    timer()
    {
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_FULLBRIGHT,ALL_SIDES, FALSE]);
        llSetTimerEvent(0);
    }
}
