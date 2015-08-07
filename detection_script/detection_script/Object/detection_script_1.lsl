// :CATEGORY:Scanner
// :NAME:detection_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:229
// :NUM:315
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// detection script.lsl
// :CODE:

float ScannerRange = 2; //radius in m of scan area
float ScanFrequency = 15; //no of secs between scans
string VisitorIsAt="my home"; //location of scanner

default
{
    state_entry()
    {
        llSensorRepeat("", "", AGENT, ScannerRange, PI, ScanFrequency);  // regularly scan for people
    }
    
    sensor(integer number_detected)
    {
        integer i;
        for(i = 0; i < number_detected; i++)  // Create a loop to let us check each
        {
              if(llDetectedKey(i) != llGetOwner())  // Is this someone other than the owner?
              {

                   llInstantMessage(llGetOwner(), llDetectedName(i) + " freeze right there! why are you snoping around next to " + VisitorIsAt);  // send an IM to the owner.
            }
        }


    }
}
// END //
