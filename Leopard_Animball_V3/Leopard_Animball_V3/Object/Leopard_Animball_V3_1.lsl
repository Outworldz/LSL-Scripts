// :CATEGORY:Pose Balls
// :NAME:Leopard_Animball_V3
// :AUTHOR:Leopard Loveless
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:466
// :NUM:627
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Leopard Animball V3.lsl
// :CODE:

// Advanced Animball by Leopard Loveless. Feel free to copy and spread.

string floattext = "wall1";
string sittext = "  ";
string animationfilename = "wl2";
string lockcommand = "lock";
string unlockcommand = "unlock";
string hidecommand = "hide";
string showcommand = "show";
string owneronlycommand = "owner";
string allcansitcommand = "all";
vector floatcolor=<1.0,1.0,1.0>; // Color of the floating text. RGB, from 0.0 to 1.0
vector offset=<-0.1,0.0,-0.7>; // Offset between the ball and the animation center, never set all 3 axis to 0..
integer channel = 9; // Channel to listen on for commands. Set to 0 if you want it public.

// Do net edit below this line.

integer listener=0;
integer owneronly=0;
integer locked;
key sitAgent = NULL_KEY;
integer gotPermission = FALSE;

default
{
    state_entry()
    {
        llSetSitText(sittext);
        llListenRemove(listener);
        llSitTarget(offset,ZERO_ROTATION);
        llListen(channel,"",NULL_KEY,"");
    }
    on_rez(integer start_param)
    {
        llSetText(floattext,floatcolor,1.0);
        llSetAlpha(1.0,ALL_SIDES);
    }
    listen(integer channel, string name, key id, string message)
    {
        if ((id==llGetOwner()) || (locked==0))
        {
            if (message==lockcommand)
            {
                locked=1;
                return;
            }
            if (message==unlockcommand)
            {
                locked=0;
                return;
            }
            if (message==hidecommand)
            {
                llSetText("",<0.0,0.0,0.0>,0.0);
                llSetAlpha(0.0,ALL_SIDES);
                return;
            }
            if (message==showcommand)
            {
                llSetText(floattext,floatcolor,1.0);
                llSetAlpha(1.0,ALL_SIDES);
                return;
            }
            if (message==owneronlycommand)
            {
                owneronly=1;
                return;
            }
            if (message==allcansitcommand)
            {
                owneronly=0;
                return;
            }
        }
    }
    touch_start(integer num_detected)
    {
        llSetText("",<0.0,0.0,0.0>,0.0);
        llSetAlpha(0.0,ALL_SIDES);
    }
    changed(integer change) {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if ((agent==llGetOwner()) || (owneronly==0))
            {
                if ( sitAgent == NULL_KEY && agent != NULL_KEY ) {
                    // Someone new sitting down
                    sitAgent = agent;
                    llRequestPermissions(sitAgent,PERMISSION_TRIGGER_ANIMATION);
                }
                else if ( sitAgent != NULL_KEY && agent == NULL_KEY) {
                    // sitting down person got up - wake up :)
                    if ( gotPermission )
                     llStopAnimation(animationfilename);
                    // Reset the script because we don't have a way of releasing permissions :)
                    llResetScript();
                }
            } else
            {
                llWhisper(0,"Sorry, only "+llKey2Name(llGetOwner())+" can use this.");
                llSleep(0.5);
                llUnSit(agent);
            }
        }        
    }
    run_time_permissions(integer parm) {
        if(parm == PERMISSION_TRIGGER_ANIMATION) {
            gotPermission = TRUE;
            llStopAnimation("sit");
            llStartAnimation(animationfilename);
        }
    }
}
// END //
