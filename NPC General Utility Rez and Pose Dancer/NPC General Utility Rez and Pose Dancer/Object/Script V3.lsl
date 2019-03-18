// :CATEGORY:NPC
// :NAME:NPC General Utility Rez and Pose Dancer
// :AUTHOR:Aine Caoimhe (aka Mata Hari)
// :KEYWORDS:
// :CREATED:2014-02-20 14:27:38
// :EDITED:2015-01-23
// :ID:1052
// :NUM:1671
// :REV:3
// :WORLD:Opensim
// :DESCRIPTION:
// This was written as a "dancer" script for a club. 
// :CODE:
// :SOURCE: http://forums.osgrid.org/viewtopic.php?f=5&t=4989

// Place this in a prim along with at least 1 animation.
// When you first touch it you will be cloned to notecard, then an NPC will rez, jump on the poseball and
// begin to play the animation(s) in its inventory. Subsequent touched of the prim will rez/unrez the dancer.
// On region restart, the dancer will auto-rez by default. You can add more animations or delete them during use
// (but it will reset the NPC's dance queue). Deleting the appearance notecard will disable the ball until you touch it again.
// Note that this script uses a very handy "orphan checker" that helps to prevent the accidentaly orphaning of a dancer.
// If an unexpected NPC is detected as already being on the poseball the ball will "take control" of that NPC instead of rezzing a new one.

// REVISIONS:
// V2 09-25-2014 - Fred Beckhusen (Ferd Frederix) - added debug info
//               save NPC key in description so pose ball can be removed and replaced
//               Added Sensor to make NPCs go away when no one is around                    

// V3 01-22-2015 - Fred Beckhusen (Ferd Frederix) - Fixed the timer so it plays more than ane animation- 
//

// NPC General Utility Rez & Pose Dancer
// Written by Aine Caoimhe (aka Mata Hari) 2012/2013
//
// OVERVIEW
//
// This basic script is designed to be placed in any object (usually a poseball) along with at least one animation.
// When the owner touches the poseball for the first time their appearance will be cloned and stored to use for
// an NPC who will then rez, sit on the poseball, and begin to play the animation. Subsequent touches of the poseball
// will remove or restore the NPC. The script doesn't provide any "advanced" features such as variable timers, variable NPCs,
// dance selection/controls, etc.
//
// Because this was written by special request, several default behaviours are part of the script but can be altered
// easily either by changing the settings in the USE VARIABLES section below (even a novice can do this!) or more
// drastic changes can be made by altering the main body of the script.
//
// This script requires a region that is configured to allow the OSSL functions necessary to create and animate NPC
// (uses osAvatarPlayAnimation() and osAvatarStopAnimation() rather than the NPC versions of those functions because
// at the time I wrote most of it the NPC versions didn't work correctly).
//
// TERMS OF USE
//
// This script is provided as a courtesy to other users of OpenSim on an as-is basis. I'll try to help you if you ask nicely
// but I won't promise to fix or resolve any issues you might encounter or further customize it for your uses.
// You are free to use and modify it as desired, provided you:
// - also provide it free of charge with full perms as per GPU General Public Licence 3.0
// - never alter the script to allow it to clone another avatar appearance without that owner's explicit and informed consent (avi theft)
//


// -----------------------------------------------------------------------
// USER VARIABLES
// you can change these default values to suit your preferences
// -----------------------------------------------------------------------
integer debug = FALSE;         // set to TRUE or FALSE for debug chat on various actions
integer iTitleText = FALSE;    //  set to TRUE or FALSE for hovertext various actions

// If Set to a non-zero number the NPC  will appear only when someone is withing this RADIUS.
float RADIUS = 30;    // in meters
float RATE = 5.0;  // the smaller this is, the quicker the NPC will appear and the laggier it will be.  Keep this as large as usefully possible for a given RADIUS.

// The name of your dancer...this is the name she will show in world
string dancerFirstName="Club";
string dancerLastName="Dancer";

// How she changes dances...one of the two following lines must be commented (disabled using // at the start of the line) and the
// other line must be active (no // at the start)

//string danceSeq="random";       // dancer will pick the next animation randomly
string danceSeq="seq";          // dancer will pick the next animation in the poseball

// How often she changes dances -- set a value here in seconds that you want her to play each dance before advancing to the next
float danceTimer=15.0;

// Is the poseball active? Set this to TRUE to have her automatically rezzed whenever the region is restarted. Otherwise set to FALSE.
integer active=TRUE;

// Positioning...how far from the ball to place the dancer (essentially this is her sit target) as a (x,y,z) vector
vector offSet=<0.0, 0.0, 1.0>;
vector rot = <0,0,0>; // In case it is not a pose ball, and easily rotated, you can adjust the axis here.

vector RezPos = <0,0,1.0>;    // set this Z to a large number, and they fall out of the sky.

// OS_NPC_CREATOR_OWNED will create an 'owned' NPC that will only respond to osNpc* commands issued from scripts that have the same owner as the one that created the NPC.
// OS_NPC_NOT_OWNED will create an 'unowned' NPC that will respond to any script that has OSSL permissions to call osNpc* commands.
integer  NPCOptions = OS_NPC_CREATOR_OWNED;    // anyone, not just the owner of this box can control this NPC.

// Control
integer PRIVATE = TRUE;    // set to FALSE to a allow anyone to touch and control the NPC;

// -----------------------------------------------------------------------
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING :)
// -----------------------------------------------------------------------

string npcCard="My Dancer";
key dancerID;
integer danceIndex;
list danceList;

// V2
// DEBUG(string) will chat a string or display it as hovertext if debug == TRUE
DEBUG(string str)
{
    if (debug)
        llSay(0, str);                    // Send the owner debug info so you can chase NPCS
    
    if (iTitleText)
    {
        llSleep(0.1);
        llSetText(str,<1.0,1.0,1.0>,1.0);    // show hovertext
    }
}


// V2
BootDancer()
{
   //DEBUG("BootDancer()");

    if (dancerID==NULL_KEY || ! NpcIsSeated() ){
        DEBUG("No NPC key in RAM");
        rezDancer();
        danceIndex=0;    // start with the first dance
    }

    // other wise, boot will do nothing as there is already a NPC
}

updateDanceList()
{
    DEBUG("updateDanceList()");
    // build list of animations in inventory
    integer anims=llGetInventoryNumber(INVENTORY_ANIMATION);
    while(--anims > -1)
    {
        danceList+=llGetInventoryName(INVENTORY_ANIMATION,anims);
    }
    if (danceSeq=="seq")
        danceList=llListSort(danceList,1,TRUE);
    else
        danceList=llListRandomize(danceList,1);
    
    danceIndex=0;

    DEBUG("We have " + (string) llGetListLength(danceList) + " animations");
    
}
rezDancer()
{
    DEBUG("rezDancer()");
    // make sure there are animations
    if (!llGetListLength(danceList))
    {
        llOwnerSay("Cannot create the dancer because there are no animations in the poseball inventory to play");
        return;
    }
    // make sure there is a dancer to rez (shouldn't be possible to get this result but included just in case
    if (llGetInventoryType(npcCard)!=INVENTORY_NOTECARD)
    {
        llOwnerSay("Cannot create the dancer because there is no stored appearance in inventory");
        return;
    }
    // see if an npc is already sitting...helps to recover from accidental script reset with active NPC
    if (NpcIsSeated()) {
        DEBUG(" NPC already in world - starting animation");
        
    } else {
        DEBUG("NPC rezzing");
        dancerID = osNpcCreate(dancerFirstName,dancerLastName,llGetPos()+ RezPos ,npcCard, NPCOptions);
        llSetObjectDesc(dancerID);    // V2
        llSleep(0.5);
        osNpcSit(dancerID,llGetKey(),OS_NPC_SIT_NOW);   
    }

}
removeDancer()
{
    //DEBUG("removeDancer()");
    // kill active npc

    // V2 if we rtest or there is a sitter
    if (dancerID == NULL_KEY || ! NpcIsSeated() ) {
        //DEBUG("Dancer  is unknown and not sittting, using the Description");
        dancerID = llGetObjectDesc();
    }

    if (llStringLength(dancerID)) {
        //DEBUG("Removing Dancer NPC UUID " + (string) dancerID);
        osNpcRemove(dancerID);
    }
    dancerID=NULL_KEY;
    llSetObjectDesc("");
}
integer NpcIsSeated()
{
    // a safety net to try to catch stray NPCs cause by script edit/reset while an NPC is active
    // if an NPC is detected already on the ball but no dancerID is set...this is only called at
    // a time when a new NPC would otherwise be created
        
    key sitterID=llAvatarOnSitTarget();

    if (sitterID != NULL_KEY)
    {
        if (osIsNpc(sitterID))
        {
            dancerID=sitterID;
            return TRUE;
        }
        else
        {
            return FALSE;
        }
    }

    return FALSE;
} 
startDancing()
{
    DEBUG("StartDancing()");

        
    // called when an NPC first sits
    string dance=llList2String(danceList,danceIndex);
    // start currently indexed dance
    osAvatarPlayAnimation(dancerID,dance);
    DEBUG("playing animation " + dance);
    
    llSleep(0.25);
    // now stop any other animations the NPC is playing (sit, etc)
    list animToStop=llGetAnimationList(dancerID);
    
    DEBUG(llDumpList2String(animToStop,"-"));
    
    integer stop=llGetListLength(animToStop);
    
    DEBUG("List L = " + (string) stop);
    
    key dontStop=llGetInventoryKey(dance);
    DEBUG("key dont stop = " + (string) dontStop);
    
    while(stop-- > 0)
    {
        if (llList2Key(animToStop,stop)!= dontStop) {
            string tostop = llList2Key(animToStop,stop);
            osAvatarStopAnimation(dancerID,tostop);
            DEBUG("Stopping animation:" + tostop);
        }
    }

    if (RADIUS > 0.0)
        llSensorRepeat("","",AGENT,RADIUS,PI,RATE);
     
    llSetTimerEvent(danceTimer); // set the timer for advancing to next dance
}
playNextDance()
{
    DEBUG("playNextDance()");

    // play the next dance
    osAvatarStopAnimation(dancerID,llList2String(danceList,danceIndex));
    DEBUG("Stopping animation " + llList2String(danceList,danceIndex));
    
    danceIndex++;
    if (danceIndex==llGetListLength(danceList))
        danceIndex=0;   // cycle back to beginning when reaching the end
    
    DEBUG("Starting animation " + llList2String(danceList,danceIndex));
    osAvatarPlayAnimation(dancerID,llList2String(danceList,danceIndex));

    llSetTimerEvent(danceTimer); // set the timer for advancing to next dance
    
}
default
{
    state_entry()
    {
        DEBUG("Reboot");
        removeDancer(); // V2 kill any old dancers
            
        // ensure sit target set
        if (offSet==ZERO_VECTOR)
            offSet.z+=0.0001;

        // V2, allow defined rotations
        llSitTarget(offSet,llEuler2Rot(rot * DEG_TO_RAD)) ;
        
        // update the animations list
        updateDanceList();

        if (INVENTORY_NOTECARD == llGetInventoryType(npcCard)) {

            // rez dancer automatically if set to do so
            if (active ) {
                rezDancer();
            } 
        }
    }
    timer()
    {
        DEBUG("Tick");
        // time to advance to next dance...make sure there is a dancer first
        if ((dancerID==NULL_KEY) || (llAvatarOnSitTarget()!=dancerID)) {
            DEBUG("No Dancer!");
            llSetTimerEvent(0.0);   // kill timer if NPC unrezzed
        } else {
            playNextDance();
        }
    }
    on_rez(integer start)
    {
        // always reset on rez
        llResetScript();
    }
    changed(integer change)
    {
        // reset script if owner changes or region restarts
        if (change & CHANGED_OWNER)
            llResetScript();
        else if (change & CHANGED_REGION_START)    // Opensim changed the variable to RE start
            llResetScript();
        // handle changes in inventory that might affect operation
        else if (change & CHANGED_INVENTORY)
        {
            DEBUG("Inventory Changed");
            // safety check on deleting notecard during use
            if ((llGetInventoryType(npcCard)!=INVENTORY_NOTECARD) && (dancerID==NULL_KEY))
            {
                llOwnerSay("You have deleted the dancer notecard. Removing the dancer");
                removeDancer();
                return;
            }
            // else see if it's a change in animations
            integer anims=llGetInventoryNumber(INVENTORY_ANIMATION);
            if (!anims && (dancerID!=NULL_KEY))
            {
                // user deleted the last animation...kill active dancer
                llOwnerSay("There are no animations in the poseball...removing your dancer");
                removeDancer();
            }
            else if (anims!=llGetListLength(danceList))
            {
                DEBUG("Update Dance List");
                updateDanceList();
                if (dancerID!=NULL_KEY) {
                    startDancing();
                }
            }
        }
        // handle changes in link...will usually be triggered by the NPC sitting or being removed
        else if (change & CHANGED_LINK)
        {
            DEBUG("Inventory Changed Link");
            
            osAvatarStopAnimation(dancerID,"sit");
            
            // start dancing when an npc sits
            if (dancerID!=NULL_KEY && llAvatarOnSitTarget()==dancerID)
                startDancing();
            // can ignore npc standing (derez) because key reset is handled by the remove routine
            // also ignoring any non-npc who sits here
        }
    }
    touch_start(integer num)
    {
        // only owner can play with this
        if (PRIVATE) {
            if (llDetectedKey(0)!=llGetOwner())
                return;
        }
        // first, clone owner if no appearance card has been stored
        if (llGetInventoryType(npcCard)!=INVENTORY_NOTECARD)
        {
            llOwnerSay("One moment while your appearance is saved for the npc to use");
            osOwnerSaveAppearance(npcCard);
            llSleep(2.0);
        }
        // if no dancer, rez one
        if (dancerID==NULL_KEY)
        {
            BootDancer();
        }
        // else there's a dancer so this touch means we want to remove it
        else {
            removeDancer();
            llSetTimerEvent(0);
            llSensorRemove();
        }
    } 

    sensor(integer n)
    {
        BootDancer();
    }
    
    no_sensor()
    {
        DEBUG("No Sensor");
        if (dancerID) {
            removeDancer();
        }
    }
}
