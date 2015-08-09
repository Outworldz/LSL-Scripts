// :CATEGORY:Inventory Giver
// :NAME:LandMark_NoteCard_Giver
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:457
// :NUM:613
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LandMark_NoteCard Giver.lsl
// :CODE:


1// remove this number for the script to work.




//This script will automatically detect the name of you landmark and notecard. Just insure that they are the only 2 things you put in the box with this script other than the sound which is provided.

string HText = "Landmark and Notecard Giver!"; //This is the text you wish to be displayed above your object, leave blank if you do not wish for anything to be displayed. To make a new line of text, add '\n' to your text to tell the script to start a new line.

vector Color = <1,0,0>; //This is the color you wish for the hover text to be displayed as. Its is currently red.

float Alpha = 1; //This is the transparency of the HoverText, 1 is solid, 0 is Transparent.

//________________________________________________________________________



default
{ 
    state_entry()
    {
        llSetText(HText,Color,Alpha);
    }
    touch_start(integer total_number)
    {
        llSay(0, "Thank you for requesting this information");
        llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_LANDMARK, 0));
        llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_NOTECARD, 0));
        llInstantMessage(llGetOwner(), "LandMark giver at " + llGetRegionName() + " has just been used by " +  llKey2Name(llDetectedKey(0)) + "!");
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
// END //
