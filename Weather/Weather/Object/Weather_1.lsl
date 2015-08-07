// :CATEGORY:Weather
// :NAME:Weather
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:969
// :NUM:1391
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Weather
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

float SEALEVEL = 101.32500;

default
{
	state_entry()
	{
		llSetTimerEvent(1);
	}

	timer()
	{
		string result;

		vector sun = llGetSunDirection();
		vector pos = llGetPos();
		float base = llLog10(5- ((pos.z - llWater(ZERO_VECTOR))/15500));
		float pascal = (SEALEVEL + base);
		float temperatureF = ((((pascal * (2 * llPow(10,22)))/
			(1.8311*llPow(10,20))/ 8.314472)/19.85553747) + (sun.z * 10));
		vector wind = llWind(pos);
		float cloud = llCloud(ZERO_VECTOR);
		cloud = cloud*100.0;

		result = "Temperature: " + (string) temperatureF;
		result+= "\nBarometer:" + (string)pascal;
		result+= "\nWind:" + (string)llVecMag(wind);
		result+= "\nClouds: " + (string)cloud + "%";
		llSetText(result,<0,1,1>,1);

		//llSay(0,"Current Temperature is "+ (string)((temperatureF - 32) * 5/9) +" Degrees Celsius");
	}
}
