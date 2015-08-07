// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1226
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// License:
// Copyright (c) 2009, Ferd Frederix

// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:

// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
default
{

    state_entry()
    {
        //[ PRIM_FLEXIBLE, integer boolean, integer softness, float gravity, float friction, float wind, float tension, vector force ]
        llSetPrimitiveParams([ PRIM_FLEXIBLE, TRUE, 2, 0.3, 2.0, 0, 1.0, <0,0,0>] );

        llSetAlpha(1.0, ALL_SIDES);
    }
    
    link_message(integer s, integer num, string str, key id)
    {
           
            
        if (str == "off")
        {
            llSetAlpha(1,ALL_SIDES);
        }
        else if (str == "on")
        {
            llSetAlpha(0,ALL_SIDES);
            llSetPrimitiveParams([ PRIM_FLEXIBLE, TRUE, 2, 0.3, 2.0, 0, 1.0,  <0,0,0>] );
        }
    }

    on_rez(integer p)
    {
        llSetAlpha(0,ALL_SIDES);
    }
}

