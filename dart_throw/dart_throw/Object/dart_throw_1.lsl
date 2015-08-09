// :CATEGORY:Weapons
// :NAME:dart_throw
// :AUTHOR:Martin
// :CREATED:2010-06-23 18:58:43.730
// :EDITED:2013-09-18 15:38:51
// :ID:219
// :NUM:295
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// add   a "sink" script into the arrow for it to stick
// :CODE:
//
//  This basic script acts as a gun, by doing the following: 
//
//  Attach gun to right hand so that aiming animation is correct.
//
//   prim's coordinate system.
string object = "object"; // Name of object in inventory
vector relativePosOffset = <2.0, 0.0, 1.0>; // "Forward" and a little "above" this prim
vector relativeVel = <30.0, 0.0, 0.0>; // Traveling in this prim's "forward" direction at 1m/s
rotation relativeRot = <-0.07107, -0.707107, 0.0, 0.707107>; // Rotated 90 degrees on the x-axis compared to this prim
integer startParam = 10;

default
{
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llAttachToAvatar(ATTACH_LHAND);
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_bazooka");
        }
    }
    
    touch_start(integer tnum)
    {
        
        integer perm = llGetPermissions();
        key on = llDetectedKey(0);
        key avatar = llDetectedKey(0);
        key owner = llGetOwner();
        if (owner == avatar)
        {
            llWhisper(0, "Attach me to your right hand, and enter mouselook to fire!");
            //if (perm != (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH))
   //         {
     //           llRequestPermissions(on, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH);
       //     }
         //   else
           // {
            //    llAttachToAvatar(ATTACH_RHAND);
             //   llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
             //   llStartAnimation("hold_R_handgun");
           // }
        }
        else
        {
            llWhisper(0, "Buy a copy and rez from your inventory and attach to your right hand to use.");
        }
    }
    
    attach(key on)
    {
        if (on != NULL_KEY)
        {
            integer perm = llGetPermissions();
            
            if (perm != (PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_ATTACH);
            }
            else
            {
                llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
                llStartAnimation("hold_R_bazooka");
            }
            
        }
        else
        {
            llTakeControls(FALSE, TRUE, FALSE);
            llStopAnimation("hold_R_bazooka");
        }
    }
        
    control(key owner, integer level, integer edge)
    {
        if ((level & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
        {
            //  Mouse down
            if ((edge & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            { 
                // First Press - start sound loop and point
                //llSay(0, "Start");
                ;
         vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
 
        llRezObject(object, rezPos, rezVel, rezRot, startParam);
                        llStartAnimation("avatar_throw_R");
            
            
        }
        else
        {
            if ((edge & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            { 
                // Stopped
                //llSay(0, "Stop");
                
                llStopPointAt();
            }  
        }
    
    }
}}
