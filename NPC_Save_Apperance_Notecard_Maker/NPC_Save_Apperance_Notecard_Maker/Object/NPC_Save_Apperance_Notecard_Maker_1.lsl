// :CATEGORY:OpenSim NPC
// :NAME:NPC_Save_Apperance_Notecard_Maker
// :AUTHOR:Wizardry and Steamworks
// :CREATED:2013-07-30 13:50:59.097
// :EDITED:2013-09-18 15:38:58
// :ID:575
// :NUM:788
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// GPLv3 license attributed to the Wizardry and Steamworks group at http://was.fm/opensim:npc// touch to save your XML to a notecard named appearance for use with NPC follower and NPC puppeteer sceipt.
// :CODE:
default
{
    touch_start(integer num)
    {
        osAgentSaveAppearance(llDetectedKey(0), "appearance");
    }
}
