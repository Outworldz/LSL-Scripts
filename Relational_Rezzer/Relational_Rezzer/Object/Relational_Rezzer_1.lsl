// :CATEGORY:Rezzers
// :NAME:Relational_Rezzer
// :AUTHOR:Innula Zenovka
// :CREATED:2010-11-16 11:22:38.940
// :EDITED:2013-09-18 15:39:01
// :ID:690
// :NUM:939
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// While the example in the wiki at LlRezAtRoot - Second Life Wiki shows very clearly how to map a rezzed prim's offset and rotation into the rezzing prim's coordinate system, I've always wondered how to calculate these if you can't, for whatever reason, read the initial offset and rotations with the rezzing prim rotated at ZERO_ROTATION (i.e. the x, y and z numbers in the prim's rotation box in edit mode set at <0.0,0.0,0.0>).// // I took a look, though, at how the Builders Buddy does it, and it's a lot simpler than I thought it would be. Here's my version of the calculation, so the rezzer positions the prim rather than (as with the Builders Buddy) having a script in the rezzed object move it into position.// // NB -- you can only rez objects up to 10 meters from the rezzer. It will silently fail otherwise.// 
// To make this work, set up the rezzer at whatever rotation you want, and place the object you want to rez at the correct relative position. You can either then read their respective positions and rotations by dropping the following simple script into each one and copy-pasting the results into the main script, or, if prefer, you can just read the numbers from the rotation boxes in the prims' edit windows and let the script convert the vector to rotation.
// 
// Either way, enter them in the rezzer script, and there you are.
// 
// I hope this is some help to people.
// :CODE:
//Sample rezzer script by Innula Zenovka Jan 27 2010
// released under the "do what the hell you want with it" licence

vector rezzer_pos = <68.4949, 151.2232, 25.6000>;  // the position of the rezzer when first you set it up
rotation rezzer_rot; // you could read the rotation by script, enter it here and comment out the next line
vector rezzer_rot_window = <180.05,0.00,52.00>;  // the numbers in the rotation box in the edit window

vector child_pos = <133.67170, 156.75260, 1751.52900> ; // the position of the rezzed object at first set up
rotation child_rot;// you could read the rotation by script, enter it here and comment out the next line
vector child_rot_window =<320.25,11.05,257.00>;// the numbers in the rotation box in the edit window

vector offset;
default
{
    state_entry()
    {
        
        rezzer_rot = llEuler2Rot(rezzer_rot_window*DEG_TO_RAD); 
        // you could comment this out and use the following line, to which it is equivalent
        // rezzer_rot = <-0.50000, -0.50000, 0.50000, 0.50000>;
        child_rot = llEuler2Rot(child_rot_window*DEG_TO_RAD);
         // you could comment this out and use the following line, to which it is equivalent
        //child_rot =<0.27363, 0.39548, 0.12470, 0.86785>;
        offset = offset/rezzer_rot;
    }

    touch_start(integer total_number)
    {
        llRezAtRoot(llGetInventoryName(INVENTORY_OBJECT,0),
        llGetPos()+offset*llGetRot(),
        ZERO_VECTOR,
        (child_rot/rezzer_rot)*llGetRot(), 
        99);
    }
}
