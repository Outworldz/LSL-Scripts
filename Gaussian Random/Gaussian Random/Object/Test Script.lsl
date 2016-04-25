// :SHOW:
// :CATEGORY:Utility Functions
// :NAME:Gaussian Random
// :AUTHOR:GMLscripts.com
// :KEYWORDS:
// :CREATED:2016-02-26 16:49:01
// :EDITED:2016-02-26  15:49:01
// :ID:1100
// :NUM:1885
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::returns a pseudo-random number with Gaussian or normal distribution
// :CODE:
//:License: Copyright (c) 2007-2015, GMLscripts.com
//DESCRIPTION:
// This script returns a pseudo-random number with Gaussian or normal distribution, meaning the values returned tend to cluster around a given average or mean value. This could be useful if one needed a random behavior or outcome where deviations from the desired target become more rare as the magnitude of the deviation increases.

/// An example use might be an enemy AI whose skill is represented by the degree of error in its aiming ability. If a target is at 90 degrees, aim = gauss(90,5) would return a firing direction with a small degree of error. This degree of error (or deviation) is controlled by the second argument. In this case, the value returned would be within 5 degrees (one standard deviation) of the desired direction (the mean) about 68% of the time, and within 10 degrees (two standard deviations) about 95% of the time. The lower the given deviation, the greater chance the returned value will be near the given mean, and the more accurate the aim of the AI would be.

// just call gauss(mean,deviation) with e value and the error around it
//
//  Returns a pseudo-random number with an exact Gaussian distribution.
//
//      mean        mean value of the distribution, real
//      deviation   standard deviation of distribution, real


// Originally from http://www.gmlscripts.com/script/gauss
// Copyright (c) 2007-2015, GMLscripts.com
// This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
// Permission is granted to anyone to use this software for any purpose,  including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

//  1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be   appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source distribution.
  
float x1;
float x2;
float w;

float rand(float mean, float deviation)
{
    
    do {
        x1 = llFrand(2) - 1;
        x2 = llFrand(2) - 1;
        w = x1*x1 + x2*x2;
    } while (0 >= w || w >= 1);

    w = llSqrt(-2 * llLog(w)/w);
    return mean + deviation * x1 * w;
}
    
default
{
    // sample test program to prioduce  100 gun rounds aimed at 90 degrees.
    touch_start(integer total_number)
    {
        integer i = 100;
        while (i-- > 0) {
            // In the case of the gun shooting at a 90 degree angle, the value returned would be within 5 degrees (one standard deviation) of the desired direction (the mean) about 68% of the time, and within 10 degrees (two standard deviations) about 95% of the time. 
            llSay(0,(string) rand(90,5));
        }        
    }
}
