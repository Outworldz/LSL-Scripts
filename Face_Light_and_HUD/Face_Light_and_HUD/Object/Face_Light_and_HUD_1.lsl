// :CATEGORY:Face Light
// :NAME:Face_Light_and_HUD
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-03-29 22:56:31.820
// :EDITED:2013-09-18 15:38:52
// :ID:294
// :NUM:392
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put his in a regular prim
// :CODE:



vector gColor = <1,1,1>;        /// WHITE ( all colors on )
float intensity = 1.0;          
float radius = 1.0;
float falloff = 1.0;        // these can be tweaked


integer gLightOn = FALSE;

lightControl()
{
    llSetPrimitiveParams([
                
                PRIM_COLOR, 
                ALL_SIDES, 
                gColor, 
                0.0,
                PRIM_POINT_LIGHT, 
                 gLightOn, 
                 gColor, 
                 intensity, 
                 radius, 
                 falloff
                 
                 ]);
}



default
{
    on_rez(integer start_param) 
    {
        llResetScript();
    }
    
    
    listen(integer channel, string name, key id, string message) 
    {
        ///  llOwnerSay("Heard " + message);
        
        if (message == "ON") 
        {
            gLightOn = TRUE;
        } 
        else if (message == "OFF") 
        {
            gLightOn = FALSE;
        }
        else if (message == "Brilliant") 
        {
            intensity = 1.0;
            gLightOn = TRUE;   
        }
        else if (message == "Normal") 
        {
            intensity = 0.8;  /// YOU MAY NEED TO CHANGE THIS   
            gLightOn = TRUE;
        }
        else if (message == "Subtle") 
        {
            intensity = 0.4;  /// YOU MAY NEED TO CHANGE THIS for lower light level
            gLightOn = TRUE;
        }
        
        
        lightControl();     // This executes the lamp commands
    }

    state_entry() 
    {
        llListen(-9999, "", "", "");
        
        gLightOn = TRUE;        // Default = on;
        
        lightControl();         /// turn it on with the defaults
        
        
        if (llGetAttached() == 0) 
        {
            llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
        }
    }
    
    // this automatically attaches it to your chin, even if rezzed in-world.
    
    run_time_permissions( integer perms ) 
    {
        if (perms & PERMISSION_ATTACH) 
        {
            llAttachToAvatar(ATTACH_CHIN);
        }
    }
}
