// :CATEGORY:Door
// :NAME:Iris_Open_Script
// :AUTHOR:Cera Murakami
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:406
// :NUM:562
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Iris Open Script by Cera Murakami.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************






// Iris Open Script by Cera Murakami - 7/21/2006
// Touch-sensitive iris opening door
// Toggles open and closed state for a hole in a torus as an iris door
// Put this script into a flattened torus. 

// Iris opening door script, using a torus
//This script enables you to use a torus as a simple touch-activated iris door, for science fiction or organic building projects. It uses a torus as the prim for the door, and opens or closes the hole in the torus to operate it.
//
//To use, make a flattened torus, the height and width you need for your door, and about 0.1M to 0.05M thick. The 'door frame' for this can be another torus, or an oval or round hole in another prim.
//
//Note that the same script should also be able to be used with a different prim shape for the iris door prim, by changing the specifications in the two llSetPrimitiveParams statements to suit the other prim shape. I'll experiment some more with that soon, and will offer some variations here later. 


// ----- Global Variables ------------------
integer g_OpenNow;                 // True (1) if iris is 'open' now

default
{
    on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        if (g_OpenNow == TRUE) // Prim is in open state, so calculate new 'closed' size
        {
            state WaitToClose;
        }
        else // Prim is in a closed (or undefined state), so calculate new 'open' size
        {
            g_OpenNow = FALSE;
            state WaitToOpen;
        }
    }
}
      
state WaitToClose // Iris is Open, and waiting to close
{
    touch_start(integer total_number)
    {
         llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_TORUS, 0, <0.0, 1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <1.0, 0.5, 0.0>, <0.0, 0.0, 0.0>, <0.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 1.0, 0.0, 0.0]);
        g_OpenNow = FALSE;
        state WaitToOpen;
    }
}

state WaitToOpen // Iris is closed, and waiting to open
{
    touch_start(integer total_number)
    {
         llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_TORUS, 0, <0.0, 1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <1.0, 0.05, 0.0>, <0.0, 0.0, 0.0>, <0.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 1.0, 0.0, 0.0]);
        g_OpenNow = TRUE;
        state WaitToClose;
    }
}// END //
