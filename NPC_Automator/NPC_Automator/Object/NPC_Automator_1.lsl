// :CATEGORY:OpenSim NPC
// :NAME:NPC_Automator
// :AUTHOR:justi
// :CREATED:2013-07-30 13:38:36.710
// :EDITED:2013-09-18 15:38:58
// :ID:569
// :NUM:782
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// From http://opensimulator.org/wiki/OSSLNPC// //This is a rough example script for most of the current NPC functionality. One of its major current deficiencies is that it doesn't track more than one created avatar at a time. Please feel free to improve it.
// :CODE:

key npc;
integer listenChannel = 10;
 
default
{
    // NPC manipulator adapted by justincc 0.0.3 released 20121025
    state_entry()
    {
        llListen(listenChannel,"",NULL_KEY,"");
        llSetText("Listening on " + listenChannel, <0, 255, 0>, 1);
        llOwnerSay("Say /" + (string)listenChannel + " help for commands");
    }  
 
    listen(integer channel, string name, key id, string msg)
    {
        if (msg != "")
        {
            list commands = llParseString2List(msg, [ " " ], []);
            string msg0 = llList2String(commands, 0);
            string msg1 = llList2String(commands, 1);            
            string msg2 = llList2String(commands, 2);
            string msg3 = llList2String(commands, 3);
 
            if (msg0 == "create")
            {
                if (msg1 != "")
                {
                    string notecardName = msg1;
 
                    npc = osNpcCreate("Jane", "Doe", llGetPos() + <5, 5, 0>, notecardName);
 
                    llOwnerSay("Created npc from notecard " + notecardName);
                }
                else
                {
                    llOwnerSay("Usage: create <notecard-name>");
                }
            }  
            else if (msg0 =="createm" && msg1 != "")
            {
                osOwnerSaveAppearance("appearance");
                vector pos = llGetPos();
                integer i;
                for (i = 0; i < (integer)msg1; i++)
                {
                    osNpcCreate("John", "Doe", pos + <8, 0, 0>, "appearance");
                    llSleep(1);
                }
            }
            else if (msg0 == "remove" && npc != NULL_KEY)
            {
                osNpcSay(npc, "You will pay for this with your liiiiiivvveeessss!!!.....");
                osNpcRemove(npc);
            }   
            else if (msg0 == "say" && npc != NULL_KEY)
            {
                osNpcSay(npc, "I am your worst Nightmare!!!!");
            }   
            else if (msg0 == "move")
            {
                if (msg1 != "" && msg2 != "" && npc != NULL_KEY)
                {                
                    vector delta = <(integer)msg1, (integer)msg2, 0>;
 
                    if (msg3 != "")
                    {
                        delta.z = (integer)msg3;
                    }
 
                    osNpcMoveTo(npc, osNpcGetPos(npc) + delta);                    
                }                            
                else
                {
                    llOwnerSay("Usage: move <x> <y> [<z>]");
                }
            }   
            else if (msg0 == "moveto")
            {
                if (msg1 != "" && msg2 != "" && npc != NULL_KEY)
                {                
                    vector pos = <(integer)msg1, (integer)msg2, 0>;
 
                    if (msg3 != "")
                    {
                        pos.z = (integer)msg3;
                    }
 
                    osNpcMoveTo(npc, pos);                    
                }                            
                else
                {
                    llOwnerSay("Usage: move <x> <y> [<z>]");
                }
            }            
            else if (msg0 == "movetarget" && npc != NULL_KEY)
            {
                osNpcMoveToTarget(npc, llGetPos() + <9,9,5>, OS_NPC_FLY|OS_NPC_LAND_AT_TARGET);
            }
            else if (msg0 == "movetargetnoland" && npc != NULL_KEY)
            {
                osNpcMoveToTarget(npc, llGetPos() + <9,9,5>, OS_NPC_FLY);
            }            
            else if (msg0 == "movetargetwalk" && npc != NULL_KEY)
            {
                osNpcMoveToTarget(npc, llGetPos() + <9,9,0>, OS_NPC_NO_FLY);                
            }
            else if (msg0 == "rot" && npc != NULL_KEY)
            {
                vector xyz_angles = <0,0,90>; // This is to define a 1 degree change
                vector angles_in_radians = xyz_angles * DEG_TO_RAD; // Change to Radians
                rotation rot_xyzq = llEuler2Rot(angles_in_radians); // Change to a Rotation                
                rotation rot = osNpcGetRot(npc);
                osNpcSetRot(npc, rot * rot_xyzq);
            }
            else if (msg0 == "rotabs" && msg1 != "")
            {
                vector xyz_angles = <0, 0, (integer)msg1>;
                vector angles_in_radians = xyz_angles * DEG_TO_RAD; // Change to Radians
                rotation rot_xyzq = llEuler2Rot(angles_in_radians); // Change to a Rotation                
                osNpcSetRot(npc, rot_xyzq);                
            }
            else if (msg0 == "animate" && npc != NULL_KEY)
            {
                osAvatarPlayAnimation(npc, "stabbed+die_2");
                llSleep(3);
                osAvatarStopAnimation(npc, "stabbed+die_2");
            }   
            else if (msg0 == "save" && msg1 != "" && npc != NULL_KEY)
            {
                osNpcSaveAppearance(npc, msg1);
                llOwnerSay("Saved appearance " + msg1 + " to " + npc);                
            }
            else if (msg0 == "load" && msg1 != "" && npc != NULL_KEY)
            {
                osNpcLoadAppearance(npc, msg1);
                llOwnerSay("Loaded appearance " + msg1 + " to " + npc);
            }
            else if (msg0 == "clone")
            {
                if (msg1 != "")
                {
                    osOwnerSaveAppearance(msg1);
                    llOwnerSay("Cloned your appearance to " + msg1);
                }
                else
                {
                    llOwnerSay("Usage: clone <notecard-name-to-save>");
                }
            }
            else if (msg0 == "stop" && npc != NULL_KEY)
            {
                osNpcStopMoveToTarget(npc);
            }
            else if (msg0 == "sit" && msg1 != "" && npc != NULL_KEY)
            {
                osNpcSit(npc, msg1, OS_NPC_SIT_NOW);
            }
            else if (msg0 == "stand" && npc != NULL_KEY)
            {
                osNpcStand(npc);
            }
            else if (msg0 == "help")
            {
                llOwnerSay("Commands are:");
                llOwnerSay("create <notecard-name> - Create NPC from a stored notecard");
                llOwnerSay("createm");       
                llOwnerSay("remove - Remove current NPC");     
                llOwnerSay("clone <notecard-name> - Clone own appearance to a notecard");
                llOwnerSay("load <notecard-name>  - Load appearance on notecard to current npc");
                llOwnerSay("save <notecard-name>  - Save appearance of current NPC to notecard");
                llOwnerSay("animate");
                llOwnerSay("move");
                llOwnerSay("moveto <x> <y> <z> - move to absolute position");
                llOwnerSay("movetarget");
                llOwnerSay("movetargetnoland");
                llOwnerSay("movetargetwalk");
                llOwnerSay("rot");
                llOwnerSay("say");
                llOwnerSay("sit <target-uuid>");
                llOwnerSay("stop");
                llOwnerSay("stand");
            }
            else
            {
                llOwnerSay("I don't understand [" + msg + "]");
            }
        }   
    }   
}
