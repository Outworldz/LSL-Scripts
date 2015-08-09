// :CATEGORY:Door
// :NAME:Basic_sliding_doorscript
// :AUTHOR:Kyrah Abbattoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:82
// :NUM:109
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Basic sliding doorscript.lsl
// :CODE:

/////////////////////////////////
//ultra basic sliding door script
//by Kyrah Abattoir
/////////////////////////////////

vector closed = <121.007,31.148,23.088>;//XYZ coordinates of the door when closed
vector open = <119.941,31.148,23.088>;//XYZ coordinates of the door when closed
float time = 5.0;//time before the door close itself
default
{
    state_entry()
    {
        llSetPos(closed);
        llSetText("",<1,1,1>,1.0);//REMOVE THIS LINE
    }

    touch_start(integer total_number)
    {
        llSetPos(open);
        llSleep(time);
        llSetPos(closed);
    }
}
// END //
