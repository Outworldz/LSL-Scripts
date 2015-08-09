// :CATEGORY:Communications
// :NAME:Chalkboard
// :AUTHOR:Ferd Frederix
// :CREATED:2014-01-07 22:48:53
// :EDITED:2014-01-07 22:48:12
// :ID:1009
// :NUM:1562
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// It creates  a chalkboard.  If  Shared media is not on, this  displays an image named "SharedMedia" to clue them in that they need to enable it or click it
// It also forces the address bar to be minimal, to auto play, and prevent navigation away from this page.
// Add this image to the same prim that holds this script:
// :CODE:
// This script will scan for avatars and pop open the screen for them ( if shared media is enabled). 
// It creates  a chalkboard.  If  Shared media is not on, this  displays an image named "SharedMedia" to clue them in that they need to enable it or click it
// It also forces the address bar to be minimal, to auto play, and prevent navigation away from this page.
// Add this image to the same prim that holds this script:
// http://dl.dropboxusercontent.com/u/31305726/SharedMedia.png


// :License:  Creative Commons CC
// :Author: Ferd Frederix
// :Description:Shared media paper for collaborative chatting in any Virtual world.
 // Makes a box <2.8, 1.8, 0.10>
// tapers the  x and y = 0.1 to make it framed
// required shared media aka Media on a Prim (MOAP)

string url = "http://sharejs.org/pad/pad.html#02tahXX";   // Change the url ending after the # for private channels

float DISTANCE = 20.0;  // distance the picture will detect up an avatar, from 0.1 to 96.0.   Biggers numbers cause more lag
float RATE = 5.0;       // seconds to scan for an avatar, lower numbers cause more lag but faster response.


string no_viewer2 = "SharedMedia"; // an image to tell them they need to click things.
integer side = 0;

list rules = [
PRIM_MEDIA_AUTO_ZOOM, TRUE,
PRIM_MEDIA_AUTO_PLAY ,TRUE,

// Permissions: choose one
// PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE ,   // view only
//PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_OWNER , //  Just the owner of the prim
//PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_GROUP , // Just group chat
PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_ANYONE , 
PRIM_MEDIA_PERMS_CONTROL,PRIM_MEDIA_PERM_NONE , 

// Media controls:  : choose one
//PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_STANDARD,  // FULL SIZE CONTROL
PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI,   // MINI CONTROL

PRIM_MEDIA_AUTO_SCALE, FALSE,       // MUST be false to allow scrolling
PRIM_MEDIA_WIDTH_PIXELS , 800,      
PRIM_MEDIA_HEIGHT_PIXELS , 600,
PRIM_MEDIA_CURRENT_URL ];


list page_visible ;     // hold the texture when avtar is away
list picture_image;     // holds the regular image
list web_rules;


default
{
    state_entry() 
    {
        
        //make boxed picture frame and set it to glow.
       llSetPrimitiveParams([ PRIM_FULLBRIGHT,side, TRUE]);
       llSetScale(<2.8, 1.8, 0.10>);
       llSetPrimitiveParams([ PRIM_TYPE,PRIM_TYPE_BOX,0, <0,1,0>, 0, <0,0,0>, <0.950,0.950,0>, <0,0,0>]);

        web_rules = rules + url;
        page_visible = [
            PRIM_TEXTURE,       // command to set a texture 
            side,                  // on side 1
            "",         // the white default texture
            <0.56,0.39,0>,    // Repeats per face  0.56
            <-0.210,-0.210,0>,  // Texture Offset
            0                   // rotation in radians
        ];
        
          picture_image = [
            PRIM_TEXTURE,       // command to set a texture 
            side,                  // on side 1
            no_viewer2,         // the white default texture
            <1,1,0>,            // Repeats per face
            <0,0,0>,            // Texture Offset
            0                   // rotation in radians
        ];

        llClearPrimMedia(side);
        llSetPrimitiveParams(picture_image);
        llSensorRepeat("","",AGENT,DISTANCE,PI,RATE);
    }
    
    sensor(integer nh)
    {           
        llSetPrimitiveParams(page_visible);
        llSetPrimMediaParams(side,web_rules);
    }

    no_sensor()
    {
        llClearPrimMedia(side);
        llSetPrimitiveParams(picture_image);
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
    

}
