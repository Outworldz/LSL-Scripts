// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:781
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Stop
// :CODE:

default
{

    link_message(integer sender_number, integer number, string msg, key id)
    {
        if (number == 99)
        {
            list anims = llGetAnimationList(id);        // get list of animations
            integer len = llGetListLength(anims);
            integer i;
            llSay(0, "Stopping " + (string)len + llGetSubString(" animations",0,-1 - (len == 1)));
            for (i = 0; i < len; ++i){
            key curAnim = llList2Key(anims, i);
            osAvatarStopAnimation(id,curAnim);
            llSay(0, "Stopping " + (string)curAnim);
            llSleep(2);
            }
        }
    }
}
