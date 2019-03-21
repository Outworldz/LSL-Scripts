// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1219
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

// License:
// Copyright (c) 2009, Fred Beckhusen (Ferd Frederix)

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
paint(string texture)
{
    integer j = llGetNumberOfPrims();
    integer i;
    llSetTexture(texture,ALL_SIDES);
    for (; i < j; i++)
    {
        llSetLinkPrimitiveParamsFast(i,[PRIM_TEXTURE,ALL_SIDES, texture, <1.0,1.0,0.0>, <0.0,0.0,0.0>, 0.0]);
    }
} 

default
{
    
    on_rez(integer p)
    {
        llResetScript();
    }
    
    state_entry()
    {
        llListen(99900,"","","");
    }

    listen(integer channel, string name, key id, string msg )
    {
        
        integer i;
        integer j = llGetInventoryNumber(INVENTORY_TEXTURE);
        for (; i < j; i++) {
            string realName = llGetInventoryName(INVENTORY_TEXTURE, i);
            list bits = llParseString2List(realName,["_"],[]);
            if ( llList2String(bits,0) == msg)
                paint(realName);
        }     

    }
}

