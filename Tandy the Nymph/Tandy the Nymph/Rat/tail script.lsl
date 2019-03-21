// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1216
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

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
         params_Up = [ PRIM_FLEXIBLE, TRUE, softness, -10, friction, wind, tension, force];
        params_Left = [ PRIM_FLEXIBLE, TRUE, softness, -gravity, friction, wind, tension,  forceL];
        params_Right = [ PRIM_FLEXIBLE, TRUE, softness, -gravity, friction, wind, tension,  forceR];

        params_Stiff = [ PRIM_FLEXIBLE, FALSE, softness,
         -gravity*4, friction, wind, tension,  force];

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
        
       // llSay(0,(string ) num);
        if (num < .25)
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




