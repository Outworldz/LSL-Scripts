// :CATEGORY:Sensor
// :NAME:Square_Sensor
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:831
// :NUM:1159
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Put this script into a cube, and change the size of the cube to the area you want to be sensed, then say 'reset'// // It has the coodinates of the cubes area, you can then change the size or location of the cube, and it will only sensor the area where you set it. 
// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei

vector corner1; //Highest
vector corner2; //Lowest
string scan;
refresh()
{
    llSetText(scan, <1,1,1>, 10);
}
default
{
    state_entry()
    {
        vector mypos = llGetPos();
        vector myscale= llGetScale();
        corner1.x = mypos.x + (myscale.x / 2);
        corner1.y = mypos.y + (myscale.y / 2);
        corner2.x = mypos.x - (myscale.x / 2);
        corner2.y = mypos.y - (myscale.y / 2);
        llSensorRepeat("", "", AGENT, 96, TWO_PI, 10); // this is a 10 second scan, hard for someone to travel 96 meters in 10 seconds!
        llListen(0, "", llGetOwner(), "");
    }
    listen(integer chan, string name, key id, string message)
    {
        if(message == "reset")
        {
            llResetScript();
        }
    }
    sensor(integer num)
    {
        scan = "";
        integer i;
        for(i=0;i<num;i++)
        {
            vector pos = llDetectedPos(i);
            if(pos.x > corner2.x && pos.x < corner1.x)
            {
                if(pos.y > corner2.y && pos.y < corner1.y)
                {
                    //When an agent is detected, do something with them within these brackets
                    scan += llDetectedName(i) + "\n";
                }
            }
        }
        refresh();
    }
}
