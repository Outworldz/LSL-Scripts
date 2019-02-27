//###############################################################################
//###############################################################################
// Script for displaying a choice of Windlight settings. Jeff Hall, January 2015
// (Special thanks to Caro Fayray for testing the gizmo too:))
// The lightshare script function is restricted to the region owner only; the region owner
// must be the same as the object owner though anyone can change windlight after.
// Changes will be visible to everyone having lightshare enabled on his viewer.

// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Original Dark Blue settings from Wizardry and Steamworks 2012
// Please be sure you read and adhere to the terms of this license: http://creativecommons.org/licenses/by-nc-sa/4.0/

//REQUIREMENTS-------------------------------------------
// LightShare must be enabled in the simulator and viewer
// (http://opensimulator.org/wiki/LightShare)
// Opensim.ini:
// [LightShare]
// ; This enables the transmission of Windlight scenes to supporting clients, such as the Meta7 viewer.
// ; It has no ill effect on viewers which do not support server-side windlight settings.
// enable_windlight = true
// and
// [XEngine]
// ; Allow the user of LightShare functions
// AllowLightShareFunctions = true
// Viewer:
// example for Firestorm: Preferences/Opensim/Micellaneous -> Enable region Lightshare settings
// Update list of compatible viewers: http://opensimulator.org/wiki/Compatible_Viewers
// Successful tests were made with both MySQL and SQLite databases
// It might happen that some lightshare settings having floating values with many digits might have
// to be reapplied after a sim restart. It is possible however to increase the number of digits for
// fields having floating values like float(3,2) to float(9,6) for example in regionwindlight table
// in opensim database. Doing that will make lightshare settings always retained in database after a
// region restart.
// (Another possibility to insure settings retaining after a region restart can be done by using the
// Windlight-Scheduler normally included with the present Windlight-Displayer).

//-----------------------------------------------------
// This script is intended to offer a customised lightshare when running but it always offers the possibility
// to display default one if user chooses Default option button in menu and it will do as long as sim is running.
// Sim restart will show by default the last custom lightshare used and stored in [regionwindlight] database table.
// If you want to get back permanently to default lightshare settings remove the device and set back default display
// in region settings through your viewer.
// This displayer can be rezzed in more than one place in region; in such case they will sync together for displaying
// Current windlight name or Default one. This script is free to edit for windlight settings but keep in mind that you
// should always have same script in all displayers of your region.
// Settings descriptions are included at end.
// After rezzing device you might need to reset scripts: right-click on device, Edit/Content/Reset Scripts
// (or you can use top bar menu Build/Scripts/Reset scripts).
// Enjoy:)
//###############################################################################
//###############################################################################

integer ownerOnly = TRUE; // default FALSE; option to limitate windlight change to owner (if TRUE)

//--------------------------
integer dialogChannel = -256;  //channel can be changed here if desired
list buttons = ["Dawn", "Sunset","Next","Starry","Glowing","Golden","Past", "Fog", "Deep Night","Dark Blue I","Dark Blue II","Evening"];
list buttons2 = ["Random","Default","Previous","Auroras","Blazing", "Tropical","Alien I","Alien II","Pastel", "Stormy I", "Stormy II", "Green"];

list lstWindlight = [];
string dialogInfo = "\nWindlight Setting\n\nPlease make a choice.";
key ToucherID;
key owner = "";
integer listenHandle;
float timerDelay = 10;  // reapply periodically lightshare settings; default 10 - change to 0 for disabling but custom lightshare may not keep showing after tp back from another region.

integer blnActivateNext;  //prevents multiple dialog windows on Next button with more than one gizmo in region
string strDeactivateNext = "2c2f8725-49b2-40c7-af2f-7d4fce2e9033";

list  settings;

list  settingsToRead =[WL_WATER_COLOR, WL_WATER_FOG_DENSITY_EXPONENT, WL_UNDERWATER_FOG_MODIFIER, WL_REFLECTION_WAVELET_SCALE, WL_FRESNEL_SCALE, WL_FRESNEL_OFFSET, WL_REFRACT_SCALE_ABOVE, WL_REFRACT_SCALE_BELOW, WL_BLUR_MULTIPLIER, WL_BIG_WAVE_DIRECTION, WL_LITTLE_WAVE_DIRECTION, WL_NORMAL_MAP_TEXTURE, WL_HAZE_HORIZON, WL_BLUE_DENSITY, WL_HORIZON, WL_DENSITY_MULTIPLIER, WL_DISTANCE_MULTIPLIER, WL_MAX_ALTITUDE, WL_SUN_MOON_COLOR, WL_AMBIENT, WL_SUN_MOON_POSITION, WL_EAST_ANGLE, WL_SUN_GLOW_SIZE, WL_SUN_GLOW_FOCUS, WL_SCENE_GAMMA, WL_STAR_BRIGHTNESS, WL_CLOUD_COLOR, WL_CLOUD_XY_DENSITY, WL_CLOUD_COVERAGE, WL_CLOUD_SCALE, WL_CLOUD_DETAIL_XY_DENSITY, WL_CLOUD_SCROLL_X, WL_CLOUD_SCROLL_Y, WL_CLOUD_SCROLL_Y_LOCK, WL_CLOUD_SCROLL_X_LOCK, WL_DRAW_CLASSIC_CLOUDS, WL_HAZE_DENSITY];


default

{
    state_entry()

    {

        llResetScript();
        llSetText(")",<0,1,1>,1.0);
        llSetTimerEvent(timerDelay);
        owner = llGetOwner();

        llSetTextureAnim( // a FUNCTION that requires the following PARAMETER list:
            (0 // option list:  use // to disable any you do not want.
                | ANIM_ON   // Disable this line to turn off animations.
            | LOOP      // repeat animation over and over. - almost always needed
            //| REVERSE   // animate in opposite direction.
            // | PING_PONG // reverses completed animation back to starting point
            | SMOOTH    // disables flip-book style 'frames' animation
            // | ROTATE    // spins texture instead of offsetting it
            // | SCALE     // zoom/shrinks texture instead of offsetting it.
            ),
            ALL_SIDES,    // One face number or ALL_SIDES. 0=top, 1=side, 2=bottom,... depending on shape.
            0,0,  // Grid Size, for 'frames' style animation, X frames wide, by Y Frames tall.
            0.0,  // START: first frame, or first offset, scale or rotation angle.
            TWO_PI, // LENGTH: # of frames to show, distance to offset or scale, use TWO_PI for ROTATE!
            0.07// "frames per second" smaller = slower
                ); // End

        listenHandle = llListen(dialogChannel, "", ToucherID, "");
        blnActivateNext = FALSE;
    }

    on_rez (integer param)

    {
        llResetScript();
    }

    touch_start(integer total_number)

    {
        if ((ownerOnly == FALSE) || ( (ownerOnly == TRUE) && (llDetectedKey(0) == owner)))
        {
            llRegionSay(dialogChannel,strDeactivateNext); //initializes blnActivateNext
            llSleep(0.1);
            blnActivateNext = TRUE;  //only touched displayer will show next dialog menu if clicked, not others listening if present in region
            ToucherID = llDetectedKey(0);
            llDialog(ToucherID, dialogInfo, buttons, dialogChannel);
        }
        else
        {
            llSay(0,"Actual settings only allow owner for changing windlight.");
        }
    }


    listen(integer channel, string name, key id, string message)

    {

        //llListenRemove(listenHandle); //keep open for communicating if you have more than one windlight displayer in region

        if (message == strDeactivateNext)
        {
            blnActivateNext = FALSE; //make sure other objects listening are correctly set
        }


        if (message == "Dark Blue I")
        {
            lstWindlight = [
                WL_WATER_COLOR, <13, 97, 135>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.0,
                WL_UNDERWATER_FOG_MODIFIER, 0.25,
                WL_REFLECTION_WAVELET_SCALE, <2.0, 2.0, 2.0>,
                WL_FRESNEL_SCALE, 0.10,
                WL_FRESNEL_OFFSET, 0.58,
                WL_REFRACT_SCALE_ABOVE, 0.08,
                WL_REFRACT_SCALE_BELOW, 0.20,
                WL_BLUR_MULTIPLIER, 0.003,
                WL_BIG_WAVE_DIRECTION, <0.50, -0.17, 0>,
                WL_LITTLE_WAVE_DIRECTION, <0.58, -0.67, 0>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.33,
                WL_BLUE_DENSITY, <0.13, 0.21, 0.34, 0.34>,
                WL_HORIZON, <0.24,0.40,0.46,0.46>,
                WL_DENSITY_MULTIPLIER, 0.01,
                WL_DISTANCE_MULTIPLIER, 0.7,
                WL_MAX_ALTITUDE, 711,
                WL_SUN_MOON_COLOR, <0.21,0.23,0.29,0.29>,
                WL_AMBIENT, <0.09,0.15,0.25,0.25>,
                WL_SUN_MOON_POSITION, 0.375,
                WL_EAST_ANGLE, 0.50,
                WL_SUN_GLOW_SIZE, 1.79,
                WL_SUN_GLOW_FOCUS, 0.10,
                WL_SCENE_GAMMA, 1.61,
                WL_STAR_BRIGHTNESS, 0.00,
                WL_CLOUD_COLOR, <0.53,0.53,0.53,0.53>,
                WL_CLOUD_XY_DENSITY, <0.73,0.34,0.33>,
                WL_CLOUD_COVERAGE, 0.26,
                WL_CLOUD_SCALE, 0.33,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.29,0.85,0.02>,
                WL_CLOUD_SCROLL_X, 0.50,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.7
                    ];

            lsSetWindlightScene(lstWindlight);
        }

        if (message == "Dark Blue II")
        {
            lstWindlight = [
                WL_WATER_COLOR, <13, 97, 135>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.0,
                WL_UNDERWATER_FOG_MODIFIER, 0.25,
                WL_REFLECTION_WAVELET_SCALE, <2.0, 2.0, 2.0>,
                WL_FRESNEL_SCALE, 0.10,
                WL_FRESNEL_OFFSET, 0.58,
                WL_REFRACT_SCALE_ABOVE, 0.08,
                WL_REFRACT_SCALE_BELOW, 0.20,
                WL_BLUR_MULTIPLIER, 0.003,
                WL_BIG_WAVE_DIRECTION, <0.50, -0.17, 0>,
                WL_LITTLE_WAVE_DIRECTION, <0.58, -0.67, 0>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.33,
                WL_BLUE_DENSITY, <0.0, 0.0, 0.0, 0.0>,
                WL_HORIZON, <0.24,0.40,0.46,0.46>,
                WL_DENSITY_MULTIPLIER, 0.01,
                WL_DISTANCE_MULTIPLIER, 0.7,
                WL_MAX_ALTITUDE, 711,
                WL_SUN_MOON_COLOR, <0.07,0.06,0.07,0.29>,
                WL_AMBIENT, <0.09,0.15,0.25,0.25>,
                WL_SUN_MOON_POSITION, 0.375,
                WL_EAST_ANGLE, 0.50,
                WL_SUN_GLOW_SIZE, 1.79,
                WL_SUN_GLOW_FOCUS, 0.1,
                WL_SCENE_GAMMA, 2.5,
                WL_STAR_BRIGHTNESS, 0.00,
                WL_CLOUD_COLOR, <0.53,0.53,0.53,0.53>,
                WL_CLOUD_XY_DENSITY, <0.73,0.34,0.33>,
                WL_CLOUD_COVERAGE, 0.26,
                WL_CLOUD_SCALE, 0.33,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.29,0.85,0.02>,
                WL_CLOUD_SCROLL_X, 0.50,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.7

                    ];

            lsSetWindlightScene(lstWindlight);

        }


        if (message == "Evening")
        {
            lstWindlight = [
                WL_WATER_COLOR, <13, 97, 135>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.0,
                WL_UNDERWATER_FOG_MODIFIER, 0.25,
                WL_REFLECTION_WAVELET_SCALE, <2.0, 2.0, 2.0>,
                WL_FRESNEL_SCALE, 0.10,
                WL_FRESNEL_OFFSET, 0.58,
                WL_REFRACT_SCALE_ABOVE, 0.08,
                WL_REFRACT_SCALE_BELOW, 0.20,
                WL_BLUR_MULTIPLIER, 0.003,
                WL_BIG_WAVE_DIRECTION, <0.50, -0.17, 0>,
                WL_LITTLE_WAVE_DIRECTION, <0.58, -0.67, 0>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.33,
                WL_BLUE_DENSITY, <0.13, 0.21, 0.34, 0.34>,
                WL_HORIZON, <0.12,0.20,0.25,0.46>,
                WL_DENSITY_MULTIPLIER, 0.01,
                WL_DISTANCE_MULTIPLIER, 0.7,
                WL_MAX_ALTITUDE, 711,
                WL_SUN_MOON_COLOR, <0.14,0.12,0.14,0.29>,
                WL_AMBIENT, <0.05,0.07,0.12,0.25>,
                WL_SUN_MOON_POSITION, 0.375,
                WL_EAST_ANGLE, 0.50,
                WL_SUN_GLOW_SIZE, 1.79,
                WL_SUN_GLOW_FOCUS, 0.10,
                WL_SCENE_GAMMA, 0.5,
                WL_STAR_BRIGHTNESS, 0.00,
                WL_CLOUD_COLOR, <0.53,0.53,0.53,0.53>,
                WL_CLOUD_XY_DENSITY, <0.73,0.34,0.33>,
                WL_CLOUD_COVERAGE, 0.35,
                WL_CLOUD_SCALE, 0.45,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.29,0.85,0.02>,
                WL_CLOUD_SCROLL_X, 0.50,
                WL_CLOUD_SCROLL_Y, -0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.7
                    ];

            lsSetWindlightScene(lstWindlight);

        }


        if (message == "Past")
        {
            lstWindlight = [
                WL_WATER_COLOR, <220, 220, 195>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.0,
                WL_UNDERWATER_FOG_MODIFIER, 0.25,
                WL_REFLECTION_WAVELET_SCALE, <2.0, 2.0, 2.0>,
                WL_FRESNEL_SCALE, 0.10,
                WL_FRESNEL_OFFSET, 0.58,
                WL_REFRACT_SCALE_ABOVE, 0.08,
                WL_REFRACT_SCALE_BELOW, 0.20,
                WL_BLUR_MULTIPLIER, 0.003,
                WL_BIG_WAVE_DIRECTION, <0.50, -0.17, 0>,
                WL_LITTLE_WAVE_DIRECTION, <0.58, -0.67, 0>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.50,
                WL_BLUE_DENSITY, <0.0, 0.0, 0.0, 0.0>,
                WL_HORIZON, <0.24,0.40,0.46,0.46>,
                WL_DENSITY_MULTIPLIER, 0.01,
                WL_DISTANCE_MULTIPLIER, 0.7,
                WL_MAX_ALTITUDE, 711,
                WL_SUN_MOON_COLOR, <0.07,0.06,0.07,0.29>,
                WL_AMBIENT, <0.4,0.4,0.25,0.25>,
                WL_SUN_MOON_POSITION, 0.375,
                WL_EAST_ANGLE, 0.50,
                WL_SUN_GLOW_SIZE, 1.79,
                WL_SUN_GLOW_FOCUS, 0.1,
                WL_SCENE_GAMMA, 2.0,
                WL_STAR_BRIGHTNESS, 0.00,
                WL_CLOUD_COLOR, <0.53,0.53,0.53,0.53>,
                WL_CLOUD_XY_DENSITY, <0.73,0.34,0.33>,
                WL_CLOUD_COVERAGE, 0.26,
                WL_CLOUD_SCALE, 0.33,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.29,0.85,0.02>,
                WL_CLOUD_SCROLL_X, 0.50,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.7
                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Fog")
        {
            lstWindlight = [
                WL_WATER_COLOR, <220, 220, 195>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.0,
                WL_UNDERWATER_FOG_MODIFIER, 0.25,
                WL_REFLECTION_WAVELET_SCALE, <2.0, 2.0, 2.0>,
                WL_FRESNEL_SCALE, 0.10,
                WL_FRESNEL_OFFSET, 0.58,
                WL_REFRACT_SCALE_ABOVE, 0.08,
                WL_REFRACT_SCALE_BELOW, 0.20,
                WL_BLUR_MULTIPLIER, 0.003,
                WL_BIG_WAVE_DIRECTION, <0.50, -0.17, 0>,
                WL_LITTLE_WAVE_DIRECTION, <0.58, -0.67, 0>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.8,
                WL_BLUE_DENSITY, <0.0, 0.0, 0.0, 0.0>,
                WL_HORIZON, <0.24,0.40,0.46,0.46>,
                WL_DENSITY_MULTIPLIER, 0.2,
                WL_DISTANCE_MULTIPLIER, 80,
                WL_MAX_ALTITUDE, 711,
                WL_SUN_MOON_COLOR, <0.07,0.06,0.07,0.29>,
                WL_AMBIENT, <0.05,0.05,0.03,0.03>,
                WL_SUN_MOON_POSITION, 0.375,
                WL_EAST_ANGLE, 0.50,
                WL_SUN_GLOW_SIZE, 1.79,
                WL_SUN_GLOW_FOCUS, 0.1,
                WL_SCENE_GAMMA, 2.5,
                WL_STAR_BRIGHTNESS, 0.00,
                WL_CLOUD_COLOR, <0.53,0.53,0.53,0.53>,
                WL_CLOUD_XY_DENSITY, <0.73,0.34,0.33>,
                WL_CLOUD_COVERAGE, 0.35,
                WL_CLOUD_SCALE, 0.33,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.29,0.85,0.02>,
                WL_CLOUD_SCROLL_X, -0.25,
                WL_CLOUD_SCROLL_Y, 0.25,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.7

                    ];

            lsSetWindlightScene(lstWindlight);
        }


        if (message == "Deep Night")
        {
            lstWindlight = [

                WL_WATER_COLOR, <13, 97, 135>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.0,
                WL_UNDERWATER_FOG_MODIFIER, 0.201542,
                WL_REFLECTION_WAVELET_SCALE, <2.000000,2.000000,2.000000>,
                WL_FRESNEL_SCALE, 0.1,
                WL_FRESNEL_OFFSET, 0.58,
                WL_REFRACT_SCALE_ABOVE, 0.08,
                WL_REFRACT_SCALE_BELOW, 0.2,
                WL_BLUR_MULTIPLIER, 0.003,
                WL_BIG_WAVE_DIRECTION, <0.500000,-0.170000,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <0.580000,-0.670000,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.33,
                WL_BLUE_DENSITY, <0.130000,0.210000,0.340000,0.340000>,
                WL_HORIZON, <0.285776,0.350453,0.211813,0.094694>,
                WL_DENSITY_MULTIPLIER, 0.000076,
                WL_DISTANCE_MULTIPLIER, 0.7,
                WL_MAX_ALTITUDE, 931,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.575061,
                WL_EAST_ANGLE, 0.5,
                WL_SUN_GLOW_SIZE, 1.79,
                WL_SUN_GLOW_FOCUS, 0.1,
                WL_SCENE_GAMMA, 1.61,
                WL_STAR_BRIGHTNESS, 0,
                WL_CLOUD_COLOR, <0.530000,0.530000,0.530000,0.530000>,
                WL_CLOUD_XY_DENSITY, <0.730000,0.340000,0.330000>,
                WL_CLOUD_COVERAGE, 0.26,
                WL_CLOUD_SCALE, 0.33,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.290000,0.850000,0.020000>,
                WL_CLOUD_SCROLL_X, -0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.7

                    ];

            lsSetWindlightScene(lstWindlight);

        }


        if (message == "Starry")
        {
            lstWindlight = [

                WL_WATER_COLOR, <0,0,128>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.806602,
                WL_UNDERWATER_FOG_MODIFIER, 0.448619,
                WL_REFLECTION_WAVELET_SCALE, <1.768648,1.242124,7.178653>,
                WL_FRESNEL_SCALE, 0.266238,
                WL_FRESNEL_OFFSET, 0.639828,
                WL_REFRACT_SCALE_ABOVE, 0.378514,
                WL_REFRACT_SCALE_BELOW, 0.877668,
                WL_BLUR_MULTIPLIER, 0.084658,
                WL_BIG_WAVE_DIRECTION, <0.81,0.621785,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <0.042799,0.56936,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.098134,
                WL_BLUE_DENSITY, <0.427008,0.535837,0.957327,0.663032>,
                WL_HORIZON, <0.528483,0.659543,0.900877,0.495787>,
                WL_DENSITY_MULTIPLIER, 0.000703,
                WL_DISTANCE_MULTIPLIER, 1.074452,
                WL_MAX_ALTITUDE, 324,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.66092,
                WL_EAST_ANGLE, 0.602004,
                WL_SUN_GLOW_SIZE, 0.450286,
                WL_SUN_GLOW_FOCUS, 0.078417,
                WL_SCENE_GAMMA, 1.0,
                WL_STAR_BRIGHTNESS, 1.99,
                WL_CLOUD_COLOR, <0.613282,0.836680,0.582055,0.301782>,
                WL_CLOUD_XY_DENSITY, <0.775693,0.040026,0.609956>,
                WL_CLOUD_COVERAGE, 0.12,
                WL_CLOUD_SCALE, 0.455395,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.398200,0.118275,0.867201>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 3.95

                    ];

            lsSetWindlightScene(lstWindlight);
        }


        if (message == "Glowing")
        {
            lstWindlight = [

                WL_WATER_COLOR, <0.0,143.0,175.0>,
                WL_WATER_FOG_DENSITY_EXPONENT, 1.156439,
                WL_UNDERWATER_FOG_MODIFIER, 0.969125,
                WL_REFLECTION_WAVELET_SCALE, <8.482132,9.775111,4.452634>,
                WL_FRESNEL_SCALE, 0.546374,
                WL_FRESNEL_OFFSET, 0.503164,
                WL_REFRACT_SCALE_ABOVE, 0.628186,
                WL_REFRACT_SCALE_BELOW, 0.980204,
                WL_BLUR_MULTIPLIER, 0.03555,
                WL_BIG_WAVE_DIRECTION, <1.05452,1.07541,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.120385,1.155334,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.472696,
                WL_BLUE_DENSITY, <0.622049,0.798068,0.097409,0.597018>,
                WL_HORIZON, <0.0,0.30,0.85,0.32>,
                WL_DENSITY_MULTIPLIER, 0.039702,
                WL_DISTANCE_MULTIPLIER, 4.824,
                WL_MAX_ALTITUDE, 44,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.365929,
                WL_EAST_ANGLE, 0.883019,
                WL_SUN_GLOW_SIZE, 1.780648,
                WL_SUN_GLOW_FOCUS, 0.073334,
                WL_SCENE_GAMMA, 0.646127,
                WL_STAR_BRIGHTNESS, 1.301247,
                WL_CLOUD_COLOR, <0.979874,0.169159,0.049543,0.470948>,
                WL_CLOUD_XY_DENSITY, <0.715409,0.414984,0.128918>,
                WL_CLOUD_COVERAGE, 0.493855,
                WL_CLOUD_SCALE, 0.656979,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.182797,0.031768,0.981983>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 2.439926

                    ];

            lsSetWindlightScene(lstWindlight);
        }


        if (message == "Golden")
        {
            lstWindlight = [

                WL_WATER_COLOR, <70.000000,105.000000,225.000000>,
                WL_WATER_FOG_DENSITY_EXPONENT, 1.074903,
                WL_UNDERWATER_FOG_MODIFIER, 0.139087,
                WL_REFLECTION_WAVELET_SCALE, <4.759264,5.874388,4.500500>,
                WL_FRESNEL_SCALE, 0.769096,
                WL_FRESNEL_OFFSET, 0.55626,
                WL_REFRACT_SCALE_ABOVE, 0.178062,
                WL_REFRACT_SCALE_BELOW, 0.292827,
                WL_BLUR_MULTIPLIER, 0.00557,
                WL_BIG_WAVE_DIRECTION, <1.117288,1.092456,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.029926,1.073620,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.464688,
                WL_BLUE_DENSITY, <0.884736,0.505738,0.718928,0.116796>,
                WL_HORIZON, <0.873863,0.656011,0.048029,0.027890>,
                WL_DENSITY_MULTIPLIER, 0.017132,
                WL_DISTANCE_MULTIPLIER, 9.799045,
                WL_MAX_ALTITUDE, 1647,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.260481,
                WL_EAST_ANGLE, 0.391493,
                WL_SUN_GLOW_SIZE, 1.916126,
                WL_SUN_GLOW_FOCUS, 0.336887,
                WL_SCENE_GAMMA, 1.25,
                WL_STAR_BRIGHTNESS, 1.493026,
                WL_CLOUD_COLOR, <0.646161,0.607957,0.273940,0.298599>,
                WL_CLOUD_XY_DENSITY, <0.903541,0.279909,0.248966>,
                WL_CLOUD_COVERAGE, 0.054694,
                WL_CLOUD_SCALE, 0.364161,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.451154,0.719094,0.904059>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 1.264978

                    ];

            lsSetWindlightScene(lstWindlight);

        }


        if (message == "Dawn")
        {
            lstWindlight = [

                WL_WATER_COLOR, <24.0,116.0,204.0>,
                WL_WATER_FOG_DENSITY_EXPONENT, 1.361316,
                WL_UNDERWATER_FOG_MODIFIER, 0.310014,
                WL_REFLECTION_WAVELET_SCALE, <9.080267,9.881126,4.626266>,
                WL_FRESNEL_SCALE, 0.289506,
                WL_FRESNEL_OFFSET, 0.465959,
                WL_REFRACT_SCALE_ABOVE, 0.1,
                WL_REFRACT_SCALE_BELOW, 0.2,
                WL_BLUR_MULTIPLIER, 0.068954,
                WL_BIG_WAVE_DIRECTION, <0.5025839,0.519449,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <0.5020831,0.51808,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.6,
                WL_BLUE_DENSITY, <0.452756,0.744644,0.876003,0.148455>,
                WL_HORIZON, <0.1,0.015,0.015,0.5>,
                WL_DENSITY_MULTIPLIER, 0.01,
                WL_DISTANCE_MULTIPLIER, 5,
                WL_MAX_ALTITUDE, 286,
                WL_SUN_MOON_COLOR, <0.500000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.044625,
                WL_EAST_ANGLE, 0.0,
                WL_SUN_GLOW_SIZE, 0.566237,
                WL_SUN_GLOW_FOCUS, 0.062125,
                WL_SCENE_GAMMA, 1.317128,
                WL_STAR_BRIGHTNESS, 0.179336,
                WL_CLOUD_COLOR, <0.2,0.5,0.98,0.5>,
                WL_CLOUD_XY_DENSITY, <0.325122,0.528978,0.082439>,
                WL_CLOUD_COVERAGE, 0.452798,
                WL_CLOUD_SCALE, 0.317025,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.593138,0.719283,0.743420>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 1.154176

                    ];

            lsSetWindlightScene(lstWindlight);

        }



        if (message == "Sunset")
        {
            lstWindlight = [
                WL_WATER_COLOR, <24.0,116.0,204.0>,
                WL_WATER_FOG_DENSITY_EXPONENT, 1.361316,
                WL_UNDERWATER_FOG_MODIFIER, 0.310014,
                WL_REFLECTION_WAVELET_SCALE, <9.080267,9.881126,4.626266>,
                WL_FRESNEL_SCALE, 0.489506,
                WL_FRESNEL_OFFSET, 0.465959,
                WL_REFRACT_SCALE_ABOVE, 0.1,
                WL_REFRACT_SCALE_BELOW, 0.2,
                WL_BLUR_MULTIPLIER, 0.068954,
                WL_BIG_WAVE_DIRECTION, <0.625839,0.75449,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <0.5831,0.61808,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.3,
                WL_BLUE_DENSITY, <0.1,0.2,0.96003,0.5>,
                WL_HORIZON, <0.6,0.35,0.05,0.5>,
                WL_DENSITY_MULTIPLIER, 0.01,
                WL_DISTANCE_MULTIPLIER, 5,
                WL_MAX_ALTITUDE, 1000,
                WL_SUN_MOON_COLOR, <0.600000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.5,0.2,0.2,0.250000>,
                WL_SUN_MOON_POSITION, 0.044625,
                WL_EAST_ANGLE, 0.5,
                WL_SUN_GLOW_SIZE, 0.566237,
                WL_SUN_GLOW_FOCUS, 0.062125,
                WL_SCENE_GAMMA, 1.0,
                WL_STAR_BRIGHTNESS, 0.179336,
                WL_CLOUD_COLOR, <0.9,0.01,0.01,0.5>,
                WL_CLOUD_XY_DENSITY, <0.325122,0.528978,0.082439>,
                WL_CLOUD_COVERAGE, 0.4,
                WL_CLOUD_SCALE, 0.317025,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.593138,0.719283,0.743420>,
                WL_CLOUD_SCROLL_X, 0.6,
                WL_CLOUD_SCROLL_Y, 0.6,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 1.154176

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Auroras")
        {
            lstWindlight = [
                WL_WATER_COLOR, <4,45,59>,
                WL_WATER_FOG_DENSITY_EXPONENT, 4.546884,
                WL_UNDERWATER_FOG_MODIFIER, 0.512493,
                WL_REFLECTION_WAVELET_SCALE, <4.469752,8.397901,6.772451>,
                WL_FRESNEL_SCALE, 0.740427,
                WL_FRESNEL_OFFSET, 0.429028,
                WL_REFRACT_SCALE_ABOVE, 0.163292,
                WL_REFRACT_SCALE_BELOW, 0.255536,
                WL_BLUR_MULTIPLIER, 0.036157,
                WL_BIG_WAVE_DIRECTION, <1.0337,1.097433,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.064652,1.104659,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.555065,
                WL_BLUE_DENSITY, <0.533372,0.948385,0.035603,0.789831>,
                WL_HORIZON, <0.205941,0.659320,0.440049,0.893509>,
                WL_DENSITY_MULTIPLIER, 0.008022,
                WL_DISTANCE_MULTIPLIER, 1.312191,
                WL_MAX_ALTITUDE, 851,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.522986,
                WL_EAST_ANGLE, 0.070157,
                WL_SUN_GLOW_SIZE, 0.923597,
                WL_SUN_GLOW_FOCUS, 0.214807,
                WL_SCENE_GAMMA, 1.352096,
                WL_STAR_BRIGHTNESS, 0.779212,
                WL_CLOUD_COLOR, <0.613282,0.836680,0.582055,0.301782>,
                WL_CLOUD_XY_DENSITY, <0.775693,0.040026,0.609956>,
                WL_CLOUD_COVERAGE, 0.10,
                WL_CLOUD_SCALE, 0.30,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.398200,0.118275,0.867201>,
                WL_CLOUD_SCROLL_X, 1.5,
                WL_CLOUD_SCROLL_Y, -1.21,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 3.053385

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Blazing")
        {
            lstWindlight = [
                WL_WATER_COLOR, <12.000000,11.000000,242.000000>,
                WL_WATER_FOG_DENSITY_EXPONENT, 3.2,
                WL_UNDERWATER_FOG_MODIFIER, 0.2,
                WL_REFLECTION_WAVELET_SCALE, <5.003543,3.677973,7.428368>,
                WL_FRESNEL_SCALE, 0.364123,
                WL_FRESNEL_OFFSET, 0.806711,
                WL_REFRACT_SCALE_ABOVE, 0.25,
                WL_REFRACT_SCALE_BELOW, 0.41,
                WL_BLUR_MULTIPLIER, 0.122565,
                WL_BIG_WAVE_DIRECTION, <1.190023,1.169864,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.294151,0.332772,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.14245,
                WL_BLUE_DENSITY, <0.12,0.22,0.6,0.38>,
                WL_HORIZON, <0.01,0.01,0.95,0.473398>,
                WL_DENSITY_MULTIPLIER, 0.015,
                WL_DISTANCE_MULTIPLIER, 5.983785,
                WL_MAX_ALTITUDE, 1273,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.421118,
                WL_EAST_ANGLE, 0.465805,
                WL_SUN_GLOW_SIZE, 1.843351,
                WL_SUN_GLOW_FOCUS, 0.100182,
                WL_SCENE_GAMMA, 0.799964,
                WL_STAR_BRIGHTNESS, 1.688747,
                WL_CLOUD_COLOR, <0.926600,0.639131,0.015565,0.787496>,
                WL_CLOUD_XY_DENSITY, <0.378630,0.555684,0.376508>,
                WL_CLOUD_COVERAGE, 0.664558,
                WL_CLOUD_SCALE, 0.538342,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.638437,0.377386,0.066438>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.411159

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Tropical")
        {
            lstWindlight = [
                WL_WATER_COLOR, <2,92,118>,
                WL_WATER_FOG_DENSITY_EXPONENT, 0.857744,
                WL_UNDERWATER_FOG_MODIFIER, 0.302291,
                WL_REFLECTION_WAVELET_SCALE, <0.122116,4.969574,4.639734>,
                WL_FRESNEL_SCALE, 0.5,
                WL_FRESNEL_OFFSET, 0.144779,
                WL_REFRACT_SCALE_ABOVE, 0.1,
                WL_REFRACT_SCALE_BELOW, 0.227461,
                WL_BLUR_MULTIPLIER, 0.129715,
                WL_BIG_WAVE_DIRECTION, <1.120768,0.014471,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.127961,1.176837,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.482459,
                WL_BLUE_DENSITY, <0.138669,0.079370,0.226809,0.355229>,
                WL_HORIZON, <0.517153,0.785614,0.787254,0.499298>,
                WL_DENSITY_MULTIPLIER, 0.008614,
                WL_DISTANCE_MULTIPLIER, 5.11371,
                WL_MAX_ALTITUDE, 1725,
                WL_SUN_MOON_COLOR, <0.180000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.476858,
                WL_EAST_ANGLE, 0.44213,
                WL_SUN_GLOW_SIZE, 0.15,
                WL_SUN_GLOW_FOCUS, 0.14,
                WL_SCENE_GAMMA, 1.773116,
                WL_STAR_BRIGHTNESS, 0.3,
                WL_CLOUD_COLOR, <0.284874,0.453412,0.481085,0.697756>,
                WL_CLOUD_XY_DENSITY, <0.679722,0.296304,0.077528>,
                WL_CLOUD_COVERAGE, 0.6683,
                WL_CLOUD_SCALE, 0.490673,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.767853,0.485206,0.288665>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 2.711425

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Alien I")
        {
            lstWindlight = [
                WL_WATER_COLOR, <255.000000,140.000000,120.000000>,
                WL_WATER_FOG_DENSITY_EXPONENT, 4.275422,
                WL_UNDERWATER_FOG_MODIFIER, 0.753856,
                WL_REFLECTION_WAVELET_SCALE, <9.072795,9.057376,8.325322>,
                WL_FRESNEL_SCALE, 0.437583,
                WL_FRESNEL_OFFSET, 0.039738,
                WL_REFRACT_SCALE_ABOVE, 0.113699,
                WL_REFRACT_SCALE_BELOW, 0.229843,
                WL_BLUR_MULTIPLIER, 0.012684,
                WL_BIG_WAVE_DIRECTION, <1.102530,1.014892,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.057676,1.151330,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.104257,
                WL_BLUE_DENSITY, <0.732192,0.577070,0.895777,0.441964>,
                WL_HORIZON, <0.688909,0.056618,0.010287,0.913922>,
                WL_DENSITY_MULTIPLIER, 0.045303,
                WL_DISTANCE_MULTIPLIER, 3.912289,
                WL_MAX_ALTITUDE, 1078,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.261623,
                WL_EAST_ANGLE, 0.858494,
                WL_SUN_GLOW_SIZE, 1.025843,
                WL_SUN_GLOW_FOCUS, 0.184915,
                WL_SCENE_GAMMA, 1.237678,
                WL_STAR_BRIGHTNESS, 1.977334,
                WL_CLOUD_COLOR, <0.915072,0.525595,0.508093,0.894061>,
                WL_CLOUD_XY_DENSITY, <0.601834,0.601545,0.901130>,
                WL_CLOUD_COVERAGE, 0.968258,
                WL_CLOUD_SCALE, 0.659125,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.887841,0.966825,0.325718>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 1.529225

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Alien II")

        {
            lstWindlight = [

                WL_WATER_COLOR, <20.000000,20.000000,250.000000>,
                WL_WATER_FOG_DENSITY_EXPONENT, 2.189766,
                WL_UNDERWATER_FOG_MODIFIER, 0.55,
                WL_REFLECTION_WAVELET_SCALE, <9.715599,4.410477,2.864550>,
                WL_FRESNEL_SCALE, 0.117491,
                WL_FRESNEL_OFFSET, 0.41,
                WL_REFRACT_SCALE_ABOVE, 0.347905,
                WL_REFRACT_SCALE_BELOW, 0.691796,
                WL_BLUR_MULTIPLIER, 0.070381,
                WL_BIG_WAVE_DIRECTION, <1.066186,1.072411,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.695046,1.454970,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.07781,
                WL_BLUE_DENSITY, <0.895898,0.132409,0.903198,0.217329>,
                WL_HORIZON, <0.803396,0.375369,0.049990,0.507849>,
                WL_DENSITY_MULTIPLIER, 0.014775,
                WL_DISTANCE_MULTIPLIER, 1.773642,
                WL_MAX_ALTITUDE, 1918,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.176223,
                WL_EAST_ANGLE, 0.887109,
                WL_SUN_GLOW_SIZE, 1.905627,
                WL_SUN_GLOW_FOCUS, 0.459043,
                WL_SCENE_GAMMA, 1.2,
                WL_STAR_BRIGHTNESS, 0.239079,
                WL_CLOUD_COLOR, <0.829880,0.622903,0.147659,0.231128>,
                WL_CLOUD_XY_DENSITY, <0.082016,0.924883,0.472532>,
                WL_CLOUD_COVERAGE, 0.549067,
                WL_CLOUD_SCALE, 0.466998,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.447306,0.118532,0.447821>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 3.542748

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Pastel")
        {
            lstWindlight = [

                WL_WATER_COLOR, <70,70,255>,
                WL_WATER_FOG_DENSITY_EXPONENT, 1.859902,
                WL_UNDERWATER_FOG_MODIFIER, 0.05484,
                WL_REFLECTION_WAVELET_SCALE, <2.332820,1.450380,6.004194>,
                WL_FRESNEL_SCALE, 0.821228,
                WL_FRESNEL_OFFSET, 0.974064,
                WL_REFRACT_SCALE_ABOVE, 0.202604,
                WL_REFRACT_SCALE_BELOW, 0.445756,
                WL_BLUR_MULTIPLIER, 0.140242,
                WL_BIG_WAVE_DIRECTION, <1.169339,1.304617,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.226967,1.201977,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.293679,
                WL_BLUE_DENSITY, <0.818531,0.225085,0.270699,0.814529>,
                WL_HORIZON, <0.542345,0.630488,0.999437,0.482495>,
                WL_DENSITY_MULTIPLIER, 0.025901,
                WL_DISTANCE_MULTIPLIER, 7.389419,
                WL_MAX_ALTITUDE, 3546,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.576888,
                WL_EAST_ANGLE, 0.301374,
                WL_SUN_GLOW_SIZE, 1.467226,
                WL_SUN_GLOW_FOCUS, 0.028611,
                WL_SCENE_GAMMA, 1.161464,
                WL_STAR_BRIGHTNESS, 0.694566,
                WL_CLOUD_COLOR, <0.097070,0.037996,0.922019,0.376037>,
                WL_CLOUD_XY_DENSITY, <0.504887,0.903854,0.333629>,
                WL_CLOUD_COVERAGE, 0.507194,
                WL_CLOUD_SCALE, 0.324423,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.362944,0.505987,0.381911>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.375798

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Green")
        {
            lstWindlight = [

                WL_WATER_COLOR, <143.000000,8.000000,244.000000>,
                WL_WATER_FOG_DENSITY_EXPONENT, 4.596728,
                WL_UNDERWATER_FOG_MODIFIER, 0.903586,
                WL_REFLECTION_WAVELET_SCALE, <6.190049,9.343415,8.273363>,
                WL_FRESNEL_SCALE, 0.734167,
                WL_FRESNEL_OFFSET, 0.92322,
                WL_REFRACT_SCALE_ABOVE, 0.198997,
                WL_REFRACT_SCALE_BELOW, 0.425253,
                WL_BLUR_MULTIPLIER, 0.156237,
                WL_BIG_WAVE_DIRECTION, <1.007799,1.063067,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <0.086489,1.027987,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.017827,
                WL_BLUE_DENSITY, <0.169330,0.881638,0.542157,0.667066>,
                WL_HORIZON, <0.135497,0.635862,0.281199,0.813000>,
                WL_DENSITY_MULTIPLIER, 0.02348,
                WL_DISTANCE_MULTIPLIER, 1.833835,
                WL_MAX_ALTITUDE, 1067,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.492108,
                WL_EAST_ANGLE, 0.679085,
                WL_SUN_GLOW_SIZE, 1.707343,
                WL_SUN_GLOW_FOCUS, 0.157667,
                WL_SCENE_GAMMA, 0.55,
                WL_STAR_BRIGHTNESS, 1.90,
                WL_CLOUD_COLOR, <0.364116,0.509619,0.694290,0.294289>,
                WL_CLOUD_XY_DENSITY, <0.317294,0.397761,0.014796>,
                WL_CLOUD_COVERAGE, 0.675815,
                WL_CLOUD_SCALE, 0.65418,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.724749,0.791208,0.833693>,
                WL_CLOUD_SCROLL_X, 0.5,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 0.154653

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Stormy I")
        {
            lstWindlight = [

                WL_WATER_COLOR, <10,20,100>,
                WL_WATER_FOG_DENSITY_EXPONENT, 4.949285,
                WL_UNDERWATER_FOG_MODIFIER, 0.841768,
                WL_REFLECTION_WAVELET_SCALE, <2.556013,7.317167,6.218210>,
                WL_FRESNEL_SCALE, 0.498239,
                WL_FRESNEL_OFFSET, 0.341853,
                WL_REFRACT_SCALE_ABOVE, 0.040897,
                WL_REFRACT_SCALE_BELOW, 0.350035,
                WL_BLUR_MULTIPLIER, 0.063045,
                WL_BIG_WAVE_DIRECTION, <1.516222,1.043062,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.479535,1.904096,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.526211,
                WL_BLUE_DENSITY, <0.315234,0.927577,0.049778,0.362574>,
                WL_HORIZON, <0.253345,0.080743,0.062392,0.760345>,
                WL_DENSITY_MULTIPLIER, 0.052131,
                WL_DISTANCE_MULTIPLIER, 8.036792,
                WL_MAX_ALTITUDE, 110,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.434187,
                WL_EAST_ANGLE, 0.354136,
                WL_SUN_GLOW_SIZE, 1.5,
                WL_SUN_GLOW_FOCUS, 0.110,
                WL_SCENE_GAMMA, 0.443614,
                WL_STAR_BRIGHTNESS, 0.01,
                WL_CLOUD_COLOR, <0.955256,0.549615,0.807651,0.774151>,
                WL_CLOUD_XY_DENSITY, <0.044507,0.831330,0.026146>,
                WL_CLOUD_COVERAGE, 0.563004,
                WL_CLOUD_SCALE, 0.203409,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.668823,0.474131,0.670602>,
                WL_CLOUD_SCROLL_X, 1.5,
                WL_CLOUD_SCROLL_Y, 1.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 3.05443

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        if (message == "Stormy II")
        {
            lstWindlight = [

                WL_WATER_COLOR, <10.000000,20.000000,30.000000>,
                WL_WATER_FOG_DENSITY_EXPONENT, 3.927478,
                WL_UNDERWATER_FOG_MODIFIER,0.25,
                WL_REFLECTION_WAVELET_SCALE, <8.648945,0.320922,5.837881>,
                WL_FRESNEL_SCALE, 0.999,
                WL_FRESNEL_OFFSET, 0.283757,
                WL_REFRACT_SCALE_ABOVE, 0.1,
                WL_REFRACT_SCALE_BELOW, 0.2,
                WL_BLUR_MULTIPLIER, 0.145278,
                WL_BIG_WAVE_DIRECTION, <0.320949,1.728583,0.000000>,
                WL_LITTLE_WAVE_DIRECTION, <1.215789,1.939170,0.000000>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, 0.598074,
                WL_BLUE_DENSITY, <0.640521,0.168140,0.110020,0.799253>,
                WL_HORIZON, <0.427968,0.986404,0.132727,0.118051>,
                WL_DENSITY_MULTIPLIER, 0.003264,
                WL_DISTANCE_MULTIPLIER, 7.389575,
                WL_MAX_ALTITUDE, 1350,
                WL_SUN_MOON_COLOR, <0.210000,0.230000,0.290000,0.290000>,
                WL_AMBIENT, <0.090000,0.150000,0.250000,0.250000>,
                WL_SUN_MOON_POSITION, 0.877433,
                WL_EAST_ANGLE, 0.618273,
                WL_SUN_GLOW_SIZE, 0.78664,
                WL_SUN_GLOW_FOCUS, 0.184933,
                WL_SCENE_GAMMA, 1.5,
                WL_STAR_BRIGHTNESS, 0.01,
                WL_CLOUD_COLOR, <0.299142,0.668265,0.691254,0.564617>,
                WL_CLOUD_XY_DENSITY, <0.624777,0.693689,0.023239>,
                WL_CLOUD_COVERAGE, 0.88998,
                WL_CLOUD_SCALE, 0.6050092,
                WL_CLOUD_DETAIL_XY_DENSITY, <0.982330,0.496900,0.855927>,
                WL_CLOUD_SCROLL_X, 1.7,
                WL_CLOUD_SCROLL_Y, -1.8,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, 2.713881

                    ];

            lsSetWindlightScene(lstWindlight);

        }

        //------------------------

        if (message == "Random")  //unlike other choices the Random option generates a new windlight each time
        {

            lstWindlight = [
                WL_WATER_COLOR, <llRound(llFrand(255)),llRound(llFrand(255)),llRound(llFrand(255))>,
                WL_WATER_FOG_DENSITY_EXPONENT,  llFrand(5.0),
                WL_UNDERWATER_FOG_MODIFIER,  llFrand(1.0),
                WL_REFLECTION_WAVELET_SCALE, <llFrand(10.0),llFrand(10.0),llFrand(10.0)>,
                WL_FRESNEL_SCALE,  llFrand(1.0),
                WL_FRESNEL_OFFSET, llFrand(1.0),
                WL_REFRACT_SCALE_ABOVE, llFrand(1.0),
                WL_REFRACT_SCALE_BELOW, llFrand(1.0),
                WL_BLUR_MULTIPLIER, llFrand(0.160),
                WL_BIG_WAVE_DIRECTION, <llFrand(8.0),llFrand(8.0),0>,
                WL_LITTLE_WAVE_DIRECTION, <llFrand(8.0),llFrand(8.0),0>,
                WL_NORMAL_MAP_TEXTURE, "822ded49-9a6c-f61c-cb89-6df54f42cdf4",
                WL_HAZE_HORIZON, llFrand(0.65),
                WL_BLUE_DENSITY, <llFrand(1.0), llFrand(1.0), llFrand(1.0), llFrand(1.0)>,
                WL_HORIZON, <llFrand(1.0),llFrand(1.0),llFrand(1.0),llFrand(1.0)>,
                WL_DENSITY_MULTIPLIER, llFrand(0.2),
                WL_DISTANCE_MULTIPLIER, llFrand(10.0),
                WL_MAX_ALTITUDE, llRound(llFrand(4000)),
                WL_SUN_MOON_COLOR, <0.21,0.23,0.29,0.29>,
                WL_AMBIENT, <0.09,0.15,0.25,0.25>,
                WL_SUN_MOON_POSITION, llFrand(1.000),
                WL_EAST_ANGLE, llFrand(1.0),
                WL_SUN_GLOW_SIZE, llFrand(1.99),
                WL_SUN_GLOW_FOCUS, llFrand(0.50),
                WL_SCENE_GAMMA, llFrand(3.0),
                WL_STAR_BRIGHTNESS, llFrand(2.0),
                WL_CLOUD_COLOR, <llFrand(1.0),llFrand(1.0),llFrand(1.0),llFrand(1.0)>,
                WL_CLOUD_XY_DENSITY, <llFrand(1.0),llFrand(1.0),llFrand(1.0)>,
                WL_CLOUD_COVERAGE, llFrand(1.0),
                WL_CLOUD_SCALE, llFrand(0.65)+0.01,
                WL_CLOUD_DETAIL_XY_DENSITY, <llFrand(1.0),llFrand(1.0),llFrand(1.0)>,
                WL_CLOUD_SCROLL_X, 0.50,
                WL_CLOUD_SCROLL_Y, 0.51,
                WL_CLOUD_SCROLL_Y_LOCK, 0,
                WL_CLOUD_SCROLL_X_LOCK, 0,
                WL_DRAW_CLASSIC_CLOUDS, 1,
                WL_HAZE_DENSITY, llFrand(4.0)
                    ];

            lsSetWindlightScene(lstWindlight);

            //llSay(0, llDumpList2String(lstWindlight,";")); //used to retrieve windlight settings in local chat
        }

        //------------------------

        if (message == "Default")

        {
            lsClearWindlightScene();
            llSetTimerEvent(0); //Disabling periodic reading in regionwindlight database table (unless timerDelay is set 0)
        }

        if (message != "Default" && message != "Next" && message != "Previous" && message != strDeactivateNext)

        {
            llSetTimerEvent(timerDelay);
        }

        if (message == "Next" && blnActivateNext == TRUE)
        {
            llDialog(ToucherID, dialogInfo, buttons2, dialogChannel);
        }

        if (message == "Previous" && blnActivateNext == TRUE)
        {
            llDialog(ToucherID, dialogInfo, buttons, dialogChannel);
        }

        if (message != "Next" && message != "Previous" && message != strDeactivateNext)
        {
            llSetText("Touch To Set Windlight\n(Lightshare Required)\n" + message,<0,1,1>,1.0);
            blnActivateNext = FALSE;  //reset until next user touch
        }


    }

    timer()

    {
        // apply last windlight periodically to insure it will show on new arrival
        settings = lsGetWindlightScene(settingsToRead);
        lsSetWindlightScene (settings);

    }
}


//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------
//SETTINGS DESCRIPTIONS

// WL_WATER_COLOR: The water colour. It expects a vector containing values between 0 and 255. <0,0,0> is black, <255,255,255> is white. <4,38,64> is the default colour.
// WL_WATER_FOG_DENSITY_EXPONENT: The "cloudiness" of the water. It expects a float value between 0.0 and 10.0. The default is 4.0.
// WL_UNDERWATER_FOG_MODIFIER: When underwater, this controls how foggy the water is. It expects a float between 0.0 and 2.0. The default is 0.25.
// WL_REFLECTION_WAVELET_SCALE: How big do you want the waves on the water to appear? This is a vector containing three values between 0.0 and 10.0. The components of the vector represent water layers 1,2 and 3. The default is <2.0,2.0,2.0>.
// WL_FRESNEL_SCALE: This controls size of the part of the wavelet that reflects light. At 0.0, the water is very reflective. At 1.0, it isn't reflective at all. It's a float between 0.0 and 1.0. The default is 0.40.
// WL_FRESNEL_OFFSET: This controls how much light to reflect. It's a float between 0.0 and 1.0, the default is 0.50.
// WL_REFRACT_SCALE_ABOVE
// WL_REFRACT_SCALE_BELOW
// WL_BLUR_MULTIPLIER: This controls how the wavelets blur in the distance. 0.0 means no blur, and values above 0.040 all seem to represent the highest amount of blur, however the float is between 0.000 and 0.160. The default is 0.040.
// WL_BIG_WAVE_DIRECTION: Which direction do the bigger waves travel in? This parameter expects a float with the first two parameters representing the X and Y value (the Z parameter can be anything). The default is <1.05,-0.42,0>.
// WL_LITTLE_WAVE_DIRECTION: Which direction do the smaller waves travel in? This parameter expects a float with the first two parameters representing the X and Y value (the Z parameter can be anything). The default is <1.11,-1.16,0>.
// WL_NORMAL_MAP_TEXTURE: This is the texture that's used for the surface of the water. It's a key, and the default is 822ded49-9a6c-f61c-cb89-6df54f42cdf4.
// WL_HORIZON: The colour of the horizon. ("Blue Horizon" in the windlight panel). This expects a faux-quaternion with the X,Y,Z,W parameters representing R,G,B,I respectively, each a float between 0.0 and 1.0. The default is <0.25,0.25,0.32,0.32>.
// WL_HAZE_HORIZON: Controls the amount of haze on the horizon. It's a float between 0.00 and 1.00. The default is 0.19.
// WL_BLUE_DENSITY: Misleadingly, this controls the density of the colour on the horizon (which isn't always blue!) and expects a faux-quaternion of four floats between 0.0 and 1.0. The default is <0.12,0.22,0.38,0.38>.
// WL_HAZE_DENSITY: This controls the density of the haze on the horizon. It's a single float between 0.0 and 4.0. The default is 0.70.
// WL_DENSITY_MULTIPLIER: This controls the density of the entire sky. A setting of 0.0 makes the sky black. It's a float between 0.0 and 0.90. The default is 0.18.
// WL_DISTANCE_MULTIPLIER: Want to bring the horizon right up to your doorstep? This controls how far away the sky is! It's a float between 0.0 and 100.0. The default is 0.8.
// WL_MAX_ALTITUDE: This controls the height of the atmosphere. It's an integer value between 0 and 4000. The default is 1605.
// WL_SUN_MOON_POSITION: The position of the sun/mooon in the sky (Please also see WL_EAST_ANGLE). This can be used to create a day/night cycle. It's a float between 0.000 and 1.000.
// WL_SUN_MOON_COLOR: Pretty self explanatory. Try a pink sun - go on, you know you want to. It's a faux-quaternion expecting four floats between 0.0 and 1.0. The default is <0.24,0.26,0.30,0.30>.
// WL_AMBIENT: This controls the ambient lighting. To a certain extent it also influences the horizon colour. Again, it's a faux-quaternion expecting four floats between 0.0 and 1.0. The default is <0.35,0.35,0.35,0.35>.
//WL_EAST_ANGLE: This controls "which way is east".. affecting the horizontal position of the sun (or moon) in the sky. It's a float between 0.00 and 1.00. The default is 0.00.
// WL_SUN_GLOW_FOCUS: This controls how blurry the suns' corona is. It's a float between 0.0 and 0.50, and the default is 0.10.
// WL_SUN_GLOW_SIZE: This controls the size of the sun's corona. It's a float between 1.00 and 1.99, and the default is 1.75.
// WL_SCENE_GAMMA: This controls the scene gamma correction. It's a float between 0.0 and 10.00, and the default is 1.00.
// WL_STAR_BRIGHTNESS: Starry starry night! Or day! You be the boss. This is a float between 0.00 and 2.00. The default is 0.00.
// WL_CLOUD_COLOR: A faux-quaternion representing cloud colour. Four floats between 0.0 and 1.0. The default is <0.41,0.41,0.41,0.41>.
// WL_CLOUD_XY_DENSITY: This is a vector of three components, <X position, Y Position, Cloud Density>. The X and Y positions control the location of the "cloud mass" in the sky, which may be useless if you use WL_CLOUD_SCROLL_X. The Density however is more useful and controls the thickness of the cloud masses.  Three floats between 0.0 and 1.0. The default is <1.00,0.53,1.0>.
// WL_CLOUD_COVERAGE: This simply controls how cloudy the sky is. It's a float between 0.0 and 1.0, and the default is 0.27.
// WL_CLOUD_SCALE: This controls the size of the clouds. It's a float between 0.01 and 1.00, and the default is 0.42.
// WL_CLOUD_DETAIL_XY_DENSITY: Much like WL_CLOUD_XY_DENSITY, except it doesn't control the "cloud mass" but instead affects the density of cloud whisps with those masses. Three floats between 0.0 and 1.0, the default is <1.00,0.53,0.12>.
// WL_CLOUD_SCROLL_X: How fast (and in what direction on the X axis) do the clouds move? It's a float between -10.00 and 10.00, and the default is 0.20.
// WL_CLOUD_SCROLL_Y:How fast (and in what direction on the Y axis) do the clouds move? It's a float between -10.00 and 10.00, and the default is 0.01.
// WL_DRAW_CLASSIC_CLOUDS: Currently non functional, but accepts TRUE or FALSE. May be implemented in the future. Default is TRUE.
// WL_CLOUD_SCROLL_X_LOCK: This allows you to lock clouds in place. It's the same as setting WL_CLOUD_SCROLL_X to 0.0. It accepts TRUE or FALSE. Default is FALSE.
// WL_CLOUD_SCROLL_Y_LOCK: This allows you to lock clouds in place. It's the same as setting WL_CLOUD_SCROLL_Y to 0.0. It accepts TRUE or FALSE. Default is FALSE.
//-------------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------

