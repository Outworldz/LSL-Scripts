// :CATEGORY:XS Pet
// :NAME:XS Pet Quail Modified
// :AUTHOR:Xundra Snowpaw, Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:09
// :ID:987
// :NUM:1421
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Modified Pet Quail
// :CODE:



// Version .24  10-3-2011

// script by Xundra Snowpaw
// mods by Ferd Frederix
//
// New BSD License: http://www.opensource.org/licenses/bsd-license.php
// Copyright (c) 2010, Xundra Snowpaw
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////



integer LINK_SPECIAL = 1010;          // xs_special, is str = "Normal", removes script


default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_SPECIAL) {
            if (str == "Normal") {
                llRemoveInventory("xs_special");
            } else {
                    // add states for specific specails
                }
        }
    }
}




