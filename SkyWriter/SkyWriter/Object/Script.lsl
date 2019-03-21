// :CATEGORY:Writing
// :NAME:SkyWriter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:03
// :ID:780
// :NUM:1068
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Write on the sky with mouselook
// :CODE:

integer offset=88000;
float zh;
default
{
    on_rez(integer a){
        llResetScript();
    }
    state_entry()
    {
        llOwnerSay("Press 'M' to go into mouselook. Then Hold the left Mouse Button to draw!!D");
        if(!llGetAttached())return;
        llSetTextureAnim(ANIM_ON+LOOP,ALL_SIDES,255,1,0,0,395+llFrand(75));
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
        llTakeControls(CONTROL_ML_LBUTTON,1,0);
        vector pos=llGetAgentSize(llGetOwner());
        zh=pos.z*.5;
    }

    control(key id,integer on, integer change)
    {
        offset+=1;
        if(on&CONTROL_ML_LBUTTON){
            llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),<0,0,zh>+llGetPos()+(<2.5,0,0>*llGetRot()),<0,0,0>,<0,0,0,0>,offset);
            llStartAnimation("arm0");
        }
        if(~on&CONTROL_ML_LBUTTON&&change&CONTROL_ML_LBUTTON){
            llRezObject(llGetInventoryName(INVENTORY_OBJECT,0),<0,0,zh>+llGetPos()+(<2.5,0,0>*llGetRot()),<0,0,0>,<0,0,0,0>,offset);
            offset+=5;
            llStopAnimation("arm0");
        }
    }
}
