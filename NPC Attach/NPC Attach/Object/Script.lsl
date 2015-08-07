// :CATEGORY:NPC
// :NAME:NPC Attach
// :AUTHOR:Thomas Ringate
// :KEYWORDS:
// :CREATED:2014-09-24 14:34:17
// :EDITED:2014-09-24
// :ID:1047
// :NUM:1657
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Attach things to NPCs by script
// :CODE:
//XEngine:lsl
string name = "NPC Mate test box ";
string version = "V2.2";
list avatars = [];
key victim = "aaefe00e-724a-4346-83df-92fa615b009f";
// NPC Genie - id - V2.2
//* Licensed under the GPLv2, with the additional requirement that these scripts remain "full perms".
//*
//

default
{
    state_entry()
    {
        if(!llGetAttached())
            llSetObjectName(name + version);
        else
            llSetObjectName(llKey2Name(llGetOwner()));
    }
    touch_start(integer iNum)
    {
        llSay(0,"You touched me.");
        avatars = osGetAvatarList(); // get list of avatars on region
        llSay(0, "Avatars in this sim (without the owner): " + 
        llList2CSV(avatars));
        victim = llList2Key(avatars,0);
        if(osIsNpc(victim)  == TRUE)
        {
            llSay(0, "Victim is Genie: " + victim);
            osForceAttachToOtherAvatarFromInventory(victim, "testbox", ATTACH_PELVIS);
        }
        else
        {
            victim = llGetOwner();
            llSay(0, "Victim is Avatar: " + victim);
            osForceAttachToAvatarFromInventory("testbox", ATTACH_PELVIS);
        }
        //llSleep(5);
        //osForceDropAttachment();
    }
    on_rez(integer iParam)
    {
        llResetScript();
    }
}
