// :SHOW:
// :CATEGORY:NPC
// :NAME:NPC Manager
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:
// :CREATED:2015-11-24 20:37:08
// :EDITED:2015-11-24  19:37:08
// :ID:1091
// :NUM:1865
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Wear or rez to ground, then touch to be able to globally or selectively remove NPCs from a region
// :CODE:
// Paramour NPC Manager
// by Aine Caoimhe (Mata Hari)(c. LACM) April 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Wear or rez to ground, then touch to be able to globally or selectively remove NPCs from a region
// OSSL functions required:
//      osGetAvatarList()
//      osNpcRemove()
//      osIsNpc()
// 
// USER SETTINGS
float dialogTimeout=60.0;       // how long to wait before timing out the dialog if no response received
integer ownerOnlyTouch=TRUE;    // TRUE = only owner to can touch to activate, FALSE = anyone can use it
string floatyText="Paramour NPC Manager\n(right-click and take a copy)";   // text to have floating above the object or supply an empty string ( "") for none
vector floatyTextColour=<1.000, 0.906, 0.502>;  // LSL vector colour to use for the text (<0.0, 0.0, 0.0> = black, <1.0, 1.0, 1.0> = white)
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
list npcList;
integer indNpc;
list globalButtons=["DONE","-","KILL ALL","< PREV","RESCAN","NEXT >"];
integer myChannel;
integer handle;
key user;

showMenu()
{
    string txtDia="Select a NPC to remove\nor KILL ALL to remove all NPCs\nor RESCAN to refresh the list\n\nNPCs currently in the region: "+(string)(llGetListLength(npcList)/4-1)+"\n";
    list butDia;
    integer i=indNpc;
    while (llGetListLength(butDia)<6)
    {
        if ((i*4)>=llGetListLength(npcList)) butDia=butDia+["-"];
        else
        {
            butDia=[]+butDia+[(string)i];
            txtDia+="\n"+(string)i+". "+llList2String(npcList,i*4+2)+" at "+llList2String(npcList,i*4+3);
        }
        i++;
    }
    butDia=[]+globalButtons+llList2List(butDia,3,5)+llList2List(butDia,0,2);
    handle=llListen(myChannel,"",user,"");
    llSetTimerEvent(dialogTimeout);
    llDialog(user,txtDia,butDia,myChannel);
}
doRemoveNpc(integer ind)
{
    if (llGetAgentSize(llList2Key(npcList,ind+1))!=ZERO_VECTOR) osNpcRemove(llList2Key(npcList,ind+1));
    llRegionSayTo(user,0,"Removed NPC "+llList2String(npcList,ind+2)+" from location "+llList2String(npcList,ind+3));
    npcList=[]+llDeleteSubList(npcList,ind,ind+3);
}
doKillAll()
{
    integer i;
    integer l=llGetListLength(npcList);
    for (i=4;i<l;i+=4)
    {
        if (llGetAgentSize(llList2Key(npcList,i+1))!=ZERO_VECTOR) osNpcRemove(llList2Key(npcList,i+1));
    }
    llRegionSayTo(user,0,"All NPCs in the region have now been removed");
    finishedUsing();
}
finishedUsing()
{
    user=NULL_KEY;
    npcList=[];
    indNpc=0;
}
stopListening()
{
    llSetTimerEvent(0.0);
    llListenRemove(handle);
}
doRescan()
{
    list inRegion=osGetAvatarList();    // UUUID | POS | NAME
    vector myPos=llGetPos();
    npcList=["distance","UUID","name","location"];
    integer l=llGetListLength(inRegion);
    integer i;
    for (;i<l;i+=3)
    {
        if (
            osIsNpc(llList2Key(inRegion,i))
            )
            npcList=[]+npcList+
            [
                llVecDist(myPos,llList2Vector(inRegion,i+1)),
                llList2Key(inRegion,i),
                llList2Key(inRegion,i+2),
                vec2Int0String(llList2Vector(inRegion,i+1))
            ];
    }
    if (llGetListLength(npcList)<=4) indNpc=0;
    else
    {
        npcList=[]+llListSort(npcList,4,TRUE);
        indNpc=1;
    }
}
checkIndex()
{
    if ((indNpc*4)>=llGetListLength(npcList)) indNpc=1;
    if (indNpc==-5) indNpc=(integer)(llGetListLength(npcList)/4.0 -6.0);
    if (indNpc<1) indNpc=1;
}
string vec2Int0String(vector vConvert)
{
    // returns a vector as a string with values rounded to nearest whole number
    string r="<"+(string)(llRound(vConvert.x))+", "+(string)(llRound(vConvert.y))+", "+(string)(llRound(vConvert.z))+">";
    return r;
}
default
{
    state_entry()
    {
        myChannel=0x80000000|(integer)("0x"+(string)llGetKey());
        finishedUsing();
        llSetText(floatyText,floatyTextColour,1.0);
    }
    timer()
    {
        llRegionSayTo(user,0,"Dialog has timed out. Please touch me again to resume");
        stopListening();
        finishedUsing();
    }
    on_rez(integer food)
    {
        llResetScript();
    }
    changed (integer change)
    {
        if (change & CHANGED_REGION_START) llResetScript();
        else if (change & CHANGED_OWNER) llResetScript();
        else if (change & CHANGED_REGION) llResetScript();
    }
    touch_start(integer num)
    {
        key toucher=llDetectedKey(0);
        if (toucher!=user)
        {
            if (user==NULL_KEY)
            {
                if (ownerOnlyTouch && (toucher!=llGetOwner())) llRegionSayTo(toucher,0,"Sorry, only the owner can use this");
                else
                {
                    doRescan();
                    if (!indNpc) llRegionSayTo(toucher,0,"There are currently no NPCs in this region");
                    else
                    {
                        user=toucher;
                        showMenu();
                    }
                }
            }
            else llRegionSayTo(toucher,0,"Sorry, this is already being used by someone else");
        }
        else showMenu();
    }
    listen(integer channel, string name, key who, string message)
    {
        stopListening();
        if (message=="DONE") finishedUsing();
        else if (message=="KILL ALL") doKillAll();
        else if (message=="-") showMenu();
        else if (message=="RESCAN")
        {
            doRescan();
            showMenu();
        }
        else if ((message=="< PREV")||(message=="NEXT >"))
        {
            if (message=="NEXT >") indNpc+=6;
            else indNpc-=6;
            checkIndex();
            showMenu();
        }
        else
        {
            // message is number of the NPC to remove
            doRemoveNpc(4*((integer)message));
            if (llGetListLength(npcList)<=4)
            {
                llRegionSayTo(user,0,"There are no more NPCs remaining in the region");
                finishedUsing();
            }
            else
            {
                checkIndex();
                showMenu();
            }
        }
    }
}
