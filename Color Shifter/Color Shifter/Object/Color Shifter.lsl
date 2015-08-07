// :CATEGORY:Color
// :NAME:Color Shifter
// :AUTHOR:ferd Frederix    
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:50
// :ID:189
// :NUM:262
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Color shifter for dance floors, makes a bunch of linked prims very colorful
// :CODE:


// Color shifter for dance floors, makes a bunch of linked prims very colorful

list colCom ;  // an empty list we will fill up with color vectors
integer position = 0;    // the first position in the list = 0

default
{
    state_entry()
    {
        // Here I set up three start and 3 end color schemes in a list, which must be done in pairs.
        // You can add as many as you want.  I picked 3 cuz i am lazy
        //
        // syntax is always <RED,GREEN,BLUE>, in 0 to 255 decimal numbers.
        // If this bothers you, try just multiplying by 255 to get the equivalent.
        // so 50% red, 25% green, and 10 blue = 0.5, 0.25, 0.1, or multiplied by 255 = 128, 64, 25, which is entered as <128,64,25>
        // This is the same as the color numbers in the Texture Window in SL.

        // first color pair       
        colCom += <255,0,0>; // start with 100% = 255 red
        colCom += <0,0,255>; // go to all blue

        // color pair
        colCom += <0,0,255>; // start with all  blue
        colCom += <0,255,0>; // end with all green


        //  color pair
        colCom += <0,255,0>; // start with 100% = 255 green
        colCom += <255,0,0>; // now back to red.  It will repeat after that starting with step #1, all red

        // you can use partial colors, too. White = <255,255,255>, black = <0,0,0>, light cyan = <0,128,128>, and so on.

        // the list colCom now contains 6 vectors
       
        llSetTimerEvent(5.0);   //wait 5 seconds, then change color   
    }
   
    timer ()
    {
        vector startCol = llList2Vector(colCom,position);  // get the vector on the list colCom pointed to by 'position'
        vector endCol = llList2Vector(colCom,position+1);  // get the next one for end color
        vector grades = <(endCol.x - startCol.x)/llGetNumberOfPrims(), (endCol.y - startCol.y)/llGetNumberOfPrims(), (endCol.z - startCol.z)/llGetNumberOfPrims()>;
        // grades is a vector of 3 numbers represeting the difference added each time to fade the color
        // each color bit, the <Reg,Green.Blue> is now the difference between start and end color as a percentage of the number of prims

        // scan over each prim and make the changes from start to end using the percentage change in 'grades'
        integer x;
        for(x = 1; x < llGetNumberOfPrims()+ 1; x++)
        {
            startCol += grades;        // add the delta we calculated above to a start color
            llSetLinkColor(x, startCol, ALL_SIDES);    // and set the color
        }

        // now we need to get the next color scheme
        position += 2; // advance to the next position in the list, which is two steps up, not one

        // llGetListLength returns the number 3 in my demo, we need to check against the numbers 0,1,2 as lists are zero-based, so I check for >=, not just greater than.
        if (position >=  llGetListLength(colCom))
        {
            position = 0; // reset to beginning if past the 3rd item (as in 0,1,2)
        }
       
    }        // end timer
   
}// end program

