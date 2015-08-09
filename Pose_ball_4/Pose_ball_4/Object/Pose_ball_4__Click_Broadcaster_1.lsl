// :CATEGORY:Pose Balls
// :NAME:Pose_ball_4
// :AUTHOR:Click Broadcaster
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:641
// :NUM:870
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Pose ball 4 - Click Broadcaster.lsl
// :CODE:

1// remove this number for the script to work.

//Pose Ball script, Revision 4.3
//Click Broadcaster

// ** This script is NOT FOR SALE **
//You can use it in commercial products as long as you give this script to anyone who asks for it.
//You can use this source, distribute it and modify it freely. Please leave the credits intact!

integer visible = TRUE;

default
{
    touch_start(integer total_number)
    {
        if(visible == TRUE)
        {
            llMessageLinked(LINK_SET,99,"hide",NULL_KEY);
            visible = FALSE;
        }
        else
        {
            llMessageLinked(LINK_SET,99,"show",NULL_KEY);
            visible = TRUE;
        }
    }
}
// END //
