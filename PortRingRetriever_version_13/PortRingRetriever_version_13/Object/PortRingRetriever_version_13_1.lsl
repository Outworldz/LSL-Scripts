// :CATEGORY:Teleport
// :NAME:PortRingRetriever_version_13
// :AUTHOR:neo Rebus
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:640
// :NUM:869
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// PortRingRetriever version 1.3.lsl
// :CODE:

//  PortRingRetriever - Retrieve a set of PortRing objects from
//                      a dropped-in notecard.
//  version 1.3.0, 1 August 2004, by Neo Rebus
//
//  This script will retrieve the objects that make up a PortRing
//  structure.
//
//  See PortRingCreator for the details of the notecard.
//
//  General algorithm:
//
//      When a notecard is dropped in, parse the notecard into the
//      gxPortRingInfo and gxPortRingStations global lists.  When
//      finished, the first three entries should be strings containing
//      the names of the three Porter objects - back, forward, base,
//      respectively, followed by the spacing between 'porters in a
//      set, and then by vector, rotation pairs, the first for the base
//      location, the rest
//      for each station.
//
//      Delete the notecard.
//
//      Loop through the base and station locations, use a sensor to
//      find the different objects, and attach them to this object.
//
////////////////////////////////////////////////////////////////////////
//
//  REVISION HISTORY
//
//  version 1.3.0, 1 August 2004, by Neo Rebus
//      Added RINGSTYLE option for compatibility with PortRingCreator.
//  version 1.2.0, 25 July 2004, by Neo Rebus
//      Added OPTIONS line to notecard format.
//      Added BASEPORTERS option for compatibility with PortRingCreator.
//  version 1.0.1, 25 July 2004, by Neo Rebus
//      New version of f_TeleportTo, that only lifts up when necessary.
//  version 1.0.0, 24 July 2004, by Neo Rebus
//      First version.  Only works inside a single sim.
//
////////////////////////////////////////////////////////////////////////
//
//  A NOTE ABOUT VARIABLE NAMES
//
//  I use a form of "polish notation", where variable names are prefixed
//  by their scope and type.  The first letter of a variable name is its
//  scope:
//
//    p - parameter (a global that is set by the program maintainer and
//                   referenced but not changed by the program itself)
//    g - global
//    f - function
//    s - state     (a global that is only used in a particular state)
//    l - local
//    a - argument  (in the formal argument list for a function)
//
//  The second letter is the variable's type:
//
//    b - boolean   (an integer that holds TRUE or FALSE)
//    f - float
//    i - integer
//    r - rotation
//    s - string
//    v - vector
//    x - list      ('x' is used instead of 'l' to avoid llXYZ names)
//    _ - void      (only for functions)
//
//  The rest of the name is in MultipleCaps notation.
//
////////////////////////////////////////////////////////////////////////
//
//  CONSTANTS
//
//  cxHeadingToRotation
//      A list used to translate a heading to a rotation

list cxHeadingToRotation = [
    "E", <0.00000, 0.00000, 0.00000, 1.00000>,
    "ENE", <0.00000, 0.00000, 0.19509, 0.98079>,
    "NE", <0.00000, 0.00000, 0.38268, 0.92388>,
    "NNE", <0.00000, 0.00000, 0.55557, 0.83147>,
    "N", <0.00000, 0.00000, 0.70711, 0.70711>,
    "NNW", <0.00000, 0.00000, 0.83147, 0.55557>,
    "NW", <0.00000, 0.00000, 0.92388, 0.38268>,
    "WNW", <0.00000, 0.00000, 0.98079, 0.19509>,
    "W", <0.00000, 0.00000, 1.00000, -0.00000>,
    "WSW", <0.00000, 0.00000, 0.98078, -0.19509>,
    "SW", <0.00000, 0.00000, 0.92388, -0.38268>,
    "SSW", <0.00000, 0.00000, 0.83147, -0.55557>,
    "S", <0.00000, 0.00000, 0.70711, -0.70711>,
    "SSE", <0.00000, 0.00000, 0.55557, -0.83147>,
    "SE", <0.00000, 0.00000, 0.38268, -0.92388>,
    "ESE", <0.00000, 0.00000, 0.19509, -0.98078>
] ;

////////////////////////////////////////////////////////////////////////
//
//  PARAMETERS
//
//  (none)

////////////////////////////////////////////////////////////////////////
//
//  GLOBAL VARIABLES
//
//  gsNotecardName
//      The name of the notecard we're parsing.
//
//  giNotecardLine
//      The line number in the notecard we're parsing.
//
//  gxPortRingInfo
//      A list of:
//          string   porterBackName
//          string   porterForwardName
//          string   porterBaseName
//          float    porterSpacing
//
//  gxPortRingStations
//      A list of:
//          vector   baseLocation
//          rotation baseRotation
//          vector   stationLocation
//          rotation stationRotation
//          ...  add'l stations  ...
//
//  gxOptions
//      A list of:
//          string   optionName
//          string   optionValue
//          string   possibleValues
//      Initialized to the option names and default option values.
//      option names must be in all caps and start with a ",".
//      possibleValues is a CSV of the possible values.  If empty,
//      any value is allowed.
//
//  gxLocations
//      A refactored form of gxPortRingInfo and gxPortRingStations; this
//      is a list of:
//          string   porterName
//          vector   stationLocation
//          ...
//
//  giLocationIndex
//      Holds the current index into gxLocations as we're travelling around.
//
//  gvStartLocation
//      Where we want to return to when we're done.

string gsNotecardName ;

integer giNotecardLine ;

list gxPortRingInfo ;
list gxPortRingStations ;

list gxOptions = [
    ",BASEPORTERS", "FIRSTONLY", "FIRSTONLY,FIRSTANDLAST,ALL" ,
    ",RINGSTYLE", "LINEAR", "LINEAR,LOOP"
] ;

list gxLocations ;
integer giLocationIndex ;
vector gvStartLocation ;

////////////////////////////////////////////////////////////////////////
//
//  FUNCTIONS
//

////////////////////////////////////////////////////////////////////////
//
//  f_TeleportTo(vector avDestination)
//      teleport to avDestination, in the same sim as the object.
//
//      record PHANTOM status, and set PHANTOM to true.
//      Move UP to 250m, move to avDestination (at 250m), then move down
//      to a height above gronud equal to avDestination's Z value.

f_TeleportTo(vector avDestination)
{
    integer liOldPhantom = llGetStatus(STATUS_PHANTOM);
    llSetStatus(STATUS_PHANTOM, TRUE);

    vector lvTemp;
    vector lvDest;
    float  lfHeight;

    lvDest = avDestination;
    lvDest.z = 0;
    lvTemp = llGetPos();
    lfHeight = lvTemp.z;
    lvTemp.z = 0;

    while (llVecDist(lvTemp, lvDest) > 0.1)
    {
        vector lvDelta = lvDest - lvTemp;
        if (llVecMag(lvDelta) > 8)
        {
            lvDelta = llVecNorm(lvDelta) * 8;
        }
        if (llGround(lvDelta) > (lfHeight - 1.0))
        {
            lfHeight = llGround(lvDelta) + 1.0;
        } else {
            lvTemp += lvDelta ;
        }
        llSetPos( <lvTemp.x, lvTemp.y, lfHeight> );
    }

    lvDest = avDestination;
    lvDest.z += llGround(ZERO_VECTOR);

    while (llVecDist(llGetPos(), lvDest) > 0.1)
    {
        llSetPos(lvDest);
    }

    llSetStatus(STATUS_PHANTOM, liOldPhantom);
}

////////////////////////////////////////////////////////////////////////
//
//  Default state:
//
//  Immediately switch to state WaitingForNotecard.

default
{

    on_rez(integer liStartCode)
    {
        llResetScript();
    }

    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
    }

    run_time_permissions(integer aiPermissions)
    {
        if (aiPermissions & PERMISSION_CHANGE_LINKS)
        {
            state WaitingForNotecard ;
        } else {
            llSay(0, "Cannot run without PERMISSION_CHANGE_LINKS");
            llRequestPermissions(llGetOwner(), PERMISSION_CHANGE_LINKS);
        }
    }

}

////////////////////////////////////////////////////////////////////////
//
//  WaitingForNotecard state:
//
//  on changed(), if CHANGED_INVENTORY, check if we have a notecard.
//  if so, get the notecard name and switch to ParsingNotecard state.

state WaitingForNotecard
{
    on_rez(integer liStartCode)
    {
        llResetScript();
    }

    changed(integer aiWhat)
    {
        if (aiWhat == CHANGED_INVENTORY)
        {
            integer liNotecardCount = llGetInventoryNumber(INVENTORY_NOTECARD);
            if (liNotecardCount > 0)
            {
                gsNotecardName = llGetInventoryName(INVENTORY_NOTECARD, liNotecardCount - 1);
                state ParsingNotecard ;
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////
//
//  ParsingNotecard state:
//
//  On entry, read the next notecard line.
//  On exit, delete the notecard.
//
//  On dataserver, fetch the line.  If EOF, switch to state
//  CreatingPortRing.  If not blank or comment, parse the information
//  out and add it to the gxPortRingInfo list.

state ParsingNotecard
{
    on_rez(integer liStartCode)
    {
        llResetScript();
    }

    state_entry()
    {
        llWhisper(0, "Parsing notecard " + gsNotecardName);
        gxPortRingInfo = [ ] ;
        gxPortRingStations = [ ] ;
        llGetNotecardLine(gsNotecardName, 0);
        giNotecardLine = 1;
        llSetTimerEvent(10.0);
    }

    state_exit()
    {
        llSetTimerEvent(0.0);
        llRemoveInventory(gsNotecardName);
    }

    timer()
    {
        llWhisper(0, "Still parsing...");
    }

    dataserver(key akRequestID, string asLine)
    {
        string lsError = "";

        if (asLine == EOF)
        {
            state RetrievingPortRing;
        }

        if ((asLine != "") && (llGetSubString(asLine, 0, 1) != "//"))
        {
            list lxLineInfo = llCSV2List(asLine);
            string lsLineType = llList2String(lxLineInfo, 0);
            if ("PORTERS" == lsLineType)
            {
                if (llGetListLength(gxPortRingInfo) != 0)
                {
                    lsError = "Invalid notecard format - only one PORTERS line allowed";
                } else {
                    gxPortRingInfo += llList2List(lxLineInfo, 1, 3);
                    gxPortRingInfo += [ (float)llList2String(lxLineInfo, 4) ];
                }
            } else if ("OPTIONS" == lsLineType)
            {
                integer liNumOptions = llGetListLength(lxLineInfo) - 1;
                integer i;
                for (i = 1; i <= liNumOptions; i++)
                {
                    string lsOptionName = llList2String(lxLineInfo, i);
                    string lsOptionValue;
                    integer liIndex = llSubStringIndex(lsOptionName, "=");
                    if (liIndex > -1)
                    {
                        lsOptionValue = llGetSubString(lsOptionName, liIndex + 1, -1);
                        lsOptionName = llGetSubString(lsOptionName, 0, liIndex - 1);
                    } else {
                        lsOptionValue = "";
                    }
                    lsOptionName = llToUpper(lsOptionName);
                    lsOptionValue = llToUpper(lsOptionValue);
                    liIndex = llListFindList( gxOptions, [ "," + lsOptionName ] );
                    if (liIndex >= 0)
                    {
                        list lxAllowedValues = llCSV2List( llList2String(gxOptions, liIndex + 2) );
                        if ("" == lsOptionValue)
                        {
                            lsOptionValue = llList2String(lxAllowedValues, 0);
                        }
                        if ((llGetListLength(lxAllowedValues) == 0) || (llListFindList(lxAllowedValues, [lsOptionValue]) > -1))
                        {
                            gxOptions = llListInsertList( llDeleteSubList(gxOptions, liIndex + 1, liIndex + 1), [ lsOptionValue ], liIndex + 1);
                        } else {
                            lsError = "Invalid notecard format - invalid value " + lsOptionValue + " for option " + lsOptionName;
                        }
                    } else {
                        lsError = "Invalid notecard format - unknown option " + lsOptionName;
                    }
                }
            } else if ("BASE" == lsLineType)
            {
                if (llGetListLength(gxPortRingInfo) == 0)
                {
                    lsError = "Invalid notecard format - first entry must be PORTERS";
                } else if (llGetListLength(gxPortRingStations) != 0)
                {
                    lsError = "Invalid notecard format - only one BASE line allowed";
                } else {
                    vector lvPosition = (vector)(llList2String(lxLineInfo, 1));
                    string lsHeading = llList2String(lxLineInfo, 2);
                    integer liIdx = llListFindList(cxHeadingToRotation, [ lsHeading ]);
                    if (liIdx < 0)
                    {
                        lsError = "Invalid notecard format - unknown heading " + lsHeading;
                    } else {
                        gxPortRingStations += [
                            lvPosition,
                            llList2Rot(cxHeadingToRotation, liIdx + 1)
                        ] ;
                    }
                }
            } else if ("STATION" == lsLineType)
            {
                if (llGetListLength(gxPortRingInfo) == 0)
                {
                    lsError = "Invalid notecard format - first entry must be PORTERS";
                } else if (llGetListLength(gxPortRingStations) == 0)
                {
                    lsError = "Invalid notecard format - BASE must occur before STATION lines";
                } else {
                    vector lvPosition = (vector)(llList2String(lxLineInfo, 1));
                    string lsHeading = llList2String(lxLineInfo, 2);
                    integer liIdx = llListFindList(cxHeadingToRotation, [ lsHeading ]);
                    if (liIdx < 0)
                    {
                        lsError = "Invalid notecard format - unknown heading " + lsHeading;
                    } else {
                        gxPortRingStations += [
                            lvPosition,
                            llList2Rot(cxHeadingToRotation, liIdx + 1)
                        ] ;
                    }
                }
            } else {
                lsError = "Invalid notecard format - found unknown line type " + lsLineType;
            }
        }

        if (lsError != "")
        {
            llSay(0, "ERROR: " + lsError);
            llSay(0, (string)giNotecardLine + ": " + asLine);
            state WaitingForNotecard ;
        } else {
            llGetNotecardLine(gsNotecardName, giNotecardLine);
            giNotecardLine += 1;
        }
    }

}

////////////////////////////////////////////////////////////////////////
//
//  RetrievingPortRing state:
//

state RetrievingPortRing
{
    on_rez(integer liStartCode)
    {
        llResetScript();
    }

    state_entry()
    {
        llWhisper(0, "Retrieving PortRing...");

        llSetRot( <0,0.707,0,0.707> );

        integer i;
        integer liNumStations = (llGetListLength(gxPortRingStations) / 2) - 1;
        vector lvLocation;
        rotation lrRotation;
        string lsBackPorter;
        string lsForwardPorter;
        string lsBasePorter;

        lsBackPorter = llList2String(gxPortRingInfo, 0);
        lsForwardPorter = llList2String(gxPortRingInfo, 1);
        lsBasePorter = llList2String(gxPortRingInfo, 2);

        // then create stations
        for (i = 0; i <= liNumStations; i++)
        {
            lvLocation = llList2Vector(gxPortRingStations, i * 2);
            lrRotation = llList2Rot(gxPortRingStations, i * 2 + 1);

            gxLocations += [ lsBackPorter, lvLocation, lsForwardPorter, lvLocation, lsBasePorter, lvLocation ] ;
        }

        gvStartLocation = llGetPos() ;
        gvStartLocation.z = liNumStations + 2;
        giLocationIndex = 0;
        llSetTimerEvent(1.0);
    }

    timer()
    {
        llSetTimerEvent(0.0);

        if (giLocationIndex < llGetListLength(gxLocations))
        {
            float lfDist = (giLocationIndex/6) + 1;
            float lfSpacing = llList2Float(gxPortRingInfo, 3);
            f_TeleportTo(llList2Vector(gxLocations, giLocationIndex + 1) + <0,0,lfDist>);

            llSensor(
                llList2String(gxLocations, giLocationIndex),
                NULL_KEY,
                SCRIPTED|PASSIVE|ACTIVE|AGENT,
                llVecMag( <0, lfDist+lfSpacing, 2*lfSpacing> ),
                PI
            );
            giLocationIndex += 2;
        } else {
            f_TeleportTo(gvStartLocation);
        }
    }

    no_sensor()
    {
        llSetTimerEvent(1.0);
    }

    sensor(integer num)
    {
        integer i;
        for (i=0; i<num; i++)
        {
            llCreateLink(llDetectedKey(i), TRUE);
        }
        llSetTimerEvent(1.0);
    }

}
// END //
