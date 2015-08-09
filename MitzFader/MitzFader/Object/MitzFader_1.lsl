// :CATEGORY:Texture
// :NAME:MitzFader
// :AUTHOR:Mitzpatrick Fitzsimmons
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:515
// :NUM:699
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// he MitzFader// // This script will allow you to fade an object to a specific alpha between 0 and 100.// The transition effect is fairly smooth, and can be adjusted to your liking.// The script is written so that a chat command controls the action, but this can be changed to allow for other types of control, such as a Dialog Box, touch command, ect.
// :CODE:
// Fader by Mitzpatrick Fitzsimmons

// Place this script inside the object you wish to "fade"

//---------------------------------------------------------
//                   NOTES
// You can control (somewhat) how fast or slow your fader works by editing the float v variable
// which is set as (i * 0.01) by default.
// Change the 0.01 value to your liking (HINT: 0.02 will fade 2x faster than 0.01)
// You can also change the fade and fadeset values too...just remember to change your float too!

// SCRIPT

integer fadeset = 0;
integer fade = 100;

fade_up()
{
        float i;
        for (i =fadeset; i < fade; i++)
        {
            float v = i * 0.01;
            llSetAlpha(v, ALL_SIDES);
          }
}   

fade_down()
{
        float i;
        for (i =fadeset; i > fade; i--)
        {
            float v = i * 0.01;
            llSetAlpha(v, ALL_SIDES);
          }
}   

default
{
    state_entry()
    {
        llOwnerSay("Type 'fade #' where # is between 0 and 100");
        llListen(0,"",llGetOwner(),"");
        llListen(1,"",llGetOwner(),"");
    }
    
    on_rez(integer num)
    {
        llResetScript();
    }

    listen(integer number, string name, key id, string message)
    {
        if(llGetSubString(message, 0, 4) == "fade ")
        {
            fadeset = fade;
            fade = (integer) llGetSubString(message, 5, -1);
            if(fadeset < fade)
            {
                fade_up();
            }else{
                fade_down();
            }
            fadeset = fade;
        }
   }

}
