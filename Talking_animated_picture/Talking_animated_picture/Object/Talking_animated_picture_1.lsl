// :CATEGORY:Presentations
// :NAME:Talking_animated_picture
// :AUTHOR:Ferd Frederix
// :CREATED:2010-08-05 22:38:41.050
// :EDITED:2013-09-18 15:39:06
// :ID:866
// :NUM:1203
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// An article on how to use this script is at http://www.outworldz.com/Secondlife/posts/talking-picture</a>// You will need to create your avatar first.   Navigate to this link at http://www.honestjohnny.co.uk/play/?mid=36766892 and click  Create your own talking picture
// :CODE:

// Go through steps 1) Choose your character, 2) Appearance, 3) Accessorize Yourself, and 4) Add your Audio.   You will be able to pick from over 100 avatar looks, choose your skin colors,  change hair,  clothes, headgear, and even choose your own background image.  When you are done, email the link to yourself.
// 
// Paste the code from the following  script into the script window, and save it.  Close the editor, and walk up to the picture!
// 
// The picture will detect all approaching avatars.  When they get within 10 meters of the picture, the picture will change from a static image and the picture will talk.   You can change the default image by changing the string no_viewer2 to the UUID of any image, you can set the range, and set the scan time to help control lag.
// 
// Please note that under the terms of this license, you  must share this script OPEN SOURCE, with mod rights. You cannot sell this script or the objects derived from it.

// Script by Ferd Frederix
// Creative Commons Attribution-NonCommercial-ShareAlike 3.0 
// See http://creativecommons.org/licenses/by-nc-sa/3.0/ for the license.

float DISTANCE = 10.0;  // distance the picture will detect up an avatar, from 0.1 to 96.0.   
// Bigger numbers cause more lag
float RATE = 3.0;       // seconds to scan for an avatar, lower numbers cause more lag but faster response.
string no_viewer2 = "eabd4399-7884-ae7e-545e-ea9345bbf586"; // a default image, change this if you like


// do not modify below this point

string ablank = "8a2d8475-c746-f4a6-4601-6849905e0f58";      // a blank image
list rules = [
PRIM_MEDIA_AUTO_PLAY ,1,
PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE, 
PRIM_MEDIA_PERMS_CONTROL,PRIM_MEDIA_PERM_OWNER, 
PRIM_MEDIA_CONTROLS, PRIM_MEDIA_CONTROLS_MINI, 
PRIM_MEDIA_AUTO_SCALE, FALSE,
PRIM_MEDIA_WIDTH_PIXELS , 1200,
PRIM_MEDIA_HEIGHT_PIXELS , 1200,
PRIM_MEDIA_CURRENT_URL ];

list page_visible ;     // hold the texture when avtar is away
list blank_image ;    // holds the blank texture 
list picture_image;     // holds the regular image
string texturename;
string url;
list web_rules;
default
{
    state_entry()
    {
        url = llGetObjectDesc();
        web_rules = rules + url;
        page_visible = [
            PRIM_TEXTURE,       // command to set a texture 
            1,                  // on side 1
            ablank,         // the white default texture
            <0.170,0.140,0>,    // Repeats per face
            <-0.240,-0.135,0>,  // Texture Offset
            0                   // rotation in radians
        ];
        
        blank_image = [
            PRIM_TEXTURE,       // command to set a texture 
            1,                  // on side 1
            ablank,             // the white default texture
            <1,1,0>,            // Repeats per face
            <0,0,0>,            // Texture Offset
            0                   // rotation in radians
        ];
        
        picture_image = [
            PRIM_TEXTURE,       // command to set a texture 
            1,                  // on side 1
            no_viewer2,         // the white default texture
            <1,1,0>,            // Repeats per face
            <0,0,0>,            // Texture Offset
            0                   // rotation in radians
        ];

        llClearPrimMedia(1);
        llSetPrimitiveParams(picture_image);
        llSensorRepeat("","",AGENT,DISTANCE,PI,RATE);
    }
    sensor(integer nh)
    {   
        if (llStringLength(url) == 0)
        {   
            llSensorRemove();
            llOwnerSay("You must put a URL into the Description and reset this script");
            return;
        }
        llSetPrimitiveParams(page_visible);
        llSetPrimMediaParams(1,web_rules);
    }

    no_sensor()
    {
        llClearPrimMedia(1);
        llSetPrimitiveParams(picture_image);
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
}
