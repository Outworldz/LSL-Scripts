// :CATEGORY:Particles
// :NAME:Special_Particle_Sensor__Brain_
// :AUTHOR:Christopher Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:819
// :NUM:1129
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Special Particle Sensor _Brain_.lsl
// :CODE:

// Special Particle Sensor "Brain" Script
// Written by Christopher Omega
//
// Tasks:
// Listen to the owner.
// Parse the owner's message,
// Signal individual locators to reset
// Or point at a certain object within
// 96 meters of the apparatus.

// Global Variables
// targetName Stores the name of the object that's being looked for.
string targetName   = "";

// Global Constants
// LOCATOR_ALL_LOCATORS A constant defining when the message sent by this script is meant for all locators.
integer LOCATOR_ALL_LOCATORS        = -1;

// SENSOR_TYPE_ALL A constant that tells the sensor to look for (ACTIVE|PASSIVE|AGENT). 
// 7 is just the integer form of (ACTIVE|PASSIVE|AGENT)
integer SENSOR_TYPE_ALL             = 7;

// SENSOR_MAX_RANGE A constant defining the max. range of the sensor to run. As of SL v1.2.13, it is 96.0 meters.
float SENSOR_MAX_RANGE              = 96.0;

// MESSAGE_PARAMETER_SEPERATOR A constant that is used as a seperator in parsing lists sent as strings.
string MESSAGE_PARAMETER_SEPERATOR  = "|~|";

// strStartsWith()
// Returns a boolean-integer that tells if the string starts with the prefix.
// @param   str     The string to search.
// @param   prefix  The prefix of str to find.
// @return  TRUE or FALSE, if str starts with prefix.
integer strStartsWith(string str, string prefix) {
    return (llSubStringIndex(str, prefix) == 0);
}

// contactLocator()
// Sends a message to the locators.
// @param   locatorNumber   The number identifyer of the locater to send the message to. LOCATOR_ALL_LOCATORS to send to all.
// @param   parameters      The parameters to send to the locator.
// @param   command         The command to send to the locator.
contactLocator(integer locatorNumber, string parameters, string command) {
    integer linkNumber = locatorNumber + 2;
    
    if(locatorNumber == LOCATOR_ALL_LOCATORS) linkNumber = LINK_ALL_OTHERS;
    
    llMessageLinked(linkNumber, 0, parameters, command);
}

// pointLocatorAt()
// Sends a message to the locator specified by locatorNumber
// Telling it to point itself and its particle system at a
// target defined by targetId and targetPosition.
// @param   locatorNumber   The particle emitter to tell to point.
// @param   targetId        The UUID (key) of the target to point at.
// @param   targetPosition  The position, in region-local coordinates, of the target.
pointLocatorAt(integer locatorNumber, key targetId, vector targetPosition) {
    list paramList = [targetId, targetPosition];
    contactLocator(locatorNumber, llDumpList2String(paramList, MESSAGE_PARAMETER_SEPERATOR), "POINT_AT");
}

// resetLocator()
// Kills the particle system emininating from the locator defined by locatorNumber.
// @param   locatorNumber   The particle emitter in which to shut off. LOCATOR_ALL_LOCATERS to turn off all.
resetLocator(integer locatorNumber) {
    contactLocator(locatorNumber, "", "RESET"); // Turn off the particles.
}

default {
    state_entry() {
        llSay(0, "Running.");
        llListen(0, "", llGetOwner(), "");
        resetLocator(LOCATOR_ALL_LOCATORS);
    }
    listen(integer chan, string name, key id, string msg) {
        if (strStartsWith(msg, "#reset")) {
            llSensorRemove();
            resetLocator(LOCATOR_ALL_LOCATORS);
        }
        else if (strStartsWith(msg, "#find ")) {
            resetLocator(LOCATOR_ALL_LOCATORS);
            
            targetName = llDeleteSubString(msg, 0, 5); // Delete "#find " from msg
            
            llSensor(targetName, NULL_KEY, SENSOR_TYPE_ALL, SENSOR_MAX_RANGE, TWO_PI);
            llSay(0, "Searching for " + targetName);
        }
    }
    no_sensor()
    {
        llSay(0, targetName + " not found within a distance of "
            + (string) SENSOR_MAX_RANGE + " meters.");
            
        llSensorRemove();
    }
    sensor(integer numDetected) {
        integer i;
        for (i = 0; i < numDetected; i++) {
            key targetKey = llDetectedKey(i);
            vector targetPos = llDetectedPos(i);
            llSay(0, targetName + " found at " + (string) targetPos 
                + " with key " + (string) targetKey);
            pointLocatorAt(i, targetKey, targetPos);
        }
    }
}
// END //
