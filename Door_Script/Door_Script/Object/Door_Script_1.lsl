// :CATEGORY:Door
// :NAME:Door_Script
// :AUTHOR:Zanlew Wu
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:256
// :NUM:347
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Door Script.lsl
// :CODE:

// ==========================================================================
// Basic Door Script
// Original Script By Unknown
// Modifications made by Zanlew Wu 01-Apr-2003
//
//============================================
// Declare global constants.
//
integer SW_OPEN = FALSE;   // used to signify door swinging open
integer SW_CLOSE = TRUE;   // used to signify door swinging closed
integer SW_NORMAL = FALSE; // used to signify a normal swing
integer SW_REVERSE = TRUE; // used to signify a reverse swing
//
// Note that it is hard to call a given swing outward or inward as that has
// a lot to do witht he rotation and/or orientation of the door, which
// swing direction is correct/desired, and whether you are referring to the
// swing from the "out" side of the door or the "in" side of the door. It
// was easier by convention to call the swings normal and reverse.

//============================================
// Declare global fields.
//
key     gfOwnerKey;    // Owner of the elevator object
integer gfDoorClosed;  // Current state of the door (Open, Closed)
integer gfDoorSwing;   // Deteremines which way the door swings (In, Out)

//============================================
// gmInitFields
//
gmInitFields()
{
    //
    // Get the owner of the door.
    //
    gfOwnerKey = llGetOwner();
    
    //
    // Close doors by default.
    //
    gfDoorClosed = TRUE;
    
    //
    // Set the door swing.
    //
    gfDoorSwing = SW_NORMAL;
    
    return;
}
//
// End of gmInitVars
//============================================

//============================================
// gmSwingDoor
//
gmSwingDoor(integer direction)
{
    //-----------------------
    // Local variable defines
    //
    rotation rot;
    rotation delta;
    float piVal;
    
    //
    // First thing we need to do is decide whether we are applying a 
    // negative or positive PI value to the door swing algorythm. The
    // positive or negative makes the difference on which direction the door
    // swings. Additionally, since we allow the doors to modify their swing
    // direction (so the same door can be placed for inward or outward
    // swing, we have to take that into account as well. Best to determine
    // that value first. The rest of the formula does not change regardless
    // of door swing direction.
    //
    // So we have two variables to pay attention to: open/close and swing
    // in/out. First we start with open/close. We will presume the
    // following:
    //      SW_OPEN:  +PI
    //      SW_CLOSE: -PI
    // This also presumes that the door has a standard swing value of 
    // SW_NORMAL.
    //
    // A door that has had it's swing changed would have those values
    // reversed:
    //      SW_OPEN:  -PI
    //      SW_CLOSE: +PI
    //
    // The variable passed into this method determines if the intent were
    // to open the door or close it.
    //
    // The global field gfDoorSwing will be used to modify the PI based on
    // whether the door normally swings in or out.
    //
    if (direction == SW_OPEN)
    {
        //
        // Ok, we know the door is opening. Assign a +PI value to piVal.
        //
        piVal = PI/4;
        //
        // Now check to see if the door has it's swing reversed.
        //
        if (gfDoorSwing == SW_REVERSE)
        {
            //
            // Yep, it's reversed and we are opening the door, so replace 
            // piVal with a -PI value.
            //
            piVal = -PI/4;
        }
    } else
    {
        //
        // So we know we are closing the door this time. Assign a -PI value
        // to piVal.
        //
        piVal = -PI/4;
        //
        // Now check to see if the door has it's swing reversed.
        //
        if (gfDoorSwing == SW_REVERSE)
        {
            //
            // Yep, it's reversed and we are closing the door, so we need to
            // assing a +PI value to piVal.
            //
            piVal = PI/4;
        }
    }
    
    //
    // This formula was part of the original script and is what makes
    // the door swing open and closed. This formula use a Pi/-Pi to 
    // move the door one quarter-circle in total distance.
    //
    // The only change I've made to this function is to replace the hard-
    // coded PI/-PI values with a variable that is adjusted
    // programmatically to suit the operation at hand. 
    //
    rot = llGetRot();
    delta = llEuler2Rot(<0,0,piVal> );
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25); 
    rot = delta * rot;
    llSetRot(rot);
    
    return;
}
//
// End of gmSwingDoor
//============================================

//============================================
// gmCloseDoor
//
// The close command is used to close doors. If the doors are 
// locked, the doors cannot be closed. (Note: presumably, this 
// script does not allow doors to be opened AND locked at the same 
// time). If the doors are already closed, they cannot be 
// re-closed. These checks will be made before performing a door 
// close operation. Once the door is successfully closed, the 
// door's state will be updated.
//
gmCloseDoor()
{
    //
    // First let's check to see if the door is already closed. If it 
    // is, let the user know.
    //
    if (gfDoorClosed == TRUE)  
    {
        //
        // Yep, it was already closed.
        //
        llSay (0, "This door is already closed.");
        return;
    }
        
    //
    // Now we generate the proper sound for the door closing.
    //
    llTriggerSound("open_creaky_door", 0.2);

    //
    // Now we call the method gmSwingDoor with the SW_CLOSE argument (since
    // we are closing the door.
    //    
    gmSwingDoor(SW_CLOSE);    

    //
    // Now that the door is closed, set the door's state.
    //
    gfDoorClosed = TRUE;

    return;
}
//
// End of gmCloseDoor
//============================================

//============================================
// gmOpenDoor
//
// The open command is used to open the doors. If the doors are 
// locked, the doors cannot be opened. If the doors are already 
// opened, they cannot be re-opened. These checks will be made 
// before performing a door open operation. Once the door is 
// successfully opened, the door's state will be updated.
//
gmOpenDoor()
{
    //
    // First let's check to see if the door is open already. If it is,
    // let the user know.
    //
    if (gfDoorClosed == FALSE)  
    {
        //
        // Yep, it was already open.
        //
        llSay (0, "This door is already open.");
        return;
    }
    
    //
    // Now we generate the proper sound for the door closing.
    //
    llTriggerSound("open_creaky_door", 0.2);
    
    //
    // Now we call the method gmSwingDoor with the SW_OPEN argument (since
    // we are opening the door.
    //    
    gmSwingDoor(SW_OPEN);

    //
    // Now that the door is opened, set the door's state.
    //
    gfDoorClosed = FALSE;
    return;
}
//
// End of gmOpenDoor
//============================================


//============================================
// Default State
//
// This is the state that is automatically bootstrapped when the object
// is first created/rez'd, or the world or environment resets.
// 
default
{
    //
    // state_entry() is the first method executed when the state it resides
    // in is run. So State A, B, and C all can have state_entry methods,
    // and if they do, they are run when their respective states are called
    // and or executed.
    //
    state_entry()
    {
        //
        // Perform global field initialization
        //
        gmInitFields();
        
        //
        // We are listening for two different commands. This script is set 
        // up to accept spoken commands only from the object owner.
        //
        llListen(999, "", "", "open");
        llListen(999, "", "", "close");
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        //-----------------------
        // Local variable defines
        //
        string operName;
        string ownerName;

        //
        // Ideally, we want the door only to work on spoken commands 
        // from the owner. To accomplish this task, we need to check the 
        // id of the owner and the person issuing the command to see if 
        // they match.
        //
        // Alternately, commands can be issued from the control panel, 
        // which can be used by anyone. Later on, it will be presumed that
        // access to the control panel will be controlled.
        //
        
        //
        // First get the string names of the owner and the operator so they
        // can be compared.
        //
        operName = llKey2Name(id);
        ownerName = llKey2Name(gfOwnerKey);
        
        
            
        //----------------------------------------
        // OPEN DOOR
        //
        if(msg == "open") 
        { 
            gmOpenDoor();
        }
        
        //----------------------------------------
        // CLOSE DOOR
        //
        if (msg == "close")
        {
            gmCloseDoor();
        }
    }
    
    touch_start(integer i)
    {
        //
        // This is the same code as the UNLOCK, OPEN and CLOSE DOOR 
        // code. For reasons of brevity, I have removed the comments 
        // from this copy of the code.
        //
        if (gfDoorClosed == FALSE)
        {
            llTriggerSound("open_creaky_door", 0.2);
            gmSwingDoor(SW_CLOSE);
            gfDoorClosed = TRUE;
            return;
        } else
        {
            llTriggerSound("open_creaky_door", 0.2);
            gmSwingDoor(SW_OPEN);
            gfDoorClosed = FALSE;
            return;
        }
    }
}
// END //
