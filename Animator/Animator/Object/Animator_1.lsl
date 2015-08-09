// :CATEGORY:Animation
// :NAME:Animator
// :AUTHOR:Fred Kinsei
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-08-11
// :ID:39
// :NUM:52
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Functions & Commands: Agent Animator Made by Fred Kinsei
// // This script allows you to request permissions from another agent and then play animations on them.
//  Can be used for fun, modeling, or any remote animation function.

// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei

// The script holds a persons permissions until it is reset, or either the owner or the person you took permission from logs off.// 
// All commands should be lowercase. All commands are available on channel's 0 and 3. It will only play animations from SL's
// default anims OR any animations within the inventory the script is in. You can place animations in before or after you have
// gotten someone's permissions. You can only have animation permissions from one person at a time.
// 
// Commands: request name OR request self -- This gets someone's permissions, they need to be within 96 meters of you. You only need first names, or parts of first names. -- This will release any previous permissions. -- It will tell you if they accept/reject your request.
// 
// play animname -- This will play the name of the animation you mentioned, this is CASE SENSITIVE. -- They must be in the same sim as you to play animations.
// 
// stop -- This will stop the last played animation
// 
// stop all -- This stops ALL animations they are playing, even one's you didn't start.
// 
// release -- This will release your current permissions.


string find;
string anim;
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llListen(0, "", llGetOwner(), "");
        llListen(3, "", llGetOwner(), "");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(llGetSubString(message, 0, 6) == "request")
        {
            find = llGetSubString(message, 8, -1);
            if(find == "self")
                llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            else
                llSensor("", "", AGENT, 96, TWO_PI);
        }
        else if(llToLower(llGetSubString(message, 0, 3)) == "play")
        {
            if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
            {
                llStartAnimation(llGetSubString(message, 5, -1));
                anim = llGetSubString(message, 5, -1);
            }
        }
        if(message == "stop")
        {
            if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
            {
                llStopAnimation(anim);
            }
        }
        if(message == "stop all")
        {
            if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)
            {
                list anims = llGetAnimationList(llGetPermissionsKey());
                integer len = llGetListLength(anims);
                integer i;
                for (i = 0; i < len; ++i) llStopAnimation(llList2Key(anims, i));
            }
        }
        if(message=="release")
            llResetScript();
    }
    run_time_permissions(integer perms)
    {
        if(perms & PERMISSION_TRIGGER_ANIMATION)
        {
            list anims = llGetAnimationList(llGetPermissionsKey());
            integer len = llGetListLength(anims);
            integer i;
            for (i = 0; i < len; ++i) llStopAnimation(llList2Key(anims, i));
            llOwnerSay("Permissions Accepted");
        }
        else if(!(perms & PERMISSION_TRIGGER_ANIMATION))
            llOwnerSay("Permissions Denied");
    }
    sensor(integer num)
    {
        integer i;
        for(i=0;i<num;i++)
        {
            if(llSubStringIndex(llToLower(llDetectedName(i)), llToLower(find)) == 0)
            {
                llOwnerSay("Requesting " + llKey2Name(llDetectedKey(i)));
                llRequestPermissions(llDetectedKey(i), PERMISSION_TRIGGER_ANIMATION);
                return;
            }
        }
    }
}
