// :CATEGORY:Pet
// :NAME:Mesh_Frog_Project
// :AUTHOR:Ferd Frederix
// :CREATED:2012-05-11 16:43:46.393
// :EDITED:2013-09-18 15:38:57
// :ID:512
// :NUM:686
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Bug Movement script
// :CODE:
// Bug movement script
// rez the bug, touch it, and it woill move around randombly in about 1/2 meters space


vector pos;  // the home position is saved here


// This is an OpenSim compatible llLookAt()!
face_target(vector lookat)
{
    rotation rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), lookat - llGetPos());
    llSetRot(rot);
}


default
{
    state_entry()
    {
        llSetAlpha(1,ALL_SIDES);
        llSetLinkPrimitiveParams(2,[PRIM_COLOR,ALL_SIDES,<1,1,1>,1.0]);
        pos = llGetPos();            // save start
        llSetObjectName("Bug");      // the frog will look for this name
    }

    listen(integer n, string name, key id, string message)
    {
        if (message == "eat")        // the frog is trying to grab us.
        {
            list details = llGetObjectDetails(id,[OBJECT_POS]);

            // see if he is close enough to grab us.
            if (llVecDist( llList2Vector(details,0),llGetPos()) < 0.3)
            {

                // make us invisible to people
                llSetAlpha(0,ALL_SIDES);
                llSetLinkPrimitiveParams(2,[PRIM_COLOR,ALL_SIDES,<1,1,1>,0]);

                // and make us invisible to the frog
                llSetObjectName("invisible Bug");
                llSleep(15);

                // okay, time to live again
                llSetAlpha(1,ALL_SIDES);
                llSetLinkPrimitiveParams(2,[PRIM_COLOR,ALL_SIDES,<1,1,1>,1.0]);
                llSetObjectName("Bug");
            }


        }
    }

    timer()
    {
        // get a position somewhere withing 1/2 meter of home
        float newX = llFrand(1)+.5 -.75;
        float newY = llFrand(1)+.5 -.75;

        vector newpos = <pos.x + newX, pos.y + newY, pos.z>;  // in the same Z plane as when we were rezzed

        // look at that spot
        face_target(newpos);
        // and go there
        llSetPos(newpos);
    }

    // if owner touches us, set a new position
    touch_start(integer whowmany)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            pos = llGetPos();

            //and start the movement
            llSetTimerEvent(2);
            llListen(2222,"","","eat");     // we turn invisible and rename when we hear commands on this channel

        }
    }


    on_rez(integer p)
    {
        llResetScript();
    }
}
