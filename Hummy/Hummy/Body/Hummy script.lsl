// :CATEGORY:Bird
// :NAME:Hummy
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:55
// :ID:395
// :NUM:549
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// hummingbird flight
// :CODE:

// Simple Hummingbird
// opensim 0.1


vector startPos;
float dist = 10;
integer debug = 1;
 
DEBUG(string msg)
{
    if (debug) llOwnerSay(msg);
}

// This is an OpenSim compatible llLookAt()

face_target(vector lookat)
{
    rotation rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), lookat - llGetPos());
    llSetRot(rot);
}


vector getDestination()
{
    float x = llFrand(dist) + startPos.x;
    float y = llFrand(dist) + startPos.y;
    float z= llFrand(1) + startPos.z;

    vector result = <x,y,z>;

    DEBUG((string) result);
    return result;
}

default 
{
    state_entry()
    {

        // debug
        //llSetPos(<240, 330, 21>);

        vector rezPos = llGetPos();
        rezPos.z += 1;
        llSetPos(rezPos);

        vector new = <0,0,0> * DEG_TO_RAD;
        rotation r = llEuler2Rot(new);
        llSetRot(r);
        startPos = llGetPos();
        llSensorRepeat("", NULL_KEY, AGENT, dist, PI, 5);
        llSetTimerEvent(.1);    // move every 5 seconds

    }

    on_rez(integer p)
    {
        llResetScript();
    }

    timer()
    {
        vector dest = getDestination();
        vector new = <00,0,0> * DEG_TO_RAD;
        rotation r = llEuler2Rot(new);

        face_target(dest);


        llSetPos(dest);

        llSetRot(r);

        llSetTimerEvent(llFrand(5) + 1);    // move every 1-6 seconds
    }

    sensor(integer numDetected)
    {
        llSetTimerEvent(0);    // move every 1-6 seconds
        integer j;
        for (j = 0; j < numDetected; j++)
        {
            //vector new = <0,0,0> * DEG_TO_RAD;
            //rotation r = llEuler2Rot(new);

            vector detected = llDetectedPos(j);
            vector avatar = detected;

            float rand = llFrand(2);
            if (rand > 1)
                detected.x = detected.x +1;
            else
                detected.x = detected.x -1;

            rand = llFrand(2);
            if (rand > 1)
                detected.y = detected.y +1;
            else
                detected.y = detected.y -1;

            detected.z += rand;
            avatar.z += rand;

            face_target(detected);
            llSetPos(detected);
            face_target(avatar);

        }
    }

    no_sensor()
    {
        llSetTimerEvent(1);
    }
}
