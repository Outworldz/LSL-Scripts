// :CATEGORY:Building
// :NAME:Builders Buddy
// :AUTHOR:Newfie Pendragon
// :KEYWORDS:
// :CREATED:2014-10-21 20:01:53
// :EDITED:2014-10-21
// :ID:122
// :NUM:185
// :REV:10.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// This script goes in the each link set of parts. Those parts then go in the Builders Buddy Box
// :CODE:

// Fri Dec 12, 2008  Mods by Michelle Argus to allow use on Var amd Mega regions in Opensim.


///////////////////////////////////////////////////////////////////////////////
// Builders' Buddy 1.10 (Component Script)
// by Newfie Pendragon, 2006-2008
///////////////////////////////////////////////////////////////////////////////
//
// Script Purpose & Use
// Functions are dependent on the "component script"
//
// QUICK USE:
// - Drop this script in the Base.
// - Drop the "Component" Script in each building part.
// - Touch your Base, and choose RECORD
// - Take all building parts into inventory
// - Drag building parts from inventory into Base Prim
// - Touch your base and choose BUILD
//
// OTHER COMMANDS from the Touch menu
// - To reposition, move/rotate Base Prim choose POSITION
// - To lock into position (removes scripts) choose DONE
// - To delete building pieces: choose CLEAN
///////////////////////////////////////////////////////////////////////////////
// This script is copyrighted material, and has a few (minor) restrictions.
// For complete details, including a revision history, please see
//  http://wiki.secondlife.com/wiki/Builders_Buddy
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Added a Memory datastorage for opensim using osMakeNotecard
///////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////////////
// Configurable Settings
float fTimerInterval = 0.25;        // Time in seconds between movement 'ticks'
integer DefaultChannel = -192567; // Andromeda Quonset's default channel
//integer PRIMCHAN = DefaultChannel;  // Channel used by Base Prim to talk to Component Prims;
integer PRIMCHAN = -192567;  // OpenSim Modification - also comment out the previous line for OpenSim
                                    // ***THIS MUST MATCH IN BOTH SCRIPTS!***

//////////////////////////////////////////////////////////////////////////////////////////
// Runtime Variables (Dont need to change below here unless making a derivative)
vector vOffset;
rotation rRotation;
integer bNeedMove;
vector vDestPos;
rotation rDestRot;
integer bMovingSingle = FALSE;
integer bAbsolute = FALSE;
integer bRecorded = FALSE;


list record_mem = []; // Memory to be stored
key g_quary_nc;  //for reading our memory notecard
integer nc_line;  //what line are we reading
integer iStartValue;

//////////////////////////////////////////////////////////////////////////////////////////
// Variables for Positioninglimits within the sim of a 1024 X 1024 var or mega
float vDestPosXMIN = 0.0;
float vDestPosXMAX = 1024.0;
float vDestPosYMIN = 0.0;
float vDestPosYMAX = 1024.0;
float vDestPosZMAX = 10000.0;


////////////////////////////////////////////////////////////////////////////////
string first_word(string In_String, string Token)
{
    //This routine searches for the first word in a string,
    // and returns it.  If no word boundary found, returns
    // the whole string.
    if(Token == "") Token = " ";
    integer pos = llSubStringIndex(In_String, Token);

    //Found it?
    if( pos >= 1 )
        return llGetSubString(In_String, 0, pos - 1);
    else
        return In_String;
}

////////////////////////////////////////////////////////////////////////////////
string other_words(string In_String, string Token)
{
    //This routine searches for the other-than-first words in a string,
    // and returns it. If no word boundary found, returns
    // an empty string.
    if( Token == "" ) Token = " ";

    integer pos = llSubStringIndex(In_String, Token);

    //Found it?
    if( pos >= 1 )
        return llGetSubString(In_String, pos + 1, llStringLength(In_String));
    else
        return "";
}

////////////////////////////////////////////////////////////////////////////////
do_move()
{
    integer i = 0;
    vector vLastPos = ZERO_VECTOR;
    while( (i < 5) && (llGetPos() != vDestPos) )
    {
        list lParams = [];

        //If we're not there....
        if( llGetPos() != vDestPos )
        {
            //We may be stuck on the ground...
            //Did we move at all compared to last loop?
            if( llGetPos() == vLastPos )
            {
                //Yep, stuck...move straight up 10m (attempt to dislodge)
                lParams = [ PRIM_POSITION, llGetPos() + <0, 0, 10.0> ];
                //llSetPos(llGetPos() + <0, 0, 10.0>);
            } else {
                //Record our spot for 'stuck' detection
                vLastPos = llGetPos();
            }
        }

        //Try to move to destination
        //Upgraded to attempt to use the llSetPrimitiveParams fast-move hack
        //(Newfie, June 2006)
        integer iHops = llAbs(llCeil(llVecDist(llGetPos(), vDestPos) / 10.0));
        integer x;
        for( x = 0; x < iHops; x++ ) {
            lParams += [ PRIM_POSITION, vDestPos ];
        }
        llSetPrimitiveParams(lParams);
        //llSleep(0.1);
        i++;
    }

    //Set rotation
    llSetRot(rDestRot);
}

start_move(string sText, key kID)
{
    //Don't move if we've not yet recorded a position
    if( !bRecorded ) return;

    //Also ignore commands from bases with a different owner than us
    //(Anti-hacking measure)
    if( llGetOwner() != llGetOwnerKey(kID) ) return;

    //Calculate our destination position relative to base?
    if(!bAbsolute) {
        //Relative position
        //Calculate our destination position
        sText = other_words(sText, " ");
        list lParams = llParseString2List(sText, [ "|" ], []);
        vector vBase = (vector)llList2String(lParams, 0);
        rotation rBase = (rotation)llList2String(lParams, 1);

        vDestPos = (vOffset * rBase) + vBase;
        rDestRot = rRotation * rBase;
    } else {
        //Sim position
        vDestPos = vOffset;
        rDestRot = rRotation;
    }

    //Make sure our calculated position is within the sim
    if(vDestPos.x < vDestPosXMIN) vDestPos.x = vDestPosXMIN;
    if(vDestPos.x > vDestPosXMAX) vDestPos.x = vDestPosXMAX;
    if(vDestPos.y < vDestPosYMIN) vDestPos.y = vDestPosYMIN;
    if(vDestPos.y > vDestPosYMAX) vDestPos.y = vDestPosYMAX;
    if(vDestPos.z > vDestPosZMAX) vDestPos.z = vDestPosZMAX;


    //Turn on our timer to perform the move?
    if( !bNeedMove )
    {
        llSetTimerEvent(fTimerInterval);
        bNeedMove = TRUE;
    }
    return;
}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
default
{
    //////////////////////////////////////////////////////////////////////////////////////////
    state_entry()
    {
        //Open up the listener
        llListen(PRIMCHAN, "", NULL_KEY, "");
        llRegionSay(PRIMCHAN, "READYTOPOS");
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    on_rez(integer iStart)
    {
        iStartValue = iStart;
        if(llGetInventoryType("Builders Buddy Memory") != -1)
        {
            nc_line = 0;
            g_quary_nc = llGetNotecardLine("Builders Buddy Memory", nc_line);
        }
        else
        {
            //Set the channel to what's specified
            if( iStart != 0 )
            {
                PRIMCHAN = iStart;
                state reset_listeners;
            }
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    listen(integer iChan, string sName, key kID, string sText)
    {
        string sCmd = llToUpper(first_word(sText, " "));

        if( sCmd == "SET_LIMITS" )
        {
            list lParams = llParseString2List(sText, [ " " ], []);
            
            vDestPosXMIN = llList2Float(lParams, 1);
            vDestPosXMAX = llList2Float(lParams, 2);
            vDestPosYMIN = llList2Float(lParams, 3);
            vDestPosYMAX = llList2Float(lParams, 4);
            vDestPosZMAX = llList2Float(lParams, 5);        
        
        }   
        else if( sCmd == "RECORD" )
        {
            record_mem = [];
            
            //Record position relative to base prim
            sText = other_words(sText, " ");
            list lParams = llParseString2List(sText, [ "|" ], []);
            vector vBase = (vector)llList2String(lParams, 0);
            rotation rBase = (rotation)llList2String(lParams, 1);

            vOffset = (llGetPos() - vBase) / rBase;
                record_mem += "vOffset|" +(string)vOffset ;
            rRotation = llGetRot() / rBase;
                record_mem += "rRotation|" +(string)rRotation ;
            bAbsolute = FALSE;
                record_mem += "bAbsolute|" +(string)bAbsolute ;
            bRecorded = TRUE;
                record_mem += "bRecorded|" +(string)bRecorded ;
            
            if(llGetInventoryType("Builders Buddy Memory") != -1)
            {
                llRemoveInventory("Builders Buddy Memory");
            }
            osMakeNotecard( "Builders Buddy Memory", record_mem );
            
            
            llOwnerSay("Recorded position.");
            return;
        }

        if( sCmd == "RECORDABS" )
        {
            record_mem = [];
            //Record absolute position
            rRotation = llGetRot();
                record_mem += "rRotation|" +(string)rRotation ;
            vOffset = llGetPos();
                record_mem += "vOffset|" +(string)vOffset ;
            bAbsolute = TRUE;
                record_mem += "bAbsolute|" +(string)bAbsolute ;
            bRecorded = TRUE;
                record_mem += "bRecorded|" +(string)bRecorded ;
                
            if(llGetInventoryType("Builders Buddy Memory") != -1)
            {
                llRemoveInventory("Builders Buddy Memory");
            }
            osMakeNotecard( "Builders Buddy Memory", record_mem );                
            
            llOwnerSay("Recorded sim position.");
            return;
        }

        //////////////////////////////////////////////////////////////////////////////////////////
        if( sCmd == "MOVE" )
        {
            start_move(sText, kID);
            return;
        }

        if( sCmd == "MOVESINGLE" )
        {
            //If we haven't gotten this before, position ourselves
            if(!bMovingSingle) {
                //Record that we are a single-prim move
                bMovingSingle = TRUE;

                //Now move it
                start_move(sText, kID);
                return;
            }
        }

        //////////////////////////////////////////////////////////////////////////////////////////
        if( sCmd == "DONE" )
        {
            //We are done, remove script
            if(llGetInventoryType("Builders Buddy Memory") != -1)
            {
                llRemoveInventory("Builders Buddy Memory");
            }
            llRemoveInventory(llGetScriptName());
            return;
        }

        //////////////////////////////////////////////////////////////////////////////////////////
        if( sCmd == "CLEAN" )
        {
            //Clean up
            llDie();
            return;
        }

        //////////////////////////////////////////////////////////////////////////////////////////
        if( sCmd == "RESET" )
        {
            llResetScript();
        }
    }

    //////////////////////////////////////////////////////////////////////////////////////////
    timer()
    {
        //Turn ourselves off
        llSetTimerEvent(0.0);

        //Do we need to move?
        if( bNeedMove )
        {
            //Perform the move and clean up
            do_move();

            //If single-prim move, announce to base we're done
            if(bMovingSingle) {
                llRegionSay(PRIMCHAN, "ATDEST");
            }

            //Done moving
            bNeedMove = FALSE;
        }
        return;
    }
    dataserver(key queryid, string data)
    {
        if ( queryid == g_quary_nc)
        {
            if (data != EOF)
            {
                list n = llParseString2List(data, ["|"], []);
                
                if(llList2String(n, 0) == "vOffset")
                {
                    vOffset = llList2Vector(n, 1);
                }
                else if(llList2String(n, 0) == "rRotation")
                {
                    rRotation = llList2Rot(n, 1);
                }
                else if(llList2String(n, 0) == "bAbsolute")
                {
                    bAbsolute = (integer)llList2String(n, 1);
                }
                else if(llList2String(n, 0) == "bRecorded")
                {
                    bRecorded = (integer)llList2String(n, 1);
                }
                nc_line++;
                g_quary_nc = llGetNotecardLine("Builders Buddy Memory", nc_line);
            }
            else
            {
                //Set the channel to what's specified
                if( iStartValue != 0 )
                {
                    PRIMCHAN = iStartValue;
                    state reset_listeners;
                }
            }
        }
    }
}


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
state reset_listeners
{
    //////////////////////////////////////////////////////////////////////////////////////////
    state_entry()
    {
        state default;
    }
}
