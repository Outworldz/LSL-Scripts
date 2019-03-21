// :CATEGORY:NPC
// :NAME:NPC rotator
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-09-24 14:52:23
// :EDITED:2014-09-24
// :ID:1048
// :NUM:1659
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Makes a set of NPC's walk in a circle
// :CODE:
// The name of your dancer...this is the name she will show in world
string dancerFirstName="Club";
string dancerLastName="Dancer";

// How she changes dances...one of the two following lines must be commented (disabled using // at the start of the line) and the
// other line must be active (no // at the start)

string danceSeq="random";       // dancer will pick the next animation randomly
// string danceSeq="seq";          // dancer will pick the next animation in the poseball

// How often she changes dances -- set a value here in seconds that you want her to play each dance before advancing to the next
float danceTimer=120.0;

// Is the poseball active? Set this to TRUE to have her automatically rezzed whenever the region is restarted. Otherwise set to FALSE.
integer active=TRUE;

// Positioning...how far from the ball to place the dancer (essentially this is her sit target) as a (x,y,z) vector
vector offSet=<0.0, 0.0, 1.0>;


// V1.1 Fred Beckhusen (Ferd Frederix) - remote control - Link messages to the prim animator are captured here.
// any NPC Options?
// OS_NPC_CREATOR_OWNED will create an 'owned' NPC that will only respond to osNpc* commands issued from scripts that have the same owner as the one that created the NPC.
// OS_NPC_NOT_OWNED will create an 'unowned' NPC that will respond to any script that has OSSL permissions to call osNpc* commands.
integer  NPCOptions = OS_NPC_CREATOR_OWNED;    // only the owner of this box can control this NPC.

integer NPCControllerchannel = 32468;

// -----------------------------------------------------------------------
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU ARE DOING :)
// -----------------------------------------------------------------------

string npcCard="My Dancer";
key dancerID;
integer danceIndex;
list danceList;

updateDanceList()
{
    // build list of animations in inventory
    integer anims=llGetInventoryNumber(INVENTORY_ANIMATION);
    while(--anims>-1)
    {
        danceList+=llGetInventoryName(INVENTORY_ANIMATION,anims);
    }
    if (danceSeq=="seq") danceList=llListSort(danceList,1,TRUE);
    else danceList=llListRandomize(danceList,1);
    danceIndex=0;
}
rezDancer()
{
    // make sure there are animations 
    if (!llGetListLength(danceList))
    {
        llOwnerSay("Cannot create the dancer because there are no animations in the poseball inventory for her to play");
        return;
    }
    // make sure there is a dancer to rez (shouldn't be possible to get this result but included just in case
    if (llGetInventoryType(npcCard)!=INVENTORY_NOTECARD)
    {
        llOwnerSay("Cannot create the dancer because there is no stored appearance in inventory for her.");
        return;
    }
    // see if an npc is already sitting...helps to recover from accidental script reset with active NPC
    if (checkForSitter()) startDancing();
    // safe to proceed with rezzing new NPC if we get to this point
    else
    {
        dancerID= osNpcCreate(dancerFirstName,dancerLastName,llGetPos()+<0,0,1>,npcCard,NPCOptions);
        llSetObjectDesc(dancerID);    // Rev 1.1 save dancer ID persistently.
        llSleep(0.5);
        osNpcSit(dancerID,llGetKey(),OS_NPC_SIT_NOW);
    }
}
removeDancer()
{
    // kill active npc
    osNpcRemove(dancerID);
    dancerID=NULL_KEY;
}
integer checkForSitter()
{
    // a safety net to try to catch stray NPCs cause by script edit/reset while an NPC is active
    // if an NPC is detected already on the ball but no dancerID is set...this is only called at
    // a time when a new NPC would otherwise be created
    key sitterID=llAvatarOnSitTarget();
    if (sitterID!=NULL_KEY)
    {
        if (osIsNpc(sitterID))
        {
            llOwnerSay("Detected an NPC already using the ball...setting this as my npc");
            dancerID=sitterID;
            return TRUE;
        }
        else
        {
            llOwnerSay("Unexpectedly found an avatar sitting on the poseball...it's going to get crowded!");
            return FALSE;
        }
    }
    else return FALSE;
}
startDancing()
{
    // called when an NPC first sits
    string dance=llList2String(danceList,danceIndex);
    // start currently indexed dance
    osAvatarPlayAnimation(dancerID,dance);
    llSleep(0.25);
    // now stop any other animations the NPC is playing (sit, etc)
    list animToStop=llGetAnimationList(dancerID);
    integer stop=llGetListLength(animToStop);
    key dontStop=llGetInventoryKey(dance);
    while(--stop)
    {
        if (llList2Key(animToStop,stop)!=dontStop) osAvatarStopAnimation(dancerID,llList2Key(animToStop,stop));
    }
    // set the timer for advancing to next dance
    llSetTimerEvent(danceTimer);
}
playNextDance()
{
    // play the next dance
    osAvatarStopAnimation(dancerID,llList2String(danceList,danceIndex));
    danceIndex++;
    if (danceIndex==llGetListLength(danceList)) danceIndex=0;   // cycle back to beginning when reaching the end
    osAvatarPlayAnimation(dancerID,llList2String(danceList,danceIndex));
}






default
{
    state_entry()
    {
        // ensure sit target set
        if (offSet==ZERO_VECTOR) offSet.z+=0.0001;
        llSitTarget(offSet,ZERO_ROTATION);
        // update the animations list
        updateDanceList();

        // Rev 1.1 remove old dancwers if we are reset or re-rezzed.
        dancerID = llGetObjectDesc();
        removeDancer();
        
        // rez dancer automatically if set to do so
        if (active && (llGetInventoryType(npcCard)==INVENTORY_NOTECARD))
            rezDancer();

        llListen(NPCControllerchannel,"","","");
    }
    timer()
    {
        // time to advance to next dance...make sure there is a dancer first
        if ((dancerID==NULL_KEY) || (llAvatarOnSitTarget()!=dancerID)) llSetTimerEvent(0.0);   // kill timer if NPC unrezzed
        else playNextDance();
    }
    on_rez(integer start)
    {
        // always reset on rez
        llResetScript();
    }
    changed(integer change)
    {
        // reset script if owner changes or region restarts
        if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION_START) llResetScript();
        // handle changes in inventory that might affect operation
        else if (change & CHANGED_INVENTORY)
        {
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
                updateDanceList();
                if (dancerID!=NULL_KEY) startDancing();
            }
        }
        // handle changes in link...will usually be triggered by the NPC sitting or being removed
        else if (change & CHANGED_LINK)
        {
            // start dancing when an npc sits
            if (dancerID!=NULL_KEY && (llAvatarOnSitTarget()==dancerID))
                startDancing();
            // can ignore npc standing (derez) because key reset is handled by the remove routine
            // also ignoring any non-npc who sits here
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "go"){
            rezDancer();    
        } else if (str== "quit"){    
            removeDancer();
        }
    }
    
    touch_start(integer num)
    {
        // only owner can play with this
        if (llDetectedKey(0)!=llGetOwner()) return;
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
            if (checkForSitter()) startDancing();
            else rezDancer();
        }
        // else there's a dancer so this touch means we want to remove it
        else removeDancer();
    }
    
    
    
    

}
