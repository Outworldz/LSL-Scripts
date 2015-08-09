// :CATEGORY:Curtain
// :NAME:Zillas_Curtain_script_V1
// :AUTHOR:Connely Aura
// :CREATED:2011-04-29 22:46:24.577
// :EDITED:2013-09-18 15:39:11
// :ID:990
// :NUM:1485
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Copyright (C) 2008 Zilla Larsson// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License version 3, as published by the Free Software Foundation.// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>
// :CODE:
vector offset = <1,0,0>; //Prim moves/changes size along this local coordinate
float hi_end_fixed = FALSE; //Which end of the prim should remain in place when size changes?          
                            //The one with the higher (local) coordinate? 
float min = 0.6; //The minimum size of the prim relative to its maximum size
integer ns = 10; //Number of distinct steps for move/size change


default {
    state_entry() {
        offset *= ((1.0 - min) / ns) * (offset * llGetScale());
        hi_end_fixed -= 0.5;
    }
    
    touch_start(integer detected) {
        integer i;
        do  llSetPrimitiveParams([PRIM_SIZE, llGetScale() - offset,
                PRIM_POSITION, llGetLocalPos() + ((hi_end_fixed * offset) * llGetLocalRot())]);
        while ((++i) < ns);           
        offset = - offset;
    }
}
