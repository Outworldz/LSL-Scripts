// :CATEGORY:Vehicles
// :NAME:CarSeat
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:159
// :NUM:227
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// CarSeat
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

default
{
    state_entry()
    {
        llSitTarget(<0.2,0,0.45>, ZERO_ROTATION );
    }
}
