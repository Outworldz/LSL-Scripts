// :CATEGORY:Pose Balls
// :NAME:DavyAnimBall
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:221
// :NUM:307
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DavyAnimBall
// :CODE:
// The Script
//Feel Free To Mod The Following Values. ~Davy
Rev 2 - fixed the rotations to be expressed in degrees - Fred Beckhusen (Ferd Frederix)

//Animation Options
string animation_name = "sit"; //The name of the animation to use (In Object Inv.)

//User/Owner Options
integer owner_only = FALSE; //TRUE or FALSE to only let the owner use the ball.

//Floating Text Options
string floating_text = ""; //What the floating text says in a string.
vector text_colour = <1,1,1>; //The color of the floating text in a vector.
float text_transparency = 1.0; //Transparency of the floating text. 0.0 to 1.0.

//Set Target/Sit Position Options
vector sit_offset = <0,-0.3,0.4>; //The offset from the ball while sitting.
vector sit_rotation = <0,0,-90>; //The avatar rotation while sitting.

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
                llSay(0,"Poseball Currently Set To Owner Only.");
            }
        }
        if(llAvatarOnSitTarget() == NULL_KEY)
        {
            llResetScript();
        }
    }
    run_time_permissions(integer perm)
    {
        if(llAvatarOnSitTarget() != NULL_KEY)
        {
            if(perm)
            {
                llStopAnimation("sit");
                llStartAnimation(animation_name);
            }
            else if(!perm)
            {
                 llRequestPermissions(llAvatarOnSitTarget(),PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {   
                llStopAnimation(animation_name);
                llResetScript();
            }
        }
    }
}


