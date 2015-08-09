// :CATEGORY:Notecard Reader
// :NAME:Fast_Find_Lines_in_a_Notecard
// :AUTHOR:AmaOmega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:298
// :NUM:397
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// There is an LL function that does this now:// llGetNumberOfNotecardLines// // This is a fast way to find the number of lines in a notecard. It is fast as is, and can be adjusted to be faster if you have an idea about the notecards you will be getting the size of. This is an implementation of a binary search.
// :CODE:
// Made by Ama Omega
// Version 1.1

// Adjust these two values for your notecards:

// A Higher START_INC will be faster if 
//   you have a large range of possible card lengths
// A Lower START_INC will be faster if 
//   you have a small range of possible card lengths
// This needs to be less than START_LINE
integer START_INC = 10;

// This should be set to your average note card length.
integer START_LINE = 20;

// Below is the actual code.
integer inc;
integer line;
string name;
key request;

default
{
    state_entry()
    {
        inc = START_INC;
        line = START_LINE;
    }

    changed(integer total_number)
    {
        inc = START_INC;
        line = START_LINE;
        
        name = llGetInventoryName(INVENTORY_NOTECARD,0);
        request = llGetNotecardLine(name,line);
    }
    
    dataserver(key query, string data)
    {
        if (query == request)
        {
            request = "";

            if (data == EOF) // Too Far
            {
                if ( inc == 1 ) // We just went up 1 space.  We go up if a line was found. 
                {
                    line++;
                    llWhisper(0, (string)line + " lines in notecard " + name);
                    inc = 10;
                    line = 10;
                }
                else if (inc < 0) // Were going down
                {
                    line += inc;  // Keep going down
                    request = llGetNotecardLine(name,line);
                }
                else if (inc > 0) // Were going up
                {
                    inc = - inc / 2; // Go back (down) half as much.
                    line += inc;
                    request = llGetNotecardLine(name,line);
                }
                else // Error!
                {
                    llWhisper(0, "inc == 0!");
                }
            }
            else
            {
                if ( inc == - 1 ) // We just went down 1 space.  We go down if EOF. 
                {
                    line++;
                    if (data == "") llWhisper(0, "Notecard " + name + " is empty");
                    else llWhisper(0, (string)line + " lines in notecard " + name);
                    inc = START_INC;
                    line = START_LINE;
                }
                else if (inc > 0) // Were going up
                {
                    line += inc;  // Keep going up.
                    request = llGetNotecardLine(name,line);
                }
                else if (inc < 0) // Were going down
                {
                    inc = - inc / 2; // Go back (up) half as much.
                    line += inc;
                    request = llGetNotecardLine(name,line);
                }
                else // Error!
                {
                    llWhisper(0, "inc == 0!");
                }            
            }
        }
    }
}
