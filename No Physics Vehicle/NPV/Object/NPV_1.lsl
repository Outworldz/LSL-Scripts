// :CATEGORY:Vehicles
// :NAME:No Physics Vehicle
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-17 21:48:39
// :ID:576
// :NUM:789
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// NPV.lsl
// :CODE:

float   speed       =   0.5;
vector  velocity    =   <0,0,0>;
default
{
    state_entry()
    {
        llSitTarget(<0,0,-0.5>,<0,0,0,0>);
        llSetCameraEyeOffset(<-6.0, 0.0, 2.00>);
        llSetCameraAtOffset(<0.0, 0.0, 1.0>);
        llListen(4,"",llGetOwner(),"");
    }
    
    changed(integer c)
    {
        if(c & CHANGED_LINK && llAvatarOnSitTarget() == llGetOwner())
        {
            llRequestPermissions(llAvatarOnSitTarget(),PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
        }   
    }
    
    listen(integer c, string n, key id, string msg)
    {
        speed = (float)msg;   
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION && llAvatarOnSitTarget() == llGetOwner())
        {
            llStopAnimation("Sit");
            llStartAnimation("!WAway");
        }
        if(perm & PERMISSION_TAKE_CONTROLS && llAvatarOnSitTarget() == llGetOwner())
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT,TRUE,FALSE);
        }
        if(perm & PERMISSION_CONTROL_CAMERA && llAvatarOnSitTarget() == llGetOwner())
        {
            
        }
    }
    
    touch_start(integer n)
    {
        llRequestPermissions(llAvatarOnSitTarget(),PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS | PERMISSION_CONTROL_CAMERA);
    }
    
    control(key id, integer held, integer change)
    {
        rotation rot;
        if(held & CONTROL_FWD)
            velocity.x = velocity.x + speed;
        else
            velocity.x *= 0.75;
        if(held & CONTROL_BACK)
             velocity.x = velocity.x - speed;
        else
            velocity.x *= 0.75;
            
        if(held & CONTROL_LEFT)
             velocity.y = velocity.y - speed;
        else
            velocity.y *= 0.75;
        if(held & CONTROL_RIGHT)
            velocity.y = velocity.y + speed;
        else
            velocity.y *= 0.75;
        if(held & CONTROL_UP)
            llSetPos(llGetPos() + <0,0,speed>);
        if(held & CONTROL_DOWN)
            llSetPos(llGetPos() + <0,0,-speed>);
        if(held & CONTROL_ROT_LEFT)
        {
            //llSetRot(llEuler2Rot(llRot2Euler(llGetRot())*RAD_TO_DEG - (<0,0,0.001>*DEG_TO_RAD)));
            rot = llGetRot() * llEuler2Rot(<0,0,0.12>); 
            llSetRot(rot);
        }
        if(held & CONTROL_ROT_RIGHT)
        {
            //llSetRot(llEuler2Rot(llRot2Euler(llGetRot())*RAD_TO_DEG - (<0,0,0.001>*DEG_TO_RAD)));
            rot = llGetRot() * llEuler2Rot(<0,0,-0.12>); 
            llSetRot(rot);
        }
        //if(velocity.x > 0.5) velocity.x = 0.5;
        //if(velocity.x < -0.5) velocity.x = -0.5;
        //if(velocity.y > 0.5) velocity.y = 0.5;
        //if(velocity.y < -0.5) velocity.y = -0.5;
        
        llSetPos(velocity * llGetRot() + llGetPos());
    }
}
// END //
