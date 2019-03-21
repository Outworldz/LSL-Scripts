// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1225
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

integer enabled;
integer on;

list colors = ["Black Glitter", "Blue Glitter", "Chocolate Glitter","Emerald Glitter","Golden Glitter","Purple Glitter","Red Glitter","Royal Glitter","Ruby Glitter","Silver Glitter","White Glitter"];
list codes = [<0.502, 0.502, 0.502>,<0.486, 0.745, 1.000>,<0.478, 0.239, 0.000>,<0.000, 0.537, 0.537>,<1.000, 1.000, 0.000>,<0.502, 0.000, 1.000>,<0.820, 0.000, 0.000>,<0.369, 0.369, 1.000>,<0.996, 0.580, 0.639>,<0.749, 0.749, 0.749>,<1.000, 1.000, 1.000>];


default
{

    state_entry()
    {
        llSetTimerEvent(1);
        llListen(99900,"","","");
    }
    
    touch_start(integer n)
    {
        llSay(100,"menu");
    }
    listen (integer channel, string name, key id, string msg)
    {
        integer where = llListFindList(colors,[msg]);
        if (where == -1)
            return;

         vector colorcode = llList2Vector(codes,where);
         
         integer i;
         integer j = llGetNumberOfPrims();
         for (; i <= j; i++)
         {
             llSetLinkColor(i,colorcode,ALL_SIDES);
         }

    }

    timer() {
        
         integer  avatarstuff = llGetAgentInfo(llGetOwner());

         if (avatarstuff & AGENT_IN_AIR)
            enabled = TRUE;
        else
            enabled = FALSE;
        
        if (enabled && ! on)
        {
            on = TRUE;
            llMessageLinked(LINK_SET,0,"on","");
        }
        if (!enabled &&  on)
        {
            on = FALSE;
            llMessageLinked(LINK_SET,0,"off","");
        }
    }
        
    on_rez(integer p)
    {
        llResetScript();
    }
}

