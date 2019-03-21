//  xs_prim_animator_timer
// Used to debug the amimator.  This makes the pet stand, wave, stand, and walk


/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike

// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship to me and leave this notice intact.
//
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Fred Beckhusen (Ferd Frederix)

// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
// in the documentationand/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////

integer counter;

default
{
    state_entry()
    {
        llSetTimerEvent(5);
    }

    timer()
    {
        if (counter++ == 0)
        {
            llMessageLinked(LINK_SET,1,"stand","");
            llSleep(1.0);
            llMessageLinked(LINK_SET,1,"wave","");
            llSleep(1.0);
            llMessageLinked(LINK_SET,1,"stand","");
        }
        else if (counter == 2)
        {
            llMessageLinked(LINK_SET,1,"left","");
            llSleep(.5);
            llMessageLinked(LINK_SET,1,"right","");
            llSleep(.5);
            llMessageLinked(LINK_SET,1,"left","");
            llSleep(.5);
            llMessageLinked(LINK_SET,1,"right","");
            llSleep(.5);
            llMessageLinked(LINK_SET,1,"stand","");
        }
        else if (counter == 3)
        {
            llMessageLinked(LINK_SET,1,"sleep","");
            llSleep(5);
        }
        else
        {
            counter = 0;
        }

    }


}
