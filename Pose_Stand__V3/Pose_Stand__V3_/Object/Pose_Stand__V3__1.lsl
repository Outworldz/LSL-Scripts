// :CATEGORY:Pose Stand
// :NAME:Pose_Stand__V3
// :AUTHOR:Fred Gandt
// :CREATED:2011-01-02 22:56:29.087
// :EDITED:2013-09-18 15:39:00
// :ID:644
// :NUM:874
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multi type, multi sex, multi story car park? Nope it just does poses.// // Create a fresh prim and drop this script on it. You have an instant pose stand. Then fill it with various poses and animations and copy the names of the animations into the lists at the top of the script. As you can see there are categories for 3 sex types and 3 body types. You could change these to suit (e.g. 3 styles (action, silly, erotic)) and 3 other things if you liked.// // Just put the names in the list that it makes most sense to put it in. As you sit on the stand (maybe these things should be called pose seats) you will be posted a dialog menu asking for "What type" then "What sex" then the list of anims appropriate for those choices. After making the animation choice, to recall the dialog menu click the pose stand.// 
// I kinda rushed to the finish with this one because something else came up. I will probably get back to it sometime but for now it seems to work ok.
// 
// ANIMATIONS WITH A BUILT IN OFFSET MAY BE POSITIONED BADLY. 
// 
// This work uses content from the Second Life® Wiki article Viewer Architecture. Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 Licens
// :CODE:
// V3 //
 
///////////////////////////////////////////////////////////////////
//YOU CAN CHANGE THESE MESSAGES. DON'T MAKE THEM TOO LONG THOUGH.//
///////////////////////////////////////////////////////////////////
 
string dialog_msg_type = "What type are you?";
 
string dialog_msg_sex = "What sex are you?";
 
string dialog_msg_anims = "Select the pose/animation to play";
 
/////////////////////////////////////////////////////////////////////////////
//////////WRITE INTO EACH LIST CATEGORY THE NAMES OF THE ANIMATIONS//////////
//APPROPRIATE FOR THAT CATEGORY. ANIMS MUST BE IN THE POSE STAND INVENTORY.//
/////////////////////////////////////////////////////////////////////////////
 
// Each of these lists can hold up to 72 names. However, if you filled them all to the max...
// ...you may encounter memory problems (not you, the script).
 
list tiny_male_anims = ["Tiny Male 1",
                        "Tiny Male 2",
                        "Tiny Male 3",
                        "Tiny Male 4",
                        "Tiny Male 5",
                        "Tiny Male 6",
                        "Tiny Male 7",
                        "Tiny Male 8",
                        "Tiny Male 9",
                        "Tiny Male 10",
                        "Tiny Male 11",
                        "Tiny Male 12",
                        "Tiny Male 13"];
 
list tiny_female_anims = ["Tiny Female 1", "Tiny Female 2", "Tiny Female 3"];
 
list tiny_thingy_anims = [];
 
 
list humanoid_male_anims = [];
 
list humanoid_female_anims = [];
 
list humanoid_thingy_anims = [];
 
 
list quadruped_male_anims = [];
 
list quadruped_female_anims = [];
 
list quadruped_thingy_anims = ["Quad Wotsit"];
 
///////////////////////////////////////////////////////////////////
//DON'T EDIT BELOW HERE UNLESS YOU ARE SURE OF WHAT YOU ARE DOING//
///////////////////////////////////////////////////////////////////
 
integer ousted;
 
integer last;
 
integer next;
 
string playing;
 
key agent = NULL_KEY;
 
string agent_name;
 
integer channel = -7463792;
 
integer lis;
 
list dialog_buttons_type = [];
 
list dialog_buttons_sex = [];
 
list agent_anim_set = [];
 
string type;
 
string sex;
 
CreatePoseStand()
{
    llSetPrimitiveParams([7, <1.0, 1.0, 0.1>,
                          9, 1, 0, <0.0, 1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <0.9, 0.9, 0.0>, <0.0, 0.0, 0.0>,
                          17, 0, "5748decc-f629-461c-9a36-a35a221fe21f", <3.0, 3.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
                          17, 1, "5748decc-f629-461c-9a36-a35a221fe21f", <0.35, 2.0, 0.0>, <0.0, 0.0, 0.0>, 1.570796,
                          17, 2, "5748decc-f629-461c-9a36-a35a221fe21f", <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
                          18, -1, <0.0, 0.0, 0.0>, 1.0,
                          19, 0, 3, 17,
                          19, 1, 3, 13,
                          19, 2, 3, 0]);
    SetName();
    llSitTarget(<0.0,0.0,1.5>, ZERO_ROTATION);
    llSetClickAction(CLICK_ACTION_SIT);
}
 
SetName()
{
    string name = llKey2Name(llGetOwner());
    llSetObjectName(((llGetSubString(name, 0, (llSubStringIndex(name, " ") - 1)) + "'s") + " Pose Stand"));
}
 
TypeCast()
{
    next = 0;
    dialog_buttons_type = [];
    if((llGetListLength(tiny_male_anims)) | (llGetListLength(tiny_female_anims)) | (llGetListLength(tiny_thingy_anims)))
    dialog_buttons_type += ["Tiny"];
    if((llGetListLength(humanoid_male_anims)) | (llGetListLength(humanoid_female_anims)) | (llGetListLength(humanoid_thingy_anims)))
    dialog_buttons_type += ["Humanoid"];
    if((llGetListLength(quadruped_male_anims)) | (llGetListLength(quadruped_female_anims)) | (llGetListLength(quadruped_thingy_anims)))
    dialog_buttons_type += ["Quadruped"];
    llListenRemove(lis);
    if(llGetListLength(dialog_buttons_type) && llGetInventoryNumber(INVENTORY_ANIMATION))
    {
        lis = llListen(channel, agent_name, agent, "");
        if(agent != NULL_KEY)
        llDialog(agent, ("\n" + dialog_msg_type), dialog_buttons_type, channel);
    }
    else
    {
        dialog_buttons_type = [];
        if(agent != NULL_KEY)
        llInstantMessage(agent, "There are no poses/animations available");
        if(agent != NULL_KEY)
        llUnSit(agent);
    }
}
 
SexCast()
{
    dialog_buttons_sex = [];
    if(type == "Tiny")
    {
        if(llGetListLength(tiny_male_anims))
        dialog_buttons_sex += ["Male"];
        if(llGetListLength(tiny_female_anims))
        dialog_buttons_sex += ["Female"];
        if(llGetListLength(tiny_thingy_anims))
        dialog_buttons_sex += ["Thingy"];
    }
    else if(type == "Humanoid")
    {
        if(llGetListLength(humanoid_male_anims))
        dialog_buttons_sex += ["Male"];
        if(llGetListLength(humanoid_female_anims))
        dialog_buttons_sex += ["Female"];
        if(llGetListLength(humanoid_thingy_anims))
        dialog_buttons_sex += ["Thingy"];
    }
    else if(type == "Quadruped")
    {
        if(llGetListLength(quadruped_male_anims))
        dialog_buttons_sex += ["Male"];
        if(llGetListLength(quadruped_female_anims))
        dialog_buttons_sex += ["Female"];
        if(llGetListLength(quadruped_thingy_anims))
        dialog_buttons_sex += ["Thingy"];
    }
    llListenRemove(lis);
    lis = llListen(channel, agent_name, agent, "");
    if(agent != NULL_KEY)
    llDialog(agent, ("\n" + dialog_msg_sex), dialog_buttons_sex, channel);
}
 
AnimSet()
{
    agent_anim_set = [];
    if(sex == "Male")
    {
        if(type == "Tiny")
        agent_anim_set = tiny_male_anims;
        else if(type == "Humanoid")
        agent_anim_set = humanoid_male_anims;
        else
        agent_anim_set = quadruped_male_anims;
    }
    else if(sex == "Female")
    {
        if(type == "Tiny")
        agent_anim_set = tiny_female_anims;
        else if(type == "Humanoid")
        agent_anim_set = humanoid_female_anims;
        else
        agent_anim_set = quadruped_female_anims;
    }
    else
    {
        if(type == "Tiny")
        agent_anim_set = tiny_thingy_anims;
        else if(type == "Humanoid")
        agent_anim_set = humanoid_thingy_anims;
        else
        agent_anim_set = quadruped_thingy_anims;
    }
}
 
SortDialog(integer b)
{
    last = b;
    string fore = "-";
    string dialog_anims = "";
    list dialog_buttons = [];
    integer count = b;
    integer max = (b + 10);
    do
    {
        string anim_name = llList2String(agent_anim_set, count);
        if(anim_name != "")
        {
            dialog_anims += ("\n" + ((string)(++count)) + " - " + anim_name);
            dialog_buttons += [((string)count)];
        }
        else
        count = max;
    }
    while(count < max);
    if(llGetListLength(agent_anim_set) > llGetListLength(dialog_buttons))
    {
        fore = ">>";
        if(max < llGetListLength(agent_anim_set))
        next = max;
        else
        next = 0;
    }
    dialog_buttons = llListInsertList(dialog_buttons, ["RESET", fore], 0);
    llListenRemove(lis);
    lis = llListen(channel, agent_name, agent, "");
    if(agent != NULL_KEY)
    llDialog(agent, dialog_anims, dialog_buttons, channel);
}
 
default
{
    state_entry()
    {
        CreatePoseStand();
    }
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            integer NOP = llGetNumberOfPrims();
            if(NOP == 1)
            {
                ousted = FALSE;
                agent = NULL_KEY;
                llListenRemove(lis);
                if(playing != "")
                {
                    llStopAnimation(playing);
                    playing = "";
                }
                llSetClickAction(CLICK_ACTION_SIT);
            }
            else if(NOP == 2)
            {
                if(!ousted)
                {
                    agent = llAvatarOnSitTarget();
                    agent_name = llKey2Name(agent);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION);
                }
            }
            else if(NOP == 3)
            {
                llUnSit(llGetLinkKey(3));
                ousted = TRUE;
            }
        }
        else if(change & CHANGED_OWNER)
        SetName();
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            if(agent != NULL_KEY)
            {
                llStopAnimation("Sit");
                if(agent != NULL_KEY)
                llInstantMessage(agent, "Don't forget to turn off your AO.");
                TypeCast();
            }
        }
    }
    touch_start(integer nd)
    {
        integer count;
        do
        {
            if(llDetectedKey(count) == agent)
            SortDialog(last);
        }
        while((++count) < nd);
    }
    listen(integer chan, string name, key id, string msg)
    {
        llListenRemove(lis);
        if(msg != "RESET")
        {
            if((msg != ">>") && (msg != "-"))
            {
                if(llListFindList(dialog_buttons_type, [msg]) != -1)
                {
                    type = msg;
                    dialog_buttons_type = [];
                    SexCast();
                }
                else if(llListFindList(dialog_buttons_sex, [msg]) != -1)
                {
                    sex = msg;
                    dialog_buttons_sex = [];
                    AnimSet();
                    SortDialog(0);
                    llSetClickAction(CLICK_ACTION_TOUCH);
                }
                else
                {
                    string name = llList2String(agent_anim_set, (((integer)msg) - 1));
                    if(llGetInventoryType(name) == INVENTORY_ANIMATION)
                    {
                        if(playing != "")
                        llStopAnimation(playing);
                        playing = name;
                        if(agent != NULL_KEY)
                        llStartAnimation(name);
                    }
                    else
                    {
                        if(agent != NULL_KEY)
                        llInstantMessage(agent, "\"" + name + "\" is missing from the pose stand inventory.");
                    }
                }
            }
            else
            {
                if(msg == ">>")
                SortDialog(next);
                else if(msg == "-")
                SortDialog(last);
            }
            return;
        }
        TypeCast();
    }
}
