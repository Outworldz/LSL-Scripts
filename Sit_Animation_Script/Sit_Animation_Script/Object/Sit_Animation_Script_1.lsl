// :CATEGORY:Pose Balls
// :NAME:Sit_Animation_Script
// :AUTHOR:Moopf
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:773
// :NUM:1061
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sit Animation Script.lsl
// :CODE:

//Sit Animation Script by Moopf (All Rights Reserved).
//THE ABOVE LINE NEEDS TO STAY WITH ANY VERSION OF THIS SCRIPT THAT YOU USE

//If you purchased this script from me you may use it as much as you like.
//If you didn't purchase this script from me let me know where you got it!

//Instructions
//This script will allow you to create an object with an animation other than the standard sitting
//animation. There is a notecard in this object which contains a full list of possible animations
//as of 1.3

//This is used to store the key of the avatar currently sitting on the object
key agentKey = NULL_KEY;

//When an avatar sits down we request permission to animate them, and this gets set to TRUE if we
//receive those permissions. The avatar isn't normally requested to give permissions with a pop up box - it just
//happens.
integer permissionResult = FALSE;

//This is the animation we want to use when the avatar sits down. A full list is in the notecard contained in this
//object.
string theAnim = "sit_ground";

//This is the text that will be shown in place of 'Sit' on the pie menu the avatar sees when they right-click on
//the object
string sitText = "Meditate";

//Sitting position. This is the X,Y and Z position of where the avatar should sit on the object,
//in relation to the center of the object. <0,0,0> cancels the sit position. Different objects need
//different sitting positions to look right, so you'll need to play with the X, Y and Z values until
//you are happy. You can use + or - numbers. For simplicity (so you don't have to worry about rotation,
//you should orient your object so that the Z axis points up and the X axis (the axis the avatar will
//face) points forward.
vector sittingPosition = <-0.1,0,0.7>;


//init() - runs on state_entry and on_rez
init()
{
    //Change the text shown on the pie menu to what we've specified in sitText
    llSetSitText(sitText);
    //Set the position on the object that the avatar should sit. For simplicity
    //you should orient your object with the Z axis (blue one) pointing up.
    //The <0,0,0,1> is a quaternion rotation and if you follow the sitting
    //position notes about axis, you won't need to touch this and it's not easy
    //to explain!
    llSitTarget(sittingPosition,<0,0,0,1>);
}

default
{
    //state_entry - launches whenever the script is reset (or on change of
    //state but this script doesn't use other states!)
    state_entry()
    {
        init();
    }
    
    //on_rez - launches whenever the object is rezzed
    on_rez(integer times)
    {
        init();
    }

    //changed - launches whenever something about the object changes, such as a new
    //object is linked which is exactly what happens when you sit on an object!    
    changed(integer change) {
        
        //Check to see if the number if linked objects has changed
        if (change & CHANGED_LINK)
        {
            //If it has try to get the key of the avatar that's sat down.
            key agent = llAvatarOnSitTarget();
            //Check to see if it was an avatar and that we
            //don't currently have an avatar sitting down.
            if ( agentKey == NULL_KEY && agent != NULL_KEY ) {
                //OK, we now now there's an avatar sitting on this object and we have their key
                agentKey = agent;
                //Request permission to animate the avatar
                llRequestPermissions(agentKey,PERMISSION_TRIGGER_ANIMATION);
            } else if ( agentKey != NULL_KEY && agent == NULL_KEY) {
                //The person sitting down has got up. If we managed to get permission
                //to animate then we need to stop the animation.
                if (permissionResult) {
                    //Stop animating the avatar
                    llStopAnimation(theAnim);
                }
                //So the object is ready for the next person to sit down let's reset the script
                //to reset everything.
                llResetScript();
            }
        }        
    }
    
    //run_time_permissions - launched when llRequestPermissions is used and
    //the script receives the result of that request
    run_time_permissions(integer value) {
        //Check to see if we got permission to animate the avatar
        if (value == PERMISSION_TRIGGER_ANIMATION) {
            //Set the permission flag for use later.
            permissionResult = TRUE;
            //Stop the default "sit" animation
            llStopAnimation("sit");
            //Start the animation we want to use.
            llStartAnimation(theAnim);
        }
    }
}// END //
