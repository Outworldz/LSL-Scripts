// :SHOW:
// :CATEGORY:NPC
// :NAME:PMAC
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:
// :CREATED:2015-11-24 20:38:40
// :EDITED:2015-11-24  19:38:40
// :ID:1095
// :NUM:1877
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// PARAMOUR MULTI-ANIMATION CONTROLLER (PMAC) v1.02 (OSSL)
// :CODE:


// PARAMOUR MULTI-ANIMATION CONTROLLER (PMAC) v1.02
// by Aine Caoimhe (Mata Hari)(c. LACM) March 2015-May 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// UserConfig added by Seth Nygard March 2015
// modified to store positions for NC_PROPS addon Neo Cortex April 2015
// additional tweaks by Aine Caoimhe May 2015
// *** THIS SCRIPT REQUIRES (AND WILL ONLY WORK) IN REGIONS WHERE THE SCRIPT OWNER HAS OSSL FUNCTION PERMISSIONS ***
// *** THIS SCRIPT MUST ALWAYS BE LOCATED IN THE ROOT PRIM OF A LINKSET ***
//
// *********************************************************
// *****  GENERAL USER SETTINGS - ADJUST AS PREFERED   *****
// *********************************************************
string defaultGroup="Dance";      // name of a group (not the full card name!) to load by default (regardless of its permission setting)
                                    //
integer resetOnQuit=FALSE;           // TRUE = when no more sitters, reset the script (will also load default group again)
                                    // FALSE = leave most recently loaded animation active
integer ownerUseReq=FALSE;          // TRUE = the owner must be the first to sit and other people can only sit while the owner is still present and seated
                                    // FALSE = no restriction...anyone can sit and use it at any time
integer ownerOnlyMenus=FALSE;       // TRUE = only the owner can access the dialog menus (can be turned off in options menu until script is reset or it is turned on again) - NOT RECOMMENDED unless ownerUseReq=TRUE
                                    // FALSE = anyone can be the controller
integer ownerUseUnlocksPerms=FALSE; // TRUE = if owner is a current user, all users then have access to all groups and NPCs
                                    // FALSE = only the owner can ever load an owner-only Group or NPC
integer autoOn=TRUE;               // TRUE = will start in auto mode after a reset
                                    // FALSE = will start in manual mode after a reset -- after use will remain in whatever state it was left in unless resetOnQuit=TRUE
float autoTimer=120.0;              // default time to use for the autotimer (in seconds) - after use will remain at whatever timer was last set to unless resetOnQuit=TRUE;
string gs_ConfigName=".PMAC-CONFIG";     // Name of optional notecard with user defined configuration that overide the above values if present
integer showGroupsMenuFirst=FALSE;  // TRUE = when first initiating dialog, show the groups menu instead of the current group's animation menu; FALSE = show current group's animation menu
integer allowSoloNPC=TRUE;         // TRUE = NPCs can be left rezzed even if there are no avatars seated; FALSE = kill all NPCs if there are no remaining avatars
//
// ***************************************
// *****  ADVANCED/BUILDER SETTINGS  *****
// ***************************************
string handleName="~~~positioner";                  // inventory object to rez as a handle for positioning
list handleColours=[<1.000, 0.004, 0.667>,<0.004, 0.667, 1.000>,<0.667, 1.000, 0.004>,   // colours to use for handles (must supply 9)
                    <1.000, 0.004, 0.004>,<0.004, 0.004, 1.000>,<1.000, 0.667, 0.004>,
                    <0.667, 0.004, 1.000>,<0.004, 1.000, 0.667>,<0.004, 1.000, 0.004>];
vector handleSize=<0.2,0.2,3.0>;                    // size of handles
float handleAlpha=0.5;                              // alpha of handles
string baseAn="~~~~~base_DO_NOT_DELETE_ME!!!!!";    // name of the P1 animation to use for synch
//
// ************************************************
// *****  DO NOT CHANGE ANYTHING BELOW HERE   *****
// *****  UNLESS YOU KNOW WHAT YOU'RE DOING!  *****
// ************************************************
key user;
list positions;
list invNpc;            // fullName | A/G/O | buttonName
integer invNpcStride=3;
list npcList;
integer npcPage;
list invGroups;         // fullName | positions | A/G/O | buttonName
integer invGroupStride=4;
list groupList;
integer groupPage;
integer myChannel;
integer diaHandle;
string menu;
string txtDia;
list butDia;
string currentGroup;
list anData;            // anName | command | A1Name | A1 Pos | A1 Rot | ...
integer anStride;
list anList;
list currentAn;         // groupName | anName | command | A1Name | A1 Pos | A1 Rot | ...
integer anPage;
list editHandles;
integer rezzingHandles;
float editTimer=0.2;
string myState="INITIALIZING";
list specials;          //buttonName | stringToSend
integer specPage;
integer gi_HaveConfig=0;
// NC_PROP ADDON
integer gi_NC_PROP_CHANGED=FALSE;   // global integer flag to indicate if new prop values have been sent form NC_PROPS addon
string gs_NC_PROP_DATA="";          // global string containing changed props data

showAnMenu()
{
    integer maxAn=llGetListLength(anList);
    integer showStart=(anPage+1);
    integer showEnd=(anPage+6);
    if (showEnd>maxAn) showEnd=maxAn;
    txtDia=""+"ANIMATION MENU: Select an animation\n"+currentlyPlaying()+"\nShowing animation";
    if (showEnd!=showStart) txtDia+="s "+(string)showStart+" to "+(string)showEnd;
    else txtDia+=" "+(string)showStart;
    txtDia+=" of "+(string)maxAn+ " total animations in this group\n\n"+llDumpList2String(llList2List(anList,anPage,anPage+5),"\n");
    butDia=[]+llList2List(anList,anPage,anPage+5);
    while (llGetListLength(butDia)<6) { butDia=[]+butDia+["-"]; }
    butDia=[]+butDia+["< PREV","SYNCH","NEXT >","GROUPS","OPTIONS","QUIT"];
    menu="MENU_ANIM";
    startListening();
}
showGroupsMenu()
{
    txtDia=""+"GROUPS MENU: Select a group of animations\n"+currentlyPlaying()+"\nShowing groups "+(string)(groupPage+1)+" to "+(string)(groupPage+6)+" of "+(string)llGetListLength(groupList)+ " total groups\n\n"+llDumpList2String(llList2List(groupList,groupPage,groupPage+5),"\n");
    butDia=[]+llList2List(groupList,groupPage,groupPage+5);
    while (llGetListLength(butDia)<6) { butDia=[]+butDia+["-"]; }
    butDia=[]+butDia+["< PREV","SYNCH","NEXT >","<< BACK","OPTIONS","QUIT"];
    menu="MENU_GROUPS";
    startListening();
}
showEditMenu()
{
    txtDia=""+"EDIT MODE ACTIVE!!!\n"+currentlyPlaying()+" (#"+(string)(llListFindList(anList,[llList2String(currentAn,1)])+1)+" of "+(string)llGetListLength(anList)+")\n\nPlease ensure you have read and are familiar with the PMAC instructions for using the edit menu, particularly if you use add-on modules. You have been warned...";
    butDia=[]+["< PREV","SYNCH","NEXT >","REVERT THIS","STORE THIS","STORE ADDON","EDIT OFF","SAVE CARD","SAVE NEW"];
    menu="MENU_EDIT";
    startListening();
}
showOptionsMenu()
{
    txtDia=""+"OPTIONS MENU:\n\n";
    butDia=[];
    if (user==llGetOwner())
    {
        if (ownerOnlyMenus)
        {
            txtDia+="EDIT ON enters edit mode (all positions must be filled)\nMENUS UNLOCK allows other users to take control\n";
            butDia=[]+butDia+["EDIT ON","MENUS UNLOCK","-"];
        }
        else
        {
            txtDia+="EDIT ON enters edit mode (all positions must be filled)\nMENUS LOCK prevents other users from taking control\n";
            butDia=[]+butDia+["EDIT ON","MENUS LOCK","-"];
        }
    }
    txtDia+="AUTO is used to enable, disable or adjust auto mode\n";
    butDia=[]+butDia+["AUTO","-"];
    if (llGetListLength(specials)>0)
    {
        txtDia+="SPECIAL access special add-on menus\n";
        butDia=[]+butDia+["SPECIAL"];
    }
    else butDia=[]+butDia+["-"];
    txtDia+="SWAP to swap positions\nUNSIT to force someone to stand up or remove a npc\n";
    butDia=[]+butDia+["SWAP","UNSIT"];
    if (llListFindList(positions,[NULL_KEY])>-1)
    {
        txtDia+="ADD NPC to have a npc join you\n";
        butDia=[]+butDia+["ADD NPC"];
    }
    else butDia=[]+butDia+["-"];
    butDia=[]+butDia+["<< BACK","SYNCH","QUIT"];
    menu="MENU_OPTIONS";
    startListening();
}
showSpecialsMenu()
{
    txtDia=""+"SPECIALS MENU\n\nThese are options supplied by any add-ons you have installed. Please consult their instructions for details.\n";
    butDia=[];
    integer i=specPage;
    while (llGetListLength(butDia)<9)
    {
        if (i<llGetListLength(specials))
        {
            butDia=[]+butDia+llList2String(specials,i);
            txtDia+="\n"+llList2String(specials,i);
            i+=2;
        }
        else butDia=[]+butDia+["-"];
    }
    butDia=[]+butDia+["< PREV","CANCEL","NEXT >"];
    menu="MENU_SPECIALS";
    startListening();
}
showAutoMenu()
{
    txtDia="AUTO MENU\n\nAuto mode is currently ";
    butDia=[]+["120","300","600","30","60","90"];
    if (autoOn)
    {
        txtDia+="ON and set to "+(string)llRound(autoTimer)+" seconds\n\nSelect a different time if you wish, or AUTO OFF to switch to manual mode";
        butDia=[]+butDia+["AUTO OFF","-","CANCEL"];
    }
    else
    {
        txtDia+="OFF\n\nSelect AUTO ON to use the last preset time or pick your preferred timer";
        butDia=[]+butDia+["AUTO ON","-","CANCEL"];
    }
    menu="MENU_SELECT_AUTO_MODE";
    startListening();
}
showAddNpcMenu()
{
    txtDia=""+"ADD NPC\n\nSelect the NPC to add. It will occupy the first available position\n\n"+llDumpList2String(llList2List(npcList,npcPage,npcPage+8),"\n");
    butDia=[]+llList2List(npcList,npcPage,npcPage+8);
    while (llGetListLength(butDia)<9) { butDia=[]+butDia+["-"]; }
    butDia=[]+butDia+["< PREV","CANCEL","NEXT >"];
    menu="MENU_ADD_NPC";
    startListening();
}
playAnimation(string name)
{
    if (autoOn) llSensorRemove();
    integer i=llGetListLength(positions);
    while (--i>=0)  { if (llList2Key(positions,i)!=NULL_KEY) osAvatarStopAnimation(llList2Key(positions,i),llList2String(currentAn,3+i*3)); }
    integer indexAn=llListFindList(anData,[name]);
    list nextAn=[currentGroup]+llList2List(anData,indexAn,indexAn+anStride-1);
    integer have=llGetListLength(positions);
    integer need=llRound(((float)llGetListLength(nextAn)-3.0)/3.0);
    while(have<need) { positions=[]+positions+[NULL_KEY];have++; }
    while ((have>need) && (llListFindList(positions,[NULL_KEY])>=0)) { positions=[]+llDeleteSubList(positions,llListFindList(positions,[NULL_KEY]),llListFindList(positions,[NULL_KEY]));have--; }
    if (have>need)
    {
        llSay(0,"Encountered an error in attempting to start a new animation: there are currently too many users seated. You will need to reduce the number of seated users by "+(string)(have-need)+" to play it, or select a different group of animations");
        return;
    }
    i=llGetListLength(positions);
    while (--i>=0)
    {
        key who=llList2Key(positions,i);
        if (who!=NULL_KEY)
        {
            osAvatarPlayAnimation(who,llList2String(nextAn,3+i*3));
            setPosition(who,getUserLink(who),llList2Vector(nextAn,4+i*3),llList2Rot(nextAn,5+i*3));
            if (myState=="EDIT") setHandle(llList2Key(editHandles,i),llList2Vector(nextAn,4+i*3),llList2Rot(nextAn,5+i*3));
        }
    }
    currentAn=[]+nextAn;
    llMessageLinked(LINK_THIS,0,"GLOBAL_NEXT_AN|"+llList2String(currentAn,2),llDumpList2String(positions,"|"));
    if (autoOn) llSensorRepeat("THIS_WILL_NEVER_RETURN_A_SENSOR_RESULT",NULL_KEY,AGENT,0.001,0.0,autoTimer);
}
doSynch()
{
    integer i=llGetListLength(positions);
    while (--i>=0)
    {
        key who=llList2Key(positions,i);
        if (who!=NULL_KEY)
        {
            osAvatarStopAnimation(who,llList2String(currentAn,3+i*3));
            osAvatarPlayAnimation(who,llList2String(currentAn,3+i*3));
        }
    }
    llMessageLinked(LINK_THIS,0,"GLOBAL_ANIMATION_SYNCH_CALLED",llDumpList2String(positions,"|"));
}
doSwapPositions(integer indFrom,integer indTo)
{
    key whoFrom=llList2Key(positions,indFrom);
    if (whoFrom!=NULL_KEY)
    {
        osAvatarStopAnimation(whoFrom,llList2String(currentAn,3+indFrom*3));
        setPosition(whoFrom,getUserLink(whoFrom),llList2Vector(currentAn,4+indTo*3),llList2Rot(currentAn,5+indTo*3));
    }
    key whoTo=llList2Key(positions,indTo);
    if (whoTo!=NULL_KEY)
    {
        osAvatarStopAnimation(whoTo,llList2String(currentAn,3+indTo*3));
        setPosition(whoTo,getUserLink(whoTo),llList2Vector(currentAn,4+indFrom*3),llList2Rot(currentAn,5+indFrom*3));
    }
    positions=[]+llListReplaceList(positions,[whoFrom],indTo,indTo);
    positions=[]+llListReplaceList(positions,[whoTo],indFrom,indFrom);
    doSynch();
}
doChangeUser(key who)
{
    if (user!=NULL_KEY) llRegionSayTo(user,0,llGetUsername(who)+" has now taken control of me");
    user=who;
    buildGroupList();
    specials=[];
    llMessageLinked(LINK_THIS,0,"GLOBAL_NEW_USER_ASSUMED_CONTROL|"+(string)user,llDumpList2String(positions,"|"));
    if (llListFindList(groupList,[currentGroup])==-1) loadGroup(llList2String(groupList,0));
    else if (autoOn) showGroupsMenu();
    else if (showGroupsMenuFirst) showGroupsMenu();
    else showAnMenu();
}
doQuit()
{
    if (myState=="EDIT") removeHandles();
    integer i=llGetListLength(positions);
    while (--i>=0)
    {
        key who=llList2Key(positions,i);
        if (who!=NULL_KEY)
        {
            if (osIsNpc(who)) osNpcRemove(who);
            else
            {
                llRegionSayTo(who,0,"Quit called");
                llUnSit(who);
            }
        }
    }
}
loadGroup(string name)
{
    if (name==currentGroup)
    {
        if (user!=NULL_KEY) showAnMenu();
        return;
    }
    integer indToLoad=llListFindList(invGroups,[name])-3;
    integer newUserCount=llList2Integer(invGroups,indToLoad+1);
    if (newUserCount<llGetListLength(positions))
    {
        integer agents;
        integer a=llGetListLength(positions);
        while (--a>-1) { if (llList2Key(positions,a)!=NULL_KEY) agents++; }
        if (agents>newUserCount)
        {
            llRegionSayTo(user,0,"You cannot use animations from the "+name+" group at the moment because it is for a maximum of "+(string)newUserCount+" users and there are currently "+(string)agents+" seated. Please select a different group of animations, remove NPCs, or ask someone to stand.");
            if (user!=NULL_KEY) startListening();
            return;
        }
    }
    currentGroup=name;
    anData=[]+llParseString2List(osGetNotecard(llList2String(invGroups,indToLoad)),["|","\n"],[""]);
    anStride=2+(3*newUserCount);
    anPage=0;
    anList=llList2ListStrided(anData,0,-1,anStride);
    if (autoOn && (myState=="RUNNING"))
    {
        playAnimation(llList2String(anList,0));
        if (user!=NULL_KEY)
        {
            llRegionSayTo(user,0,"Now automatically playing animations from "+name);
            showGroupsMenu();
        }
    }
    else if (user!=NULL_KEY) showAnMenu();
}
loadConfig()
{
    integer i;
    float n;
    string  sParam;
    string  sValue;
    list lParams=[];
    for(i=0;i<osGetNumberOfNotecardLines(gs_ConfigName); i++) {
       lParams=llParseString2List(osGetNotecardLine(gs_ConfigName,i),["="],"");
       if (llGetListLength(lParams)==2){
           sParam=llList2String(lParams,0);
           sValue=llList2String(lParams,1);
           if ((sParam=="defaultGroup") || (sParam=="DefaultGroup")) {
               defaultGroup=sValue;
           }else if ((sParam=="resetOnQuit")||(sParam=="ResetOnQuit")) {
               resetOnQuit=(sValue=="TRUE");
           }else if ((sParam=="ownerUseReq")||(sParam=="OwnerUseReq")) {
               ownerUseReq=(sValue=="TRUE");
           }else if ((sParam=="ownerOnlyMenus")||(sParam=="OwnerOnlyMenus")) {
               ownerOnlyMenus=(sValue=="TRUE");
           }else if ((sParam=="ownerUseUnlocksPerms")||(sParam=="OwnerUseUnlockPerms")) {
               ownerUseUnlocksPerms=(sValue=="TRUE");
           }else if ((sParam=="autoTimer")||(sParam=="AutoTimerValue")) {
               autoTimer=(float)sValue;
           }else if ((sParam=="baseAn")||(sParam=="BaseAnimation")) {
               baseAn=sValue;
           }else if ((sParam=="showGroupsMenuFirst") || (sParam=="ShowGroupsMenuFirst")) {
               showGroupsMenuFirst=(sValue=="TRUE");
           }else if ((sParam=="allowSoloNPC") || (sParam=="AllowSoloNPC")) {
               allowSoloNPC=(sValue=="TRUE");
           }else {
               llOwnerSay("Warn: Unable to parse user defined configuration "+llDumpList2String(lParams,"="));
           }
       }else if (llGetListLength(lParams)!=0){
           llOwnerSay("Warn: Skipping user defined configuration line "+(string)i+"  "+llDumpList2String(lParams,"="));
       }
    }
}
buildGroupList()
{
    groupList=[];
    groupPage=0;
    integer i;
    while (i<llGetListLength(invGroups))
    {
        if ( ( llList2String(invGroups,i+2)=="A" ) || ( (llList2String(invGroups,i+2)=="G") && llSameGroup(user)) || (user==llGetOwner()) || ( ownerUseUnlocksPerms && (llListFindList(positions,[llGetOwner()])>=0) ) ) groupList=[]+groupList+[llList2String(invGroups,i+3)];
        i+=invGroupStride;
    }
}
buildNpcList()
{
    npcList=[];
    npcPage=0;
    integer i;
    while (i<llGetListLength(invNpc))
    {
        if ( ( llList2String(invNpc,i+1)=="A" ) || ( (llList2String(invNpc,i+2)=="G") && llSameGroup(user)) || (user==llGetOwner()) || ( ownerUseUnlocksPerms && (llListFindList(positions,[llGetOwner()])>=0) ) ) npcList=[]+npcList+[llList2String(invNpc,i+2)];
        i+=invNpcStride;
    }
    showAddNpcMenu();
}
buildInventoryLists()
{
    invGroups=[];
    invNpc=[];
    integer i=llGetInventoryNumber(INVENTORY_NOTECARD);
    while (--i>-1)
    {
        string name=llGetInventoryName(INVENTORY_NOTECARD,i);
        if (llSubStringIndex(name,".menu")==0)
        {
            if (llListFindList(invGroups,[llGetSubString(name,10,-1)])>-1) llOwnerSay("ERROR! You have two groups notecards where the name \""+llGetSubString(name,10,-1)+"\" is used for the button! Group button names must be unique");
            else invGroups=[]+[name,(integer)(llGetSubString(name,7,7)),llGetSubString(name,8,8),llGetSubString(name,10,-1)]+invGroups;
        }
        else if (llSubStringIndex(name,".NPC")==0)
        {
            if (llListFindList(invNpc,[llGetSubString(name,8,-1)])>-1) llOwnerSay("ERROR! You have two NPC notecards where the NPC name is \""+llGetSubString(name,8,-1)+"\" but NPC names must be unique");
            else invNpc=[]+[name,llGetSubString(name,6,6),llGetSubString(name,8,-1)]+invNpc;
        }
        else if (llSubStringIndex(name,gs_ConfigName)==0)
        {
            gi_HaveConfig=1;
        }
    }
}
saveCard(string cardName)
{
    if (llGetInventoryType(cardName)==INVENTORY_NOTECARD)
    {
        llRemoveInventory(cardName);
        llSleep(0.25);
    }
    integer i;
    integer l=llGetListLength(anData);
    string dataToStore;
    while (i<l)
    {
        dataToStore+=llDumpList2String(llList2List(anData,i,i+anStride-1),"|")+"\n";
        i+=anStride;
    }
    osMakeNotecard(cardName,dataToStore);
    llMessageLinked(LINK_THIS,0,"GLOBAL_EDIT_STORE_TO_CARD|"+cardName,llDumpList2String(positions,"|"));
}
integer getUserLink(key who)
{
    integer ret=FALSE;
    if (who!=NULL_KEY)
    {
        integer link=llGetNumberOfPrims();
        while ((link>1) && (ret==FALSE))
        {
            key this=llGetLinkKey(link);
            if(this==who) ret=link;
            link--;
        }
    }
    return ret;
}
startListening()
{
    llDialog(user,txtDia,llList2List(butDia,9,11)+llList2List(butDia,6,8)+llList2List(butDia,3,5)+llList2List(butDia,0,2),myChannel);
}
string currentlyPlaying()
{
    string strToReturn="Currently playing: "+llList2String(currentAn,0)+" > "+llList2String(currentAn,1);
    if (autoOn) strToReturn+="\nAUTO mode is on and set to "+(string)llRound(autoTimer)+" seconds";
    return strToReturn;
}
persistChanges()
{
    integer u=llGetListLength(positions);
    while(--u>=0)
    {
        list avData=getPosition(llList2Key(positions,u),getUserLink(llList2Key(positions,u)));
        vector pos=llList2Vector(avData,0);
        rotation rot=llList2Rot(avData,1);
        string strPos="<"+trimF(pos.x)+","+trimF(pos.y)+","+trimF(pos.z)+">";
        string strRot="<"+trimF(rot.x)+","+trimF(rot.y)+","+trimF(rot.z)+","+trimF(rot.s)+">";
        currentAn=[]+llListReplaceList(currentAn,[strPos,strRot],4+u*3,5+u*3);
    }
    integer anIndex=llListFindList(anData,llList2List(currentAn,1,1));
    if(gi_NC_PROP_CHANGED) { // NC_PROPS
        string old_cmd=llList2String(currentAn,2);
        integer NC_PROP_data_start=llSubStringIndex(old_cmd,"NC_PROP{")+8; // find start
        // test is little weird, as i added +8 to compensate for search string length
        if (NC_PROP_data_start != 7) {
            // search ending delimiter in rest of string
            integer NC_PROP_data_end=NC_PROP_data_start+llSubStringIndex(llGetSubString(old_cmd, NC_PROP_data_start,-1),"}");
            string new_cmd=llGetSubString(old_cmd, 0, NC_PROP_data_start -1) + gs_NC_PROP_DATA + llGetSubString(old_cmd, NC_PROP_data_end,-1);
            currentAn=[]+llListReplaceList(currentAn,[new_cmd],2,2);
        }
        gi_NC_PROP_CHANGED=FALSE;
    }
    anData=[]+llListReplaceList(anData,llList2List(currentAn,1,-1),anIndex,anIndex+anStride-1);
    llMessageLinked(LINK_THIS,0,"GLOBAL_EDIT_PERSIST_CHANGES",llDumpList2String(positions,"|"));
}
rezHandles()
{
    if (llGetListLength(editHandles)<llGetListLength(positions)) llRezObject(handleName,llGetPos(),ZERO_VECTOR,ZERO_ROTATION,0);
    else
    {
        rezzingHandles=FALSE;
        integer h=llGetListLength(editHandles);
        while (--h>=0) { osSetPrimitiveParams( llList2Key(editHandles,h),[PRIM_SIZE,handleSize,PRIM_COLOR,ALL_SIDES,llList2Vector(handleColours,h),handleAlpha,PRIM_TEXT,"pos "+(string)(h+1),llList2Vector(handleColours,h),1.0,PRIM_NAME,"pos "+(string)(h+1)]); }
        playAnimation(llList2String(currentAn,1));
        llSetTimerEvent(editTimer);
        doSynch();
        showEditMenu();
    }
}
removeHandles()
{
    llSetTimerEvent(0.0);
    myState="RUNNING";
    llMessageLinked(LINK_THIS,0,"GLOBAL_NOTICE_LEAVING_EDIT_MODE",llDumpList2String(positions,"|"));
    integer l=llGetListLength(editHandles);
    while (--l>=0) { osMessageObject(llList2Key(editHandles,l),"HANDLE_DIE"); }
    editHandles=[];
    showOptionsMenu();
}
setHandle(key prim, vector relPos, rotation relRot)
{
    vector pos=relPos*llGetRot()+llGetPos();
    rotation rot=relRot*llGetRot();
    osSetPrimitiveParams(prim,[PRIM_POSITION,pos,PRIM_ROTATION,rot]);
}
setPosition(key who, integer link, vector pos, rotation rot)
{
    vector size = llGetAgentSize(who);
    float fAdjust = ((((0.008906 * size.z) + -0.049831) * size.z) + 0.088967) * size.z;
    llSetLinkPrimitiveParamsFast(link,[PRIM_POS_LOCAL, ((pos + <0.0, 0.0, 0.4>) - (llRot2Up(rot) * fAdjust)), PRIM_ROT_LOCAL, rot]);
}
list getPosition(key who, integer link)
{
    vector size = llGetAgentSize(who);
    float fAdjust = ((((0.008906 * size.z) + -0.049831) * size.z) + 0.088967) * size.z;
    list avData=llGetLinkPrimitiveParams(link,[PRIM_POS_LOCAL,PRIM_ROT_LOCAL]);
    vector avPos=llList2Vector(avData,0);
    rotation avRot=llList2Rot(avData,1);
    vector avPosUnadjusted=(avPos - <0.0, 0.0, 0.4>) + (llRot2Up(avRot) * fAdjust);
    return [avPosUnadjusted,avRot];
}
list regToRel(vector regionPos,rotation regionRot)
{
    vector relPos=(regionPos - llGetPos()) / llGetRot();
    rotation relRot=regionRot/ llGetRot();
    return [relPos,relRot];
}
list relToReg(vector refPos,rotation refRot)
{
    vector regionPos=refPos*llGetRot()+llGetPos();
    rotation regionRot=refRot*llGetRot();
    return [regionPos,regionRot];
}
string trimF(float value)
{
    integer newVal=llRound(value*10000);
    integer negFlag=FALSE;
    if (newVal<0)
    {
        negFlag=TRUE;
        newVal*=-1;
    }
    integer strLength;
    string retStr;
    if (newVal==0) retStr="0";
    else if (newVal<10) retStr="0.000"+(string)newVal;
    else if (newVal<100) retStr="0.00"+(string)newVal;
    else if (newVal<1000) retStr="0.0"+(string)newVal;
    else if (newVal<10000) retStr="0."+(string)newVal;
    else
    {
        retStr=(string)newVal;
        strLength=llStringLength(retStr);
        retStr=llGetSubString(retStr,0,strLength-5)+"."+llGetSubString(retStr,strLength-4,strLength-1);
    }
    while (llGetSubString(retStr,strLength,strLength)=="0")
    {
        retStr=llGetSubString(retStr,0,strLength-1);
        strLength-=1;
    }
    if (negFlag) retStr="-"+retStr;
    return retStr;
}
default
{
    state_entry()
    {
        if (llGetAttached()) return;
        if (llGetLinkNumber()>1)
        {
            myState="ERROR";
            llOwnerSay("ERROR! The main PMAC controller script must always be located in the root prim of a linkset!");
            return;
        }
        myChannel=0x80000000|(integer)("0x"+(string)llGetKey());
        user=NULL_KEY;
        buildInventoryLists();
        if (gi_HaveConfig)
            loadConfig();
        if (llGetInventoryType(baseAn)!=INVENTORY_ANIMATION)
        {
            llOwnerSay("ERROR! Unable to find the base priority 1 animation to use for synch: "+baseAn);
            myState="ERROR";
            return;
        }

        if (llListFindList(invGroups,[defaultGroup])==-1)
        {
            myState="ERROR";
            llOwnerSay("ERROR! Unable to find the specified default group \""+defaultGroup+"\" in inventory. Make sure you supplied the simple group name, not the full card name");
            return;
        }
        loadGroup(defaultGroup);
        integer i=llList2Integer(invGroups,llListFindList(invGroups,[defaultGroup])-2);
        positions=[];
        while (--i>=0) { positions=[]+positions+[NULL_KEY]; }
        currentAn=[]+[currentGroup]+llList2List(anData,0,anStride-1);
        myState="READY";
        llMessageLinked(LINK_THIS,0,"GLOBAL_SYSTEM_RESET",NULL_KEY);
        llSitTarget(<0.0,0,0.001>,ZERO_ROTATION);
        llOwnerSay("Initialization complete and ready to use");
    }
    on_rez(integer num)
    {
        llResetScript();
    }
    object_rez(key id)
    {
        if (!rezzingHandles) return;
        editHandles=[]+editHandles+[id];
        rezHandles();
    }
    sensor(integer num)
    {
        llOwnerSay("ERROR! Sensor event inexplicably returned a result!");
        llSensorRemove();
        autoOn=FALSE;
    }
    no_sensor()
    {
        if (!autoOn)
        {
            llOwnerSay("ERROR! Sensor repeat triggered but auto mode is off. Figure out how this can happen and fix. Sensor removed");
            llSensorRemove();
            return;
        }
        if (myState!="RUNNING")
        {
            llOwnerSay("ERROR! Sensor repeat triggered while not in normal running state: Please figure out how this happened and fix. Sensor removed and auto turned off.\nState was=: "+myState);
            autoOn=FALSE;
            llSensorRemove();
            return;
        }
        integer i=llListFindList(anList,[llList2String(currentAn,1)]);
        if (i==-1)
        {
            llOwnerSay("ERROR! Auto timer was unable to determine the index of the currently playing animation!");
            llSensorRemove();
            autoOn=FALSE;
        }
        else
        {
            i++;
            if (i>=llGetListLength(anList)) i=0;
            playAnimation(llList2String(anList,i));
        }
    }
    timer()
    {
        if(myState=="EDIT")
        {
            llSetTimerEvent(0.0);
            integer l=llGetListLength(positions);
            while (--l>-1)
            {
                key who=llList2Key(positions,l);
                if (who==NULL_KEY)
                {
                    llOwnerSay("ERROR! NULL_KEY user while processing timer event edit mode. Leaving edit mode without saving changes.");
                    removeHandles();
                    return;
                }
                if (llGetAgentSize(who)==ZERO_VECTOR)
                {
                    llOwnerSay("ERROR! Cannot detect user in region while processing timer event edit mode. Leaving edit mode without saving changes");
                    removeHandles();
                    return;
                }
                list handleData=llGetObjectDetails(llList2Key(editHandles,l),[OBJECT_POS,OBJECT_ROT]);
                if (llGetListLength(handleData)==0)
                {
                    llOwnerSay("ERROR! Unable to detect a handle! Leaving edit mode without saving changes");
                    removeHandles();
                    return;
                }
                handleData=[]+regToRel(llList2Vector(handleData,0),llList2Rot(handleData,1));
                setPosition(who,getUserLink(who),llList2Vector(handleData,0),llList2Rot(handleData,1));
            }
            llSetTimerEvent(editTimer);
        }
        else llSetTimerEvent(0.0);
    }
    link_message(integer sender,integer num,string message,key command)
    {
        if (num!=-1) return;
        if (message=="MAIN_RESUME_MAIN_DIALOG") showOptionsMenu();
        else if (llSubStringIndex(message,"MAIN_REGISTER_MENU_BUTTON")==0)
        {
            string buttonName=llList2String(llParseString2List(message,["|"],[]),1);
            integer locationToAdd=llListFindList(specials,[buttonName]);
            if (locationToAdd==-1) specials=[]+specials+[buttonName,command];
            else specials=[]+llListReplaceList(specials,[buttonName,command],locationToAdd,locationToAdd+1);
            specials=[]+llListSort(specials,2,TRUE);
        }
        else if (llSubStringIndex(message,"MAIN_UNREGISTER_MENU_BUTTON")==0)
        {
            string buttonName=llList2String(llParseString2List(message,["|"],[]),1);
            integer locationToKill=llListFindList(specials,[buttonName,command]);
            if (locationToKill==-1) return;
            else specials=[]+llDeleteSubList(specials,locationToKill,locationToKill+1);
            specials=[]+llListSort(specials,2,TRUE);
        }
        else if (llSubStringIndex(message,"NC_PROP_UPDATE")==0) // NC_PROP addon
        {
            gi_NC_PROP_CHANGED=TRUE;
            gs_NC_PROP_DATA=llGetSubString(message,15,-1);
        }
    }
    changed (integer change)
    {
        if (change & CHANGED_LINK)
        {
            if (llGetLinkNumber()>1)
            {
                llOwnerSay("ERROR! You have changed the linkset and the PMAC main script is no longer located in the root prim!");
                myState="ERROR";
                return;
            }
            integer i=llGetNumberOfPrims();
            integer l=llGetObjectPrimCount(llGetKey());
            list seated;
            integer realAvi;
            while (i>l)
            {
                key who=llGetLinkKey(i);
                if ((myState=="ERROR") || (myState=="INITIALIZING"))
                {
                    if (osIsNpc(who)) osNpcRemove(who);
                    else
                    {
                        if (myState=="ERROR") llRegionSayTo(who,0,"Sorry, I have encountered an error and must shut down until it is corrected");
                        else llRegionSayTo(who,0,"Sorry, you cannot sit while I am initializing. Please wait a moment and try again.");
                        llUnSit(who);
                    }
                }
                else
                {
                    seated=[]+[who]+seated;
                    if (!osIsNpc(who)) realAvi++;
                    if (llListFindList(positions,[who])==-1)
                    {
                        // new sitter
                        integer indexToSit=llListFindList(positions,[NULL_KEY]);
                        if (ownerUseReq && (who!=llGetOwner()) && (llListFindList(positions,[llGetOwner()])==-1))
                        {
                            llRegionSayTo(who,0,"Sorry, the system is set to require that the owner is using me before anyone else may sit.");
                            llUnSit(who);
                        }
                        else if (indexToSit==-1)
                        {
                            llRegionSayTo(who,0,"Sorry, there are no available positions for you to occupy. Please wait for someone to stand");
                            llUnSit(who);
                        }
                        else
                        {
                            positions=[]+llListReplaceList(positions,[who],indexToSit,indexToSit);
                            llSleep(0.2);
                            list anToStop=llGetAnimationList(who);
                            osAvatarPlayAnimation(who,baseAn);
                            integer stop=llGetListLength(anToStop);
                            key dontStop=llGetInventoryKey(baseAn);
                            while (--stop>-1) { osAvatarStopAnimation(who,llList2Key(anToStop,stop)); }
                            if (myState=="READY")
                            {
                                if ((osIsNpc(who)) && (!allowSoloNPC))
                                {
                                    llSay(0,"Sorry, an NPC cannot sit until there is a human user in control. Unsitting your NPC.");
                                    llUnSit(who);
                                    positions=[]+llListReplaceList(positions,[NULL_KEY],indexToSit,indexToSit);
                                    osAvatarStopAnimation(who,baseAn);
                                }
                                else
                                {
                                    myState="RUNNING";
                                    llMessageLinked(LINK_THIS,0,"GLOBAL_START_USING",llDumpList2String(positions,"|"));
                                    playAnimation(llList2String(currentAn,1));
                                }
                            }
                            else playAnimation(llList2String(currentAn,1));
                        }
                    }
                }
                i--;
            }
            i=llGetListLength(positions);
            while (--i>=0)
            {
                key who=llList2Key(positions,i);
                if (who!=NULL_KEY)
                {
                    if ((!realAvi)&&osIsNpc(who))
                    {
                        if (!allowSoloNPC)
                        {
                            osNpcRemove(who);
                            positions=[]+llListReplaceList(positions,[NULL_KEY],i,i);
                        }
                    }
                    else if (llListFindList(seated,[who])==-1)
                    {
                        if (myState=="EDIT")
                        {
                            llOwnerSay("WARNING! Someone stood! Leaving edit mode and no changes will be stored to card");
                            removeHandles();
                            if (who!=llGetOwner())showOptionsMenu();
                        }
                        if (llGetAgentSize(who)!=ZERO_VECTOR)
                        {
                            osAvatarPlayAnimation(who,"stand");
                            osAvatarStopAnimation(who,llList2String(currentAn,3+i*3));
                            osAvatarStopAnimation(who,baseAn);
                            if (who==user) user=NULL_KEY;
                        }
                        positions=[]+llListReplaceList(positions,[NULL_KEY],i,i);
                        llMessageLinked(LINK_THIS,0,"GLOBAL_USER_STOOD|"+(string)i+"|"+(string)who,llDumpList2String(positions,"|"));
                    }
                }
            }
            if (!realAvi)
            {
                if (diaHandle)
                {
                    llListenRemove(diaHandle);
                    diaHandle=FALSE;
                }
                if (llGetListLength(seated)<1)
                {
                    if (autoOn) llSensorRemove();
                    myState="READY";
                    llMessageLinked(LINK_THIS,0,"GLOBAL_SYSTEM_GOING_DORMANT",NULL_KEY);
                    if (resetOnQuit) llResetScript();
                }
            }
        }
        else if (change & CHANGED_REGION_START) llResetScript();
        else if (change & CHANGED_OWNER) llResetScript();
    }
    touch_start(integer num)
    {
        if (llGetAttached()) return;
        key who=llDetectedKey(0);
        if (osIsNpc(llDetectedKey(0))) return;
        if (myState=="ERROR")
        {
            if (who==llGetOwner()) llOwnerSay("PMAC somehow entered ERROR state. Please check your chat log for one or more messages indicating the nature of the error, correct it, then reset the script");
            else llRegionSayTo(who,0,"Sorry, I encountered an error and am waiting for the owner to correct the issue and restart me");
        }
        else if (myState=="INITIALIZING") llRegionSayTo(who,0,"Please wait until initialization is complete, then try again");
        else if (myState=="READY") llRegionSayTo(who,0,"Please sit to begin using me");
        else if (myState=="EDIT")
        {
            if (who!=llGetOwner()) llRegionSayTo(who,0,"Sorry, the owner is currently editting positions and must remain in control of the dialog until this is complete.");
            else startListening();
        }
        else if (myState=="RUNNING")
        {
            if (llListFindList(positions,[who])==-1) llRegionSayTo(who,0,"Only current users may access the controls. Please sit, then try again");
            else if (ownerOnlyMenus && (who!=llGetOwner())) llRegionSayTo(who,0,"Sorry, this item is currently set to only allow the owner to access the controls.");
            else if (who!=user)
            {
                if (user==NULL_KEY)
                {
                    if (!diaHandle) diaHandle=llListen(myChannel,"",NULL_KEY,"");
                    doChangeUser(who);
                }
                else llDialog(who,"Please confirm that you want to take control of me",["TAKE CONTROL","CANCEL"],myChannel);
            }
            else startListening();
        }
        else llOwnerSay("ERROR! Unexpected state when touched. State is: "+myState);
    }
    listen (integer channel, string name, key who, string message)
    {
        if (who!=user)
        {
            if (message=="TAKE CONTROL")
            {
                if (myState!="RUNNING")
                {
                    if (who==llGetOwner()) llOwnerSay("Cannot give you control because I am not in RUNNING state. Current state is: "+myState);
                    else llRegionSayTo(who,0,"Sorry, you cannot take control at the moment because I am not currently in normal operation mode.");
                    return;
                }
                doChangeUser(who);
            }
            else if (message=="CANCEL") return;
            else return;
        }
        else if (message=="-") startListening();
        else if (message=="SYNCH")
        {
            doSynch();
            startListening();
        }
        else if (message=="OPTIONS") showOptionsMenu();
        else if (message=="GROUPS") showGroupsMenu();
        else if (message=="<< BACK") loadGroup(llList2String(currentAn,0));
        else if (message=="QUIT") doQuit();
        else if (menu=="MENU_GROUPS")
        {
            if ((message=="< PREV") || (message=="NEXT >"))
            {
                if (message=="< PREV") groupPage-=6;
                else groupPage+=6;
                if (groupPage>=llGetListLength(groupList)) groupPage=0;
                else if (groupPage<=-6) groupPage=llGetListLength(groupList)-6;
                if (groupPage<0) groupPage=0;
                showGroupsMenu();
            }
            else loadGroup(message);
        }
        else if (menu=="MENU_ANIM")
        {
            if ((message=="< PREV") || (message=="NEXT >"))
            {
                if (message=="< PREV") anPage-=6;
                else anPage+=6;
                if (anPage>=llGetListLength(anList)) anPage=0;
                else if (anPage<=-6) anPage=llGetListLength(anList)-6;
                if (anPage<0) anPage=0;
                showAnMenu();
            }
            else
            {
                playAnimation(message);
                showAnMenu();
            }
        }
        else if (menu=="MENU_ADD_NPC")
        {
            if (message=="CANCEL") showOptionsMenu();
            else if (llListFindList(positions,[NULL_KEY])==-1)
            {
                llRegionSayTo(user,0,"Cannot add a NPC as there are no longer any vacant positions");
                showOptionsMenu();
            }
            else if ((message=="< PREV") || (message=="NEXT >"))
            {
                if (message=="< PREV") npcPage-=9;
                else npcPage+=9;
                if (npcPage>=llGetListLength(npcList)) npcPage=0;
                else if (npcPage<=-9) npcPage=llGetListLength(npcList)-9;
                if (npcPage<0) npcPage=0;
                showAddNpcMenu();
            }
            else
            {
                string npcToLoad=llList2String(invNpc,llListFindList(invNpc,[message])-2);
                if (llGetInventoryType(npcToLoad)!=INVENTORY_NOTECARD)
                {
                    llRegionSayTo(user,0,"ERROR! Unable to locate the appearance notecard for this NPC.\nButton was: "+message+"\nCard should be: "+npcToLoad);
                    startListening();
                    return;
                }
                list thisNames=llParseString2List(message,[" "],[]);
                if (llGetListLength(thisNames)==1) thisNames=[]+thisNames+["~"];
                key npc=osNpcCreate(llList2String(thisNames,0),llList2String(thisNames,1),llGetPos()+<0.0,0.0,2.0>,npcToLoad,OS_NPC_SENSE_AS_AGENT);
                osNpcSit(npc,llGetKey(),OS_NPC_SIT_NOW);
                showOptionsMenu();
            }
        }
        else if (menu=="MENU_SWAP_TO_POSITION")
        {
            if (message=="CANCEL") showOptionsMenu();
            else doSwapPositions(llListFindList(positions,[user]),((integer)message)-1);
            showOptionsMenu();
        }
        else if (menu=="MENU_UNSIT_POSITION")
        {
            if (message=="CANCEL") showOptionsMenu();
            else
            {
                integer posToUnsit=(integer)message-1;
                key thisKey=llList2Key(positions,posToUnsit);
                if (osIsNpc(thisKey))
                {
                    positions=[]+llListReplaceList(positions,[NULL_KEY],posToUnsit,posToUnsit);
                    osNpcRemove(thisKey);
                }
                else llUnSit(thisKey);
                showOptionsMenu();
            }
        }
        else if (menu=="MENU_SELECT_AUTO_MODE")
        {
            if (message=="AUTO OFF")
            {
                autoOn=FALSE;
                llSensorRemove();
                llRegionSayTo(user,0,"Auto mode now off");
            }
            else if (message!="CANCEL")
            {
                autoOn=TRUE;
                if(message!="AUTO ON") autoTimer=(float)message;
                llSensorRepeat("THIS_WILL_NEVER_RETURN_A_SENSOR_RESULT",NULL_KEY,AGENT,0.001,0.0,autoTimer);
                llRegionSayTo(user,0,"Auto mode is on and set to "+(string)llRound(autoTimer)+" seconds");
            }
            showOptionsMenu();
        }
        else if (menu=="MENU_SPECIALS")
        {
            if (message=="CANCEL") showOptionsMenu();
            else if ((message=="< PREV") || (message=="NEXT >"))
            {
                if (message=="< PREV") specPage-=18;
                else specPage+=18;
                if (specPage>=llGetListLength(specials)) specPage=0;
                else if (specPage<=-18) specPage=llGetListLength(specials)-18;
                if (specPage<0) specPage=0;
                showSpecialsMenu();
            }
            else llMessageLinked(LINK_THIS,0,llList2String(specials,llListFindList(specials,[message])+1)+"|"+user,llDumpList2String(positions,"|"));
        }
        else if (menu=="MENU_OPTIONS")
        {
            if (message=="AUTO") showAutoMenu();
            else if (message=="SPECIAL") showSpecialsMenu();
            else if (llSubStringIndex(message,"MENUS")==0)
            {
                ownerOnlyMenus=!ownerOnlyMenus;
                if (ownerOnlyMenus) llRegionSayTo(who,0,"Menus are now locked. Only the owner can take control of me");
                else llRegionSayTo(who,0,"Menus are now unlocked. Any user can now take control of me");
                showOptionsMenu();
            }
            else if (message=="EDIT ON")
            {
                if (llListFindList(positions,[NULL_KEY])>=0)
                {
                    llRegionSayTo(who,0,"Sorry, all positions must be filled before you can enter edit mode and there is currently at least one that is empty.");
                    showOptionsMenu();
                }
                else if (currentGroup!=llList2String(currentAn,0))
                {
                    llRegionSayTo(user,0,"Cannot enter edit mode because the animation currently playing is not from the same notecard as your currently loaded group. Either select an animation from this card or load the group that the current animation belongs to.");
                    showOptionsMenu();
                }
                else
                {
                    if (autoOn)
                    {
                        autoOn=FALSE;
                        llSensorRemove();
                        llOwnerSay("Auto mode switched off");
                    }
                    integer l=llGetListLength(positions);
                    while (--l>=0) { if (!osIsNpc(llList2Key(positions,l))) llRegionSayTo(llList2Key(positions,l),0,"The Owner has entered edit mode and all functions are temporarily disabled. Please do not stand while these adjustments are being made."); }
                    myState="EDIT";
                    llMessageLinked(LINK_THIS,0,"GLOBAL_NOTICE_ENTERING_EDIT_MODE",llDumpList2String(positions,"|"));
                    editHandles=[];
                    rezzingHandles=TRUE;
                    rezHandles();
                }
            }
            else if (message=="SWAP")
            {
                integer i=llGetListLength(positions);
                if (i==1)
                {
                    llRegionSayTo(user,0,"The current animation group is for only one position so cannot swap positions.");
                    showOptionsMenu();
                }
                else if (i==2)
                {
                    doSwapPositions(0,1);
                    showOptionsMenu();
                }
                else
                {
                    txtDia="";
                    butDia=[];
                    while (--i>=0)
                    {
                        key thisKey=llList2Key(positions,i);
                        if (thisKey==user) txtDia="\n"+(string)(i+1)+". (you are curently here)"+txtDia;
                        else
                        {
                            butDia=[]+[(string)(i+1)]+butDia;
                            if (thisKey==NULL_KEY) txtDia="\n"+(string)(i+1)+". (empty)"+txtDia;
                            else txtDia="\n"+(string)(i+1)+". "+llGetUsername(thisKey)+txtDia;
                        }
                    }
                    txtDia=""+"SWAP POSITION\n\nSelect the position number you would like to swap with\n"+txtDia;
                    while (llGetListLength(butDia)<8) { butDia=[]+butDia+["-"]; }
                    butDia=[]+butDia+["CANCEL"];
                    while (llListFindList(butDia,["-","-","-"])>=0) { butDia=[]+llDeleteSubList(butDia,llListFindList(butDia,["-","-","-"]),llListFindList(butDia,["-","-","-"])+2); }
                    menu="MENU_SWAP_TO_POSITION";
                    startListening();
                }
            }
            else if (message=="UNSIT")
            {
                list whoCanUnsit;
                integer i=llGetListLength(positions);
                while (--i>=0)
                {
                    key thisKey=llList2Key(positions,i);
                    if ((thisKey!=user) && (thisKey!=llGetOwner()) && (thisKey!=NULL_KEY)) whoCanUnsit=[]+[i,thisKey]+whoCanUnsit;
                }
                integer l=llGetListLength(whoCanUnsit);
                if (l==0)
                {
                    llRegionSayTo(user,0,"There are no users you can remove");
                    showOptionsMenu();
                }
                else if (l==2)
                {
                    integer thisInd=llList2Integer(whoCanUnsit,0);
                    key thisUser=llList2Key(whoCanUnsit,1);
                    if (osIsNpc(thisUser))
                    {
                        positions=[]+llListReplaceList(positions,[NULL_KEY],thisInd,thisInd);
                        osNpcRemove(thisUser);
                    }
                    else llUnSit(thisUser);
                    showOptionsMenu();
                }
                else
                {
                    txtDia="UNSIT A USER\n\nSelect the user to unsit (selecting NPC it will remove it). The number is the position they currently occupy.\n";
                    butDia=[];
                    i=0;
                    while (i<l)
                    {
                        txtDia+="\n"+(string)(llList2Integer(whoCanUnsit,i)+1)+". "+llGetUsername(llList2Key(whoCanUnsit,i+1));
                        butDia=[]+butDia+[(string)(llList2Integer(whoCanUnsit,i)+1)];
                        i+=2;
                    }
                    while (llGetListLength(butDia)<8) { butDia=[]+butDia+["-"]; }
                    butDia=[]+butDia+["CANCEL"];
                    while (llListFindList(butDia,["-","-","-"])>=0) { butDia=[]+llDeleteSubList(butDia,llListFindList(butDia,["-","-","-"]),llListFindList(butDia,["-","-","-"])+2); }
                    menu="MENU_UNSIT_POSITION";
                    startListening();
                }
            }
            else if (message=="ADD NPC")
            {
                if (llListFindList(positions,[NULL_KEY])==-1)
                {
                    llRegionSayTo(user,0,"Cannot add a new NPC at this time as there are no vacant positions");
                    showOptionsMenu();
                }
                else buildNpcList();
            }
            else llOwnerSay("ERROR! Received unexpected message from Options menu: "+message);
        }
        else if (menu=="MENU_EDIT")
        {
            if (myState!="EDIT")
            {
                llOwnerSay("No longer in edit mode so unable to handle a response from that menu.");
                showOptionsMenu();
            }
            llSetTimerEvent(0.0);
            integer valid=TRUE;
            integer check=llGetListLength(positions);
            while (valid && (--check>=0)) { if (!getUserLink(llList2Key(positions,check))) valid=FALSE; }
            if (!valid)
            {
                llOwnerSay("ERROR! A user appears to have stood. Cannot remain in edit mode unless all positions are occupied. Ignoring your selection, reverting to stored position for this animation, and leaving edit mode without saving any changes. Once all positions are filled once more you may return to edit mode to resume work or save the stored data.");
                playAnimation(llList2String(currentAn,1));
                removeHandles();
                return;
            }
            if (message=="STORE ADDON") llMessageLinked(LINK_THIS,0,"GLOBAL_STORE_ADDON_NOTICE",llDumpList2String(positions,"|"));
            else if (message=="REVERT THIS") playAnimation(llList2String(currentAn,1));
            else
            {
                persistChanges();
                if (message=="EDIT OFF") removeHandles();
                else if ((message=="STORE THIS") || (message=="< PREV") || (message=="NEXT >"))
                {
                    integer anToPlay=llListFindList(anList,[llList2String(currentAn,1)]);
                    if (message=="< PREV") anToPlay--;
                    else if (message=="NEXT >") anToPlay++;
                    if (anToPlay<0) anToPlay=llGetListLength(anList)-1;
                    if (anToPlay>=llGetListLength(anList)) anToPlay=0;
                    playAnimation(llList2String(anList,anToPlay));
                }
                else if ((message=="SAVE CARD") || (message=="SAVE NEW"))
                {
                    string cardName=llList2String(invGroups,llListFindList(invGroups,[currentGroup])-3);
                    string strToSay;
                    if (message=="SAVE NEW")
                    {
                        integer num=2;
                        while (llGetInventoryType(cardName+(string)num)==INVENTORY_NOTECARD) { num++; }
                        cardName=""+cardName+(string)num;
                        currentGroup=llGetSubString(cardName,10,-1);
                        invGroups=[]+invGroups+[cardName,(integer)(llGetSubString(cardName,7,7)),llGetSubString(cardName,8,8),currentGroup];
                        groupList=[]+groupList+[currentGroup];
                        currentAn=[]+llListReplaceList(currentAn,[currentGroup],0,0);
                        strToSay="All data stored to a new notecard and now working with the newly created group: "+currentGroup;
                    }
                    else strToSay="All data now updated in notecard for the group: "+currentGroup;
                    saveCard(cardName);
                    llRegionSayTo(user,0,strToSay);
                }
                else llOwnerSay("ERROR! Message not expected in Edit menu handling: "+message);
            }
            if (myState=="EDIT")
            {
                llSetTimerEvent(editTimer);
                showEditMenu();
            }
        }
    }
}
