// :CATEGORY:Candles
// :NAME:Candle_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:149
// :NUM:217
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Candle Script.lsl
// :CODE:
// you need two textures, one of a lit candle, and one without.
default
{
     state_entry()
     {
         llSetStatus(STATUS_PHANTOM, TRUE);
         llSetTexture("lit_texture", ALL_SIDES);
         llListen(0,"","","blow");
         llListen(0,"","","light");
     }

     touch_start(integer number)
     {
            llSetTexture("lit_texture",ALL_SIDES);
     }

     listen(integer number, string name, key id, string message)
     {
        if(message=="blow")
        {
           llSetTexture("unlit_texture",ALL_SIDES);
        }
       else if(message=="light")
        {
           llSetTexture("lit_texture",ALL_SIDES);
        }
        }
     }
 
 
 // END //
