// :CATEGORY:Blue Whale
// :NAME:BlueWhale
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:107
// :NUM:148
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// prim mover
// :CODE:


// User settable parameters:
float FLIPTIME = 1.5;  // how often the tail moves, floating point.
string NOTECARD = "Movement";   // the notecard name, you can add any nuimber of Notecards and eitherchange this to play them, or rename one of them to this string

// global variables below - no need to modify

// These are for notecard reading
integer iIndexLines;
integer i = 0;
integer iMove;               // N movements rea from the notecard
key kNoteCardLines;                // the key of the notecard
key kGetIndexLines;                // the key of the current line

// misc
list masterlist; // the list of coords, filled in by a notecard reader
integer tailcounter = 0; // this counter flips the tail up and down
integer STRIDE = 6;    // the list we record contains  6 pieces of info

// subroutine to remove any white space before or after a string
string strip(string str)
{
    return llStringTrim(str, STRING_TRIM);
}

// subroutine to get a line at index 'line' from list Input, and strip white space b4 or after
string Getline(list Input, integer line)
{
    return strip(llList2String(Input, line));
}

// subroutine to Play Back a named animation
PlayBack (string name)
{
    integer i;
    integer iMax = llGetListLength(masterlist);        // how many are in the list? we need this to know when to stop
    // scan the entire array for the named animation
    for (i = 0; i < iMax; i+= STRIDE)
    {
        string aniname2 = llList2String(masterlist,i);
        if (aniname2 == name)
        {
            // convert each list element into a loal variable
            float fPrimnum = llList2Float(masterlist,i+1);
            vector  vPrimpos  = llList2Vector(masterlist,i+2);
            rotation rPrimrot = llList2Rot(masterlist,i+3) ;
            string  sMsg = llList2String(masterlist,i+4);
            string sUUID = llList2String(masterlist,i+5);

            if (llStringLength(sMsg) > 0)
                llSay(0,sMsg);        // chat any text we find
            if (llStringLength(sUUID) > 0)
                llPlaySound(sUUID,1.0);    // play any sound we find

            if (fPrimnum < 0)
            {
                llSleep(-fPrimnum); // sleep the interval in the notecard
            }
            else
            {
                rPrimrot /=  llGetRot();       // Add in the local rot

                if (fPrimnum != 0)
                    // The new way llSetLinkPrimitiveParamsFast((integer) fPrimnum,[PRIM_POSITION,vPrimpos,PRIM_ROTATION,rPrimrot]);
                    llSetLinkPrimitiveParamsFast((integer) fPrimnum,[PRIM_POSITION,vPrimpos,PRIM_ROTATION,rPrimrot]);

            }
        }
    }
}


default
{
    state_entry()
    {
        kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
        kGetIndexLines = llGetNotecardLine(NOTECARD,0);
    }

    // read notecard on reset, once.  We store this in RAM and never reset again
    dataserver(key kQueryid, string sData)
    {
        if (kQueryid == kNoteCardLines)
            iIndexLines = (integer) sData;

        if (kQueryid == kGetIndexLines)
        {
            if (sData != EOF)
            {
                // read and parse the notecard line into a list of items
                kQueryid = llGetNotecardLine(NOTECARD, i);
                list lLine = (llParseString2List(sData, ["|"], []));

                // pull each element from the notecard list so we can store it in the proper format
                string junk = llList2String(lLine,0); // this is the time/date field and object name that was chatted into the notecard
                string sAniname = llList2String(lLine,1);        // the name of the animation
                integer iNum = (integer)Getline(lLine,2);        // the prim link number
                vector vPos = (vector) Getline(lLine,3);            // the position
                rotation rRot = (rotation) Getline(lLine,4);        // the rotation
                string sMsg = llList2String(lLine,5);            // optional chat string
                string sUUID = llList2String(lLine,6);            // option sound name or UUID

                if(iNum > 1)    // skip the root prim! we don't want to move it
                {
                    if (llStringLength(sMsg) > 0)
                        llSay(0,sMsg);        // chat any text in this notecard
                    if (llStringLength(sUUID) > 0)
                        llPlaySound(sUUID,1.0);    // play any sound we find in the notecard

                    masterlist += [sAniname];
                    masterlist += [iNum];
                    masterlist += [vPos];
                    masterlist += [rRot];
                    masterlist += [sMsg];
                    masterlist += [sUUID];
                    rRot /= llGetRot();        // remove our current rotation, by subtracting.. yes, a divide is a subtract in vector math

                    //llSetLinkPrimitiveParamsFast(Num,[PRIM_POSITION,Pos,PRIM_ROTATION,Rot]);
                    llSetLinkPrimitiveParamsFast(iNum,[PRIM_POSITION,vPos,PRIM_ROTATION,rRot]);
                    iMove++;            // count the real movement
                }
                i++;
                integer     iInitPerCent = (integer) llRound(( (i+1) / (float) iIndexLines) * 100);
                llSetText("Initialising... \n" + (string) iInitPerCent + "%" , <1,1,1>, 1.0);
                if (iInitPerCent == 100)
                    llSetText(""  , <1,1,1>, 1.0);
                kGetIndexLines = llGetNotecardLine(NOTECARD,i);
            }
            else
            {
                llOwnerSay("initialized with " + (string) iMove + " movements");
                llSetText(""  , <1,1,1>, 1.0);
                // start the whale flipping the tail every so often
                llSetTimerEvent(FLIPTIME);
            }
        }
    }


    // The timer code moves the prim up and down
    timer()
    {
        if (tailcounter ++ %2 == 0)
            PlayBack("up");
        else
            PlayBack("down");

    }

}

