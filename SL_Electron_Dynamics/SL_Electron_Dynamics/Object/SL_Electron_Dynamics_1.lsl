// :CATEGORY:Physical simulations
// :NAME:SL_Electron_Dynamics
// :AUTHOR:Daniel C. Smith 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:783
// :NUM:1071
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script has been working sporadically - use at your own risk. 
// :CODE:
//=============================================================
//SL Electron Dynamics, 0.1
//Demonstrates the movement of an electron through a magnetic field //Copyright (C) 2006 Daniel C. Smith //=============================================================
 
//GNU LICENSE ===============
//This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA. See: http://www.gnu.org/licenses/licenses.html
//============================

// This script is very rough. Use at your own risk!

// Instructions:
//==============
// Just place script in an object (with physics turned off!) and touch the object. Any nonphysical object 
// will do. I usually just use a sphere to represent an electron (or any charged particle).
// The default setting is a constant magnetic field pointing in the z direction, so the "electron" just 
// travels in a circle.
// You can change the initial velocity (v), charge (q), and mass (m) of the "electron."
// You can also change the magnetic field (b). For now I have only implemented a constant mangetic 
// field (constant in space and time).

// To do:
//=======
// - Make magnetic field variable in space and time.
// - Make magnetic field readable from an external source.
// - Add force due to electric field.

//SETTING UP THE OBJECT ===============

vector v; // velocity
vector x; // position
vector k0;
vector k1;
//vector k2;
//vector k3;
vector b = <0.0, 0.0, 1.0>; // magnetic field 
float q = -1.0; // charge 
float m = 1.0; // mass 
float dt; // timestep

default
{
    state_entry()
    {
        v = <0.0, 0.0, 0.0>;
        x = llGetPos();
    }
    
    on_rez(integer start_param)
    {
        llOwnerSay("Rezzing.");
        llResetScript();
    }

    touch_start(integer total_number)
    {
        //llSay(0, "Tally ho!");
        v = <1.0, 0.0, 0.0>; // Give an initial velocity.
        state move;
    }
}

state move
{
    state_entry()
    {
        llSetTimerEvent(0.02); 
    }
    
    timer()
    {
        // This is a 2nd (or 4th) order Runge-Kutta solver.
        dt = 0.2;
        x = x + v*dt;   // Calculate new position.
        llSetPos(x);    // Send to new position.
        //llOwnerSay((string) x.z);
        // Calculate terms for Runge-Kutta solver:
        k0 = dt*(q/m)*v%b;
        k1 = dt*(q/m)*(v + 0.5*k0)%b;
        //k2 = dt*(q/m)*(v + 0.5*k1)%b;
        //k3 = dt*(q/m)*(v + k2)%b;
        v = v + k1;   // Calculate new velocity (2nd order).
        //v = v + (k0 + 2*k1 + 2*k2 + k3)/6.0; // (4th order).
        //llOwnerSay((string) llVecMag(v)); // Print the speed.
        // Rinse. Lather. Repeat.
    }    
    
    touch_start(integer total_number)
    {
        state default; // Stop moving.
    }

    on_rez(integer start_param)
    {
        llOwnerSay("Rezzing.");
        llResetScript();
    }
            
    state_exit()
    {
        llSay(0, "Stopping.");
    }
}      
//=============================================================

