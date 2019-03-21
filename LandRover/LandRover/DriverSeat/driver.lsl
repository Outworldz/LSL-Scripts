// :CATEGORY:Vehicle
// :NAME:LandRover
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:459
// :NUM:615
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Opensim Vehicle
// :CODE:

// Author: Davy Maltz
// Clean and user-friendly Poseball script.

// Downloaded from : http://www.outworldz.com/cgi/freescripts.plx?ID=1350

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// and these licenses may require you to publish any changes you make on request.
//
// There are literally thousands of hours of work in these scripts. Please respect
// the creators wishes and Copyright law and follow their license requirements.
//
// License information included herein must be included in any script you give out or use.
// Licenses may also be included in the script or comments by the original author, in which case
// the authors license must be followed, and  their licenses override any licenses outlined in this header.
//
// You cannot attach a license to any of these scripts to make any license more or less restrictive.
//
// All scripts by avatar Fred Beckhusen (Ferd Frederix), unless stated otherwise in the script, are licensed as Creative Commons By Attribution and Non-Commercial.
// Commercial use is NOT allowed - no resale of my scripts in any form.  
// This means you cannot sell my scripts but you can give them away if they are FREE.  
// Scripts by Fred Beckhusen (Ferd Frederix) may be sold when included in a new object that actually uses these scripts. Putting my script in a prim and selling it on marketplace does not constitute a build.
// For any reuse or distribution, you must make clear to others the license terms of my works. This is done by leaving headers intact.
// See http://creativecommons.org/licenses/by-nc/3.0/ for more details and the actual license agreement.
// You must leave any author credits and any headers intact in any script you use or publish.
///////////////////////////////////////////////////////////////////////////////////////////////////
// If you don't like these restrictions and licenses, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////
// The Script
// The Script
//Feel Free To Mod The Following Values. ~Davy
// Rev 2 - fixed the rotations to be expressed in degrees - Fred Beckhusen (Ferd Frederix)

//Animation Options
string animation_name = "avatar_sit_generic"; //The name of the animation to use (In Object Inv.)

//User/Owner Options
integer owner_only = FALSE; //TRUE or FALSE to only let the owner use the ball.

//Floating Text Options
string floating_text = ""; //What the floating text says in a string.
vector text_colour = <1,1,1>; //The color of the floating text in a vector.
float text_transparency = 1.0; //Transparency of the floating text. 0.0 to 1.0.

//Set Target/Sit Position Options
//vector sit_offset = <0,1.35,-.1>; //The offset from the ball while sitting.
 
 vector sit_offset = <0,0.35,-.1>; //The offset from the ball while sitting.

vector sit_rotation = <90,180,90>; //The avatar rotation while sitting.

rotation rot;
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        rot = llEuler2Rot(sit_rotation * DEG_TO_RAD);
        llSitTarget(sit_offset,rot);
        llSetText(floating_text,text_colour,text_transparency);
    } 
    changed(integer change)
    {
        if(change & CHANGED_LINK && llAvatarOnSitTarget() != NULL_KEY)
        {
            if(owner_only == FALSE)
            {
                llRequestPermissions(llAvatarOnSitTarget(),PERMISSION_TRIGGER_ANIMATION);
            }
            else if(owner_only == TRUE && llAvatarOnSitTarget() != llGetOwner())
            {
                llUnSit(llAvatarOnSitTarget());
                llSay(0,"Vehicle Currently Set To Owner Only.");
            }
        }
        if(llAvatarOnSitTarget() == NULL_KEY)
        {
            llMessageLinked(LINK_ROOT,0,"unsit","");
            llResetScript();
        }
    }
    run_time_permissions(integer perm)
    {
        if(llAvatarOnSitTarget() != NULL_KEY)
        {
            if(perm & PERMISSION_TRIGGER_ANIMATION)
            {
                //llStopAnimation("sit");
                //llStartAnimation(animation_name);
                llMessageLinked(LINK_ROOT,0,"sit",llAvatarOnSitTarget());
            }
            else if(!perm)
            {
                 llRequestPermissions(llAvatarOnSitTarget(),PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {   
                //llStopAnimation(animation_name);
                llMessageLinked(LINK_ROOT,0,"unsit","");
                llResetScript();
            }
        }
    }
}





