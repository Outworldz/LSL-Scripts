// :CATEGORY:Typing
// :NAME:Typing animation
// :AUTHOR:Ferd Frederix    
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:930
// :NUM:1335
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Put this in a prim and attach it to your spine.// When you type it triggers whatever prim holds the second script into appearing.
// :CODE:


// you can tune these two variables

float volume = 0.2;   		// set volume
float HowLongToPlay = 3;  	// how long to play when they start typing - this is tunable



integer firstTime;			// a flag to see if they started typing
float timertick = 45;		// 1 sim frame = 24 times a second.
string NEW_ANI = "Arm Typing";
key TYPING = "c541c47f-e0c0-058b-ad1a-d6ae3a4584d9"; // typing animation ID
string typingSound = "37af3633-de9c-2e84-42e6-78995fb864ae";  //Typing sound ID

integer ticks;

default
{

	state_entry()
	{
		ticks = 0;
		HowLongToPlay = 3 * timertick;
        llPreloadSound(typingSound);    
    }    



	attach(key id)
	{
		// if there is an avatar key, we are attached.
        if(id != NULL_KEY) {
            llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);	// we must ask for animation permissions
        }
		else {
			// we are detached, the script will run for a split second before it goes back to inventory.
            llStopAnimation(TYPING); // shut off typing in case they take us off while we are typing.
        }
        
    }

	run_time_permissions(integer perm)
	{
        if(perm & PERMISSION_TRIGGER_ANIMATION) 
		{
			ticks = -1;

            llSetTimerEvent(1/timertick);    // once per simulator frame is as fast as a timer can run
        }
   }
               
               
                  
	timer()
	{ 
		if (llListFindList(llGetAnimationList(llGetOwner()), [TYPING]) != -1)
		{
			// Typing is happening, lets see if this is the first time so we can start the animation
			if (firstTime++)
			{
				// yup, this is the first time.
				llStopSound();		// stop our sound (will not affect typing sound)
				llStopAnimation(TYPING);		// stop the original typing animation
				llStartAnimation(NEW_ANI);	// play the new animation
				llPlaySound(typingSound,volume);
				llMessageLinked(LINK_SET, 34, "Screen on", "");
			}
			else
			{
				// nope this is the second or longer time, so do nothing
			}
			
        }
		else	
		{
			// not typing, run this only if timer has expired and we were actually typing
			if (ticks++ > HowLongToPlay && firstTime)
			{
				llStopAnimation(NEW_ANI);
				llStopSound();
				llMessageLinked(LINK_SET, 34, "Screen off", "");
				ticks = 0;
				firstTime = 0;
			}
		}

    }
   

 
}
