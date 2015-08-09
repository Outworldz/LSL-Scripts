// :CATEGORY:Helicopter
// :NAME:Helicopter scripts
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:377
// :NUM:524
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// bullet rezzer
// :CODE:

// simple cannon pointer script
// just go into mouselook, it will point wherever you look
//  mouse button rezzes a bullet.  Release the button to stop firing.
// can only fire 10 rounds per second, max.
// the bullet will be fired from center of the entire bullet or missile. To have the bullet rez from the center of the root prim,
// change llRezObject to llRezAtRoot instead.

integer debugon = FALSE;        // set to TRUE for debug to owner only.

vector ANGLE = <0,0,90> ; // used to point the gun 90 degrees rotated around the Z axis, this may need to be changed. It depends upon your prim and how the gun sticks out of it.
    
string shoot = "shoot";        // the sound it makes when firing, must be in inventory.   You can change this to:
// key shoot = "12345000-0000-0000-0000-000000000001"; // where this is a copied UUID from your inventory and then there is no need to give away the sound file.

// The avatar must be within 2 meters of the gun script, or it will not aim or fire
// the original value was 20, which is horrible laggy in comparison as it must scan an area 4 * PI R squared larger ( 100 times more work), for no good reason!
// But if it is made larger, you can shoot the gun from a greater distance
float DISTANCE = 2;   // Make this as small  as possible to control lag

float SPEED         = 40.0;    // how fast the bullet flies away, this is really fast!   For a missile, set it to 0 and make the missile do its own acceleration   


// code bgins
// general purpose Debug("some message");     
Debug( string msg)
{
    if (debugon)
        llOwnerSay(msg);
}


default
{
    state_entry()
    {
        // normally, this little bit of code is disabled by FALSE.  It can be deleted entirely.   But it is extremely handy!
        
        // This routine lets you  change hard coded rotations to vectors so humans can work on them
        // It does not run unless you set this to TRUE
        // When it runs, it takes whatever crap quaternion has been copied from old code into a vector
        // It prints the vector in degrees

        // a crap quaternion looks like this, and has 4 numbers:
        // <0.00000, 0.00000, 0.70711, 0.70711>  // bet you didn't know this is a rotation of 90 degrees around the Z axis!
        
        // sample output when set to TRUE:
        // original:<0.00000, 0.00000, 0.70711, 0.70711>         This was the original, copied quaternion
        // replacement:<0.00000, 0.00000, 90.00000>              aha, its a 90 degree rotation about Z   

        // How to use it: Whenever you see a rotation hard-coded in like this, don't cuss at the programmer, they didn't know better.
        // llSetRot(<-0.00000, -0.00000, 0.70711, 0.70711>);
        // Paste the old crap rotation <..> in the arot line below, set the variable to TRUE, and then change the script to this line, where the <0,0,90> is whatever the script spits out:
        
        // llSetRot(llEuler2Rot(<0,0,90> * DEG_TO_RAD));    // change <0,0,90> to the vector form
        // much easier to change and the same as this unreadable crap:
        // llSetRot(<-0.00000, -0.00000, 0.70711, 0.70711>);

        // one last thing:   <0.00000,0.0000, 0.00000, 1.0000> ( 0,0,0,1) is a ZERO rotation, or <0,0,0> as a vector.  That's easy to remember so you can just change it to llSetRot(ZERO_VECTOR);  

        // you can comment this all out, but there is really no need, it just saves a few bytes of memory if you comment it out
        if (FALSE)        // set to TRUE to conver any 4-vector quaternion into a human readable 3-unit vector.
        {
            rotation  arot = <0.00000, 0.00000, 0.70711, 0.70711>;    // replace this with your crappy quaternion
            llOwnerSay("original:" + (string) arot);

            vector in_degrees = llRot2Euler(arot);
            in_degrees *=  RAD_TO_DEG;
            llOwnerSay("replacement:" + (string) in_degrees);        // output it as a vector in degrees instead of radians.
        }
    }


    touch_start(integer total_number)
    {
        integer i;
        // MUST scan over all people who touch, and only allow the owner to fire the weapon.
        // many people can click at the same time, how many is in total_number
        for (i = 0; i < total_number; i++)
        {
            // See if this person is the owner
            if (llDetectedKey(i) == llGetOwner())
            {
                llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
                Debug("Requesting Permissions");
             }
        }
   }


    touch_end(integer total_number)
    {
        integer i;
        for (i = 0; i < total_number; i++)
        {
            // See if this person is the owner
            if (llDetectedKey(i) == llGetOwner())
            {
                llReleaseControls();
                llSensorRemove();                
                llSetRot(llEuler2Rot(ANGLE * DEG_TO_RAD)); 
                Debug("stopped firing");
            }
        }
    }

    sensor(integer sense)
    {
        rotation k = llDetectedRot(0);
        llRotLookAt(k, 0.1, 0.1);
    }

    // oh dear, the avatar is out of range
    no_sensor()
    {
        llReleaseControls();
        llSensorRemove();
        
        llSetRot(llEuler2Rot(ANGLE * DEG_TO_RAD));    // this is the same as the following line, but easily changed
        //llSetRot(<-0.00000, -0.00000, 0.70711, 0.70711>); // old crap code, actually <0.00000, 0.00000, 90.00000>
        Debug("No Owner nearby, check the DISTANCE variable");
        
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TAKE_CONTROLS)
        {
            Debug("Permissions to take controls has been granted");
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llSensorRepeat("", llGetOwner(), AGENT, DISTANCE, TWO_PI, 0.1);       // look for the owner only     
        }
    }
    
    control(key name, integer levels, integer edges)
    {
        // mouse left button pressed
        if (levels & CONTROL_ML_LBUTTON)
        {
            rotation rot = llGetRot();   // mouselook rotation
            vector vel = llRot2Fwd(rot);   // forward direction only
            vector  pos = llGetPos();     // gun position         
            pos = pos + vel;    // add to gun position the forward direction           
            pos.z += 0.0;       // worthless by adding a 0, but by changing 0.0 to another number you can fire higher or lower than the prim this script is in.           
            vel = vel * SPEED;  // multiply all 3 coordinates by the constant SPEED to set a bullet speed.         
            llTriggerSound(shoot, 1.0);
            llRezObject("bullet", pos, vel, rot, 1);    // sends a 1 to the bullet, to the on_rez(integer start_param)
        }
    }
   
}
