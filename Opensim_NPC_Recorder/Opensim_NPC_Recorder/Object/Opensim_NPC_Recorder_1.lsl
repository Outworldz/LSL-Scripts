// :CATEGORY:OpenSim NPC
// :NAME:Opensim_NPC_Recorder
// :AUTHOR:Ferd Frederix
// :CREATED:2013-07-30 13:47:53.993
// :EDITED:2013-09-18 15:38:59
// :ID:596
// :NUM:818
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// OpenSim only.// This NPC script is used to make the 'appearance' notecard and 'Script' notecard for the Wizardry and Steamworks NPC controller script.// Put the script into a prim, and wear it as a HUD.  When you first wear it, a menu will appear. You may touch the prim to bring up the menu.
// :CODE:
// Author: Ferd Frederiz
// 7-28-2013 Rev 1
// Mods: none

// This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
// http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US
// You may use this for sanything as long as you do not sell the script.
// Please support Open source by crediting any authors of these scripts and sharing any improvement with the community.

// Dialog menu that appears:
// Help:  Brings you to a help web page.
// Erase:  Deletes the memory of the recorder so you can start over.  It does not delete any notecards.
// Stop NPC:   Prompts you for the name of a NPC to stop.  If located, it will be removed from the world. This script does not create NPC's or control them.  The W&S Controller script does that.    But if you have used this to create an NPC and are testing it, this can be used to remove the NPC.
// Appearance:   This button records your appearance into an 'appearance' notecard.  This card is used by the W&S scripts to make the NPC appear exactly as you are.   An NPC is not exactly the same as an Avatar.  For example, if you are wearing a AO, the AO will be able to animate the NPC.  You must use the recorder to move the NPC and to animate it.
// Save:  Will ask you to stand where you want the NPC to appear and will prompt you for a name of the NPC.   The name does not have to be an OpenSim avatar name, and thus can be any name.   The notecard "Script" will be created with all recordings saved in it.
// Recording:  Brings up a menu of NPC actions you can make.

// Recording Menu:
// @walk records the current position of your avatar for the NPC to walk to.
// @wander will prompt for a radius to wander, and a length of time to wander
// @say will prompt for something for the NPC to  say in chat
// @pause will prompt for a number of seconds to pause in one place
// @rotate will prompt for a rotation in degrees. Negative degrees, such as '-90', will rotate to the left.
// @sit will prompt you for the name of a prim to sit on.  The prim must be with 96 meters of the NPC.
// @stand will make the NPC stand up after sitting.
// @animate will prompt for the name of an animation and a time for the animation to play. The animation must be stored in the same object that holds the W&S controller script


// Typical 'Script' notecard
//@spawn=Digit Gorilla|<645, 128, 25>
//@walk=<645, 120, 25>
//@wander=3|1
//@say=omg, walking is so tiresome...
//@pause=2
//@rotate|degrees
//@sit|object
//@stand
//@animate|animation


// comment these lines out for Opensim, leave uncommented for testing in LSLEditor
osAgentSaveAppearance(key avatar, string notecard) {}
osNpcRemove (key  target) {llOwnerSay("NPC removed");}        
list osGetAvatarList () { return ["1234"];}
osMakeNotecard(string notecardName, string contents) {llOwnerSay("Notecard::" + (string) contents);}

    
// globals
integer channel;
integer handle;

// NPC

string NPCName;            // the name of the NPC that may be in world. So we can remove it.
integer NPC_STOP = FALSE;  // boolean to reuse a listener

// menus
list lCmdButtons = ["Appearance","Recording","Save","Help","Erase","Stop NPC"];
list lGoButtons = ["Menu","@say","@walk","@wander","@pause","@rotate","@sit","@stand","@animate"];


// the commands
list lCommands;  // commands are stored here  
string notecard; // commands are stored here temporarily for dumping
string command;  // place to stor a command for two-prompted ones
string Param2;   // place to stor a primpt for two-prompted ones

// Kill a NPC by Name

Kill(string NPCName)
{
    list avatars = osGetAvatarList(); // Returns a strided list of the UUID, position, and name of each avatar in the region except the owner.
    integer i;
    integer count;
    integer j = llGetListLength(avatars)/3;
    for (; i < j; i+=3)    // stride of 3
    {
        if (llList2String(avatars,i+2) == NPCName)
        {
            vector v = llList2Vector(avatars,i+1);
            key target = llList2Key(avatars,i);    // get the UUID of the avatar
            osNpcRemove(target);
            llOwnerSay("Rmoved " + NPCName + " at  location " + (string) v);
            count++;
        }        
    }
    if (! count)
        llOwnerSay("Could not locate " + NPCName);
}


// return the position we are at, less half the avatar heght as this is worn as a HUD.
string Pos()
{
    vector size = llGetAgentSize(llGetOwner());
    float h = size.z;
    vector where = llGetPos();
    where.z -= h/2;
    return (string) where;
}

// make a text box
makeText(string Param)
{
    llListenRemove(handle);
    channel = llCeil(llFrand(100000) + 20000);
    handle = llListen(channel,"","","");
    llTextBox(llGetOwner(), Param, channel);
}

// make a menu
makeMenu(list  buttons)
{
    llListenRemove(handle);
    channel = llCeil(llFrand(100000) + 20000);
    handle = llListen(channel,"","","");
    llDialog(llGetOwner(),"Choose a command",buttons,channel);
}

// make one or two text boxes with prompts
Text(string cmd, string p1, string p2)
{
    command = cmd;
    Param2 = "";
    if (llStringLength(p2))
        Param2 = p2;
    
    makeText(p1);
}


default
{
    state_entry()
    {
        makeMenu(lCmdButtons);
    }

    on_rez(integer param)
    {
        makeMenu(lCmdButtons);
    }

    touch_start(integer n)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            makeMenu(lCmdButtons);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == "Stop NPC")
        {
            if (llStringLength(NPCName))
            {
                Kill(NPCName);
            }
            else
            {
                NPC_STOP = TRUE;
                makeText("Enter name of an NPC to stop");
            }
        }
        else if (message == "Recording")
        {
            state Commands;
        }
        else if (message == "Appearance")
        {
            osAgentSaveAppearance(llGetOwner(), "appearance");
            llOwnerSay("Appearance recorded in notecard 'appearance'");
            makeMenu(lCmdButtons);
        }
        else if (message == "Save")
        {
            state Run;
        }
        else if (message == "Erase")
        {
            lCommands = [];
            makeMenu(lCmdButtons);
        }
        else if (message == "Help")
        {
            llLoadURL(llGetOwner(),"Click to view help","http://www.outworldz.com/opensim/posts/NPC/");
        }
        else if (NPC_STOP == TRUE)
        {
            NPC_STOP = FALSE;
            Kill(NPCName);
            makeMenu(lCmdButtons);
        }
            
    }
   
}


state Run
{
    state_entry()
    {
        makeText("Stand where you want the NPC to appear and enter the NPC Name");
        llSetTimerEvent(60);
    }

    listen(integer channel, string name, key id, string message)
    {
        llSetTimerEvent(0);

        NPCName = message;
        notecard = "@spawn=" + message + "|" +  Pos() + "\n";
        integer i;
        integer j = llGetListLength(lCommands);
        for (; i < j; i++)
        {
            notecard += llList2String(lCommands,i);
        }
        osMakeNotecard("Script",notecard); //Makes the notecard.
        llOwnerSay("'Script' notecard has been written");
        makeMenu(lCmdButtons);
        state default;

    }
    timer()
    {
        llOwnerSay("Menu expired");
        makeMenu(lCmdButtons);
        llSetTimerEvent(0);
        state default;
    }
    
}

state Commands
{
    state_entry()
    {
         makeMenu(lGoButtons);   
    }
    listen(integer channel, string name, key id, string message)
    {
        llSetTimerEvent(0);

        if (message == "Menu")
        {
            state default;
        }
        else if (message == "@say")
        {
            Text("@say=","Enter what the NPC will say","");
        }
        else if (message == "@walk")
        {
            lCommands += "@walk=" + Pos() + "\n";
            llOwnerSay("Recorded");
            makeMenu(lGoButtons);   
        }
        else if (message == "@wander")
        {
            Text("@wander=","Enter radius to wander","Enter Time to wander");
        }
        else if (message == "@pause")
        {
            Text("@pause=","Enter time to pause","");
        }
        else if (message == "@rotate")
        {
            Text("@rotate=","Enter degrees to rotate","");
        }
        else if (message == "@sit")
        {
            Text("@sit=","Enter name of object to sit on","");
        }
        else if (message == "@stand")
        {
            lCommands += "@stand\n";
            llOwnerSay("Recorded");
            makeMenu(lGoButtons);   
        }
        else if (message == "@animate")
        {
            Text("@animate=","Enter animation name to play","Enter time to play the animation");
        }
        else  if (! llStringLength(Param2))
        {
            lCommands +=  command + message + "\n";
            llOwnerSay("Recorded");
            makeMenu(lGoButtons);  
        }
        else if (llStringLength(Param2))
        {
            command = command + message + "|";
            llOwnerSay("Recorded");
            makeText(Param2);
            Param2 = "";
        }
        
    }
    timer()
    {
        llOwnerSay("Menu expired");
        makeMenu(lGoButtons);
        llSetTimerEvent(0);
    }
    
}
