// :CATEGORY:Skirt Maker
// :NAME:Skirt_Maker
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:777
// :NUM:1065
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
//flexi prim skirt generator
float a = 0.75; //elipse parameter between 0 (line) and 1 (perfect circle)
float b = -0.1; //bending parameter 0 = flat
string bead = "skirtpart"; //object to use
integer numbeads = 25; //how many beads should the necklace have
vector offsetrot = <0,0,180>; //rotation of test bead

make()
{
    integer n;
    float t; //parameter
    float d; //derivitive angle
    vector p; //position
    vector re; //rotation in euler
    rotation rot; //re in rot format
    for(n = 1;n <= numbeads;n++) {
        t = TWO_PI * ((float)n/(float)numbeads);
        llOwnerSay((string)n);
        p.x = llCos(t);
        p.y = a * llSin(t);
        p.z = b * llCos(t)*llCos(t) + 1;
        p = p + llGetPos();
        re.x = 0;//-1 llSin(t) + DEG_TO_RAD offsetrot.x;
        re.y = 0;//llCos(t) + DEG_TO_RAD offsetrot.y;
        re.z = t + DEG_TO_RAD * offsetrot.z;
        rot = llEuler2Rot(re);
        llRezObject(bead, p, ZERO_VECTOR, rot, 0);
    }
}

default
{
    state_entry()
    {
        llSay(0, "Touch to generate a Skirt");
    }

    touch_start(integer total_number)
    {
        make();
    }
}
