// :CATEGORY:Weapons
// :NAME:BulletCage
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:128
// :NUM:191
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BulletCage
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

//
//  Encog's MultiBullet Gun Bullet
//
//  Cage Bullet: This bullet will put a cage around its target.
// 


default
{   
    on_rez(integer delay)
    {
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
        llSetDamage(0);
        llSetBuoyancy(1.0);                 //  Make bullet float and not fall 
        llCollisionSound("", 1.0);          //  Disable collision sounds
        
        if (delay >0 ) 
        {
            llSetTimerEvent(delay);            
        }
    }

    collision_start(integer total_number)
    {
        if (llDetectedType(0) & AGENT)
        {
            llRezObject("Cage", llDetectedPos(0), ZERO_VECTOR, ZERO_ROTATION, 0);
        }
    }
    
    timer()
    {
        llDie();
    }
    
}
