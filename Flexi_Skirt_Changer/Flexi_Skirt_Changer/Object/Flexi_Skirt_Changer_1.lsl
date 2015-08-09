// :CATEGORY:Clothing
// :NAME:Flexi_Skirt_Changer
// :AUTHOR:Gwyneth Llewelyn
// :CREATED:2010-07-18 11:32:50.380
// :EDITED:2013-09-18 15:38:53
// :ID:316
// :NUM:424
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// 
// HOW TO USE
// [UPDATE] For some silly reason, a lot of skirt designers use an invisible ball on the centre of the skirt, which is allegedly there to “make adjustments // easier”. Often this invisible ball is also the root prim (the one that shows yellow when right-clicking on the skirt on the ground and selecting Edit).
// 
// This is what you have to do to use this script on these types of skirts:
// 
// Drop the skirt on the ground. 
// Right-click and select Edit 
// Check the box that says “Edit linked parts” 
// Right-click now on the root prim (the one in yellow) 
// If it’s a sphere, change it to a cube 
// Now go to the “Features” tab and activate the Flexible settings on the checkbox 
// For best results, the parameters should be exactly like the ones on the other skirt elements (I usually select one of them, take note of all the  parameters ona  piece of paper, select the root prim again, and copy them) 
// Throw the script above inside the root prim 
// Take the skirt back into inventory 
// Now wear it! 
// :CODE:


list FlexiState;

integer isSit;



default

{

  state_entry()

  {

    // save current state

    FlexiState = llGetPrimitiveParams([PRIM_FLEXIBLE]);

  }



  changed(integer what)

  {

    // if someone is tweaking the flexi settings, you better reset!

    if (what & CHANGED_SHAPE)

      llResetScript();

  }



  touch_start(integer total_number)

  {

    if (llDetectedKey(0) == llGetOwner())

      if (!isSit)

      {

        isSit = TRUE;

        llOwnerSay("Skirt in sit mode");



        // ok, we know the rotation. Now we need to figure out the bloody angle in the XY plane!

        rotation avatarRotation = llGetRot();



        vector PointForward = <1.0, 0.0, 0.0>;      // get a unit vector!



        PointForward *= avatarRotation;  // do vector rotation

        PointForward.z = 0.0; // clean Z as well, you never know; now this vector should be on the XY plane



        // amplify magnitude!



        PointForward.x *= 10.0;

        PointForward.y *= 10.0;



        llSetLinkPrimitiveParams(LINK_SET, [PRIM_FLEXIBLE] + llListReplaceList(FlexiState, [PointForward], 6, 6));

      }

      else

      {

        isSit = FALSE;

        llOwnerSay("Skirt in walk mode");



        llSetLinkPrimitiveParams(LINK_SET, [PRIM_FLEXIBLE] + FlexiState);

      }

  }

}
