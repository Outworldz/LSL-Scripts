// :CATEGORY:Barometer
// :NAME:Barometer
// :AUTHOR:Cid Jacobs
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:77
// :NUM:104
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Barometer.lsl
// :CODE:


// llAirPressure(vector v) Script
// Created by: Cid Jacobs
// Original by: Cid Jacobs
// Last Updated: 11-17-05
// Notes: Speak with Cid Jacobs about any concerns.
//
//This script will calculate air pressure at the objects vector plus offset.
//
//--------------------Globals
//Global Memory Storage For Calibration Offset
float Calibration = 101.32500;
//Global Memory Storage For User Definable Vector Offset
vector Offset = <0,0,10>;
//
//
//--------------------User Defined Function
float llAirPressure(vector Offset)
{
    //Extrapolate Task's Local Coordinates
    vector Position = llGetPos();
    //Calculate And Calibrate Air Pressure
    float Base_Reading = llLog10(5- (((Position.z - llWater(ZERO_VECTOR)) + Offset.z)/15500));
    //Total Sum Air Pressure
    float KiloPascal = (Calibration + Base_Reading);
    return KiloPascal;
}
//
//
//--------------------States
//Mandatory Default State
default
{
    //Triggered By The Start Of Agent Clicking
    touch_start(integer num_detected)
    {
        //Say Current Total Air Pressure at Task + V
        llSay(0,"Current air pressure is: "
        +
        (string)llAirPressure(Offset)
        +
        " KiloPascal.");
    }
}     // end 
