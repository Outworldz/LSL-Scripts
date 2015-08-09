// :CATEGORY:Elevator
// :NAME:lift_elevator_by_Timeless_Montreal
// :AUTHOR:Timeless Montreal
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:467
// :NUM:628
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// lift (elevator) by Timeless Montreal.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







// lift (elevator) by Timeless Montreal
//Well, this is the first script that I have written that I think might be worth something to someone else. There isn't much to it, but I was trying to figure out a creative way to get from one level to the next with out walking. I hope you like it, and I am sorry if it is already out there and I missed it.




// lift script, v 1.0 by timeless montreal
//
// This script will allow you to make any prim a lift or an elevator.
// You should only have to change the liftAmount to the distance
// you want the lift to move. Of course, if you rather it move
// side to side, it shouldn't be too hard to tweak.
//
// enjoy!

integer liftAmount = 4; // change this to the amount you
                                   // want to go up/down

integer isUp = FALSE; // Stores whether the object is up


movePlatform(){    
    llStartAnimation("stand");
    if(isUp == FALSE){
        llSetPos(llGetPos() + <0, 0, liftAmount>);
        isUp = TRUE;
    } else {
        llSetPos(llGetPos() + <0, 0, -1*(liftAmount)>);
        isUp = FALSE;
    }
}

default
{
    state_entry()
    {
        llSitTarget(<0,0,1>,<0,0,0,1>);        
        llSetSitText("Lift");
    }
    
    
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            key avataronsittarget = llAvatarOnSitTarget();
            if( avataronsittarget != NULL_KEY )
            {
                if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && llGetPermissionsKey() == avataronsittarget) {
                    llStopAnimation("sit");
                    movePlatform();
                } else {
                    llRequestPermissions(avataronsittarget, PERMISSION_TRIGGER_ANIMATION);
                }
            }
        }
    }


    run_time_permissions(integer perm)
    {
        if(perm)
        {
            // Place the code here!
            llStopAnimation("sit");
            movePlatform();                
        }
    }
} // END //
