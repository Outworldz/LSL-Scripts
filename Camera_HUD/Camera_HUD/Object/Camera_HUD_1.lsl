// :CATEGORY:Camera
// :NAME:Camera_HUD
// :AUTHOR:Fred Gandt
// :CREATED:2012-03-24 16:49:43.897
// :EDITED:2013-09-18 15:38:50
// :ID:145
// :NUM:211
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Create the Object// To create the object use the following script. Just drop it onto/into a fresh prim. The resulting prim is quite small since it is designed to be a low impact HUD.
// :CODE:
//This work uses content from the Second Life® Wiki article http://wiki.secondlife.com/wiki/User:Fred_Gandt/Scripts/Continued_5. Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License

// V1 //
 
default
{
    state_entry()
    {
        llSetObjectName("CamHUD"); // You can change this after if you want.
        llSetPrimitiveParams([7, <0.01, 0.05, 0.025>,
                              8, <1.0, 0.0, 0.0, 0.0>,
                              9, 0, 0, <0.125, 0.625, 0.0>, 0.1, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>,
                              17, -1, "5748decc-f629-461c-9a36-a35a221fe21f", <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0]);
        llRemoveInventory(llGetScriptName()); // Done its job so self deletes.
    }
}
