// :CATEGORY:AO
// :NAME:Basic_NPC_AO_Animation_Override
// :AUTHOR:DZ
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:48
// :ID:81
// :NUM:108
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The intent is to provide an efficient way to give NPC's unique combinations of movement ONLY animations. These are simple scripts, easy to duplicate and modify the animations to use. Attach the AO to your HUD before you clone your appearance and generate the NPC. Touch the HUD to toggle it off and back on to make sure it is working. While designed for use with NPC's, these AO's will work just as well with other bot types or regular avatars.// This script monitors change events for a CHANGED_ANIMATION flag. This is vastly more efficient than parsing the list of current animations 3 or 4 times a second to see if you are still walking/standing/flying. There are other reasons NOT to try and use AOs ported from SL on NPC's. Most will fail to work at all, and some will actually animate the avatar that was cloned instead of the NPC.// An AO script is not much use with the animations to go with it. There are a number of good AO animation sets available in some of the public domain OAR and IAR files. I had the pleasure once to meet the creator of the animations contained in the Linda Kellie OAR files. The following scripts are adapted to those animation names so that you can drop them, and the animations (after you DL them) into a single prim and attach it to your HUD.// Rememeber, You must place the HUD on the ground to add animations, and you should take it back into inventory before wearing it to make sure the contents update properly.
// :CODE:

// A basic OpenSimulator Walk and Stand animation override
// All Modifications are Copyright 2010 by Doug Osborn.
 
// This script is Licensed under the Creative Commons Attribution-Share Alike 3.0 License
//  For a copy of the license terms  please see  http://creativecommons.org/licenses/by-sa/3.0
 
// This work uses content from the Second Life® Wiki article llGetAnimation. (http://wiki.secondlife.com/wiki/LlGetAnimation)
// Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License
 
// This AO is optimized for OpenSimulator and DOES NOT POLL the animation list multiple times a second
// It relies instead on the CHANGED ANIMATION event.  The timer is ONLY active when your avatar is swapping between stands.
 
// It is NOT optimized code.  Yes it could be smaller and probably faster.  This is simple, and is intended to provide a working object
// instead of a lasting tribute to anyones programming prowess.  Feel free to Optimize and re-distribute to your hearts content.
 
// To use:   Place this script in an object that will be attached to your avatar
//           Place the animations in the same prim
//           Change the CUSTOMIZATION section to reflect the names of YOUR animations.
//           Attach to your avatar or a HUD position
 
// To Reset  Detach and re-attach the object    or   Edit the object and Reset the script
 
// All of the overrides available via the traditional ZHAO can be controlled via this script.  
// The following Animation Types can be used by expanding the StartAnimation function to include the animation type
//
// [ Standing ]
// [ Walking ]
// [ Sitting ]
// [ Sitting On Ground ]
// [ Crouching ]
// [ Crouch Walking ]
// [ Landing ]
// [ Standing Up ]
// [ Falling ]
// [ Flying Down ]
// [ Flying Up ]
// [ Flying ]
// [ Flying Slow ]
// [ Hovering ]
// [ Jumping ]
// [ Pre Jumping ]
// [ Running ]
// [ Turning Right ]
// [ Turning Left ]
// [ Floating ]
// [ Swimming Forward ]
// [ Swimming Up ]
// [ Swimming Down ]
 
//  **************************   Customize YOUR AO  by  changing the names of the Animations, and the cycle time for your stands here.
 
// Change the folling lines to reflect the animation names you want to use
 
list StandNames = ["ao-sweetness-stand1", "ao-sweetness-stand2", "ao-sweetness-stand3", "ao-sweetness-stand4", "ao-sweetness-stand5"];
 
integer StandTime = 12;  //  change this number to the number of seconds between stands
 
string WalkAnimation = "sweetness walk";   //  Change this string to the name of the Walk animation you want to use
 
string RunAnimation = "AO-Run-Female";   //  Change this string to the name of the Run animation you want to use
 
string SitAnimation = "sweetness-sit-1";   //  Change this string to the name of the sit animation you want to use 
                                           //   For NPC AO, it is best to leave this blank.  Expect SIT objects to provide the proper animation
 
string CrouchAnimation = "AO-Crouch-Female";    //  Change this string to the name of the crouch animation you want to use
 
string FlyAnimation = "sweetness-fly-1";   //  Change this string to the name of the fly animation you want to use
 
string HoverAnimation = "sweetness-hover4";   //  Change this string to the name of the hover animation you want to use
 
string SoftLandAnimation = "AO-Softland1-Female";   //  Change this string to the name of the softland animation you want to use
 
integer LandingTime = 3;                          //  Change this to reflect the length of the standing animation in seconds.
 
string JumpAnimation = "AO-JumpFlip1-Female";   //  Change this string to the name of the Jump animation you want to use
 
//  *******************************************************************************************************************************
 
// *****  Below there be dragons  <wink>   not really!  *******  
 
//  You should not need to change anything below these lines
//  You are welcome to.  If you break it, you get to keep all the parts!
//   
 
key Owner; // the wearer's key
 
string LastAnimation = ""; // last llGetAnimation value seen
 
string LastAnimName = "";
 
string newAnimation = "";
 
float StandCount = 0.0;
 
integer PowerStatus = 1;
 
vector onColor = <42,255,42>;           // all nice and green
 
vector offColor = <128,128,128>;        // and grey
 
// User functions
 
Initialize(key id) 
{
    if (id == NULL_KEY)                         // detaching
    { 
        llSetTimerEvent(0.0);                       // stop the timer
    }
    else                                        // attached, or reset while worn
    { 
        llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        Owner = id;
        StandCount = (float) llGetListLength(StandNames);
    }
}
 
OnOff()
{
    vector color;
 
    if (PowerStatus == 0) 
    {
        PowerStatus = 1;
        newAnimation = llGetAnimation(Owner);
        StartAnimation();
        llOwnerSay("Over-ride active");
        color = onColor;
    }
    else
    {
        PowerStatus = 0;
        llStopAnimation(LastAnimName);
        llOwnerSay("Over-ride off");
        color = offColor;
    }
 
    llSetColor(color/255.0, ALL_SIDES);
}
 
StartAnimation()
{
            if (LastAnimation != newAnimation)    
            { 
                if (newAnimation == "Walking") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(WalkAnimation != "")
                    {                      
                        LastAnimName = WalkAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);
                }
 
                if (newAnimation == "Running") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(RunAnimation != "")
                    {                    
                        LastAnimName = RunAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);
 
                }                                
 
                if (newAnimation == "Standing") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(StandCount > 0.0)
                    {
 
                        integer whichone = (integer)llFrand(StandCount);// pick a new stand
 
                        LastAnimName = llList2String (StandNames,whichone);
 
                        llStartAnimation(LastAnimName);
 
                        if(StandCount > 1.0)                   
                             llSetTimerEvent(StandTime);
                    }                    
                    else
                    {
                        llSetTimerEvent(0);
                    }                        
                }  
 
                if (newAnimation == "Sitting") 
                { 
                    llStopAnimation(LastAnimName);
 
                   if(SitAnimation != "")
                    {                    
                        LastAnimName = SitAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);                   
                }  
 
                if (newAnimation == "Flying") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(FlyAnimation != "")
                    {                    
                        LastAnimName = FlyAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);
 
                }
 
                if (newAnimation == "Hovering") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(HoverAnimation != "")
                    {                    
                        LastAnimName = HoverAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);
 
                }
 
                if (newAnimation == "Soft Landing") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(SoftLandAnimation != "")
                    {                    
                        LastAnimName = SoftLandAnimation;
 
                        llStartAnimation(LastAnimName);
 
                        llSetTimerEvent(LandingTime);
                    }
 
                    llSetTimerEvent(0);
 
                }
 
                if (newAnimation == "Crouching") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(CrouchAnimation != "")
                    {                    
                        LastAnimName = CrouchAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);
 
                }                
 
                if (newAnimation == "Jumping") 
                { 
                    llStopAnimation(LastAnimName);
 
                    if(JumpAnimation != "")
                    {                    
                        LastAnimName = JumpAnimation;
 
                        llStartAnimation(LastAnimName);
                    }
 
                    llSetTimerEvent(0);
 
                }                                                          
}
}  
 
 
// Event handlers
 
default
{
    state_entry()
    {
        // script was reset while already attached
        if (llGetAttached() != 0) {
            Initialize(llGetOwner());
        }
    }
 
    attach(key id) {
        Initialize(id);
    }
 
    run_time_permissions(integer perm) 
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION) {
            llOwnerSay("Over-ride active"); 
        }
    }
 
    touch_start(integer whodunit)
    {
        OnOff();
    }
 
    timer()
    {
        llStopAnimation(LastAnimName);
 
        integer whichone = (integer)llFrand(StandCount);      // pick the new stand at random
 
        LastAnimName = llList2String (StandNames,whichone);
 
        llStartAnimation(LastAnimName);
 
//        llOwnerSay( "using " + LastAnimName);    // uncomment this to see which stand gets trigger by the timer
 
        llSetTimerEvent(StandTime);
    }        
 
    changed (integer change)
    {
        if (change & CHANGED_ANIMATION)
        {
 
            newAnimation = llGetAnimation(Owner);
 
            StartAnimation();
 
            LastAnimation = newAnimation; // so we can check for changes
 
//            llOwnerSay("started " + newAnimation);  // uncomment this to see the event types you can respond to 
 
//            llOwnerSay( "using " + LastAnimName);  // uncomment this to see which animations are being used
 
 
        }
    }
}

