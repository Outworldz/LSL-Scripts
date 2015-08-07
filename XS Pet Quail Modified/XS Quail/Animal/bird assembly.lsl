// :CATEGORY:XS Quail
// :NAME:XS Pet Quail Modified
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2014-01-01 12:18:57
// :ID:987
// :NUM:1413
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// XS Quail
// :CODE:

// Version .24  10-3-2011

// script by Ferd Frederix
//

// New BSD License: http://www.opensource.org/licenses/bsd-license.php
// Copyright (c) 2010, Ferd Frederix
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////

default
{
    state_entry()
    {
        
        float new_scale = 1.0;
        
        vector  new_size = <0.124, 0.082, 0.096> * new_scale;
        vector new_pos;
        
        llSetPrimitiveParams([PRIM_SIZE, new_size]);

        // -> body -> tail <-0.032043,-0.000061,0.009560> 9

        new_size = <0.082, 0.082, 0.082> * new_scale;
        new_pos = <-0.032043,-0.000061,0.009560> * new_scale;
        llSetLinkPrimitiveParams(9, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> left wing <-0.004141,0.034098,0.008184> 7
        new_size = <0.058, 0.079, 0.023> * new_scale;
        new_pos = <-0.004141,0.034098,0.008184> * new_scale;

        llSetLinkPrimitiveParams(7, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> right wing <-0.011113,-0.034257,0.008841> 4
        new_size = <0.058, 0.079, 0.023> * new_scale;
        new_pos = <-0.011113,-0.034257,0.008841> * new_scale;

        llSetLinkPrimitiveParams(4, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> left leg <0.009700,0.020261,-0.052318> 6
        new_size = <0.01, 0.01, 0.064> * new_scale;
        new_pos = <0.009700,0.020261,-0.052318> * new_scale;

        llSetLinkPrimitiveParams(6, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> right leg <0.009747,-0.022943,-0.052399> 10
        new_size = <0.01, 0.01, 0.064> * new_scale;
        new_pos = <0.009747,-0.022943,-0.052399> * new_scale;

        llSetLinkPrimitiveParams(10, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> head <0.042349,-0.000059,0.055298> 5
        new_size = <0.082, 0.082, 0.082> * new_scale;
        new_pos = <0.042349,-0.000059,0.055298> * new_scale;

        llSetLinkPrimitiveParams(5, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);
        // -> body -> head  -> left eye <0.067205,0.018735,0.070143> 8
        new_size = <0.024, 0.024, 0.024> * new_scale;
        new_pos = <0.067205,0.018735,0.070143> * new_scale;

        llSetLinkPrimitiveParams(8, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> head -> right eye <0.067265,-0.017552,0.070217> 3
        new_size = <0.024, 0.024, 0.024> * new_scale;
        new_pos = <0.067265,-0.017552,0.070217> * new_scale;

        llSetLinkPrimitiveParams(3, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);

        // -> body -> head -> beak  <0.086439,-0.000059,0.049794> 2
        new_size = <0.043, 0.043, 0.043> * new_scale;
        new_pos = <0.086439,-0.000059,0.049794> * new_scale;

        llSetLinkPrimitiveParams(2, [PRIM_SIZE, new_size, PRIM_POSITION, new_pos]);
    }

}
