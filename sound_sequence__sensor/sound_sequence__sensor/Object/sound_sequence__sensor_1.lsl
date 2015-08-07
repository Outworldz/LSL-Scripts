// :CATEGORY:Sound
// :NAME:sound_sequence__sensor
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:817
// :NUM:1127
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// sound sequence  sensor.lsl
// :CODE:

integer FLAG = FALSE;
integer FLAG2 = FALSE;

integer counter = 0;


default
{
    state_entry()
    {
         llSensorRepeat("", NULL_KEY, AGENT, 10.0, PI/2, 2 );

    }
    sensor(integer num) 
    {
        
        if (FLAG2 == TRUE)
        {
            vector pos = llDetectedPos(0);      // point at avatar
            llSay(-908765, (string) pos);

        }
         if (FLAG== FALSE)
         {
             
            key thisKey = llDetectedKey(0);
           
           
            llSay(0,"Welcome " +  llKey2Name(thisKey)) ;
            
            vector pos = llDetectedPos(0);
            llSay(-908765, (string) pos);

            
            integer sounds = llGetInventoryNumber(INVENTORY_SOUND);
            
            if (counter > sounds)
                counter = 0;
            string soundname = llGetInventoryName( INVENTORY_SOUND, counter );
            counter++;
            llSay(0,soundname);
            if ( soundname != "" )
            {
                llPlaySound( soundname, 1.0 );
            }

            FLAG2 = TRUE;
        }
        FLAG++;
         
     }
     
     
     
     no_sensor()
     {
        FLAG = FALSE;

        if (FLAG2 == TRUE)
             llSay(0,"Goodbye!");
             
        FLAG2 =  FALSE;
    }

}
  // END //
