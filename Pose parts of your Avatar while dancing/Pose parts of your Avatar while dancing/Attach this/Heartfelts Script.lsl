// :SHOW:
// :CATEGORY:Animation
// :NAME:Pose parts of your Avatar while dancing
// :AUTHOR:Heartfelt
// :KEYWORDS:
// :CREATED:2016-09-10 10:18:08
// :EDITED:2016-09-10  09:18:08
// :ID:1109
// :NUM:1910
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Free Script to hold poses like carrying a bag or an umbrella or a cat whilst on a dance hud by Heartfelt
// :CODE:
//INSTRUCTIONS = Make an animation in the free program Qavimator http://www.qavimator.org.
// Make it about 555 frames long and make 1 pose at the very beginning and leave the rest.
// Upload it to second life on Singularity viewer as you can set anim priority to 5, make the lead in and lead out 0.000 set no loop .
// Upload it again and use the same settings but tick loop then put both anims into a prim with this script and write the names in then wear it.
// Then your pose will be forced to repeat every 0.2 seconds and you can carry stuff whilst other animations happen.
// enjoy and hugs <3 Heartfelt

float speed = 0.2;
string plushy1 = "write the animation name here inside the quote marks";
string plushy2 = "Write the other animation name here";

integer tickstate = 1;

default { 
    state_entry() { 
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    } 

    changed(integer change) { 
        if(change & CHANGED_OWNER) { 
           llResetScript();
        } 
    }
    run_time_permissions(integer perm) { 
        if(perm == PERMISSION_TRIGGER_ANIMATION) {
            llSetTimerEvent(speed); 
        } 
    } 
    
    attach(key id)
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
      
    timer(){
        if (tickstate == 2)  {     
            llStartAnimation(plushy2);
            llStopAnimation(plushy1);
            tickstate = 4;
        }  
         if (tickstate == 3)  {     
            llStartAnimation(plushy1);
            llStopAnimation(plushy2);
            tickstate = 2;
        }           
    
        if(tickstate == 4)
            tickstate = 3;
        
        if (tickstate == 1)  {     
            llStartAnimation(plushy2);   
            tickstate = 2;
        }                                                                                    
    }
}    
