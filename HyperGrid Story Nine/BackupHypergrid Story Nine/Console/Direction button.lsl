//:AUTHOR: Fred Beckhusen (Ferd Frederix)
//:DESCRIPTION:
// Button Script for console
//:CODE:

string E = "<1,0,0>";
string NE = "<1,1,>";
string N = "<0,1,0>";
string NW = "<-1,1,0>";
string W = "<-1,0,0>";
string SW = "<-1,-1,0>";
string S = "<0,-1,0>";
string WE = "<1,-1,0>";

// chose a direction for one of 8 buttons.

default
{
    touch_start(integer total_number)
    {
        llMessageLinked(LINK_SET,0,N,"");
    }
}