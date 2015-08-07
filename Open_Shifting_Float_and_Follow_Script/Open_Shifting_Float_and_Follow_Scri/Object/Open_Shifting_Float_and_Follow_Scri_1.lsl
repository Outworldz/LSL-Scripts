// :CATEGORY:Pet
// :NAME:Open_Shifting_Float_and_Follow_Script
// :AUTHOR:Foolish Frost
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:590
// :NUM:809
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Open Shifting Float and Follow Script, by Foolish Frost.lsl
// :CODE:

////////////////////////////////////////////////////////////////////////
// Open Shifting Float and Follow Script, by Foolish Frost.      //
// From Open Basic Follower/Facing Script, by Logan Bauer. //
///////////////////////////////////////////////////////////////////////
// OFFSET is the position of your pet in relation to it's owner's position.
// For example, in the default setting below, "vector offset =<-1,0,1>;"
// I.E. (x,y,z), the -1 puts it 1m back behind owner, the 0 means don't have
// it stay left or right, and 1 means have it stay 1m above it's owner.  
// So, if you wanted the script to make it follow directly in front of you,
// and to the left, then you would change it to "vector offset =<1,1,0>;"


// llFrand(float max)

vector offset =<-1.2,0,1>;
vector currentoffset =<0,0,0>; 
float xshift =.2; //How far it roams forward and back.
float yshift =1.25; //How wide it roams left to right.
float bob =2; //multiplyer of the BobCycle listed below.
float shifttime =5; //average time it takes to shift to another XY position.
integer timeset=0; //Is the timer running?
float currentxshift =0; //current X shift position
float currentyshift =0; //current Y shift position
float currentyfacing =0; //currentyfacing storage
integer currentbob; //current state of the BobCycle
float bobbing =0; //bob storage
list BobCycle = [0.0, 0.08, 0.12, 0.14, 0.15, 0.14, 0.12, 0.08, 0.0, -0.08, -0.12, -0.14, -0.15, -0.14, -0.12, -0.08];


startup()
{
        vector pos = llGetPos();
        llSetStatus(STATUS_ROTATE_Z,TRUE);
        llSetStatus(STATUS_PHYSICS, TRUE);
        key id = llGetOwner();
        llSensorRemove();
        llSensorRepeat("",llGetOwner(),AGENT,200,2*PI,.5);
}

default
{
        state_entry()
    {
        startup();

       
    }

    on_rez(integer start_param)
    {
        startup();
    }

    sensor(integer total_number) 
    {
        vector pos = llDetectedPos(0);

        bobbing = llList2Float(BobCycle, currentbob)*bob;
        
        llSetTimerEvent(llFrand(shifttime));
        currentoffset = <currentxshift, currentyshift, bobbing>;
        llMoveToTarget(pos+(offset+currentoffset)*llDetectedRot(0),.3);
        if (currentyshift>=0)
        {
            currentyfacing = currentyshift;
        } else {
            currentyfacing = currentyshift*-1;
        }
        
        llLookAt(pos+<0,0+(currentyfacing*.33),1+bobbing>, 1 , 2); 
        
        currentbob = currentbob +1;
        if (currentbob == 16)
        {
            currentbob = 0;
        }
        
        if(timeset==0)
        {
            timeset = 1;
            llSetTimerEvent(((llFrand(shifttime)+llFrand(shifttime)+llFrand(shifttime))/3)*2);
        }
        
        
    }
    
        timer()
    {
        timeset = 0;
        currentyshift = llFrand(yshift*2)-yshift;
        currentxshift = llFrand(xshift*2)-xshift;
    }
}// END //
