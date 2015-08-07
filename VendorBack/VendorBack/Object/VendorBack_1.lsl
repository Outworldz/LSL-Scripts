// :CATEGORY:Vendor
// :NAME:VendorBack
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:950
// :NUM:1371
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// VendorBack
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
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ALL_OTHERS , 0, "back", NULL_KEY);
    }
}
