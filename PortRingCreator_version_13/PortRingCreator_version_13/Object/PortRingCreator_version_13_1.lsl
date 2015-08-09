// :CATEGORY:Teleport
// :NAME:PortRingCreator_version_13
// :AUTHOR:neo Rebus
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:639
// :NUM:868
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// PortRingCreator version 1.3.lsl
// :CODE:

//  PortRingCreator - Create a PortRing from a set of Porter objects and
//                    a dropped-in notecard.
//  version 1.3.0, 1 August 2004, by Neo Rebus
//
//  COPYRIGHT 2004 BY NEO REBUS - SEE LICENSE AT END
//
//  This script will create a PortRing structure.  Currently, it must
//  all be within the same sim!
//
//  The object containing this script must also contain the three Porter
//  objects - one for Back, one for Next, and one for Base (obviously,
//  each must have a different name).
//
//  The owner can drop a notecard onto the object.  This script will
//  detect that, read the notecard, process it, delete it, then create
//  the porters.
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
//      Using the "CreatePorterSet" function, create the base 'porter
//      and the 'porters for each station.
//
//  The CreatePorterSet(list axPorters) algorithm:
//      axPorters is a strided list consisting of sets of:
//          [ "porterName", <destVector>, <destRotation>, "descriptiveName" ]
//
//      Teleport to the 'porter location plus 2m in Z direction, and
//      orient to the correct rotation.
//
//      Calculate the relative offset of the first 'porter: <spacing>
//      meters in the positive Y direction.
//
//      Loop through axPorters:
//          Rez the requested 'porter in its location and correct
//          orientation.  Send a message with the destVector and
//          destRotation in a CSV to the private channel given in
//          the start code.
//
////////////////////////////////////////////////////////////////////////
//
//  REVISION HISTORY
//
//  version 1.3.0, 1 August 2004, by Neo Rebus
//      Added in RINGSTYLE option, equal to LINEAR or LOOP; this
//      determines if the first and last stations should "wrap around"
//      to each other.
//  version 1.2.1, 1 August 2004, by Neo Rebus
//      Added a check for a vector of <0,0,0> to make sure that invalid
//      vectors don't pass the error checking.
//  version 1.2.0, 25 July 2004, by Neo Rebus
//      Added OPTIONS line to notecard format.
//      Added BASEPORTERS option to control what base 'porters get
//      created:  FIRSTONLY, FIRSTANDLAST, or ALL
//  version 1.1.0, 25 July 2004, by Neo Rebus
//      Allow station/base names in the control card; pass those on to
//      the PortRing Porter script to set the sit text.
//  version 1.0.1, 25 July 2004, by Neo Rebus
//      New version of f_TeleportTo, that only lifts up when necessary.
//  version 1.0.0, 24 July 2004, by Neo Rebus
//      First version.  Limited to a single sim.
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
//  piPrivateChannel
//      The first channel number to use for passing information to the
//  'porters.

integer piPrivateChannel = 1850896466 ;

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
//  gxPortRingStationNames
//      A list of:
//          string   stationName
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

string gsNotecardName ;

integer giNotecardLine ;

list gxPortRingInfo ;
list gxPortRingStations ;
list gxPortRingStationNames ;

list gxOptions = [
    ",BASEPORTERS", "FIRSTONLY", "FIRSTONLY,FIRSTANDLAST,ALL" ,
    ",RINGSTYLE", "LINEAR", "LINEAR,LOOP"
] ;

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
//  f_CreatePorterSet(vector avDest, rotation arRot, list axPorters)
//      axPorters is a strided list consisting of sets of:
//          [ "porterName", <destVector>, <destRotation>, "descriptiveName" ]
//
//      Teleport to the 'porter location plus 2m in Z direction, and
//      orient to the correct rotation.
//
//      Calculate the relative offset of the first 'porter: <spacing>
//      meters in the Y direction.
//
//      Loop through axPorters:
//          Rez the requested 'porter in its location.
//          Send a message with the destVector and destRotation
//          in a CSV to the private channel given in the start code.
//

f_CreatePorterSet(vector avDest, rotation arRot, list axPorters)
{
    f_TeleportTo(avDest + <0,0,2>);
    llSetRot(arRot);

    integer liNumPorters = llGetListLength(axPorters) / 4;
    float lfSpacing = llList2Float(gxPortRingInfo, 3);
    float lfOffset = (lfSpacing * 0.5) * (float)(liNumPorters - 1);

    integer i;
    for (i = 0; i < liNumPorters; i++)
    {
        vector lvPorterLocation = llGetPos() + <0, lfOffset, -2> * llGetRot() ;
        llRezObject(
            llList2String(axPorters, i*4),  // the name of object to rez
            lvPorterLocation,               // the location at which to rez
            ZERO_VECTOR,                    // the velocity
            llGetRot(),                     // the rotation
            piPrivateChannel + i            // the start code
        );
        llSleep(1.0);
        vector lvDest = llList2Vector(axPorters, i*4+1);
        rotation lrRot = llList2Rot(axPorters, i*4+2);
        string lsName = llList2String(axPorters, i*4+3);
        lvDest += <-2,0,0> * lrRot;
        llWhisper(piPrivateChannel + i, "Porter:Destination:" + llList2CSV( [ lvDest, lrRot, lsName ] ));
        lfOffset -= lfSpacing;
    }
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
        state WaitingForNotecard ;
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
        gxPortRingStationNames = [ ] ;
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
            state CreatingPortRing;
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
//llWhisper(0, "Parsed line " + (string)giNotecardLine + ": " + asLine);
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
                    string lsName = llList2String(lxLineInfo, 3);
                    integer liIdx = llListFindList(cxHeadingToRotation, [ lsHeading ]);
                    if (llVecMag(lvPosition) < 1.0)
                    {
                        lsError = "Invalid notecard format - illegal vector " + llList2String(lxLineInfo, 1);
                    } else if (liIdx < 0)
                    {
                        lsError = "Invalid notecard format - unknown heading " + lsHeading;
                    } else {
//llWhisper(0, "Parsed line " + (string)giNotecardLine + ": " + asLine);
                        gxPortRingStations += [
                            lvPosition,
                            llList2Rot(cxHeadingToRotation, liIdx + 1)
                        ] ;
                        if (lsName == "")
                        {
                            lsName = "Base";
                        }
                        gxPortRingStationNames += [ lsName ] ;
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
                    string lsName = llList2String(lxLineInfo, 3);
                    if (liIdx < 0)
                    {
                        lsError = "Invalid notecard format - unknown heading " + lsHeading;
                    } else {
//llWhisper(0, "Parsed line " + (string)giNotecardLine + ": " + asLine);
                        gxPortRingStations += [
                            lvPosition,
                            llList2Rot(cxHeadingToRotation, liIdx + 1)
                        ] ;
                        if (lsName == "")
                        {
                            integer num = llGetListLength(gxPortRingStationNames);
                            lsName = "Station " + (string)num;
                        }
                        gxPortRingStationNames += [ lsName ] ;
                    }
                }
            } else {
                lsError = "Invalid notecard format - found unknown line type " + lsLineType;
            }
        }

        if (lsError != "")
        {
            llWhisper(0, "ERROR: " + lsError);
            llWhisper(0, (string)giNotecardLine + ": " + asLine);
            state WaitingForNotecard ;
        } else {
            llGetNotecardLine(gsNotecardName, giNotecardLine);
            giNotecardLine += 1;
        }
    }

}

////////////////////////////////////////////////////////////////////////
//
//  CreatingPortRing state:
//
//  Call f_CreatePorterSet for the base and each station.
//
//  For the base, the porter list will be a single 'porter set for
//  "forward" pointing to station #1.
//
//  For each station, the porter list will contain back (if not the
//  first station), base, and forward (if not the last station).

state CreatingPortRing
{
    on_rez(integer liStartCode)
    {
        llResetScript();
    }

    state_entry()
    {
        llWhisper(0, "Creating PortRing...");

        integer i;
        integer liNumStations = (llGetListLength(gxPortRingStations) / 2) - 1;
        vector lvStartingLocation;
        vector lvBaseLocation;
        rotation lrBaseRotation;
        vector lvStationLocation;
        rotation lrStationRotation;
        vector lvNextStationLocation;
        rotation lrNextStationRotation;
        vector lvPreviousStationLocation;
        rotation lrPreviousStationRotation;
        string lsBackPorter;
        string lsForwardPorter;
        string lsBasePorter;
        list lxPorters;
        string lsBaseName;
        string lsPreviousStationName;
        string lsStationName;
        string lsNextStationName;

        lvStartingLocation = llGetPos();
        lvStartingLocation.z -= llGround(ZERO_VECTOR);

        // initialize BASE and first STATION values [as NEXT station]
        lvBaseLocation = llList2Vector(gxPortRingStations, 0);
        lrBaseRotation = llList2Rot(gxPortRingStations, 1);
        lsBaseName = llList2String(gxPortRingStationNames, 0);
        lvNextStationLocation = llList2Vector(gxPortRingStations, 2);
        lrNextStationRotation = llList2Rot(gxPortRingStations, 3);
        lsNextStationName = llList2String(gxPortRingStationNames, 1);
        lsBackPorter = llList2String(gxPortRingInfo, 0);
        lsForwardPorter = llList2String(gxPortRingInfo, 1);
        lsBasePorter = llList2String(gxPortRingInfo, 2);

        i = llListFindList(gxOptions, [",RINGSTYLE"]);
        string lsRingStyleOption = llList2String(gxOptions, i+1);

        // construct BASE 'porters, based on BASEPORTERS option.
        i = llListFindList(gxOptions, [",BASEPORTERS"]);
        string lsBasePortersOption = llList2String(gxOptions, i+1);

        lxPorters = [
            lsForwardPorter,
            lvNextStationLocation,
            lrNextStationRotation,
            lsNextStationName
        ];

        if ("ALL" == lsBasePortersOption)
        {
            for (i = 2; i <= liNumStations; i++)
            {
                lvStationLocation = llList2Vector(gxPortRingStations, i * 2);
                lrStationRotation = llList2Rot(gxPortRingStations, i * 2 + 1);
                lsStationName = llList2String(gxPortRingStationNames, i);
                lxPorters += [
                    lsForwardPorter,
                    lvStationLocation,
                    lrStationRotation,
                    lsStationName
                ];
            }
        } else if ("FIRSTANDLAST" == lsBasePortersOption)
        {
            lvStationLocation = llList2Vector(gxPortRingStations, liNumStations * 2);
            lrStationRotation = llList2Rot(gxPortRingStations, liNumStations * 2 + 1);
            lsStationName = llList2String(gxPortRingStationNames, liNumStations);
            lxPorters += [
                lsForwardPorter,
                lvStationLocation,
                lrStationRotation,
                lsStationName
            ];
        }

//llWhisper(0, "BASE : " + (string)lvBaseLocation + " @ " + (string)lrBaseRotation);
        f_CreatePorterSet(lvBaseLocation, lrBaseRotation, lxPorters);

        // then create stations
        for (i = 1; i <= liNumStations; i++)
        {

            lvPreviousStationLocation = lvStationLocation;
            lrPreviousStationRotation = lrStationRotation;
            lsPreviousStationName = lsStationName;
            lvStationLocation = lvNextStationLocation;
            lrStationRotation = lrNextStationRotation;
            lsStationName = lsNextStationName;

            // construct lxPorters for BACK (if appropriate), BASE, FORWARD (if appropriate)
            lxPorters = [ ] ;
            if (i > 1)
            {
                lxPorters += [
                    lsBackPorter,
                    lvPreviousStationLocation,
                    lrPreviousStationRotation,
                    lsPreviousStationName
                ];
            } else if ("LOOP" == lsRingStyleOption)
            {
                lvPreviousStationLocation = llList2Vector(gxPortRingStations, liNumStations * 2);
                lrPreviousStationRotation = llList2Rot(gxPortRingStations, liNumStations * 2 + 1);
                lsPreviousStationName = llList2String(gxPortRingStationNames, liNumStations);
                lxPorters += [
                    lsBackPorter,
                    lvPreviousStationLocation,
                    lrPreviousStationRotation,
                    lsPreviousStationName
                ];
            }
            lxPorters += [
                lsBasePorter,
                lvBaseLocation,
                lrBaseRotation,
                lsBaseName
            ];
            if (i < liNumStations)
            {
                lvNextStationLocation = llList2Vector(gxPortRingStations, i * 2 + 2);
                lrNextStationRotation = llList2Rot(gxPortRingStations, i * 2 + 3);
                lsNextStationName = llList2String(gxPortRingStationNames, i + 1);
                lxPorters += [
                    lsForwardPorter,
                    lvNextStationLocation,
                    lrNextStationRotation,
                    lsNextStationName
                ];
            } else if ("LOOP" == lsRingStyleOption)
            {
                lvNextStationLocation = llList2Vector(gxPortRingStations, 2);
                lrNextStationRotation = llList2Rot(gxPortRingStations, 3);
                lsNextStationName = llList2String(gxPortRingStationNames, 1);
                lxPorters += [
                    lsForwardPorter,
                    lvNextStationLocation,
                    lrNextStationRotation,
                    lsNextStationName
                ];
            }

//llWhisper(0, "STATION " + (string)i + " : " + (string)lvStationLocation + " @ " + (string)lrStationRotation);
            f_CreatePorterSet(lvStationLocation, lrStationRotation, lxPorters);
        }

        f_TeleportTo(lvStartingLocation);

        state WaitingForNotecard;
    }
}

////////////////////////////////////////////////////////////////////////
//
//  LICENSE FOR USE
//
//  This code is copyright (c) 2004 by Johnson Earls.
//  All rights reserved.
//
//  Permission to use and redistribute this source code, with or without
//  modifications, is granted under the following conditions:
//
//  1)  This code may be used, in whole or in part, in other code, so
//      long as the author is credited by SL name (Neo Rebus) or FL
//      name (Johnson Earls).
//  2)  This code, including portions of this code that are
//      incorporated into other works, may be redistributed as long as
//      it is accompanied by the author's original copyright notice,
//      and a pointer ot the full original souce code.  For example:
//          Portions of this code are copyright (c) 2004 by Johnson
//          Earls, used under license.  Original code available at
//          http://www.badgeometry.com/wiki/LibraryPortRingCreator
//
////////////////////////////////////////////////////////////////////////
// END //
