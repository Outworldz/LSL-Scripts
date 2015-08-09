// :CATEGORY:Pose Balls
// :NAME:FlipperPAs_autotransparent_minimum
// :AUTHOR:FLipperPA
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:321
// :NUM:429
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// FlipperPA's auto-transparent minimum lag pose thingy.lsl
// :CODE:

// FlipperPA's auto-transparent minimum lag pose thingy.

// STEP 1: Drop your pose into an object inventory with this script (only 1)
// STEP 2: Simply enter the text you wish to hover about the pose object below

string DISPLAY_TEXT = "Float";

// STEP 3: Hit "SAVE" below. If you change the pose, you can reset the script to re-read the pose

/////////////////////// DESCRIPTION AND USE ////////////////////////

//This script will automatically turn the prim it uses transparent and solid when used. It automatically reads the animation in inventory so you should have to modify anything other than the "Sit Replacement Text" at the top. It will cause almost no lag to your sim.
//Another advantage: I'm calling the transparent and solid textures by key, so you don't have to put any textures into the prim's inventory - just the script and the animation you want triggered. I'm sure they can be improved a bit, but here they are.
//Enjoy,

//-Flip

/////////////////////// DO NOT CHANGE BELOW ////////////////////////
string ANIMATION;
integer is_sitting;

default
{
    state_entry()
    {
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, 0);
        is_sitting = 0;
        llSitTarget(<0,0,.1>,ZERO_ROTATION);
        llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
        llSetText(DISPLAY_TEXT,<1,1,1>,1);
    }
    
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            key av = llAvatarOnSitTarget();
            
            if(av != NULL_KEY)
            {
                llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                if((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && is_sitting)
                {
                    is_sitting = 0;
                    llStopAnimation(ANIMATION);
                    llSetText(DISPLAY_TEXT,<1,1,1>,1);
                    llSetTexture("5748decc-f629-461c-9a36-a35a221fe21f",ALL_SIDES);
                }
            }
            
        }
        ANIMATION = llGetInventoryName(INVENTORY_ANIMATION, 0);
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            is_sitting = 1;
            llStopAnimation("sit_generic");
            llStopAnimation("sit");
            llStartAnimation(ANIMATION);
            llSetTexture("f54a0c32-3cd1-d49a-5b4f-7b792bebc204",ALL_SIDES);
            llSetText("",<1,1,1>,1);
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
} // END //
