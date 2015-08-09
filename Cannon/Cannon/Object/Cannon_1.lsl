// :CATEGORY:Weapons
// :NAME:Cannon
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:150
// :NUM:218
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cannon
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

key target;
integer countdown;

default
{
    state_entry()
    {
        llSitTarget(<0,0,0.1>,ZERO_ROTATION);
        llSetText("Sit here to\nbe fired from the cannon!", <0.0, 1.0, 0.0>, 1.0);
    }
    
    timer()
    {
        llSay(0,"Cannon will fire in " + (string)countdown + " seconds.");
        countdown--;
        if( countdown<0 )
        {
            llSetTimerEvent(0);
            llPushObject(target, <0,0,2147483647>, ZERO_VECTOR, FALSE);
        }
    }

    changed(integer change)
    {
        
        if (change & CHANGED_LINK)
        {
          
            key agent = llAvatarOnSitTarget();

            if (agent)
            {     
                countdown = 10;
                target = agent;
                llUnSit(target);
                llSetTimerEvent(1);           
            }
        }
    }
}
