// :CATEGORY:AO
// :NAME:SuperSimpleAO
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2014-02-07 19:09:46
// :EDITED:2014-02-07 19:09:46
// :ID:1019
// :NUM:1583
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A very simple AO using the newest Second Life commands
// :CODE:
// :Description:  Super simple AO without timers can override the Sit, Stand and Walk animations

// Override the Sit, Stand and Walk animations
// 1. place this script and your animations in a prim
// 2. edit the animation names in the script to your animation's names
// 3. attach the prim to your avatar
// From the Second Life Wiki 
// Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0

//"Crouching"		
//"CrouchWalking"		
//"Falling Down"		
//"Flying"		
//"FlyingSlow"		
//"Hovering"		
//"Hovering Down"		
//"Hovering Up"		
//"Jumping"	While still in the air during a jump.	
//"Landing"	When landing from a jump.	
//"PreJumping"	At the beginning of a jump.	
//"Running"		
//"Sitting"	Sitting on an object (and linked to it).	
//"Sitting on Ground"	Sitting, but not linked to an object.[1]	
//"Standing"		
//"Standing Up"	After falling a great distance. Sometimes referred to as Hard Landing.	
//"Striding"	When the avatar is stuck on the edge of an object or on top of another avatar.	
//"Soft Landing"	After falling a small distance.	
//"Taking Off"		
//"Turning Left"		
//"Turning Right"		
//"Walking"

 
string gMySit = "chop_sit";
string gMyStand = "FStand _02";
string gMyWalk = "Kort gang F v4.1";
 
default
{
    attach(key id)
    {
        if ( id ) llRequestPermissions(id , PERMISSION_OVERRIDE_ANIMATIONS);
        else if ( llGetPermissions() & PERMISSION_OVERRIDE_ANIMATIONS ) llResetAnimationOverride("ALL");
    }
    run_time_permissions(integer perms)
    {
        if ( perms & PERMISSION_OVERRIDE_ANIMATIONS )
        {
            llSetAnimationOverride( "Sitting", gMySit);
            llSetAnimationOverride( "Standing", gMyStand);
            llSetAnimationOverride( "Walking", gMyWalk);
        }
    }
}
