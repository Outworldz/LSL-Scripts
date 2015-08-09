// :CATEGORY:Profile Status
// :NAME:Profile_Display
// :AUTHOR:generaal.joubert
// :CREATED:2013-04-08 09:50:02.640
// :EDITED:2013-09-18 15:39:00
// :ID:661
// :NUM:901
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script:
// :CODE:
//************************
// GENERAL PARAMETERS
//************************
 
// listen channel for Owner
integer OwnerChannel = 54321;
 
// set the maximum number of entries in the 'Exclude List' at any one time
integer ExcludeListSize = 30;
 
// the number of seconds that a listen remains open before timing-out & automatically closing
float DialogTimeout = 20.00;
 
// how often in seconds the sensor fires
float RepeatTime = 35.00;
 
// sensor range in meters. Maximum 96m but in practice 10 to 30m because of particle draw distance
float Range = 25.00;
 
// sets the number of consecutive times that the scanner is allowed to operate without having located an AV within range
// eg: if RepeatTime = 60.0 seconds and TotalNoScansAllowed = 30, then the toy will operate for 1800 seconds (60x30, or 30 minutes) without locating
// anyone before it automatically powers down. Set to '0' to disable the auto-off function
integer TotalNoScansAllowed = 20;
 
// texture palette of UUID's. One will be randomly selected for display when an AV without a profile pic is selected
list DefaultTexturePalette = ["8fb9ad84-4183-51df-f566-9b21c3a610fe", "1201c3de-d022-c0a5-56bd-bc49ab971726", "c3eebd9e-ee92-a16f-f906-bc275928df86"];
 
// sets whether the DefaultTexturePalette will be used to texture/project when the toy is switched OFF. 'TRUE' to texture/project; 'FALSE' to have no texturing/projection when off
integer EmployDefaultTexture = TRUE;
 
 
//************************
// PARTICLE EMISSION PARAMETERS
//************************
 
// set to TRUE to display the profile picture as a particle 'holographic' image above the prim
integer DisplayBanner = TRUE;
 
// width size in meters of the projected image (max 4.00)
float Size = 2.50;
 
// height above object the centre of projected image will be (theoretical max. 50.0, in practice 2.0 to 10.0))
float Height = 2.50;
 
 
//************************
// PRIM TEXTURE PARAMETERS
//************************
 
// set to TRUE to texture the prim with the profile picture on ALL_SIDES
integer TexturePrim = TRUE;
 
// the following 'Prim*' parameters effect the prim only if ("EmployDefaultTexture = FALSE") OR ("EmployDefaultTexture = TRUE" and "TexturePrim=FALSE")
// if TexturePrim = TRUE then the prim is automatically set to solid blank white no shiny with full bright as this is usually the best surface to display the profile picture
 
// texture to use for the prim when toy is OFF
key PrimUUIDTexture = "5748decc-f629-461c-9a36-a35a221fe21f";
 
// set to TRUE to turn on Full Bright on ALL_SIDES when the toy is OFF
integer PrimFullBright = FALSE;
 
// vector for the prim colour when toy is OFF
vector PrimColour = <0.0, 0.0, 0.0>;
 
// set the alpha of the prim from 0.0 (clear) to 1.0 (solid) for when toy is OFF
float PrimAlpha = 1.00;
 
// set the degree of 'shininess' to apply to the prim "0" = None, "1" = Low, "2" = medium, "3" = high
integer PrimShine = 3;
 
 
//************************
// FLOATING TEXT PARAMETERS
//************************
// set to TRUE for floating text above the prim; FALSE to disable the floating text
integer ApplyFloatingText = TRUE;
 
// set the text to be displayed
string FloatingText = "'Touch' for more information";
 
// set the text colour
vector FloatingTextColour = <1.0,1.0,0.0>;
 
// set the text alpha
float FloatingTextAlpha = 0.8;
 
 
//************************
// ROTATION PARAMETERS
//************************
 
// if TRUE, applies a slow rotation to the prim when the toy is swtiched ON and TexturePrim = TRUE; FALSE to disable rotation
integer ApplyRotation = FALSE;
 
 
//************************
// SHOUTOUT PARAMETERS
//************************
 
// set to 'TRUE' to give a 'ShoutOut' to the AV once they have been selected; 'FALSE' for no 'ShoutOut'
integer ShoutOut = TRUE;
 
// text to 'ShoutOut' when an AV's profile is projected. Text will be preceeded by their name, eg: "<AV Name>'s face is up in lights!"
string ShoutOutText = "'s face is up in lights!";
 
 
 
 
//************************
// ** DO NOT CHANGE BELOW THIS LINE **
//************************
 
 
 
 
integer Power = FALSE;
integer ListenChannel;
integer OwnerListenChannel;
integer NoSensorCounter = 0;
key AVKey = "";
key DetectedUser = "";
key ObjectOwner = "";
key LastTexture = "";
string OwnerName = "";
string ObjectName = "Profile Projector";
string Author = "Debbie Trilling";
string Supplier = "The Particle Crucible";
string Version = " v5.4.5";
string OwnerListenText = "OpenListen";
string SelfExcludedSuffix = "**";
string PowerText = "On";
list ExcludeListing = [];
 
 
 
GiveShoutOut()
{
    // any interaction with selected AV (give Inventory items etc) can safely be done from this function
    // this function will only execute if ShoutOut == TRUE
 
    //although fondly calling it a 'ShoutOut', it actually makes more sense to keep within the 20m range of llSay
    llSay(0, llKey2Name(AVKey) + ShoutOutText);
 
}
 
 
AnnounceWelcome()
{
    llOwnerSay(
        "\nThank you for your interest in this " + ObjectName + " "
            + Version + " created by " + Author + " at " + Supplier + ". \nHelp setting up, configuring and operating the "
        + ObjectName + " can be gotton at http://wiki.secondlife.com/wiki/Talk:Random_AV_Profile_Projector \nTOUCH the " + ObjectName + " to operate it.");
}
 
 
InitialiseObject()
{
    llParticleSystem([]);
    StopRotation();
    ObjectOwner = llGetOwner();
    OwnerName = llKey2Name(ObjectOwner);
    llSetObjectName(ObjectName + Version);
    llSetObjectDesc("Supplied free by " + Author + "'s " + Supplier);
    CloseAllListens();
}
 
 
SetFloatingText()
{
    if (ApplyFloatingText)
    {
        llSetText(FloatingText, FloatingTextColour, FloatingTextAlpha);
    }
    else
    {
        llSetText("",<1.0,1.0,1.0>,0.0);
    }
}
 
 
ProjectTexture()
{
    // are we going to use a default texture when toy is OFF?
    if (EmployDefaultTexture)
    {
        if (TexturePrim)
        {
            // using a default texture
            ApplyPrimSurface();
        }
        else
        {
            // not texturing the prim, so apply the prim preferences
            ApplyPrimPrefs();
        }
        ApplyDefaultTexture();
    }
    else
    {
        // we're not doing anything when the toy is OFF; change the prim to user preferences
        llParticleSystem([]);
        ApplyPrimPrefs();
    }
}
 
 
ApplyPrimSurface()
{
    // putting texture on the prim, let's make sure it is solid white, blank. full bright
    llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE, PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, 0, 0 ]);
}
 
 
ApplyPrimPrefs()
{
    llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, PrimFullBright,
        PRIM_TEXTURE, ALL_SIDES, PrimUUIDTexture, <1.000000, 1.000000, 0.000000>, <0.000000, 0.000000, 0.000000>, 0.000000, PRIM_COLOR, ALL_SIDES, PrimColour, PrimAlpha, PRIM_BUMP_SHINY, ALL_SIDES, PrimShine, 0 ]);
}
 
 
StartUp()
{
    Power = TRUE;
    PowerText = "Off";
    llSensorRepeat("",NULL_KEY,AGENT,Range,PI,RepeatTime);
    NoSensorCounter = 0;
    ApplyPrimUpdate();
    llOwnerSay("\nThe " + ObjectName + " is now switched ON. Please wait...");
}
 
 
ApplyPrimUpdate()
{
    if (TexturePrim)
    {
        ApplyPrimSurface();
 
        if (ApplyRotation)
        {
            llTargetOmega(<0.0,0.0,1.0>, 0.2, PI);
        }
    }
}
 
ApplyDefaultTexture()
{
    ApplySelectedTexture((key)llList2String(DefaultTexturePalette, (integer)llFrand((float)llGetListLength(DefaultTexturePalette))));
}
 
 
string RemainingExcludeSlots()
{
    string RemainingSlots = (string)(ExcludeListSize - llGetListLength(ExcludeListing)) + " slots are now available.";
    return RemainingSlots;
}
 
 
string DeriveName(string messagecapture)
{
    string DerivedName = llGetSubString(llStringTrim(messagecapture,STRING_TRIM),8,llStringLength(llStringTrim(messagecapture,STRING_TRIM)));
    return DerivedName;
}
 
 
integer DeriveNamePosition(string messagecapture)
{
    integer DerivedNamePosition = llListFindList(ExcludeListing, (list)llGetSubString(llStringTrim(messagecapture,STRING_TRIM),8,llStringLength(llStringTrim(messagecapture,STRING_TRIM))));
    return DerivedNamePosition;
}
 
 
ApplySelectedTexture(key texture)
{
    if (DisplayBanner)
    {
        // make the particle banner if required
        //core code by Moriash Moreau. Adapted to suit by Debbie Trilling
        llParticleSystem([
            PSYS_PART_FLAGS, 0,
            PSYS_SRC_PATTERN, 4,
            PSYS_PART_START_ALPHA, 0.50,
            PSYS_PART_END_ALPHA, 0.50,
            PSYS_PART_START_COLOR, <1.0,1.0,1.0>,
            PSYS_PART_END_COLOR, <1.0,1.0,1.0>,
            PSYS_PART_START_SCALE, <Size * 1.6 ,Size,0.00>,
            PSYS_PART_END_SCALE, <Size * 1.6,Size,0.00>,
            PSYS_PART_MAX_AGE, 1.20,
            PSYS_SRC_MAX_AGE, 0.00,
            PSYS_SRC_ACCEL, <0.0,0.0,0.0>,
            PSYS_SRC_ANGLE_BEGIN, 0.00,
            PSYS_SRC_ANGLE_END, 0.00,
            PSYS_SRC_BURST_PART_COUNT, 8,
            PSYS_SRC_BURST_RADIUS, Height,
            PSYS_SRC_BURST_RATE, 0.10,
            PSYS_SRC_BURST_SPEED_MIN, 0.00,
            PSYS_SRC_BURST_SPEED_MAX, 0.00,
            PSYS_SRC_OMEGA, <0.00,0.00,0.00>,
            PSYS_SRC_TEXTURE, texture]);
    }
 
    if (TexturePrim)
    {
        llSetTexture(texture, ALL_SIDES);
    }
}
 
 
ShutDown()
{
    Power = FALSE;
    PowerText = "On";
    CloseAllListens();
    llSensorRemove();
    StopRotation();
    ProjectTexture();
    llOwnerSay("\nThe " + ObjectName + " is now switched OFF.");
}
 
 
StopRotation()
{
    llTargetOmega(<0.0,0.0,0.0>, 0.0, PI);
}
 
 
CloseAllListens()
{
    CloseUserListen();
    llListenRemove(OwnerListenChannel);
    OwnerListenText = "OpenListen";
}
 
 
CloseUserListen()
{
    llSetTimerEvent(0.0);
    llListenRemove(ListenChannel);
}
 
 
default
{
 
    on_rez(integer start_param)
    {
        // reset script on rez
        llResetScript();
    }
 
    changed( integer change )
    {
        if(change & CHANGED_OWNER )
        {
            // reset script on change of owner
            llResetScript();
        }
    }
 
    state_entry()
    {
        //initialise system
        InitialiseObject();
        SetFloatingText();
        ProjectTexture();
        AnnounceWelcome();
    }
 
    touch_start(integer total_number)
    {
        DetectedUser = llDetectedKey(0);
        list MenuItems = ["LearnMore", "GetScript", "Help"];
        string MenuText = "MAIN MENU: Please make a selection within " + (string)llFloor(DialogTimeout)
            + " seconds.\n- LearnMore: Read the forum thread on this product\n- GetScript: Get yourself the latest version of this free script\n- Help: Link to the "
            + ObjectName + " Help page";
 
        if (DetectedUser == ObjectOwner)
        {
            // touched by Owner
 
            if (Power)
            {
                MenuItems = [PowerText, OwnerListenText] + MenuItems;
                MenuText = MenuText + "\n- Off: Switch off \n- Open/CloseListen: Opens/Closes Owner listen channel " + (string)OwnerChannel;
            }
            else
            {
                MenuItems = (list)PowerText + MenuItems;
                MenuText = MenuText + "\n- On: Switch on";
            }
        }
        else
        {
            // touched by someone other than Owner. Send them a message & a dialog box of options
 
            // if they placed their own name on 'Exclude List', so give opportunity to clear their name, else give opportunity to exclude their name
            if (llListFindList(ExcludeListing, (list)(llKey2Name(AVKey) + SelfExcludedSuffix)) != -1 )
            {
                // they placed themself on the 'Exclude List' so are therefore allowed to clear their name
                MenuItems = (list)"IncludeMe" + MenuItems;
                MenuText =  MenuText + "\n- IncludeMe: Have the " + ObjectName + " remove your name from the 'Exclude List'";
            }
            else
            {
                // they have not placed themself on the 'Exclude List', so check whether the Owner has already done it
                if (llListFindList(ExcludeListing, (list)llKey2Name(AVKey)) == -1 )
                {
                    // neither they themself nor the Owner has previously excluded them, so give them the opportunity to exclude themselves now
                    MenuItems = (list)"ExcludeMe" + MenuItems;
                    MenuText =  MenuText + "\n- ExcludeMe: Have your name added to the " + ObjectName + "'s 'Exclude List'";
                }
            }
            llInstantMessage(DetectedUser, "\nThank you for your interest in the " + ObjectName + " created by " + Author + "\nThe dialog menu offers a number of options.");
        }
        // generate the dialog menu
        integer CommChannel = (-200000 - ((integer)llFrand(12345) * -1));
        ListenChannel = llListen(CommChannel, "", DetectedUser, "");
        llDialog(DetectedUser, MenuText, MenuItems, CommChannel);
        llSetTimerEvent(DialogTimeout);
    }
 
 
    sensor(integer total_number)
    {
        // save the AV key in case it is needed for a 'ShoutOut'
        AVKey = llDetectedKey((integer)llFrand(total_number));
        // core code by Coder Kas. Adapted to suit by Debbie Trilling
        string URL_RESIDENT = "http://world.secondlife.com/resident/";
        llHTTPRequest( URL_RESIDENT + (string)AVKey,[HTTP_METHOD,"GET"],"");
    }
 
 
    no_sensor()
    {
        // counts the number of times that the scanner doesn't find anyone in range. If TotalNoScansAllowed is set to greater than zero, automatically powers down the toy
        // when the number of no_sensors exceeds TotalNoScansAllowed. However, this functionality is disabled if TotalNoScansAllowed is set to zero.
        NoSensorCounter++;
        if ((NoSensorCounter > TotalNoScansAllowed) && (TotalNoScansAllowed > 0))
        {
            ShutDown();
            llInstantMessage(ObjectOwner, "\nThe " + ObjectName + " has been automatically switched OFF as no Agents have been detected within the set timeframe.");
        }
        else
        {
            ApplyDefaultTexture();
        }
    }
 
 
    http_response(key req,integer stat, list met, string body)
    {
        // core code by Coder Kas. Adapted to suit by Debbie Trilling
        integer s1 = 0;
        integer s2 = 0;
        integer s1l= 0;
        integer s2l= -3;
        s1 = llSubStringIndex(body,"<img alt=\"profile image\" src=\"http://secondlife.com/app/image/");
        s1l = llStringLength("<img alt=\"profile image\" src=\"http://secondlife.com/app/image/");
        s2 = llSubStringIndex(body,"\" class=\"parcelimg\" />");
 
        if(s1 == -1)
        {
            // selected AV doesn't have a profile picture, so use the default instead
            ApplyDefaultTexture();
        }
        else
        {
            //check whether this was the texture used last time
            if ((key)llGetSubString(body,s1+s1l,s2+s2l) == LastTexture)
            {
                // same profile pic as last time. so display a random default instead
                ApplyDefaultTexture();
                // clear the last texture out
                LastTexture = "";
            }
            else
            {
                // are they on the ExcludeListing, with or without a suffix? if so, display a random default texture instead
                if ((llListFindList(ExcludeListing, (list)llKey2Name(AVKey)) != -1 ) || (llListFindList(ExcludeListing, (list)(llKey2Name(AVKey) + SelfExcludedSuffix)) != -1))
                {
                    // they are on the 'Exclude List'
                    ApplyDefaultTexture();
                }
                else
                {
                    // different profile from last time & not on ExcludeListing, so display it
                    ApplySelectedTexture((key)llGetSubString(body,s1+s1l,s2+s2l));
                    // save the key for comparison purposes next time tho'
                    LastTexture = (key)llGetSubString(body,s1+s1l,s2+s2l);
 
                    // give a 'ShoutOut', if set to do so
                    if (ShoutOut)
                    {
                        GiveShoutOut();
                    }
                }
            }
        }
    }
 
 
    listen(integer channel, string name, key id, string message)
    {
 
        if (message == "LearnMore")
        {
            string URL_FORUMTHREAD = "http://forums.secondlife.com/showthread.php?t=225692";
            llLoadURL(DetectedUser, "Thank you for choosing to learn more about the " + ObjectName + ".This link will take you to the relevant SL forum thread.", URL_FORUMTHREAD);
            CloseUserListen();
        }
        else if (message == "GetScript")
        {
            string URL_WIKIPAGE = "http://wiki.secondlife.com/wiki/User:Debbie_Trilling";
            llLoadURL(DetectedUser, "Thank you for choosing to look at the script for the " + ObjectName + ".This link will allow you to get your own free copy.", URL_WIKIPAGE);
            CloseUserListen();
        }
        else if (message == "Help")
        {
            string URL_HELPPAGE = "http://wiki.secondlife.com/wiki/Talk:Random_AV_Profile_Projector";
            llLoadURL(DetectedUser, "This link will take you to the " + ObjectName + "'s Help page.", URL_HELPPAGE);
            CloseUserListen();
        }
        else if (message == "ExcludeMe")
        {
            // as a suffix to the name, as it is the user adding their own name
            ExcludeListing = (list)(llKey2Name(DetectedUser) + SelfExcludedSuffix) + llList2List( ExcludeListing, 0, (ExcludeListSize - 2));
            llInstantMessage(DetectedUser, "You have been added to the " + ObjectName + "'s 'Exclude List'");
            CloseUserListen();
        }
        else if (message == "IncludeMe")
        {
            integer ExcludeListPosition = llListFindList(ExcludeListing, (list)(llKey2Name(DetectedUser) + SelfExcludedSuffix));
            ExcludeListing = llDeleteSubList(ExcludeListing, ExcludeListPosition, ExcludeListPosition);
            llInstantMessage(DetectedUser, "You have been removed from the " + ObjectName + "'s 'Exclude List'");
            CloseUserListen();
        }
        else if ((message == "On") && (id == ObjectOwner))
        {
            StartUp();
        }
        else if ((message == "Off") && (id == ObjectOwner))
        {
            ShutDown();
        }
        else if ((message == "OpenListen") && (id == ObjectOwner))
        {
            // open the Owner Only channel
            OwnerListenChannel = llListen(OwnerChannel, "", ObjectOwner, "");
            OwnerListenText = "CloseListen";
            llOwnerSay("Owner Only channel " + (string)OwnerChannel + " is now open for you.\n Options are: 'Exclude <AV_NAME>', 'Include <AV_NAME>', 'ClearAll' and 'List'");
        }
        else if ((message == "CloseListen") && (id == ObjectOwner))
        {
            // close the Owner Only channel
            llListenRemove(OwnerListenChannel);
            OwnerListenText = "OpenListen";
            llOwnerSay("Owner Only channel " + (string)OwnerChannel + " is now closed.");
        }
        else if (((llGetSubString(message,0,6) == "Exclude") || (llGetSubString(message,0,6) == "exclude")) && (id == ObjectOwner))
        {
            // before adding them to the 'Exclude List', check if already on it
            // they could be on the list simply as their own name, their name + a suffix, perhaps even both.
 
            if ((DeriveNamePosition(message) != -1 ) || (DeriveNamePosition(message + SelfExcludedSuffix) != -1))
            {
                llOwnerSay(DeriveName(message) + " already exists on the " + ObjectName + "'s 'Exclude List'.");
            }
            else
            {
                // not on the list, so add them (without a suffix, as it is the Owner doing the adding)
                string NewExcludeName = DeriveName(message);
                ExcludeListing = (list)NewExcludeName + llList2List( ExcludeListing, 0, (ExcludeListSize - 2));
                llOwnerSay(NewExcludeName + " has been added to the "
                    + ObjectName + "'s 'Exclude List'. \nThere are now " + RemainingExcludeSlots());
            }
        }
        else if (((llGetSubString(message,0,6) == "Include") || (llGetSubString(message,0,6) == "include")) && (id == ObjectOwner))
        {
            // they could be on the list simply as their own name, their name + a suffix, perhaps even both. We need to test for all scenerios
            // locate their position within in 'Exclude List', if they do exist
            integer NamePositionTest = DeriveNamePosition(message);
            integer NamePositionSuffixTest = DeriveNamePosition(message + SelfExcludedSuffix);
 
            // test to see if either are on the 'Exclude List'.
            if ((NamePositionTest != -1) || (NamePositionSuffixTest != -1))
            {
                // well, their name is definately on the 'Exclude list', but is it with or without a suffix? Is it both?
                // would look neater to do the next tests in an IF-IF/ELSE-ELSE, but we can save a lil memory using two IF statement (albeit with a tiny speed overhead)
                if (NamePositionTest != -1)
                {
                    // it's on without a suffix
                    ExcludeListing = llDeleteSubList(ExcludeListing, NamePositionTest, NamePositionTest);
                }
 
                if (NamePositionSuffixTest != -1)
                {
                    //it's on with a suffix
                    ExcludeListing = llDeleteSubList(ExcludeListing, NamePositionSuffixTest, NamePositionSuffixTest);
                }
                llOwnerSay(DeriveName(message) + " has been removed from the "
                    + ObjectName + "'s 'Exclude List'. \nThere are now " + RemainingExcludeSlots());
            }
            else
            {
                llOwnerSay(DeriveName(message) + " could not located on the " + ObjectName + "'s 'Exclude List'.");
            }
        }
        else if (((llGetSubString(message,0,7) == "ClearAll") || (llGetSubString(message,0,7) == "clearall") || (llGetSubString(message,0,8) == "clear all") || (llGetSubString(message,0,8) == "Clear all")) && (id == ObjectOwner))
        {
            ExcludeListing = [];
            llOwnerSay("The 'Exclude List' has been cleared. All " + RemainingExcludeSlots());
 
        }
        else if (((llGetSubString(message,0,3) == "List") || (llGetSubString(message,0,3) == "list")) && (id == ObjectOwner))
        {
            if (llGetListLength(ExcludeListing) > 0)
            {
                llOwnerSay("The following " + (string)llGetListLength(ExcludeListing) + " AV's are listed on the 'Exclude List'. Names ending with '" + SelfExcludedSuffix + "' chose to exclude themselves.\n"
                    + llDumpList2String(ExcludeListing, " | "));
            }
            else
            {
                llOwnerSay("No AV's are listed on the 'Exclude List'.");
            }
        }
        else
        {
            llInstantMessage(DetectedUser, "Unrecognised option or selection made from a timed-out menu.");
        }
 
    }
 
    timer()
    {
        CloseUserListen();
    }
 
//default end
}
