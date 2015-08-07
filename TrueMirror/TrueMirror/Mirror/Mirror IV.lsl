// :SHOW:
// :CATEGORY:NPC
// :NAME:TrueMirror
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:
// :CREATED:2015-07-24 03:39:05
// :EDITED:2015-07-24  02:39:05
// :ID:1083
// :NUM:1813
// :REV:1.1
// :WORLD:OpenSim
// :DESCRIPTION:
// NPC True Mirror script
// :CODE:
// Mirror script
// by Aine Caoimhe (c. LACM) July 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/

// Mods: Ferd Frederix tweaked it slightly to use the mirrored animations from a web site
// You can use the BVH Mirror web site at http://tali.appspot.com/bvh/bvhmirror.html to flip any animation around
// You can get free, open source animations at www.outworldz.com/download

//
// When an avatar sits on an object containing this script the avi will be cloned to an NPC who will also sit
// Paired aniamtions supplied in the object will be played, making it appear as though the NPC is the mirrored user
// If the sitter touches the mirror it will advance to the next pose (if there are more to play)
// when the sitter stands, the NPC is removed
// (Note: if sitter changes appearance during use the NPC will not change to copy that change...it will continue to appear as intiailly rezzed)
//
// Place this script in the ROOT prim which can either be the mirror object itself or an invisible prim placed at that location.
// It is assumed that the root prim's XZ-plane is the axis to be mirrored
//
// Add animations to the contents of the root prim in pairs where each pair consists of:
//      - an animation for the sitter to play
//      - an animation that mirrors this, that has the IDENTICAL NAME with " mirrored" (including the leading space) added after it
//      example: "sit 1" and "sit 1 mirrored"
// DO NOT have a main sitter pose end with the word mirror because it would be interpretted as being a mirror pose and ignored
// 
// ***** IF YOU ADD OR REMOVE ANIMATIONS YOU WILL NEED TO RESET THE SCRIPT TO PICK UP THE CHANGES!!! *****
//
// The sitter's pose position is determined by the base sitPos and sitRot settings (see user settings section below) UNLESS you
// overide these for an animation by placing new values in the DESCRIPTION field of the main pose in the format:
//      <sitpose>::<sit rot>        <--- note the double colon separator between position and rotation
//                                  example:  <0.0, 1.0, 0.0>::<0.0, 0.0, 0.0, 1.0>
// at which point the sitter will be moved to that sit target posision instead
//
// In all cases, the clone (mirror NPC) will be positioned exactly 180 rotated around the root prim's LOCAL Z axis
// If you have already rotated the mirror pose animation on axis when creating the mirror and do not need it subequently rotated
// when the clone NPC plays it, set the user variable mirrorRot to FALSE, otherwise leave it TRUE (this applies to all animations played
// so you can't use a mixture of both, sorry)

//
// USER SETTINGS

integer sayPoseName=FALSE;                   // TURE = owner will be told the name of the pose each time one is activated, FALSE = mirror will be silent
integer userName=FALSE;                     // TRUE = NPC will have the sitter's name, FALSE = NPC will have empty name
// use something like the Magic Sit Kit to set the value of these two
vector sitPos=<0.0, 1.0, 0.0>;              // base sit target position to set for the main sitter relative to the mirror - NPC clone will mirror this position on the opposite side of the mirror
rotation sitRot=<0.0, 0.0, 0.0, 1.0>;       // base sit target rotation to set for the main sitter relative to the mirror - NPC clone will mirror this on the opposite side of the mirror
integer mirrorRot=TRUE;     // FALSE = the mirror animations you are supplying are already rotated on root; TRUE = they need to be rotated by the script
string baseAn="*****base__stand priority 1";    // name of a base priority 1 animation to use for underlying synch (no mirror pose of it is needed)
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
// DO NOT CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
list poses;
list mirrors;
integer anIndex;
key user;
key npc;
integer linkNpc;
integer linkUser;

updatePositions()
{
    vector pos=sitPos;
    rotation rot=sitRot;
    // see if this pose requires position override
    string posOverride=osGetInventoryDesc(llList2String(poses,anIndex));
    if (llSubStringIndex(posOverride,"::")>=0)
    {
        list orData=llParseString2List(posOverride,["::"],[]);
        pos=llList2Vector(orData,0);
        rot=llList2Rot(orData,1);
    }
    vector size = llGetAgentSize(user);
    float fAdjust = ((((0.008906 * size.z) + -0.049831) * size.z) + 0.088967) * size.z;
    vector newPos=(pos + <0.0, 0.0, 0.4>) - (llRot2Up(rot) * fAdjust);
    llSetLinkPrimitiveParamsFast(linkUser, [PRIM_POS_LOCAL,newPos,PRIM_ROT_LOCAL, rot]);
    newPos.y=-newPos.y;
    if (mirrorRot)
    {
        vector aviRot=llRot2Euler(rot);
        aviRot.z=-aviRot.z;
        aviRot.x=-aviRot.x;
        rot =llEuler2Rot(aviRot);
    }
    llSetLinkPrimitiveParamsFast(linkNpc, [PRIM_POS_LOCAL,newPos,PRIM_ROT_LOCAL, rot]);
    if (sayPoseName) llOwnerSay("New pose: "+llList2String(poses,anIndex));
}
buildPoseList()
{
    list an;
    poses=[];
    mirrors=[];
    integer i=llGetInventoryNumber(INVENTORY_ANIMATION);
    while (--i>=0) { an=[]+[llGetInventoryName(INVENTORY_ANIMATION,i)]+an; }
    i=llListFindList(an,[baseAn]);
    if (i==-1)
    {
        llOwnerSay("ERROR! Unable to locate the base priototy 1 aniamtion: "+baseAn);
        user="ERROR";
    }
    else an=[]+llDeleteSubList(an,i,i);
    i=llGetListLength(an);
    while (--i>=0)
    {
        string name=llList2String(an,i);
        if (llGetSubString(name,-7,-1)!=" mirrored") // tweak by FKB to use web site naming
        {
            integer m=llListFindList(an,[name+" mirrored"]);
            if (m==-1) llOwnerSay("WARNING: found an animation with the name \""+name+"\" but no matching animation was located");
            else
            {
                poses=[]+[name]+poses;
                mirrors=[]+[name+" mirror"]+mirrors;
            }
        }
    }
    // double-check even though mismatch ought to be impossible;
    if (llGetListLength(poses)!=llGetListLength(mirrors))
    {
        llOwnerSay("ERROR! Somehow build pose and mirror lists with mismatched lengths. Dump of data:\n\nPOSES: "+llDumpList2String(poses,", ")+"\nMIRRORS: "+llDumpList2String(mirrors,", "));
        user="ERROR";
    }
    else
    {
        anIndex=0;
        if (llGetListLength(poses)==1) llOwnerSay("Pose list built. Found only 1 mirrored pose in inventory so disabling touch advance");
        else llOwnerSay("Pose list built. Found "+(string)llGetListLength(poses)+" mirrored pose in inventory");
    }
}
cleanSitters()
{
    user=NULL_KEY;
    npc=NULL_KEY;
    integer l=llGetNumberOfPrims();
    while (l>0)
    {
        key who=llGetLinkKey(l);
        if (llGetAgentSize(who)==ZERO_VECTOR) l=0; // agents are always the last link numbers
        else
        {
            if (osIsNpc(who)) osNpcRemove(who);
            else
            {
                llRegionSayTo(who,0,"Sorry, the system has been reset so you will need to sit down again");
                llUnSit(who);
            }
        }
        l--;
    }
}
default
{
    state_entry()
    {
        buildPoseList();
        llSitTarget(<0.0, 0.0, 0.000001>,ZERO_ROTATION);
        llSetClickAction(CLICK_ACTION_SIT);
        if (user=="ERROR") llOwnerSay("Cannot active device until animation list building errors are correct");
        else cleanSitters();
    }
    on_rez(integer foo)
    {
        llResetScript();
    }
    touch_start(integer num)
    {
        key who=llDetectedKey(0);
        if (who!=user)
        {
            if (user==NULL_KEY) llRegionSayTo(who,0,"Please sit on me to use me");
            else llRegionSayTo(who,0,"Sorry, only the current user can touch me");
        }
        else
        {
            if (llGetListLength(poses)==1) return;   // with only 1 pose no changing
            osAvatarStopAnimation(user,llList2String(poses,anIndex));
            osAvatarStopAnimation(npc,llList2String(mirrors,anIndex));
            anIndex++;
            if (anIndex>=llGetListLength(poses)) anIndex=0;
            osAvatarPlayAnimation(user,llList2String(poses,anIndex));
            osAvatarPlayAnimation(npc,llList2String(mirrors,anIndex));
            updatePositions();
        }
    }
    changed (integer change)
    {
        if (change & CHANGED_OWNER) llResetScript();
        if (change & CHANGED_REGION_START) llResetScript();
        if (change & CHANGED_INVENTORY) llOwnerSay("Detected a change in inventory. Remember to reset the script if you have changed the animations");
        if (change & CHANGED_LINK)
        {
            // find out who is currently sitting
            list aviSitters=[];
            list npcSitters=[];
            integer l=llGetNumberOfPrims();
            while (l>0)
            {
                key who=llGetLinkKey(l);
                if (llGetAgentSize(who)==ZERO_VECTOR) l=0;  // sitters are always last links
                else
                {
                    if (osIsNpc(who))
                    {
                        npcSitters=[]+[who]+npcSitters;
                        if (who==npc) linkNpc=l;
                    }
                    else
                    {
                        aviSitters=[]+[who]+aviSitters;
                        if (who==user) linkUser=l;
                    }
                }
                l--;
            }
            if (user==NULL_KEY)
            {
                l=llGetListLength(npcSitters);
                while (--l>=0) { osNpcRemove(llList2Key(npcSitters,l)); }
                npc=NULL_KEY;
                if (llGetListLength(aviSitters)==0)
                {
                    llSetClickAction(CLICK_ACTION_SIT); // back to sit as default action
                    return;     // link change triggered by user standing or a change in some other linkset action
                }
                // getting here means a new avi sat
                user=llList2Key(aviSitters,0);
                osAvatarPlayAnimation(user,baseAn); // initiate base an
                llSetClickAction(CLICK_ACTION_TOUCH);   // now in use so default action should be touch
                string first=" ";
                string last=" ";
                if (userName)
                {
                    string nameToParse=llList2String(llGetObjectDetails(user,[OBJECT_NAME]),0);
                    list parsedName=llParseString2List(nameToParse,[" ",".","@"],[]);
                    first=llList2String(parsedName,0);
                    last=llList2String(parsedName,1);
                }
                npc=osNpcCreate(first,last,llGetPos()+<0.0,0.0,1.0>,user);
                osAvatarPlayAnimation(npc,baseAn);
                osNpcSit(npc,llGetKey(),OS_NPC_SIT_NOW);
                // everything else handled when NPC is detected as sitting
            }
            else if (user=="ERROR")
            {
                l=llGetListLength(npcSitters);
                while (--l>=0) { osNpcRemove(llList2Key(npcSitters,l)); }
                l=llGetListLength(aviSitters);
                while (--l>=0)
                {
                    llRegionSayTo(llList2Key(aviSitters,l),0,"Sorry, the mirror has encountered an error and needs to be reset");
                    llUnSit(llList2Key(aviSitters,l));
                }
            }
            else
            {
                // we already have a user on record
                if (llListFindList(aviSitters,[user])==-1)
                {
                    // but no longer sitting so need to release animations, clear user, and remove NPC
                    if (llGetAgentSize(user)!=ZERO_VECTOR)
                    {
                        osAvatarPlayAnimation(user,"Stand");
                        osAvatarStopAnimation(user,llList2Key(poses,anIndex));
                        osAvatarStopAnimation(user,baseAn);
                    }
                    user=NULL_KEY;
                    if (osIsNpc(npc))
                    {
                        osNpcRemove(npc);
                        npc=NULL_KEY;
                    }
                    llSetClickAction(CLICK_ACTION_SIT); // back to sit as default action
                }
                // make sure someone else didn't sit down when user was set
                l=llGetListLength(aviSitters);
                while (--l>=0)
                {
                    if (llList2Key(aviSitters,l)!=user)
                    {
                        llRegionSayTo(llList2Key(aviSitters,l),0,"Sorry, the mirror is already being used by someone else");
                        llUnSit(llList2Key(aviSitters,l));
                    }
                }
                // prevent any NPC from sitting other than the current one on record
                l=llGetListLength(npcSitters);
                while (--l>=0) { if (llList2Key(npcSitters,l)!=npc) osNpcRemove(llList2Key(npcSitters,l)); }
                if ((npc!=NULL_KEY) && osIsNpc(npc))
                {
                    // most of the time we only get here if a new NPC sat after initial creation so this should trigger start of animation
                    // need to wait briefly for base an to kick in
                    llSleep(0.25);
                    // then clear any existing AO/sit animations
                    key dontStop=llGetInventoryKey(baseAn);
                    list anToStop=llGetAnimationList(user);
                    l=llGetListLength(anToStop);
                    while (--l>=0) { if (llList2Key(anToStop,l)!=dontStop) osAvatarStopAnimation(user,llList2Key(anToStop,l)); }
                    anToStop=[]+llGetAnimationList(npc);
                    l=llGetListLength(anToStop);
                    while (--l>=0) { if (llList2Key(anToStop,l)!=dontStop) osAvatarStopAnimation(npc,llList2Key(anToStop,l)); }
                    // now start the mirrored animations
                    osAvatarPlayAnimation(user,llList2String(poses,anIndex));
                    osAvatarPlayAnimation(npc,llList2String(mirrors,anIndex));
                    updatePositions();
                }
            }
        }
    }
}
