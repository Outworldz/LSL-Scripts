// :CATEGORY:Train
// :NAME:Opensim Train
// :AUTHOR:Moundsa Mayo
// :CREATED:
// :EDITED:
// :REV:2.6.0// :WORLD:OpensimSim
// :DESCRIPTION:this is setup for non-physical, phantom movement but can be modified for physical, etc.
// :CODE:

// [VRCLocomotiveOpensourceScript]

string   gsScriptVersion               = "2.6.0";

// Created for VRC distribution by Moundsa Mayo
//
//  Based on the original Opensource Hobo Train Script
//  written by Twisted Laws sometime in 2007 or 2008
//
//  Contact the VRC for the original script unaltered along with some
//  revision history removed from this version.
//


// train driver script example for SLRR.
//
// this is setup for non-physical, phantom movement but can be
// modified for physical, etc.


//===================================================================//
//====  Global Constants  ============================  <START>  ====//

integer  INDEX_INVALID                 = -1;
integer  LINK_INVALID                  = -32768;
string   NAME_WILDCARD                 = "*";

vector   COLOR_GREEN                   = <0.00, 1.00, 0.00>;
vector   COLOR_BLACK                   = <0.00, 0.00, 0.00>;

//====  Global Constants  ==============================  <END>  ====//
//===================================================================//


//===================================================================//
//====  Utility Routines  ============================  <START>  ====//

string gsHexPrefix                     = "0x";
string gsHexChars                      = "0123456789ABCDEF";

string Int2Hex(integer iInt, integer iDigits)
{
    integer iWork = iInt & 0xF;
    string sResult = llGetSubString(gsHexChars, iWork, iWork);
    iInt = (iInt >> 4) & 0x0FFFFFFF;

    while (iInt != 0)
    {
        iWork = iInt & 0xF;
        sResult = llGetSubString(gsHexChars, iWork, iWork) + sResult;
        iInt = iInt >> 4;
    }

    if (llStringLength(sResult) < iDigits)
    {
        sResult = "00000000" + sResult;
        sResult = llGetSubString(sResult, -iDigits, - 1);
    }

    return(gsHexPrefix + sResult);
} // string Int2Hex


// Force unsit all sitting agents
integer UnsitAllAgents()
{
    integer iIndex;
    list    lLinkDetails = [];
    integer iAgentCount = 0;
    integer iLinkCount = llGetNumberOfPrims();

    for (iIndex = 1;  iIndex <= iLinkCount; ++iIndex)
    {
        lLinkDetails = llGetObjectDetails(llGetLinkKey(iIndex), [OBJECT_CREATOR]);

        //  Probably an Agent, so unsit and add to count
        if (llList2Key(lLinkDetails, 0) == NULL_KEY)
        {
            ++iAgentCount;
            llUnSit(llGetLinkKey(iIndex));
        }

    } // for all Links in Object

    return(iAgentCount);
} // UnsitAllAgents


//  Sum up prims in linkset, omitting any sitting agents
//  (llGetNumberOfPrims includes sitting Agents in the returned count)
integer PrimCount()
{
    integer iIndex;
    list    lLinkDetails = [];
    integer iPrimCount = 0;
    integer iLinkCount = llGetNumberOfPrims();

    for (iIndex = 1;  iIndex <= iLinkCount; ++iIndex)
    {
        lLinkDetails = llGetObjectDetails(llGetLinkKey(iIndex),
            [OBJECT_CREATOR]);

        //  Probably not an Agent, so add to count
        if (llList2Key(lLinkDetails, 0) != NULL_KEY)
        {
            ++iPrimCount;
        }

    } // for all Links in Object

    //    llOwnerSay("Links=" + (string)iPrimCount);
    return(iPrimCount);
} // PrimCount


string clip(float value)
{
    string str = (string)value;
    integer where = llSubStringIndex(str, ".");
    return(llGetSubString(str, 0, where + 2));
} // clip


integer NamedLinkFind(string sName)
{
    // locate a linked prim
    integer i;
    integer m = llGetNumberOfPrims();
    integer ret= LINK_INVALID;

    for (i = 1; i <= m; i++)
    {

        if (llGetLinkName(i) == sName)
        {
            ret = i;
        }

    }

    return ret;
} // NamedLinkFind


key ScanForAgentGone()
{
    key kLinkID;

    integer iIndex;
    integer iRiderRollCount = llGetListLength(glRidersAboard);

    // Scan Rider roll for ID missing from linked objects beyond
    // original object linkset.  Assume any missing are AGENT
    list lRiderLinks = [];

    for (iIndex = giLinkCountRiderless + 1; iIndex <=
        giLinkCountCurrent; ++iIndex)
        {
            kLinkID = llGetLinkKey(iIndex);
            lRiderLinks = lRiderLinks + (list)kLinkID;
        }

    for (iIndex = 0; iIndex < iRiderRollCount; ++iIndex)
    {
        kLinkID = llList2Key(glRidersAboard, iIndex);

        if (llListFindList(lRiderLinks, [kLinkID]) == INDEX_INVALID)
        {
            return(kLinkID);
        }

    } // for all high links (sitting atatars)

    return(NULL_KEY);
} // ScanForAgentGone

//====  Utility Routines  ==============================  <END>  ====//
//===================================================================//


//===================================================================//
//====  Locomotive-Specific Values & Code  ===========  <START>  ====//

//  This code subsection defines a list of locomotive features encoded
//  as single-bit values into an integer.  The feature set controls
//  which buttons are included in the Engineer's Menu and some aspects
//  of the locomotive's operation.

integer  FEATURE_SOUND_ENGINE          = 0x00000001;
integer  FEATURE_SOUND_WHEELS          = 0x00000002;
integer  FEATURE_SOUND_STEAM           = 0x00000004;
integer  FEATURE_SOUND_RESERVED        = 0x00000008;

integer  FEATURE_ALERT_BELL            = 0x00000010;
integer  FEATURE_ALERT_WHISTLE         = 0x00000020;
integer  FEATURE_ALERT_HORN            = 0x00000040;
integer  FEATURE_ALERT_RESERVED        = 0x00000080;

integer  FEATURE_LIGHTS_HEADLAMPS      = 0x00000100;
integer  FEATURE_LIGHTS_TAILLAMPS      = 0x00000200;
integer  FEATURE_LIGHTS_RUNNING        = 0x00000400;
integer  FEATURE_LIGHTS_RESERVED       = 0x00000800;

integer  FEATURE_CONTROL_SMOKE         = 0x00010000;

integer  FEATURE_MOTION_NONPHYSICAL    = 0x00100000;
integer  FEATURE_MOTION_PHYSICAL       = 0x00200000;
integer  FEATURE_MOTION_FLIP           = 0x00400000;
integer  FEATURE_MOTION_REVERSE        = 0x00800000;

integer  FEATURE_DISPLACE_RERAIL       = 0x01000000;
integer  FEATURE_DISPLACE_LEFT         = 0x02000000;
integer  FEATURE_DISPLACE_RIGHT        = 0x04000000;


// Compute later due to LSL limitation
rotation ROTATION_FLIP                 = ZERO_ROTATION;


//  This value defines the 'standard' featureset implemented in the VRC
// Opensource Locomotive Script.  TO remove a feature from a particular
// build, Boolean (bitwise) AND the NOT of the feature code with the
// FEATURESET_DEFAULT value.  (See "VRC 2010 Train" entry in
// configuration table below)

// Compute at initialization time due to LSL limitation.  Cannot include
// in table due to LSL design.  Instead, table can include a SINGLE
// feature to be REMOVED from FEATURESET_DEFAULT
integer  FEATURESET_DEFAULT            = 0;


//  This code subsection defines a list-based table of locomotive
//  builds identified by the first words in their ObjectName.  Several
//  configuration values are preset in the table for selection by build
//  name
//
//  Any build found in the table at script initialization time will be
//  assigned the values following its BUILD_TAG.
//
//  Any build not identified in the table will be assigned the default
//  values.

integer  UNIT_BUILD_TAG_IDX            = 0;
integer  UNIT_BUILD_GUIDE_OFFSET_IDX   = 1;
integer  UNIT_BUILD_SIT_OFFSET_IDX     = 2;
integer  UNIT_BUILD_SIT_ROTATION_IDX   = 3;
integer  UNIT_BUILD_SPEED_MINIMUM_IDX  = 4;
integer  UNIT_BUILD_SPEED_MAXIMUM_IDX  = 5;
integer  UNIT_BUILD_SPEED_INCREMENT_IDX  = 6;
integer  UNIT_BUILD_FEATURE_ADJUST_IDX = 7;

integer  UNIT_BUILD_TABLE_STRIDE       = 8;

//  string sBuildTag, vector vGuideOffset, vector vSitOffset,
//  rotation rSitRotation
list     glUnitConfiguration           = [

    // DEFAULT BUILD - probably won't work well for ANY build
    "DEFAULT BUILD", <0.00, 0.00, 0.500>, <-4.000, -0.500, 1.000>,
    ZERO_ROTATION, 0.05, 8.00, 0.05, 0,

    // Desmond Shang
    "VRC Hobo Train", <0.00, 0.00, 0.585>, <-3.50816, -0.500, 1.000>,
    <-0.00876, -0.00003, 0.00000, 0.99996>, 0.0050, 0.1000, 0.0050,
    0,

    // Lotek Ixtar
//    "NS2200", <0.00, 0.00, 0.720>, <-3.88150, -0.73620, 1.51784>,
    "[ix] NS 2201", <0.00, 0.00, 0.625>,
    <-3.594925, -1.217773, 1.880998>,
    <0.00000, 0.00000, 0.00000, -1.00000>,
    0.005, 0.05, 0.005,
    0x10034,

    // Veryfluffy Wingtips
    "Fluffies Diesel", <0.00, 0.00, 0.910>, <-1.95, 0.850, 0.950>,
    ZERO_ROTATION, 0.25, 10.00, 0.25, 0,

    // Garden Mole
    "Great Western 4500", <0.00, 0.00, 0.917>,
    <-3.50816, -0.500, 1.475>, ZERO_ROTATION, 0.10, 8.00, 0.10,
    0

        ];


//====  Operator Preference Subsection  ==============  <START>  ====//

//  This feature may be unacceptable at higher speeds or if subject to
// motion sickness, so it is disable by default

//integer  CAMERA_DYNAMICS_ENABLED       = TRUE;
integer  CAMERA_DYNAMICS_ENABLED       = FALSE;

//====  Operator Preference Subsection  ================  <END>  ====//


//  CAUTION:  Be VERY careful when adjusting these values - they are
//            set to meet SLRR published track layout standards and
//            have been thoroughly tested on the SLRR

//  Scan radius in meters
float    SENSOR_SEEK_RANGE_DEFAULT     = 20.00;

//  Scan half-angle in degrees.  Arc swept is this amount on either
//  side of X-axis of sensor prim
float    SENSOR_SEEK_ARC_DEFAULT       = 25.00;


string   OBJECT_DESCRIPTION_TAG        = "Script Version ";
string   VERSION_PREFIX_TAG            = " Opensource V";
string   ENGINEER_MENU_INSTRUCTION     = "Touch train for Engineer's Menu";

string   SIT_TEXT_OPERATOR             = "Engineer";
string   SIT_TEXT_PASSENGER            = "Passenger";

// Buttons for Engineer's menu for all builds and script revisions
string   BTN_START                     = "Start";
string   BTN_IDLE                      = "Idle";
string   BTN_STOP                      = "Stop";
string   BTN_FASTER                    = "Faster";
string   BTN_SLOWER                    = "Slower";
string   BTN_FLIP                      = "Flip";
string   BTN_HELP                      = "Help";

//  Buttons for Engineer's menu constructed according to featureset
//  Not all buttons or related functionality are implemented in a given
//  revision of this script
string   BTN_BLANK                     = " ";
string   BTN_BELL                      = "Bell";
string   BTN_WHISTLE                   = "Whistle";
string   BTN_HORN                      = "Horn";
string   BTN_HEADLAMP                  = "Headlamp";
string   BTN_RERAIL                    = "Rerail";
string   BTN_NONPHYSICAL               = "NONPhysical";
string   BTN_PHYSICAL                  = "Physical";

string   BTN_SMOKE                     = "Smoke";


//  Name the smoke-emitting prim SMOKE_PRIM_NAME
string   SMOKE_PRIM_NAME               = "Smoke";
integer  SMOKE_OFF                     = 0;
integer  SMOKE_IDLE                    = 1;
integer  SMOKE_RUN                     = 2;


integer  SIT_ALLOW                     = TRUE;
integer  SIT_DENY                      = FALSE;

integer  ENGINE_STATUS_OFF             = 0;
integer  ENGINE_STATUS_IDLING          = 1;
integer  ENGINE_STATUS_ROLLING         = 2;

//  Name the Engineer's display prim ENGINEERDISPLAY_PRIM_NAME
string   ENGINEERDISPLAY_PRIM_NAME     = "EngineerDisplay";

string   gsLocomotiveNameTag           = "";
integer  giLocomotiveFeatureSet        = 0;
integer  giLocomotiveFeatureAdjust     = 0;
vector   gvUnitToGuideOffset           = ZERO_VECTOR;
vector   gvSitOffset                   = ZERO_VECTOR;
rotation grSitOrientation              = ZERO_ROTATION;
integer  giEngineStatus                = 0;
integer  giNoHitsCount                 = 0;

// Default for SLRR ROW
string   gsSensorTargetName            = "Guide";

float    gfSensorSeekRange             = 20.00;
float    gfSensorScanArc               = 0;
integer  giTravelDirection             = 0;
integer  giFlipRequest                 = 0;
vector   gvWaypointPrior               = ZERO_VECTOR;

float    gfSpeedPrior                  = 0.00;
float    gfSpeedCurrent                = 0.00;
float    gfSpeedMinimum                = 0.00;
float    gfSpeedMaximum                = 0.00;
float    gfSpeedIncrement              = 0.00;

integer  giStatusPhysical              = TRUE;
integer  giFlagPhantom                 = TRUE;
string   gsStatusDisplayPrior          = "";

integer  giRerailRequest               = TRUE;

string   gsDisplayPrimName             = "EngineerDisplay";
integer  giDisplayPrimLink             = -32768;

integer  giLinkCountRiderless          = 0;
integer  giLinkCountPrior              = 0;
integer  giLinkCountCurrent            = 0;
integer  giLinkGained                  = FALSE;
string   gsRegionCurrentName;
vector   gvRegionCurrentCorner;
integer  giSmokeEnabled                = TRUE;
integer  giSmokeOn                     = TRUE;
integer  giDialogChannel               = PUBLIC_CHANNEL;
key      gkOwnerID                     = NULL_KEY;
key      gkOperatorID                  = NULL_KEY;
key      gkPassengerID                 = NULL_KEY;
integer  giOperatorSeated              = FALSE;
integer  giCameraDynamics              = FALSE;

//  Table of all agents seated
list     glRidersAboard                =[];

//  Default Buttonset in all menu versions.  At initialization time
//  build-specific feature buttons may be added as indiczted by
//  giFeatureSet
list     glMenuOperatorDefault         = [
    "HELP",
    "FASTER", "SLOWER", "FLIP",
    "START", "IDLE", "STOP"
        ];

list     glMenuOperator                = [];


//  These are activated if set in Operator Preference section
list glCameraParameters = [
    CAMERA_ACTIVE,              TRUE,

    CAMERA_BEHINDNESS_ANGLE,    0.00,
    CAMERA_BEHINDNESS_LAG,      0.50,
    CAMERA_DISTANCE,            7.00,
    CAMERA_PITCH,              15.00,

    // CAMERA_FOCUS,
    CAMERA_FOCUS_LAG,           0.50,
    CAMERA_FOCUS_LOCKED,        FALSE,
    CAMERA_FOCUS_THRESHOLD,     0.00,

    // CAMERA_POSITION,
    CAMERA_POSITION_LAG,        0.50,
    CAMERA_POSITION_LOCKED,     FALSE,
    CAMERA_POSITION_THRESHOLD,  0.05,

    CAMERA_FOCUS_OFFSET,        <0.00, 0.00, 1.00>
        ];


//===================================================================//
//====  Locomotive-Specific Routines  ==  <START>  ==================//

list LocomotiveMenuCreateFromFeatureset(integer iFeatureSet)
{
    list lMenu = [];

    //    llOwnerSay("$00F0: FeatureSet=" + Int2Hex(iFeatureSet, 8));

    if (iFeatureSet & FEATURE_CONTROL_SMOKE)
    {
        lMenu = BTN_SMOKE + lMenu;
    }

    if (iFeatureSet & FEATURE_ALERT_BELL)
    {
        lMenu = BTN_BELL + lMenu;
    }

    if (iFeatureSet & FEATURE_ALERT_HORN)
    {
        lMenu = BTN_HORN + lMenu;
    }

    //  Temporary fix to accomodate an exception.  Later
    //  version will provide more flexible menu construction
    else
    {
        lMenu = BTN_BLANK + lMenu;
    }

    if (iFeatureSet & FEATURE_ALERT_WHISTLE)
    {
        lMenu = BTN_WHISTLE + lMenu;
    }

    if (iFeatureSet & FEATURE_LIGHTS_HEADLAMPS)
    {
        lMenu = BTN_HEADLAMP + lMenu;
    }

    if (~llGetListLength(glMenuOperator)) lMenu = lMenu + glMenuOperator;
    //    llOwnerSay("Menu=" + llList2CSV(lMenu));

    return(lMenu);
} // LocomotiveMenuCreateFromFeatureset


LocomotiveBuildConfigure()
{
    integer iBuild;
    integer iBuildItems = llGetListLength(glUnitConfiguration);
    integer iBuildIndex = INDEX_INVALID;
    string  sBuildTag;
    string  sBuildName = llGetObjectName();

    // Set to a default feature set, from which a single feature may later be removed
    integer giLocomotiveFeatureSet = FEATURE_SOUND_ENGINE |
        FEATURE_SOUND_WHEELS | FEATURE_SOUND_STEAM | FEATURE_ALERT_BELL |
        FEATURE_ALERT_WHISTLE | FEATURE_ALERT_HORN |
        FEATURE_LIGHTS_HEADLAMPS | FEATURE_LIGHTS_TAILLAMPS |
        FEATURE_CONTROL_SMOKE | FEATURE_MOTION_PHYSICAL;
//        FEATURE_CONTROL_SMOKE | FEATURE_MOTION_NONPHYSICAL;

    for (iBuild = 0; iBuild < iBuildItems; iBuild = iBuild +
        UNIT_BUILD_TABLE_STRIDE)
        {
            sBuildTag = llList2String(glUnitConfiguration, iBuild +
                UNIT_BUILD_TAG_IDX);

            if (llSubStringIndex(sBuildName, sBuildTag) == 0)
            {
                iBuildIndex = iBuild;
                gsLocomotiveNameTag = sBuildTag;
            }

        } // for all builds in table


    if (iBuildIndex == INDEX_INVALID)
    {
        iBuildIndex = 0;
    }

    gvUnitToGuideOffset = llList2Vector(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_GUIDE_OFFSET_IDX);
    gvSitOffset = llList2Vector(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_SIT_OFFSET_IDX);
    grSitOrientation = llList2Rot(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_SIT_ROTATION_IDX);
    gfSpeedMinimum = llList2Float(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_SPEED_MINIMUM_IDX);
    gfSpeedIncrement = llList2Float(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_SPEED_INCREMENT_IDX);
    gfSpeedMaximum = llList2Float(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_SPEED_MAXIMUM_IDX);
    giLocomotiveFeatureAdjust = llList2Integer(glUnitConfiguration,
        iBuildIndex + UNIT_BUILD_FEATURE_ADJUST_IDX);
/*
    llOwnerSay("$0100: Buildname=" + sBuildName +
        "  Build=" + (string)iBuildIndex +
        ":" + gsLocomotiveNameTag +
        "  FeatureSet=" + Int2Hex(giLocomotiveFeatureSet, 8) +
        "  FeatureAdjust=" + Int2Hex(giLocomotiveFeatureAdjust, 8) +
        "  AdjustedFeatureSet=" + Int2Hex(giLocomotiveFeatureSet &
            (~giLocomotiveFeatureAdjust), 8));
*/
    //  Adjust the default featureset by removing any single
    //  unwanted feature.  Need greater flexibilty here.
    giLocomotiveFeatureSet = giLocomotiveFeatureSet &
        (~giLocomotiveFeatureAdjust);
    glMenuOperator = LocomotiveMenuCreateFromFeatureset(
        giLocomotiveFeatureSet);

    //            llOwnerSay("$0110: CONFIG=" + (string)gvUnitToGuideOffset + ", " +
    //                (string)gvSitOffset + ", " + (string)grSitOrientation +
    //                ", " + (string)gfSpeedMinimum + ", " +
    //                (string)gfSpeedMaximum + ", " + (string)gfSpeedIncrement);

} // LocomotiveBuildConfigure


string LocomotiveHelpBuild()
{
    string   sHelpString               = "";

    sHelpString += "\n                    Page Up = Stopped:  Idle->Running->Faster";
    sHelpString += "\n               Page Down =  Running:  Slower->Idle->Stop";
    sHelpString += "\n  Shift + Right Arrow = Instant Idle/Resume";
    //    sHelpString += "\nDown Arrow  = Reverse";
    sHelpString += "\n    Shift + Left Arrow = Flip train around";
    return(sHelpString);
} // LocomotiveHelpBuild


LocomotiveDisplaySet(string str, vector color)
{

    if (gsStatusDisplayPrior != str)
    {
        gsStatusDisplayPrior = str;
        llSetLinkPrimitiveParamsFast(giDisplayPrimLink, [
            PRIM_TEXT, gsStatusDisplayPrior, color, 1.0]);
    }

} // LocomotiveDisplaySet


LocomotiveDisplayUpdate()
{
    vector color = <0.5, 1.0, 0.5>;
    string str = "Speed: " + clip(gfSpeedCurrent*1000) + "\n";

    if (giEngineStatus == ENGINE_STATUS_ROLLING)
    {
        str += "\nRunning";
    }
    else if (giEngineStatus == ENGINE_STATUS_IDLING)
    {
        str += "\nIdling";
    }
    else
    {
        str = llGetObjectName() + "\n\n";
        str += "\nStopped";
        color = <0.5, 0.5, 1.0>;
    }

    if (llGetStatus(STATUS_PHANTOM))
    {
        str += "\nPhantom";
    }
    else
    {
        str += "\nNOT Phantom!!";
    }

    str += "\nFollowing '" + gsSensorTargetName + "'";

    if (giLinkCountCurrent != giLinkCountRiderless)
    {
        str += "\n \n \n" + ENGINEER_MENU_INSTRUCTION;
    }

    LocomotiveDisplaySet(str, color);
} // LocomotiveDisplayUpdate


integer LocomotiveRiderAboard(key gkRiderID)
{
    return(NamedLinkFind(llKey2Name(gkRiderID)) != LINK_INVALID);
} // LocomotiveRiderAboard


LocomotivePassengerRejection(key kAgentID, integer iSitAllow)
{

    if (iSitAllow)
    {
        llInstantMessage(kAgentID, "\nSorry, " + llKey2Name(kAgentID) +
            ", only the Owner may operate this locomotive.");
    }
    else
    {
        llInstantMessage(kAgentID, "\nSorry, " + llKey2Name(kAgentID) +
            ", only the Owner may operate this locomotive." +
            "\nAnd the engineer needs to climb aboard first");
        llUnSit(kAgentID);
    }

} // LocomotivePassengerRejection


LocomotiveMoveTo(vector vWaypointNext, rotation rAttitudeNext)
{

    if (llGetStatus(STATUS_PHYSICS))
    {
        llRotLookAt(rAttitudeNext, 1 / llVecMag(llGetVel()), 1);
        llMoveToTarget( vWaypointNext, 1.0);
    }
    else
    {
        llSetLinkPrimitiveParamsFast(LINK_ROOT,
            [PRIM_POSITION, vWaypointNext,
            PRIM_ROTATION, rAttitudeNext]);
    }

} // LocomotiveMoveTo

// Opensim sim-crossing compatibility
LocomotiveMoveToSlow(vector vWaypointNext, rotation rAttitudeNext)
{
    if (llGetStatus(STATUS_PHYSICS)) {
        llRotLookAt(rAttitudeNext, 1 / llVecMag(llGetVel()), 1);
        llMoveToTarget( vWaypointNext, 1.0);
    } else {
        llSetPos(vWaypointNext);
        llSetRot(rAttitudeNext);
    }
}

LocomotiveFlip()
{
    giStatusPhysical = llGetStatus(STATUS_PHYSICS);

    if (giStatusPhysical)
    {
        llSetStatus(STATUS_PHYSICS,FALSE);
    }

    LocomotiveDisplaySet("reverse", <1.0, 0.5, 0.5>);
    giFlipRequest = FALSE;
//    llSetRot(ROTATION_FLIP * llGetRot() );
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_ROTATION, (ROTATION_FLIP*llGetRot()) ]);
    giTravelDirection = (giTravelDirection + 1) % 2;

    if (giEngineStatus == ENGINE_STATUS_ROLLING)
    {
        llSleep(0.5);
        llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
            gfSensorSeekRange, gfSensorScanArc);
    }

    if (giStatusPhysical)
    {
        llSetStatus(STATUS_PHYSICS,TRUE);
    }

} // LocomotiveFlip


float LocomotiveSpeedUpdate(float fSpeedDelta)
{
    //    llOwnerSay("SD=" + (string)fSpeedDelta);

    if (fSpeedDelta > 0.00)
    {

        if ( (gfSpeedCurrent + fSpeedDelta) <= gfSpeedMaximum)
        {
            gfSpeedCurrent += fSpeedDelta;
        }

    }

    else
    {

        if ( (gfSpeedCurrent + fSpeedDelta) > 0)
        {
            gfSpeedCurrent += fSpeedDelta;
        }

    }

    return(gfSpeedCurrent);
} // LocomotiveSpeedUpdate



LocomotiveSpeedUp()
{

    if (giEngineStatus == ENGINE_STATUS_OFF)
    {
        LocomotiveIdle();
    }
    else if (giEngineStatus == ENGINE_STATUS_IDLING)
    {
        LocomotiveRun(gfSpeedMinimum);
    }
    else if (giEngineStatus == ENGINE_STATUS_ROLLING)
    {
        LocomotiveSpeedUpdate(gfSpeedIncrement);
    }

} // LocomotiveSpeedUp


LocomotiveSlowDown()
{

    if (giEngineStatus == ENGINE_STATUS_ROLLING)
    {

        if (gfSpeedCurrent > gfSpeedMinimum)
        {
            LocomotiveSpeedUpdate(-gfSpeedIncrement);
        }
        else
        {
            LocomotiveIdle();
        }

    }
    else if (giEngineStatus == ENGINE_STATUS_IDLING)
    {
        LocomotiveStop();
    }

} // LocomotiveSlowDown


LocomotiveIdle()
{
    llMessageLinked(LINK_SET, 99, "idle", (key)NAME_WILDCARD);
    giSmokeOn = LocomotiveSmoke(SMOKE_IDLE);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION,llGetPos()+<-0.01,0.0,0.0>]);
    giEngineStatus = ENGINE_STATUS_IDLING;
    gfSpeedPrior = gfSpeedCurrent;
    gfSpeedCurrent = 0.00;
//    llVolumeDetect(TRUE);
    giFlagPhantom = TRUE;
} // LocomotiveIdle


LocomotiveRun(float fSpeedStartup)
{
    llMessageLinked(LINK_SET, 99, "run", (key)NAME_WILDCARD);
    giSmokeOn = LocomotiveSmoke(SMOKE_RUN);
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_POSITION,llGetPos()+<-0.01,0.0,0.0>]);
    llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
        gfSensorSeekRange, gfSensorScanArc);
    giEngineStatus = ENGINE_STATUS_ROLLING;
    gfSpeedCurrent = fSpeedStartup;
//    llVolumeDetect(TRUE);
    giFlagPhantom = TRUE;
} // LocomotiveRun


LocomotiveStop()
{
    gfSpeedCurrent = 0.00;
    llMessageLinked(LINK_SET, -1, "reset", (key)NAME_WILDCARD);
    giSmokeOn = LocomotiveSmoke(SMOKE_OFF);
    giStatusPhysical = llGetStatus(STATUS_PHYSICS);
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSensorRemove();
    giEngineStatus = ENGINE_STATUS_OFF;
    giFlagPhantom = FALSE;
//    llVolumeDetect(FALSE);
    llSetStatus(STATUS_PHANTOM, TRUE);
} // LocomotiveStop


integer LocomotiveSmoke(integer iSmokeLevel)
{
    integer iSmokeNew = TRUE;

    if (giSmokeEnabled)
    {
        llMessageLinked(LINK_ALL_CHILDREN, iSmokeLevel,
            SMOKE_PRIM_NAME, NULL_KEY);
    }
    else
    {
        llMessageLinked(LINK_ALL_CHILDREN, SMOKE_OFF,
            SMOKE_PRIM_NAME, NULL_KEY);
    }

    if (iSmokeLevel == SMOKE_OFF)
    {
        iSmokeNew = FALSE;
    }

    return(iSmokeNew);
} // LocomotiveSmoke

//====  Locomotive-Specific Routines  ==  <END>  ====================//


ScriptInitialize()
{
    ROTATION_FLIP = llEuler2Rot(<0.00, 0.00, 180.00> * DEG_TO_RAD);

    integer iLinkCount = llGetNumberOfPrims();

    // TO clear any existing sit targets, uncomment the code below:
    //
    //            integer iIndex;
    //            for (iIndex = 0; iIndex > iLinkCount; iIndex++)
    //            {
    //                llSetText(".", COLOR_BLACK, 0.00);
    //                llSitTarget(ZERO_VECTOR, ZERO_ROTATION);
    //            }

    UnsitAllAgents();
    llSetClickAction(CLICK_ACTION_SIT);
    giLinkCountRiderless = PrimCount();
    giLinkCountCurrent = llGetNumberOfPrims();
    giLinkCountPrior = giLinkCountCurrent;
    gsRegionCurrentName = llGetRegionName();
    gvRegionCurrentCorner = llGetRegionCorner();
    gfSensorScanArc = SENSOR_SEEK_ARC_DEFAULT * DEG_TO_RAD;
    gkOwnerID = llGetOwner();
    llMessageLinked(LINK_SET, -1, "reset", (key)NAME_WILDCARD);
    llSetBuoyancy(1.0);
    llStopMoveToTarget();
    llStopLookAt();
    llSetText(" ",<1.00, 1.00, 1.00>, 1.00);

    llSetStatus(STATUS_PHANTOM,TRUE);
    giDisplayPrimLink = NamedLinkFind(gsDisplayPrimName);
    //  llOwnerSay("Display=" + (string)giDisplayPrimLink + "  " +
    //  llGetLinkName(giDisplayPrimLink));
    LocomotiveDisplaySet("-----", <0.50, 0.50, 1.00>);

    llSetObjectDesc("");

    // For development and testing
    //    llSetObjectName(SET TO BUILD NAME TO TEST AGAINST);

    glMenuOperator = glMenuOperatorDefault;
    LocomotiveBuildConfigure();
    llSetObjectName(gsLocomotiveNameTag + VERSION_PREFIX_TAG +
        gsScriptVersion);
    llSetSitText(SIT_TEXT_OPERATOR);
    llSitTarget(gvSitOffset, grSitOrientation);
    llSetCameraAtOffset(<3.00, 0.00, 1.50>);
    llSetCameraEyeOffset(<-8.00, 0.00, 5.00>);
    LocomotiveDisplayUpdate();

    key agent = llAvatarOnSitTarget();

    if (agent != NULL_KEY)
    {
        llRequestPermissions(agent, PERMISSION_TAKE_CONTROLS);
//        llVolumeDetect(TRUE);
    }

} // ScriptInitialize



default
{

    state_entry()
    {

        if (gkOperatorID == NULL_KEY)
        {
            ScriptInitialize();
        }

        if (giRerailRequest)
        {
            state Rerail;
        }

        giDialogChannel = -llGetUnixTime();
        llListen(giDialogChannel, "", "", "");
        giSmokeOn = LocomotiveSmoke(SMOKE_OFF);
        LocomotiveDisplayUpdate();
    } // state_entry


    //  Only recognizes first Toucher
    touch_start(integer iTouching)
    {

        if (giLinkCountCurrent > giLinkCountRiderless)
        {

            if (llDetectedKey(0) == gkOperatorID)
            {
                string sPrompt = "\nSmoke ";

                if (giSmokeEnabled)
                {
                    sPrompt += "ENABLED";
                }
                else
                {
                    sPrompt += "DISABLED";
                }

                sPrompt += "\n\nOperate locomotive";
                llDialog(gkOperatorID, sPrompt,
                    glMenuOperator, giDialogChannel);
            }
//            else
//            {
//                LocomotivePassengerRejection(llDetectedKey(0),
//                    SIT_ALLOW);
//            }

        }

    } // touch_start


    changed(integer iChanged)
    {

        if (iChanged & CHANGED_REGION)
        {
            gsRegionCurrentName = llGetRegionName();
            gvRegionCurrentCorner = llGetRegionCorner();
            LocomotiveRun(gfSpeedCurrent);
            LocomotiveDisplayUpdate();
        }

        if (iChanged & CHANGED_LINK)
        {
            key kRiderID = NULL_KEY;

            giLinkCountCurrent = llGetNumberOfPrims();

            //  Gained a link
            if (giLinkCountCurrent > giLinkCountPrior)
            {
                giLinkGained = TRUE;
                giLinkCountPrior = giLinkCountCurrent;
                kRiderID = llGetLinkKey(giLinkCountCurrent);
                glRidersAboard = glRidersAboard + (list)kRiderID;

                //  If driver needed.
                if (gkOperatorID == NULL_KEY)
                {

                    // owner only can ride
                    if (kRiderID == gkOwnerID)
                    {
                        // seat as driver
                        gkOperatorID = kRiderID;
                        llSetSitText(SIT_TEXT_PASSENGER);
                        llSetClickAction(CLICK_ACTION_TOUCH);
                        llVolumeDetect(TRUE);
                        llRequestPermissions(gkOperatorID,
                            PERMISSION_TRIGGER_ANIMATION |
                            PERMISSION_TAKE_CONTROLS |
                            PERMISSION_CONTROL_CAMERA);
                    }
                    else
                    {
                        LocomotivePassengerRejection(kRiderID,
                            SIT_DENY);
                    }
                }

                // else seat as passenger
                else
                {
                    gkPassengerID = llGetLinkKey(giLinkCountCurrent);
                    // seat passenger at the right spot
                    llSetLinkPrimitiveParamsFast(giLinkCountCurrent, [ PRIM_POS_LOCAL, gvSitOffset+<.5,1,0.4>, PRIM_ROT_LOCAL, grSitOrientation ]);
//                    llSetCameraAtOffset(<3.00, 0.00, 1.50>);
//                    llSetCameraEyeOffset(<-8.00, 0.00, 5.00>);
                    llSetSitText(SIT_TEXT_OPERATOR);
                    llInstantMessage(gkPassengerID, "\nWelcome aboard, " +
                        llKey2Name(gkPassengerID) + "!" +
                        "\nYou can get your own train at:" +
                        "\n (todo: put hg address here)");
                }

            } // gained a link

            // Lost a link
            else
            {
                giLinkGained = FALSE;
                giLinkCountPrior = giLinkCountCurrent;

                //  Scan the rider roll to see who is no longer linked
                kRiderID = ScanForAgentGone();
                integer iRider = llListFindList(glRidersAboard,
                    (list)kRiderID);

                if (iRider != INDEX_INVALID)
                {
                    glRidersAboard = llDeleteSubList(glRidersAboard,
                        iRider, iRider);
                }

                // Engineer unsat
                if (kRiderID == gkOperatorID)
                {
                    giOperatorSeated = FALSE;
                    gkOperatorID = NULL_KEY;
                    llStopAnimation("sit");

                    if (llGetPermissions() & PERMISSION_TAKE_CONTROLS)
                    {
                        llReleaseControls();
                    }

                    if ( (giCameraDynamics) &&
                        (llGetPermissions() & PERMISSION_CONTROL_CAMERA) )
                        {
                            llClearCameraParams();
                        }

                    // Just leaving this commented here, as a warning.
                    // The following triggers a crash of the avatar after unseating:
                    llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, 0));

                    llSetClickAction(CLICK_ACTION_SIT);
                    llSetSitText(SIT_TEXT_OPERATOR);
                    llSitTarget(gvSitOffset, grSitOrientation);
                    // set camera for when engineer reseats
                    llSetCameraAtOffset(<3.00, 0.00, 1.50>);
                    llSetCameraEyeOffset(<-8.00, 0.00, 5.00>);            
                } // Driver dismounted

                // Passenger dismounted
                else
                {

                    if (gkOperatorID == NULL_KEY)
                    {
                        llSetSitText(SIT_TEXT_OPERATOR);
                    }
                    else
                    {
                        llSetSitText(SIT_TEXT_PASSENGER);
                    }

                    gkPassengerID = NULL_KEY;
                } // Passenger dismounted


            } // lost a link

            //  llOwnerSay("$1890: Riderless=" +
            //      (string)giLinkCountRiderless +
            //      " Prior=" + (string)giLinkCountPrior +
            //      " Current=" + (string)giLinkCountCurrent);

            //  Force any count errors our way
            if (giLinkCountCurrent < giLinkCountRiderless)
            {
                giLinkCountCurrent = giLinkCountRiderless;
            }

            // If no-one aboard, stop locomotive
            if ( ((giEngineStatus == ENGINE_STATUS_ROLLING) ||
                (giEngineStatus == ENGINE_STATUS_IDLING)) &&
                    (giLinkCountCurrent == giLinkCountRiderless))
                    {
                        LocomotiveStop();
                        llSetSitText(SIT_TEXT_OPERATOR);
                        llSetClickAction(CLICK_ACTION_SIT);
                    }

            LocomotiveDisplayUpdate();
        } // CHANGED_LINK

    } // changed


    run_time_permissions(integer iPermissions)
    {

        if (iPermissions & PERMISSION_TAKE_CONTROLS)
        {
            // llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD |
            //      CONTROL_BACK | CONTROL_LEFT | CONTROL_RIGHT,
            //       TRUE, FALSE);
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_LEFT |
                CONTROL_RIGHT, TRUE, FALSE);
            llInstantMessage(llAvatarOnSitTarget(),
                "\n" + llKey2Name(llAvatarOnSitTarget()) +
                ", " + ENGINEER_MENU_INSTRUCTION +
                LocomotiveHelpBuild());
        }

        if ( (iPermissions & PERMISSION_TRIGGER_ANIMATION) &&
            (gkOperatorID != NULL_KEY) )
            {
                llStopAnimation("sit");
                llStartAnimation(llGetInventoryName(
                    INVENTORY_ANIMATION, 0));
                llSetClickAction(CLICK_ACTION_TOUCH);
            }

        if ( (giCameraDynamics) &&
            (iPermissions & PERMISSION_CONTROL_CAMERA) )
            {
                llSetCameraParams(glCameraParameters);
            }

    } // run_time_permissions


    control(key kID, integer level, integer edge)
    {

        if (edge & level & CONTROL_UP)
        {
            LocomotiveSpeedUp();
        } // CONTROL_UP


        //        if (edge & level & CONTROL_BACK)
        //        {
        //  Reserved for reverse/forward (as opposed to Flip
        //        }


        if (edge & level & CONTROL_DOWN)
        {
            LocomotiveSlowDown();
        } // CONTROL_DOWN


        if (edge & level & CONTROL_LEFT)
        {

            if (giEngineStatus == ENGINE_STATUS_ROLLING)
            {
                giFlipRequest=TRUE;
            }
            else
            {
                LocomotiveFlip();
            }

        } // CONTROL_LEFT


        if (edge & level & CONTROL_RIGHT)
        {

            if (giEngineStatus == ENGINE_STATUS_ROLLING)
            {
                LocomotiveIdle();
            }

            else if (giEngineStatus == ENGINE_STATUS_IDLING)
            {
                LocomotiveRun(gfSpeedPrior);
            }

        } // CONTROL_ROT_RIGHT

        LocomotiveDisplayUpdate();
    } // control


    listen(integer iChannel, string sName, key kID, string sMessage)
    {

        if ((sMessage == "Stop") &&
            ((giEngineStatus == ENGINE_STATUS_IDLING) ||
            giEngineStatus == ENGINE_STATUS_ROLLING) )
            {
                LocomotiveStop();
            } // Stop


        else if ( (sMessage == "Idle") &&
            ((giEngineStatus == ENGINE_STATUS_OFF) ||
            (giEngineStatus == ENGINE_STATUS_ROLLING)) )
            {
                LocomotiveIdle();
            } // Idle


        else if ((sMessage == "Start") && (giEngineStatus !=
            ENGINE_STATUS_ROLLING))
            {
                LocomotiveRun(gfSpeedMinimum);
            } // Start


        else if (sMessage == "Flip")
        {

            if (giEngineStatus == ENGINE_STATUS_ROLLING)
            {
                giFlipRequest = TRUE;
            }
            else
            {
                LocomotiveFlip();
            }

        } // Flip


        else if (sMessage == "Rerail")
        {
            state Rerail;
        } // Rerail


        else if (sMessage == "Faster")
        {
            LocomotiveSpeedUp();
        } // Faster


        else if (sMessage == "Slower")
        {
            LocomotiveSlowDown();
        } // Slower

        else if (sMessage == "Smoke")
        {
            giSmokeEnabled = !giSmokeEnabled;
            giSmokeOn = LocomotiveSmoke(giEngineStatus);
        } // Smoke

        else if (sMessage == "Notecard")
        {
            llWhisper(PUBLIC_CHANNEL, "No Notecard available yet");
        } // Notecard

        else if (sMessage == "Help")
        {
            llOwnerSay(LocomotiveHelpBuild());
        } // Help

        else if ( (sMessage == "Bell") || (sMessage == "Horn")  ||
            (sMessage == "Whistle") || (sMessage == "Headlamp") )
            {
                llMessageLinked(LINK_SET, 0, sMessage, sMessage);
            } // Bell | Horn | Whistle

        giStatusPhysical = llGetStatus(STATUS_PHYSICS);
        LocomotiveDisplayUpdate();
    } // listen


    sensor(integer iSensed)
    {

        if (giEngineStatus == ENGINE_STATUS_ROLLING)
        {
            integer index = 0;
            giNoHitsCount = 0;

            if (giFlipRequest)
            {
                LocomotiveFlip();
                return;
            }

            if (llGetPos() == llDetectedPos(0) + gvUnitToGuideOffset)
            {

                if (iSensed > 1)
                {
                    index++;
                }
                else
                {
                    vector next = llGetPos() + <15.00, 0.00, 0.00> *
                        llGetRot();

                    if (next.x < 1.00 || next.x > 255.00
                        || next.y < 1.00 || next.y > 255.00)
                    {
                        LocomotiveDisplaySet("sim crossing 1",
                            <0.50, 0.50, 1.00>);
                        LocomotiveMoveTo(llGetPos() +
                            <2.00, 0.00, 0.00> * llGetRot(),
                            llGetRot());
                    }
                    else
                    {
                        LocomotiveFlip();
                        LocomotiveDisplayUpdate();
                        return;
                    }

                    LocomotiveDisplayUpdate();
                    llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
                        gfSensorSeekRange, gfSensorScanArc);
                    return;
                }
            }

            rotation rHeadingNext = llDetectedRot(0);

            //  Reverse Target Heading if travelling opposite to Guide
            //  X-axis polarity
            if (giTravelDirection)
            {
                rHeadingNext = ROTATION_FLIP * rHeadingNext;
            }

            //  If angle between unit and next Guide greater than acceptable
            //  flip Target Heading 180 degrees
            if (llFabs(llAngleBetween(rHeadingNext, llGetRot())) > PI_BY_TWO)
            {
                rHeadingNext = ROTATION_FLIP * rHeadingNext;
            }


            vector vPositionCurrent = llGetPos();
            vector vWaypointNext = llDetectedPos(index) + gvUnitToGuideOffset;

            if (llVecDist(vPositionCurrent, gvWaypointPrior) <
                llVecDist(vPositionCurrent, vWaypointNext))
                {
                    rHeadingNext = llGetRot();
                }
            else
            {
                gvWaypointPrior = vWaypointNext;
            }

            vector vPositionNext = vPositionCurrent + (llVecNorm(vWaypointNext -
                vPositionCurrent) * gfSpeedCurrent);
            LocomotiveMoveTo(vPositionNext, rHeadingNext);
            LocomotiveDisplayUpdate();

            llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
                gfSensorSeekRange, gfSensorScanArc);
        } // if running

    } // sensor


    no_sensor()
    {

        if (++giNoHitsCount > 4)
        {
            llResetScript();
        }
        else
        {
            gsRegionCurrentName = llGetRegionName();
            LocomotiveDisplayUpdate();
            vector vPositionNext = llGetPos() + <15.00, 0.00, 0.00> *
                llGetRot();

            if (vPositionNext.x < 1.00 || vPositionNext.x > 255.00
                || vPositionNext.y < 1.00 || vPositionNext.y > 255.00)
            {
                LocomotiveDisplaySet("sim crossing 2",
                    <0.50, 0.50, 1.00>);
                LocomotiveMoveToSlow(llGetPos() + <5.00, 0.00, 0.00> *
                    llGetRot(),
                    llGetRot());
            }
            else
            {
                LocomotiveFlip();
                LocomotiveDisplayUpdate();
                return;
            }

            LocomotiveDisplayUpdate();

            // Second Life:
            
            //  Give llSensor a rest
            //llSleep(1.00);

            //llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
            //    gfSensorSeekRange, gfSensorScanArc);

            // XEngine in OpenSim doesn't like llSleep so we use
            // a timer and do the llSensor there instead:
            
            llSetTimerEvent(1.0);

        } // if still seeking Guide

    } // no_sensor

    timer()
    {
        llSetTimerEvent(0);
        llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
            gfSensorSeekRange, gfSensorScanArc);
    }

    on_rez(integer iRezParameter)
    {
        llResetScript();
    } // on_rez


} // state default



state Rerail
{

    state_entry()
    {
        LocomotiveDisplayUpdate();
        giRerailRequest = FALSE;

        //  Note full-sphere sensor scan angle when seeking ROW
        llSensor(gsSensorTargetName, "", ACTIVE | PASSIVE,
            gfSensorSeekRange, PI);
        gfSensorSeekRange = SENSOR_SEEK_RANGE_DEFAULT;
    } // state_entry


    sensor(integer iSensed)
    {
        //  In theory, the first hit reported will always be the
        //  closest scan target detected
        LocomotiveMoveTo(llDetectedPos(0) + gvUnitToGuideOffset,
            llDetectedRot(0));
        state default;
    } // sensor


    no_sensor()
    {
        llOwnerSay("Scan target '" + gsSensorTargetName +
            "' not within " +
            (string)llRound(gfSensorSeekRange) + "m");
        state default;
    } // no_sensor

} // state Rerail

//====  Locomotive-Specific Values & Code  =============  <END>  ====//
//===================================================================//


// [VRCLocomotiveOpensourceScript]