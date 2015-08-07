// :CATEGORY:Sound
// :NAME:Sound_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:816
// :NUM:1126
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sound Script.lsl
// :CODE:

string sound1="fire";
string sound2="fireS";
default
{
    state_entry()
    {
        llPreloadSound(sound1);
        
    }
    link_message(integer n, integer g, string m, key null)
    {
        if(m=="shots")
        {
            llTriggerSound(sound1,1.0);
        }
        if(m=="shotss")
        {
            llTriggerSound(sound2,1.0);
            llSleep(0.1);
            llTriggerSound(sound2,0.1);
        }
        
    }
}
            
            
            
        
      
// END //
