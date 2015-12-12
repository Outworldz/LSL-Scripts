// :SHOW:
// :CATEGORY:NPC
// :NAME:Paramour Multi-Purpose NPC Rez & Pose
// :AUTHOR:Aine Caoimhe (Mata Hari)
// :KEYWORDS:
// :CREATED:2015-11-24 20:38:29
// :EDITED:2015-11-24  19:38:29
// :ID:1093
// :NUM:1869
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
Paramour Multi-Purpose NPC Rez & Pose//:License: Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
//CODE:
// Paramour Multi-Purpose NPC Rez & Pose
// by Aine Caoimhe (Mata Hari)(c. LACM) April 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// - Place this script in any object
// - Optionally set a different target for the NPC to sit on when rezzed
// - Optionally set the script to auto-rez an NPC if there is a notecard in inventory to use for the NPC's appearance (autorez will occur on script reset or region restart)
// - Optionally, add one or more animations for the NPC to use if controlling animations from this object. If more than one is found the NPC will cycle through them
// - Optionally, add one NPC notecard with the name ".NPCxxp Firstname Lastname" to the object. If more than one is found, the first one will be used. If none are
//   found the toucher's appearance is used and (optionally) stored to the object
//   The name conforms to the PMAC sytem NPC naming convensions where xx is used to sort the card order and p is the permission seting where A=all, G=group, and O=owner
//   but these permission settings are ignored by this script nor is there any error-checking for them -- your card will work as long as it is 3 words where the first word
//   begins with ".NPC" (dot then capital letters N P C)
//
// If you change the contents of the object (add/remove animations or notecards) you MUST reset the script to pick up those changes
// If the object containing the script is worn, it is disabled
// If the script is controlling a NPC, touching the object will remove the NPC
// If the script isn't controlling a NPC, touching the object will rez the NPC either from notecard or via cloning the toucher
// If a NPC is found standing on this object when reset, the script will assume control of that NPC. It can't do that for NPCs on other targets so remember
// to remove one before resetting this script. If you accidentally strand a NPC, use the Paramour NPC Manager to remove it.
//
// OSSL functions required:
//      osIsUUID()
//      osIsNpc()
//      osNpcCreate()
//      osNpcRemove()
//      osTeleportAgent() if rezzing to a target that is more than 10m away from the object containing this script
//      osAvatarPlayAnimation() if the option to animate the NPC is being used
//      osAvatarStopAnimation() if the option to animate the NPC is being used
//      osAgentSaveAppearance() if the option to store toucher appearance is being used
// 
// USER SETTINGS
integer ownerOnly=TRUE;     // TRUE = only owner can touch to rez/remove NPC; FALSE = anyone can
integer hideInUse=TRUEE;    // TRUE = set this object to invisible when a NPC is being controlled by it (useful when using this as a hidden poseball though then you'll have to
                            // remember where you placed it); FALSE = don't hide this object. Note if this is part of a linkset only this prim is hidden
key target=1b600ed6-c416-457c-bae0-7f3397befa42"";              // supply the key of the object you want the NPC to sit on or leave empty ("") to have the NPC sit on this object
integer animateNpc=FALSE;   // TRUE = this object will handle animations if one or more are found in inventory; FALSE = another script will handle aniamtions
float animationTimer=60.0;  // If this script is handling animations and more than one is found, how often to switch to the next animation (it also does a presense check)
integer randomAnim=TRUE;    // If more than 1 animation is found in inventory, play animations in random order (list will be re-randomized after each has played once)
integer autoRez=TRUE;       // TRUE = if there is an appearance notecard in inventory, auto-rez that NPC any time the region restarts or this script is reset; FALSE = only rez on touch
integer storeToucher=TRUE;  // TRUE = if there is no appearance notecard in inventory, store the toucher's appearance when cloning them (subject to permission from the target)
string floatyText="Paramour Multi-Purpose NPC Rez & Pose";   // text to have floating above the object or supply an empty string ( "") for none
vector floatyTextColour=<1.000, 0.906, 0.502>;  // LSL vector colour to use for the text (<0.0, 0.0, 0.0> = black, <1.0, 1.0, 1.0> = white)
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
list anims;
integer indAnim;
key npc=NULL_KEY;
string npcToRez;
string firstName;
string lastName;
integer myChannel;
integer handle;

startAnimation()
{
    buildAnimList();
    if (llGetListLength(anims)==0) return;
    string anToPlay=llList2String(anims,indAnim);
    key dontStop=llGetInventoryKey(anToPlay);
    osAvatarPlayAnimation(npc,anToPlay);
    list anToStop=llGetAnimationList(npc);
    integer stop=llGetListLength(anToStop);
    while (--stop>=0) { if (llList2Key(anToStop,stop)!=dontStop) osAvatarStopAnimation(npc,llList2String(anToStop,stop)); }
    if (llGetListLength(anims)>1) llSetTimerEvent(animationTimer);
}
doRezNpc(key clone, integer perm)
{
    if (npcToRez=="")
    {
        if (storeToucher)
        {
            if (!perm)
            {
                myChannel=0x80000000|(integer)("0x"+(string)llGetKey());
                handle=llListen(myChannel,"",clone,"");
                llSensorRepeat("",clone,AGENT,32.0,PI,60.0);
                llDialog(clone,"This object would like your permission to clone and store your appearance to a NPC notecard. Will you permit this?\nA no response will be assumed if you don't respond within 60 seoncds",["YES","NO","CANCEL"],myChannel);
                return;
            }
            else
            {
                getNameData(clone);
                osAgentSaveAppearance(clone,npcToRez);
                llSleep(0.25);  // give a little time to store the data and have it register to prim's inventory
            }
        }
        else
        {
            getNameData(clone);
            npcToRez=clone;
        }
    }
    else if (llGetInventoryType(npcToRez)!=INVENTORY_NOTECARD)
    {
        llRegionSayTo(clone,0,"Unable to locate the expected appearance notecard in inventory. Perhaps you deleted it without resetting the script? Resetting the script now. Please wait a moment, then touch me again to resume");
        llResetScript();
        return;
    }
    npc=osNpcCreate(firstName,lastName,llGetPos()+<0.0,0.0,2.0>,npcToRez,OS_NPC_SENSE_AS_AGENT);
    if (hideInUse)
    {
        llSetLinkAlpha(LINK_THIS,0.0,ALL_SIDES);
        llSetText(floatyText,floatyTextColour,0.0);
    }
    vector targetPos=llGetPos();
    if (target=="") target=llGetKey();
    else if (target==NULL_KEY) target=llGetKey();
    else if (osIsUUID(target))
    {
        list data=llGetObjectDetails(target,[OBJECT_POS]);
        if (data==[])
        {
            llRegionSayTo(clone,0,"Unable to find the target specified in the script in this region. Using this object as the target instead");
            target=llGetKey();
        }
        else targetPos=llList2Vector(data,0); 
    }
    else
    {
        llRegionSayTo(clone,0,"Your target does not appear to be a valid key. Using this object as the target instead");
        target=llGetKey();
    }
    if (llVecDist(targetPos,llGetPos())>10.0) osTeleportAgent(npc,targetPos+<0.0,0.0,2.0>,ZERO_VECTOR);
    osNpcSit(npc,target,OS_NPC_SIT_NOW);
    if (animateNpc)
    {
        llSleep(0.25);  // have to wait for the LSL sit animation to register to the npc's animation list
        startAnimation();
    }
}
getNameData(key name)
{
    list nameParsed=llParseString2List(llKey2Name(name),["."," "],[]);
    firstName=llList2String(nameParsed,0);
    lastName=llList2String(nameParsed,1);
    if (firstName=="") firstName="Noname";
    if (lastName=="") lastName="NPC";
    npcToRez=".NPC00A "+firstName+" "+lastName;
}
buildAnimList()
{
    anims=[];
    integer i=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--i>=0){ anims=[]+[llGetInventoryName(INVENTORY_ANIMATION,i)]+anims; }
    if (randomAnim) anims=[]+llListRandomize(anims,1);
    indAnim=0;
    if (llGetListLength(anims)==0) llOwnerSay("WARNING! Script is set to handle animations but none could be found in inventory. NPC will play stock SL sit animation");
}
findNpcToRez()
{
    npcToRez="";
    firstName="";
    lastName="";
    integer i;
    while ((npcToRez=="") && (i<llGetInventoryNumber(INVENTORY_NOTECARD)))
    {
        string cardName=llGetInventoryName(INVENTORY_NOTECARD,i);
        if (llSubStringIndex(cardName,".NPC")==0)
        {
            list split=llParseString2List(cardName,[" "],[]);
            npcToRez=cardName;
            firstName=llList2String(split,1);
            lastName=llList2String(split,2);
            if (firstName=="") firstName="Noname";
            if (lastName=="") lastName="NPC";
        }
        i++;
    }
}
default
{
    state_entry()
    {
        if (hideInUse)
        {
            llSetText(floatyText,floatyTextColour,1.0);
            llSetLinkAlpha(LINK_THIS,1.0,ALL_SIDES);
        }
        if (llGetAttached()) return;
        findNpcToRez();
        integer last=llGetNumberOfPrims();
        if (osIsNpc(llGetLinkKey(last)))
        {
            npc=llGetLinkKey(last);
            if (animateNpc) startAnimation();
        }
        else npc=NULL_KEY;
        if ((autoRez) && (npc==NULL_KEY) && (npcToRez!="")) doRezNpc(llGetOwner(),FALSE);
    }
    no_sensor()
    {
        llSensorRemove();
    }
    sensor(integer foo)
    {
        llRegionSayTo(llDetectedKey(0),0,"Dialog timed out. Assuming your response is NO so aborting the request to rez a NPC");
        llSensorRemove();
    }
    listen (integer channel, string name, key who, string message)
    {
        llSensorRemove();
        if (message=="YES") doRezNpc(who,TRUE);
        else llRegionSayTo(who,0,"Aborting the request to rez a NPC");
    }
    on_rez(integer foo)
    {
        llResetScript();
    }
    changed (integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION_START) llResetScript();
    }
    timer()
    {
        if (llGetAgentSize(npc)==ZERO_VECTOR)
        {
            llOwnerSay("Unable to find NPC");
            npc=NULL_KEY;
            llSetTimerEvent(0.0);
            llResetScript();
            return;
        }
        string animToStop=llList2String(anims,indAnim);
        indAnim++;
        if (indAnim>llGetListLength(anims))
        {
            indAnim=0;
            if (randomAnim) anims=[]+llListRandomize(anims,1);
        }
        string animToStart=llList2String(anims,indAnim);
        if (animToStart!=animToStop)
        {
            osAvatarPlayAnimation(npc,animToStart);
            osAvatarStopAnimation(npc,animToStop);
        }
    }
    touch_start(integer num)
    {
        if (llGetAttached()) return;
        key toucher=llDetectedKey(0);
        if (ownerOnly && (toucher!=llGetOwner()))
        {
            llRegionSayTo(toucher,0,"Sorry, you don't have permission to use this");
            return;
        }
        if (npc==NULL_KEY) doRezNpc(toucher,FALSE);
        else if (llGetAgentSize(npc)==ZERO_VECTOR)
        {
            npc=NULL_KEY;
            llSetTimerEvent(0.0);
            doRezNpc(toucher,FALSE);
        }
        else
        {
            osNpcRemove(npc);
            npc=NULL_KEY;
            llSetTimerEvent(0.0);
            llRegionSayTo(toucher,0,"NPC removed");
            if (hideInUse)
            {
                llSetLinkAlpha(LINK_THIS,1.0,ALL_SIDES);
                llSetText(floatyText,floatyTextColour,1.0);
            }
            llResetScript();
        }
    }
}
// :CODE:
//:AUTHOR: Aine Caoimhe (Mata Hari)
//:DESCRIPTION:Paramour Multi-Purpose NPC Rez & Pose
//:License: Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
//CODE:
// Paramour Multi-Purpose NPC Rez & Pose
// by Aine Caoimhe (Mata Hari)(c. LACM) April 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// - Place this script in any object
// - Optionally set a different target for the NPC to sit on when rezzed
// - Optionally set the script to auto-rez an NPC if there is a notecard in inventory to use for the NPC's appearance (autorez will occur on script reset or region restart)
// - Optionally, add one or more animations for the NPC to use if controlling animations from this object. If more than one is found the NPC will cycle through them
// - Optionally, add one NPC notecard with the name ".NPCxxp Firstname Lastname" to the object. If more than one is found, the first one will be used. If none are
//   found the toucher's appearance is used and (optionally) stored to the object
//   The name conforms to the PMAC sytem NPC naming convensions where xx is used to sort the card order and p is the permission seting where A=all, G=group, and O=owner
//   but these permission settings are ignored by this script nor is there any error-checking for them -- your card will work as long as it is 3 words where the first word
//   begins with ".NPC" (dot then capital letters N P C)
//
// If you change the contents of the object (add/remove animations or notecards) you MUST reset the script to pick up those changes
// If the object containing the script is worn, it is disabled
// If the script is controlling a NPC, touching the object will remove the NPC
// If the script isn't controlling a NPC, touching the object will rez the NPC either from notecard or via cloning the toucher
// If a NPC is found standing on this object when reset, the script will assume control of that NPC. It can't do that for NPCs on other targets so remember
// to remove one before resetting this script. If you accidentally strand a NPC, use the Paramour NPC Manager to remove it.
//
// OSSL functions required:
//      osIsUUID()
//      osIsNpc()
//      osNpcCreate()
//      osNpcRemove()
//      osTeleportAgent() if rezzing to a target that is more than 10m away from the object containing this script
//      osAvatarPlayAnimation() if the option to animate the NPC is being used
//      osAvatarStopAnimation() if the option to animate the NPC is being used
//      osAgentSaveAppearance() if the option to store toucher appearance is being used
// 
// USER SETTINGS
integer ownerOnly=TRUE;     // TRUE = only owner can touch to rez/remove NPC; FALSE = anyone can
integer hideInUse=TRUEE;    // TRUE = set this object to invisible when a NPC is being controlled by it (useful when using this as a hidden poseball though then you'll have to
                            // remember where you placed it); FALSE = don't hide this object. Note if this is part of a linkset only this prim is hidden
key target=1b600ed6-c416-457c-bae0-7f3397befa42"";              // supply the key of the object you want the NPC to sit on or leave empty ("") to have the NPC sit on this object
integer animateNpc=FALSE;   // TRUE = this object will handle animations if one or more are found in inventory; FALSE = another script will handle aniamtions
float animationTimer=60.0;  // If this script is handling animations and more than one is found, how often to switch to the next animation (it also does a presense check)
integer randomAnim=TRUE;    // If more than 1 animation is found in inventory, play animations in random order (list will be re-randomized after each has played once)
integer autoRez=TRUE;       // TRUE = if there is an appearance notecard in inventory, auto-rez that NPC any time the region restarts or this script is reset; FALSE = only rez on touch
integer storeToucher=TRUE;  // TRUE = if there is no appearance notecard in inventory, store the toucher's appearance when cloning them (subject to permission from the target)
string floatyText="Paramour Multi-Purpose NPC Rez & Pose";   // text to have floating above the object or supply an empty string ( "") for none
vector floatyTextColour=<1.000, 0.906, 0.502>;  // LSL vector colour to use for the text (<0.0, 0.0, 0.0> = black, <1.0, 1.0, 1.0> = white)
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
list anims;
integer indAnim;
key npc=NULL_KEY;
string npcToRez;
string firstName;
string lastName;
integer myChannel;
integer handle;

startAnimation()
{
    buildAnimList();
    if (llGetListLength(anims)==0) return;
    string anToPlay=llList2String(anims,indAnim);
    key dontStop=llGetInventoryKey(anToPlay);
    osAvatarPlayAnimation(npc,anToPlay);
    list anToStop=llGetAnimationList(npc);
    integer stop=llGetListLength(anToStop);
    while (--stop>=0) { if (llList2Key(anToStop,stop)!=dontStop) osAvatarStopAnimation(npc,llList2String(anToStop,stop)); }
    if (llGetListLength(anims)>1) llSetTimerEvent(animationTimer);
}
doRezNpc(key clone, integer perm)
{
    if (npcToRez=="")
    {
        if (storeToucher)
        {
            if (!perm)
            {
                myChannel=0x80000000|(integer)("0x"+(string)llGetKey());
                handle=llListen(myChannel,"",clone,"");
                llSensorRepeat("",clone,AGENT,32.0,PI,60.0);
                llDialog(clone,"This object would like your permission to clone and store your appearance to a NPC notecard. Will you permit this?\nA no response will be assumed if you don't respond within 60 seoncds",["YES","NO","CANCEL"],myChannel);
                return;
            }
            else
            {
                getNameData(clone);
                osAgentSaveAppearance(clone,npcToRez);
                llSleep(0.25);  // give a little time to store the data and have it register to prim's inventory
            }
        }
        else
        {
            getNameData(clone);
            npcToRez=clone;
        }
    }
    else if (llGetInventoryType(npcToRez)!=INVENTORY_NOTECARD)
    {
        llRegionSayTo(clone,0,"Unable to locate the expected appearance notecard in inventory. Perhaps you deleted it without resetting the script? Resetting the script now. Please wait a moment, then touch me again to resume");
        llResetScript();
        return;
    }
    npc=osNpcCreate(firstName,lastName,llGetPos()+<0.0,0.0,2.0>,npcToRez,OS_NPC_SENSE_AS_AGENT);
    if (hideInUse)
    {
        llSetLinkAlpha(LINK_THIS,0.0,ALL_SIDES);
        llSetText(floatyText,floatyTextColour,0.0);
    }
    vector targetPos=llGetPos();
    if (target=="") target=llGetKey();
    else if (target==NULL_KEY) target=llGetKey();
    else if (osIsUUID(target))
    {
        list data=llGetObjectDetails(target,[OBJECT_POS]);
        if (data==[])
        {
            llRegionSayTo(clone,0,"Unable to find the target specified in the script in this region. Using this object as the target instead");
            target=llGetKey();
        }
        else targetPos=llList2Vector(data,0); 
    }
    else
    {
        llRegionSayTo(clone,0,"Your target does not appear to be a valid key. Using this object as the target instead");
        target=llGetKey();
    }
    if (llVecDist(targetPos,llGetPos())>10.0) osTeleportAgent(npc,targetPos+<0.0,0.0,2.0>,ZERO_VECTOR);
    osNpcSit(npc,target,OS_NPC_SIT_NOW);
    if (animateNpc)
    {
        llSleep(0.25);  // have to wait for the LSL sit animation to register to the npc's animation list
        startAnimation();
    }
}
getNameData(key name)
{
    list nameParsed=llParseString2List(llKey2Name(name),["."," "],[]);
    firstName=llList2String(nameParsed,0);
    lastName=llList2String(nameParsed,1);
    if (firstName=="") firstName="Noname";
    if (lastName=="") lastName="NPC";
    npcToRez=".NPC00A "+firstName+" "+lastName;
}
buildAnimList()
{
    anims=[];
    integer i=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--i>=0){ anims=[]+[llGetInventoryName(INVENTORY_ANIMATION,i)]+anims; }
    if (randomAnim) anims=[]+llListRandomize(anims,1);
    indAnim=0;
    if (llGetListLength(anims)==0) llOwnerSay("WARNING! Script is set to handle animations but none could be found in inventory. NPC will play stock SL sit animation");
}
findNpcToRez()
{
    npcToRez="";
    firstName="";
    lastName="";
    integer i;
    while ((npcToRez=="") && (i<llGetInventoryNumber(INVENTORY_NOTECARD)))
    {
        string cardName=llGetInventoryName(INVENTORY_NOTECARD,i);
        if (llSubStringIndex(cardName,".NPC")==0)
        {
            list split=llParseString2List(cardName,[" "],[]);
            npcToRez=cardName;
            firstName=llList2String(split,1);
            lastName=llList2String(split,2);
            if (firstName=="") firstName="Noname";
            if (lastName=="") lastName="NPC";
        }
        i++;
    }
}
default
{
    state_entry()
    {
        if (hideInUse)
        {
            llSetText(floatyText,floatyTextColour,1.0);
            llSetLinkAlpha(LINK_THIS,1.0,ALL_SIDES);
        }
        if (llGetAttached()) return;
        findNpcToRez();
        integer last=llGetNumberOfPrims();
        if (osIsNpc(llGetLinkKey(last)))
        {
            npc=llGetLinkKey(last);
            if (animateNpc) startAnimation();
        }
        else npc=NULL_KEY;
        if ((autoRez) && (npc==NULL_KEY) && (npcToRez!="")) doRezNpc(llGetOwner(),FALSE);
    }
    no_sensor()
    {
        llSensorRemove();
    }
    sensor(integer foo)
    {
        llRegionSayTo(llDetectedKey(0),0,"Dialog timed out. Assuming your response is NO so aborting the request to rez a NPC");
        llSensorRemove();
    }
    listen (integer channel, string name, key who, string message)
    {
        llSensorRemove();
        if (message=="YES") doRezNpc(who,TRUE);
        else llRegionSayTo(who,0,"Aborting the request to rez a NPC");
    }
    on_rez(integer foo)
    {
        llResetScript();
    }
    changed (integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION_START) llResetScript();
    }
    timer()
    {
        if (llGetAgentSize(npc)==ZERO_VECTOR)
        {
            llOwnerSay("Unable to find NPC");
            npc=NULL_KEY;
            llSetTimerEvent(0.0);
            llResetScript();
            return;
        }
        string animToStop=llList2String(anims,indAnim);
        indAnim++;
        if (indAnim>llGetListLength(anims))
        {
            indAnim=0;
            if (randomAnim) anims=[]+llListRandomize(anims,1);
        }
        string animToStart=llList2String(anims,indAnim);
        if (animToStart!=animToStop)
        {
            osAvatarPlayAnimation(npc,animToStart);
            osAvatarStopAnimation(npc,animToStop);
        }
    }
    touch_start(integer num)
    {
        if (llGetAttached()) return;
        key toucher=llDetectedKey(0);
        if (ownerOnly && (toucher!=llGetOwner()))
        {
            llRegionSayTo(toucher,0,"Sorry, you don't have permission to use this");
            return;
        }
        if (npc==NULL_KEY) doRezNpc(toucher,FALSE);
        else if (llGetAgentSize(npc)==ZERO_VECTOR)
        {
            npc=NULL_KEY;
            llSetTimerEvent(0.0);
            doRezNpc(toucher,FALSE);
        }
        else
        {
            osNpcRemove(npc);
            npc=NULL_KEY;
            llSetTimerEvent(0.0);
            llRegionSayTo(toucher,0,"NPC removed");
            if (hideInUse)
            {
                llSetLinkAlpha(LINK_THIS,1.0,ALL_SIDES);
                llSetText(floatyText,floatyTextColour,1.0);
            }
            llResetScript();
        }
    }
}
