// :SHOW:
// :CATEGORY:NPC
// :NAME:NPC Appearance Sorter
// :AUTHOR:Aine Caoimhe (Mata Hari)
// :KEYWORDS:
// :CREATED:2016-02-26 16:49:31
// :EDITED:2016-02-26  15:49:31
// :ID:1101
// :NUM:1886
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Preview a series of NPC appearance notecards.
// :CODE:
//UTILITY SCRIPT: NPC Appearance Sorter
//I had a request from someone for a simple script to let you look through NPC appearance notecards to figure out what they were so I wrote this little utility which could be useful for others.

//To use it:
//Rez a prim in a region where NPCs and the necessary OSSL functions are enabled 
//Add one or more appearance notecards to the prim
//(Optional) add an animation to the prim -- otherwise the NPC will play the default SL stand.
//Add a new script and copy the script, below, into it, and save
//Touch the prim to begin
//* * * * * * * COPY EVERYTHING BELOW HERE INTO THE SCRIPT * * * * * * *

// PARAMOUR NPC SORTER
// by Aine Caoimhe (Mata Hari)(c. LACM) February 2016
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// *** THIS SCRIPT REQUIRES (AND WILL ONLY WORK) IN REGIONS WHERE THE SCRIPT OWNER HAS NPC ENABLED AND OSSL FUNCTION PERMISSIONS ***
//
// This is a simple script for previewing a series of NPC appearance notecards.
// The NPC is rezzed and sits on the object containing the script. Using the dialog you can scroll through appearances and (optionally) delete any you don't want.
//
// INSTRUCTIONS
//
// - Place this script in a prim (I use a generic prim sphere)
// - Add appearance notecards to its inventory (names don't matter...just don't add any notecards that aren't appearances)
// - Optional: add one animation to the prim that you want the NPC to play...if you don't, it will use the generic SL "stand" instead
// - Touch the prim and follow the dialog instructions
// - Adding a new appearance notecard or changing the animation inside it requires a script reset to pick up the changes
//
// KNOWN BUG:
// There is a known bug currently in Opensim (I reported it in Sept 2014 http://opensimulator.org/mantis/view.php?id=7325) where NPCs will often not display
// the animation until some time after told to. They will eventually display it if you wait, or you can also trigger it by changing them to a different appearance.
// There are other work-arounds but for this script I kept it simple.
//
// * * * * * * * * *
//  USER SETTINGS
// * * * * * * * * *
integer ownerOnly=TRUE;             // TRUE = only owner can activate it...FALSE = anyone can...I recommend restricting to owner so nobody else can delete any of your notecards
vector sitPos=<0.0, 0.0, 2.0>;      // sit target offset to use..adjust to whatever suits the object
float dialogTimeout=120.0;          // time (in seconds) to wait before removing the dialog listener if no response has been received
integer showFloatyText=TRUE;        // TRUE = display the current appearance name as floaty text above the prim...FALSE = only show it in the dialog menu
vector textColour=<0.0,1.0,0.0>;    // vector colour to use for the floaty text (if being used)
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// DON'T CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
key user;
key npc;
integer myChannel;
integer handle;
string anim;
list appear=[];
integer ind;

showMenu()
{
    handle=llListen(myChannel,"",user,"");
    llSetTimerEvent(dialogTimeout);
    string txtDia="Currently showing: "+llList2String(appear,ind)+"\n("+(string)(ind+1)+" of "+(string)llGetListLength(appear)+")";
    list butDia=["< PREV","DONE","NEXT >"];
    if (npc==NULL_KEY)
    {
        txtDia="\n\nREZ rezzes an NPC";
        butDia=[]+butDia+["REZ"];
    }
    else
    {
        txtDia+="\n\nKILL removes the NPC";
        butDia=[]+butDia+["KILL"];
    }
    txtDia+="\n\nDELETE will delete the current appearance notecard and advance to the next one\n\nGIVE hands you a copy of the appearance notecard";
    butDia=[]+butDia+["DELETE","GIVE"];
    llDialog(user,txtDia,butDia,myChannel);
}
rezNpc()
{
    string show=llList2String(appear,ind);
    if (show=="")
    {
        llRegionSayTo(user,0,"ERROR! There are no apperanaces in inventory!");
        user=NULL_KEY;
        return;
    }
    npc=osNpcCreate("NPC","Model",llGetPos()+<0,0,2>,show,8);   //flag 8 = access perms compatible with both Opensim 0,9 parcel perm changes and all previous Opensim versions
    llSleep(0.25);  // ugly but necessary delay before sitting...give NPC time to register properly
    osNpcSit(npc,llGetKey(),OS_NPC_SIT_NOW);
}
setAppearance()
{
    if (osIsNpc(npc)) osNpcLoadAppearance(npc,llList2String(appear,ind));
    llSetText(llList2String(appear,ind)+"\n("+(string)(ind+1)+" of "+(string)llGetListLength(appear)+")",textColour,(float)showFloatyText);
}
startAnimation()
{
    if (!osIsNpc(npc)) return;
    llSleep(0.25); // need to sleep for 0.25 just to give the sit animation a chance to register, but this may still not be long enough to work around the long-standing Opensim bug
    list anToStop=llGetAnimationList(npc);
    osAvatarPlayAnimation(npc,anim);
    integer stop=llGetListLength(anToStop);
    while (--stop>=0) { osAvatarStopAnimation(npc,llList2String(anToStop,stop));}
}
buildAppear()
{
    appear=[];
    ind = llGetInventoryNumber(INVENTORY_NOTECARD);
    while (--ind>=0) { appear = []+[llGetInventoryName(INVENTORY_NOTECARD,ind)]+appear;}
    if (llGetListLength(appear)) ind=0;
    else ind=-1;
}
default
{
    state_entry()
    {
        if (llGetInventoryNumber(INVENTORY_ANIMATION)>0) anim=llGetInventoryName(INVENTORY_ANIMATION,0);
        else anim="stand";
        llSetClickAction(CLICK_ACTION_TOUCH);
        myChannel=0x80000000 | (integer)("0x"+(string)llGetKey());
        user=NULL_KEY;
        buildAppear();
        if (ind==-1)
        {
            llOwnerSay("WARNING: No appearance notecards found in inventory. Disabling script.");
            return;
        }
        if (sitPos==ZERO_VECTOR) sitPos=<0,0,0.00001>;
        llSitTarget(sitPos,ZERO_ROTATION);
        // if NPC found sitting, make this my NPC
        npc=llAvatarOnSitTarget();
        if (npc!=NULL_KEY)
        {
            if (!osIsNpc(npc))
            {
                llRegionSayTo(npc,0,"Sorry, this item is for NPCs to sit on only");
                llUnSit(npc);
                npc=NULL_KEY;
            }
            else
            {
                setAppearance();
                startAnimation();
            }
        }
    }
    timer()
    {
        llSetTimerEvent(0.0);
        llRegionSayTo(user,0,"Dialog timed out.");
        llListenRemove(handle);
        user=NULL_KEY;
    }
    on_rez(integer foo)
    {
        llResetScript();
    }
    changed(integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION_START) llResetScript();
    }
    touch_start(integer num)
    {
        key who=llDetectedKey(0);
        if (ownerOnly && (who!=llGetOwner())) llRegionSayTo(who,0,"Sorry, only the owner can use this");
        else if (ind==-1) llRegionSayTo(who,0,"ERROR: no appearance notecards found. Please add some, then reset the script.");
        else if (user!=NULL_KEY)
        {
            if (who==user) showMenu();
            else llRegionSayTo(who,0,"Sorry, this item is already in use.");
        }
        else
        {
            user=who;
            if (npc==NULL_KEY)
            {
                rezNpc();
                startAnimation();
            }
            if (user!=NULL_KEY) showMenu(); // can become null key if no appearance were found in inventory
        }
    }
    listen (integer channel,string name, key who, string message)
    {
        llListenRemove(handle);
        llSetTimerEvent(0.0);
        if (message=="DONE") 
        {
            user=NULL_KEY;
            return;
        }
        if (message=="REZ")
        {
            rezNpc();
            if (user==NULL_KEY) return; // user becomes null key when no appearances exist
        }
        else if (message=="KILL")
        {
            if (osIsNpc(npc)) osNpcRemove(npc);
            npc=NULL_KEY;
        }
        else if (message=="GIVE")
        {
            string card=llList2String(appear,ind);
            if ((card=="") || (llGetInventoryType(card)!=INVENTORY_NOTECARD))
            {
                llRegionSayTo(user,0,"ERROR: unable to find the expected card...resetting the script to pick up the necessary inventory changes");
                llResetScript();
                return;
            }
            llRegionSayTo(user,0,"Give you the appearance notecard: "+card+"\nYou will find it in your notecards folder or your suitcase's notecard folder depending on whether you're in your home grid or not");
            llGiveInventory(user,card);
        }
        else if (message=="DELETE")
        {
            string card=llList2String(appear,ind);
            if ((card=="") || (llGetInventoryType(card)!=INVENTORY_NOTECARD))
            {
                llRegionSayTo(user,0,"ERROR: unable to find the expected card...resetting the script to pick up the necessary inventory changes");
                llResetScript();
                return;
            }
            llRemoveInventory(card);
            llRegionSayTo(user,0,"Appearance notecard deleted: "+card);
            appear=[]+llDeleteSubList(appear,ind,ind);
            if (llGetListLength(appear)==0)
            {
                llRegionSayTo(user,0,"There are no more appearance notecards in inventory. Removing NPC (if any) and resetting script");
                if (osIsNpc(npc)) osNpcRemove(npc);
                npc=NULL_KEY;
                llResetScript();
                return;
            }
            if (ind>=llGetListLength(appear)) ind=0;
            setAppearance();
        }
        else
        {
            if (llGetListLength(appear)==1) llRegionSayTo(user,0,"There is only one appearance in inventory...can't change appearance");
            else
            {
                if (message=="< PREV") ind--;
                else if (message=="NEXT >") ind++;
                else
                {
                    llOwnerSay("ERROR! Unexpected menu response: "+message);
                    return;
                }
                if (ind<0) ind=llGetListLength(appear)-1;
                else if (ind>=llGetListLength(appear)) ind=0;
                setAppearance();
            }
        }
        showMenu();
    }
}
