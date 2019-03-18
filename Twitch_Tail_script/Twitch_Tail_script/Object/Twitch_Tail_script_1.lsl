// :CATEGORY:Avatar
// :NAME:Twitch_Tail_script
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-03-03 20:58:49.650
// :EDITED:2013-09-18 15:39:08
// :ID:928
// :NUM:1333
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Twitch_Tail_script
// :CODE:
// twitchy tail script by Fred Beckhusen (Ferd Frederix)
// Open Source provided this header is intact and credit is given.

float on = 0.0;
float off = 1.0;
list params_Up ;
list params_Left ;
list params_Right ;
list params_Stiff;

float ona = 0.0;
float offa = 1.0;

integer softness = 1;
float gravity = 0.4;
float friction =3.0;
float wind = 0.0;
float tension = 1.5;
vector force =<0,0,0>;
vector forceL =<1,0,0>;
vector forceR =<-1,0,0>;
default
{
    state_entry()
    {
         params_Up = [ PRIM_FLEXIBLE, TRUE, softness, -1, friction, wind, tension, force];
        params_Left = [ PRIM_FLEXIBLE, TRUE, softness, -gravity, friction, wind, tension,  forceL];
        params_Right = [ PRIM_FLEXIBLE, TRUE, softness, -gravity, friction, wind, tension,  forceR];
        params_Stiff = [ PRIM_FLEXIBLE, FALSE, softness, -gravity*4, friction, wind, tension,  force];
        llSetPrimitiveParams(params_Up);
        llSetTimerEvent(1);
    }


    touch_start(integer total_number)
    {
        llSay(0, "Don't touch that!");
    }
    
    timer()
    {
        float num  = llFrand(4);
        
         if (num < 0.25)
         {  
             llSetPrimitiveParams(params_Stiff);
         }
         else if (num < 2)
         {
             llSetPrimitiveParams(params_Up);
         }        
         else if (num < 3)
         {
             llSetPrimitiveParams(params_Right);
         }    
         else {
             llSetPrimitiveParams(params_Left);
        }   
        
         llSetTimerEvent(llFrand(1) + 1); 
    }

    on_rez(integer param)
     {
         llResetScript();
     }
}
