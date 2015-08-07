// :CATEGORY:Clock
// :NAME:KDCs_non_linear_solar_clock
// :AUTHOR:Kyrah Abattoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:417
// :NUM:573
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// KDC's non linear solar clock by Kyrah Abattoir.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************








// KDC's non linear solar clock
// Copyright (C) 2005 Kyrah Abattoir
//
//This is a bit of code i made to reflect the SL sun time, can be useful for roleplaying places that need clocks to display the proper time of the day according to the SL day/night cycle.
//
//NOTE: the speed at which time flow is not linear, in SL we have 3 hours of daytime for 1 hour of night time, but my clock is designed to consider day/night to be of equal length, so during the night the clock time flow FASTER than during the daytime, of course if the sim where you put the clock has time forced to a specific hour, the clock will be frozen too.
//
//
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

string tod = "am";
integer hour = 3600;
integer minute = 60;
default
{
    state_entry()
    {
        vector sun_angle =llGetSunDirection()*llEuler2Rot(<PI/4,0,0>);//flattening the vector
        sun_angle.z = 0;//filtering z out
        
        sun_angle = llVecNorm(sun_angle);//normalize
        
        float angle = llAcos(sun_angle.y/1)*RAD_TO_DEG;//convert the coords of the sun to angle
        
        if(sun_angle.x <0)//if we use the evening part of the quadrant
        {
            angle = 180 - angle;  
            tod = "pm";//switch to pm
        }
        
        float time = angle * 240;//convert in seconds
        integer hours = (integer)(time/hour);//extract hours
        time -= hour*hours;//substract seconds used by hours
        string minutes = (string)((integer)(time/minute));//extract minutes
        
        if( llStringLength(minutes) == 1 )//add a 0 to values of 1 digit
            minutes = "0"+minutes;
            
        llSetText((string)hours+":"+minutes+tod,<1,1,1>,1.0);
        llSleep(10.0);//sun is updated every 10 seconds
        llResetScript();
    }
} // END //
