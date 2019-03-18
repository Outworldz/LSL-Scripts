// :CATEGORY:NPC
// :NAME:OpenSim Mirror
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-09-08
// :EDITED:2014-02-14 12:32:45
// :ID:1023
// :NUM:1587
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC Mirror Make a NPC appear that looks just like thee
// :CODE:
// Requirements:
// A pose ball or a chair prim with this script, and a second prim named "npcChair" with the other script
// Needs at least one, and no more than 12 sit animations.
// NPC's have to be enabled. 

// Tunable stuff, like positions of prims, name of chair, and camera controls.
string stand = "avatar_jumpforjoy"; // the name of a animation of you standing there. plays when you stand up.

string chairName = "npcChair";  // the name of the prim the npc will sit on
vector myPos = <0.0, 0.0, 0.1>;  // my pos relative to the pose ball
vector npcPos = <-3.0, 0, 0>;      // npc rez pos relative to the pose ball
vector myEye = <-1, 0, 0>;      // my eyeball
vector myFocus = <-5, 0, -100>; // is looking at this spot


// stuff best left alone
integer chat = -483498;     // chqnnel to command the NPC pose ball to appear
key aviKey ;                // who is sitting
key npc;                        // save the npc key
vector npcPOS;                  // calculate the position of the npc;
integer listener;               // a place to hold a listen id that we can remove
list poses;                     // a list of poses
string last_anim;               // the last animation we ever played


// Display a dialog box with up to 12 animations
dialog()
{
    llListenRemove(listener);
    integer channel = llCeil(llFrand(10000)+20000);
    listener = llListen(channel,"","","");

    integer poseCount = llGetInventoryNumber(INVENTORY_ANIMATION);
    integer index;
    poses = [];
    for ( ; index < poseCount; index++) {
        string name = llGetInventoryName(INVENTORY_ANIMATION,index);
        if (llGetSubString(name,0,2) == "sit")
            poses += name;
    }
    poses = llDeleteSubList(poses,12,99);    // no more than 12, please
        
    llDialog(aviKey,"Pick a pose",poses,channel);
    
}


default {

    // reset when rezzed so any mirror gets fixed 
    on_rez(integer param)
    {
        llResetScript();
    }

    // on reset event is next
    state_entry() {
        llSetText("Mirror",<1,1,1>,1.0);
        llSay(chat,"Mirror");
        llSetAlpha(1.0,ALL_SIDES);
        osNpcRemove(llGetObjectDesc());    // kill any old miror off
                    
        // set sit target, otherwise this will not work
        llSitTarget(myPos, ZERO_ROTATION);    // one forware, not to the size, 1 up.

        llSetCameraEyeOffset(myEye);    // and set the camera up
        llSetCameraAtOffset(myFocus);
     }

    changed(integer what) {

        // someone sat
        if (what &  CHANGED_LINK) {

            aviKey =  llAvatarOnSitTarget();    // save for whom the mirror tolls
            if (aviKey != NULL_KEY) {
                llRequestPermissions(aviKey,PERMISSION_TRIGGER_ANIMATION);    // we need permission to control animations, so ask for it

            } else {  // OMG, they unsat. Must not like their own face.
                llSetText("Mirror",<1,1,1>,1.0);
                llSay(chat,"Mirror");
                
                llSetAlpha(1.0,ALL_SIDES);
                osNpcStopAnimation(npc,last_anim);    // stop whatever animation was playing
                osNpcStand(npc);                      // stand up
                osNpcPlayAnimation(npc,stand);
                llStopAnimation(last_anim);
                llStartAnimation(stand);
                llSleep(5);
                osNpcSay(npc, 0, "Goodbye");          // lets not be snarky. Just say goodbye
                osNpcRemove(npc);                     // and die a horrible death while they watch
                llStopAnimation(stand);
            }
        }
    }
 

    run_time_permissions(integer permissions)
    {
        // Now we have permission to kill the men, burn the village and rape the women. And let's get it right this time!
        if (permissions & PERMISSION_TRIGGER_ANIMATION)
        {
            llSetText("",<1,1,1>,1.0);
            llSay(chat,"");
            llSetAlpha(0.0,ALL_SIDES);
            
            llStopAnimation("sit");    // end the default "sit"
            last_anim = llGetInventoryName(INVENTORY_ANIMATION,0);    // find the first animation in inventory
            llStartAnimation(last_anim);                              // We could paint it black, or start it up. 

            string fullName = llKey2Name(aviKey);   // get the name of the avatar.
            list fl = llParseString2List(fullName,[" "],[]);    // make a list of avatars name, split apart at the space
            string fname = llList2String(fl,0);    // get first name from 0th element of the list
            string lname = llList2String(fl,1);    // 1th element is the last name

            npcPOS = llGetPos() + npcPos;    // npc will REZ here

            npc = osNpcCreate(fname, lname, npcPOS, llAvatarOnSitTarget());
            llSetObjectDesc(npc);    // save it in case we get reset
            llSetTimerEvent(5);      // give it time to rez
        }
    }

    
    timer()
    {
        llSetTimerEvent(0);
       
        llSensor(chairName,"",PASSIVE|SCRIPTED,10.0,TWO_PI);    // look around 10 meters for something to sit on
    }

    sensor (integer n)
    {
        osNpcSit(npc, llDetectedKey(0), OS_NPC_SIT_NOW);    // sit on the detected seat
        osNpcStopAnimation(npc,"sit");
        osNpcPlayAnimation(npc,last_anim);
        dialog();
    }
    
    no_sensor()
    {
        llOwnerSay("Mirror cannot find the a chair named " + chairName);
        osNpcRemove(llGetObjectDesc());              
    }
    
    listen(integer channel, string name, key id, string message)
    {
        llStopAnimation(last_anim);
        llStartAnimation(message);
        osNpcStopAnimation(npc,last_anim);
        osNpcPlayAnimation(npc,message);

        last_anim = message;
        dialog();
    }
    
}
