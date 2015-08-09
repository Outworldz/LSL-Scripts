// :CATEGORY:Rezzers
// :NAME:Twisted_Creations_Rezzer
// :AUTHOR:muziekfreak1980 miles 
// :CREATED:2011-10-08 04:52:13.933
// :EDITED:2013-09-18 15:39:08
// :ID:927
// :NUM:1332
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Twisted creations 2007-2011 // // Simple yet very efficient rezzer system, ideal for vehicles. // TIP: Set your vehicles to temprezz, this way you will not need a etra script or part of code to delete it when ppl stop using it. // 
// There properly more uses for it enjoy. 
// Keep this script free, and credits intact would be nice!
// :CODE:
//Twisted Creations 2011, Muziekfreak1980 miles
//Feel free to distribute, keep credits intact thank you and enjoy


string object = "Twisted Creations, Jet-Stream"; // Name of object in inventory
vector relativePosOffset = <4.0, 0.0, 0.2>; // "Forward" and a little "above" this prim
vector relativeVel = <1.0, 0.0, 0.0>; // Traveling in this prim's "forward" direction at 1m/s
rotation relativeRot = <0.0, 0.0, 0.0, 0.0>; // Rotated 90 degrees on the x-axis 
integer startParam = 1;//how many times the object will rezz, upon one click
string sound = "b4d0ee9c-9dab-2d53-706e-0787cc79432b"; //Sound file uuid or drop in wav, name it.
 
default
{
    state_entry()
    {
        llSetText("Twisted Creations\n Jet Stream \n Rezzer, just click me \n To rezz a jet ski", <1,1,1>,1);//set floating text 
    }

    touch_start(integer total_number)//Trigger
    {
        vector myPos = llGetPos();
        rotation myRot = llGetRot();
 
        vector rezPos = myPos+relativePosOffset*myRot;
        vector rezVel = relativeVel*myRot;
        rotation rezRot = relativeRot*myRot;
        llPlaySound(sound, 1.0);//Line 5 you can change the UUID, this is the trigger 
        llSay(0,"Hop on the Jet-Ski, you have 60 seconds to do so");
        llRezObject(object, rezPos, rezVel, rezRot, startParam);
        llSleep(30.0);//xx second sleep, to prevent abuse, recommended to keep in here
        llSay(0,"Ready to use again, feel free to click me for a Jet ski");//After sleep message
        llResetScript();//Enables rezzing again after sleep period
    }
}
