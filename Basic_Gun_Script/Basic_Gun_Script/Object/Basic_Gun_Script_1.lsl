// :CATEGORY:Weapons
// :NAME:Basic_Gun_Script
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:80
// :NUM:107
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Basic Gun Script
// :CODE:
integer auto;
float speed;
default
{
   on_rez(integer start_param)
   {
       llResetScript();
}
state_entry()
{
    speed = 30;
    llListen(0,"",llGetOwner(),"");
    llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
   
}
listen(integer channel, string name, key id, string message)
{
 if(message == ".a on")
 {
     llOwnerSay("Semi-Auto On.");
     auto = 1;
    }
    if(message == ".a off")
 {
     llOwnerSay("Semi-Auto Off.");
     auto = 0;
    }
     if(llSubStringIndex(message,".speed ") != -1)
     {
         speed = (float)llGetSubString(message,7,llStringLength(message));
llOwnerSay("Speed Now Set To " + (string)speed);
 {
    } 
}
}
run_time_permissions(integer perm)
{
    if(perm)
    {
   llTakeControls(CONTROL_ML_LBUTTON,TRUE,TRUE);  
}
}
control(key id, integer level, integer edge)
{
     if(level & CONTROL_ML_LBUTTON && auto == 1)
     {
        
          llRezObject("bullet",llGetPos(),llRot2Fwd(llGetRot())*speed,ZERO_ROTATION,0); 
}
if(level & edge & CONTROL_ML_LBUTTON && auto == 0)
     {
        
          llRezObject("bullet",llGetPos(),llRot2Fwd(llGetRot())*speed,ZERO_ROTATION,0); 
        }
    }
}
