// :CATEGORY:Bird
// :NAME:Roaming Owl
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:01
// :ID:707
// :NUM:964
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Prim animator
// :CODE:



//You can now animate any object, with just one script!  Setup is very simple. Just drop the script and a blank notecard into the object, click the object, and give your animation a name.  Move all the prims around, and click Record. When done, click the Animation Name, and watch it play back every move!

// Downloaded from : http://www.outworldz.com/cgi/freescripts.plx?ID=1519

// This program is free software; you can redistribute it and/or modify it.
// Additional Licenes may apply that prevent you from selling this code
// and these licenses may require you to publish any changes you make on request.
//
// There are literally thousands of hours of work in these scripts. Please respect
// the creators wishes and follow their license requirements. 
//
// Any License information included herein must be included in any script you give out or use.
// Licenses are included in the script or comments by the original author, in which case
// the authors license must be followed.

// A GNU license, if attached by the author, means the original code must be FREE.
// Modifications can be made and products sold with the scripts in them. 
// You cannot attach a license to make this GNU License
// more or less restrictive.  see http://www.gnu.org/copyleft/gpl.html

// Creative Commons licenses apply to all scripts from the Second Life
// wiki and script library and are Copyrighted by Linden Lab. See
// http://creativecommons.org/licenses/

// Please leave any author credits and headers intact in any script you use or publish.
// If you don't like these restrictions, then don't use these scripts.
//////////////////////// ORIGINAL AUTHORS CODE BEGINS ////////////////////////////////////////////
// One Script Prim Animation

// Original Script by: Fred Beckhusen (Ferd Frederix)
// No Spam version by: Gino Rascon

integer runtime = TRUE; // set to TRUE after making the notecard

string NOTECARD = "Movement";   // the notecard for this script, you can add more than 1 script and notecard, just change this line to match
integer playchannel = 1;    // the playback channel, this is the channel you use in LinkMessages


integer debug = FALSE;          // if set to TRUE, debug info appears


// notecard reading
string priorname;               // the prior animation name so we can spot differences as we read them in
integer iIndexLines;            // lines in a card
integer inotecardIndex = 0;     // notecard counter;
integer move = 0;               // N movements rea from the notecard

key kNoteCardLines;             // the key of the notecard
key kGetIndexLines;             // the key of the current line

//communications
integer dialogchannel ;         // dialog boxes

integer nPrims;                 // total number of prims
integer PrimsCounter = 0;       // how many have checked in
integer timercounter = 0;       // how many seconds have gone by
integer wantname;               // flag indicating we are waiting for a name to be chatted


// the list of coords
list masterlist;        // master list of all positions
list llastPrimList;      // storage of the last prim position we learned
string curranimation;   // what we are playing

integer STRIDE = 5;     // size of the master list
integer lastSTRIDE = 4; // size of the last prim list

integer listener;       // temp listener when we are waiting for them to give us a name

vector InitSize;        // the initial size when the prims were recorded
list LoadedAnims;       // animations read from the notecard added to the Menu display

// in case of hand editing, we wupe out extra stuff at end
string Getline(list Input, integer line)
{
    return llStringTrim(llList2String(Input, line),STRING_TRIM);
}

Record()
{
    if (llStringLength(curranimation) > 0)
    {
        integer foundmovement = 0;      // will be set if any child moved
        integer PrimCounter ;        // skip past the root prim
        for (PrimCounter =2; PrimCounter <= nPrims; PrimCounter++ )
        {
            list my_list = llGetLinkPrimitiveParams(PrimCounter,[PRIM_POSITION,PRIM_ROTATION, PRIM_SIZE ]);
            // position is always in region coordinates, even if the prim is a child or the root prim of an attachment.
            // rot is always the global rotation, even if the prim is a child or the root prim of an attachment.

            // get current prim pos, rot and size
            vector      vrealPrimPos    = llList2Vector (my_list,0) - llGetPos();   // position subtract Global Pos
            vrealPrimPos /= llGetRot();
            rotation    rrealPrimRot    = llList2Rot    (my_list,1) / llGetRot();   // rotation subtract Global Rot
            vector      vrealPrimSize   = llList2Vector (my_list,2);                 // size

            // compare it to the last one we had, stride of list is a 4, and it is already sorted
            integer iindex = (PrimCounter - 2) * lastSTRIDE;    // zeroth position is PrimCounter - start, or 2

            // get the last thing we remembered about this prim
            float       fprimNum        = llList2Integer    (llastPrimList, iindex);    // must be 0,1,2, in order
            vector      vlastPrimPos    = llList2Vector     (llastPrimList, iindex+1);
            rotation    rlastPrimRot    = llList2Rot        (llastPrimList, iindex+2);
            vector      vlastPrimSize   = llList2Vector     (llastPrimList, iindex+3);

            // if anything changed on this prim, we must record it.
            if (vlastPrimPos != vrealPrimPos ||
                rlastPrimRot != rrealPrimRot ||
                vlastPrimSize!= vrealPrimSize
                    )
                    {
                        foundmovement++;

                        // show owner any changes they mnade
                        if (debug)
                        {
                            llOwnerSay("prim:" + (string) PrimCounter);

                            if (vlastPrimPos != vrealPrimPos)
                                llOwnerSay("pos delta :" + (string) (vrealPrimPos - vlastPrimPos));

                            if (rlastPrimRot != rrealPrimRot)
                                llOwnerSay("rot delta:" + (string) (llRot2Euler (rrealPrimRot - rlastPrimRot) * RAD_TO_DEG));

                            if (vlastPrimSize != vrealPrimSize)
                                llOwnerSay("size delta:" + (string) (vrealPrimSize - vlastPrimSize));
                        }

                        //Save them in the master list of all animations
                        masterlist += curranimation;
                        masterlist += PrimCounter;
                        masterlist += vrealPrimPos;
                        masterlist += rrealPrimRot;
                        masterlist += vrealPrimSize;

                        // save them in the last movement list
                        integer saved = FALSE;
                        integer i;
                        integer imax = llGetListLength(llastPrimList);
                        // save the changes in the last prim list so we can keep our lists smaller
                        for ( i=0; i < imax; i += lastSTRIDE )
                        {
                            if (llList2Float(llastPrimList,i) == PrimCounter)
                            {
                                llastPrimList = llListReplaceList(llastPrimList,[vrealPrimPos],i+1,i+1);
                                llastPrimList = llListReplaceList(llastPrimList,[rrealPrimRot],i+2,i+2);
                                llastPrimList = llListReplaceList(llastPrimList,[vrealPrimSize],i+3,i+3);
                                if (debug) llOwnerSay("In history at position " + (string) (i/lastSTRIDE));
                                saved++;
                            }
                        }

                        // never moved before?  add it then
                        if (! saved)
                        {
                            if (debug) llOwnerSay("Someone added a new prim and then clicked Record");
                            llastPrimList += PrimCounter;
                            llastPrimList += vrealPrimPos;
                            llastPrimList += rrealPrimRot;
                            llastPrimList += vrealPrimSize;
                        }
                    } // if
        } // for
        if (debug)    llOwnerSay("history:" + llDumpList2String(llastPrimList,":"));

        if (!foundmovement)
            llOwnerSay("You must move at least one child prim.");
    }
    else
    {
        llOwnerSay("You must name your animation.");
        llOwnerSay("Type the new animation name on channel /" + (string) dialogchannel);
        wantname++;
    }
}

// on reset, record the base position in history so we can see changes
Clear()
{
    LoadedAnims = [];           // wipe out Menu
    masterlist = [];            // wipe all recordings
    llastPrimList = [];         // wipe last animations
    integer PrimCounter ;       // skip 1, which is the root prim
    integer counter = 0;
    // save all the current settings in memory
    for (PrimCounter=2; PrimCounter <= nPrims; PrimCounter++ )
    {
        list my_list = llGetLinkPrimitiveParams(PrimCounter,[PRIM_POSITION,PRIM_ROTATION, PRIM_SIZE ]);

        // save the local  pos and rot, since llGetLinkPrimitiveParams returns global pos and rot
        vector primpos      = llList2Vector (my_list,0) - llGetPos();
        rotation primrot    = llList2Rot    (my_list,1) / llGetRot();
        vector primsize     = llList2Vector (my_list,2) ;

        llastPrimList += PrimCounter;
        llastPrimList += primpos;
        llastPrimList += primrot;
        llastPrimList += primsize;
        counter++;
    }
    if(debug) llOwnerSay("Saved " + (string) counter + " prims initial position in history");
}

DumpBack ()
{
    integer i;
    integer imax = llGetListLength(masterlist);
    integer howmany = imax / STRIDE ;
    llOwnerSay((string) howmany + " movements recorded - copy these and paste them into the notecard");

    integer flag = 0;
    for (i = 0; i < imax; i+= STRIDE)
    {
        if ( i == 0 )
            llOwnerSay( "|start|" + (string) llGetScale());

        string saniName = llList2String(masterlist,i);
        curranimation = saniName;

        float fprimNum = llList2Integer(masterlist,     i+1);
        integer iprimNum = (integer) fprimNum;
        vector  vprimPos  = llList2Vector(masterlist,   i+2);
        rotation rprimRot = llList2Rot(masterlist,      i+3) ;
        vector  vprimSize  = llList2Vector(masterlist,  i+4);

        llOwnerSay("|"+ saniName + "|" + (string) iprimNum + "|" + (string) vprimPos + "|" + (string) rprimRot + "|" + (string) vprimSize );
        flag++;
    }
    if (! flag)
        llOwnerSay("No recording was made, nothing to play back." );
}


rotation calcChildRot(rotation rdeltaRot)
{

    if (llGetAttached())
        return rdeltaRot/llGetLocalRot();
    else
        return rdeltaRot/llGetRootRotation();

}


PlayBack (string name)
{
    integer i;
    integer imax = llGetListLength(masterlist);

    integer linknum = 0;

    for (i = 0; i < imax; i+= STRIDE)
    {
        string saniName = llList2String(masterlist,i);
        if (saniName == name)
        {
            float fprimNum      = llList2Float(masterlist,i+1);
            vector  vPos    = llList2Vector(masterlist,i+2);
            rotation rRot = llList2Rot(masterlist,i+3) ;
            vector vprimSize    = llList2Vector(masterlist,i+4) ;

            vector scale = llGetScale();
            float delta =  scale.x / InitSize.x ;   // see if the root prim has grown or shrunk as a percentage

            vPos *= delta;                           // add any difference in size to it positions there
            vprimSize *= delta;                      // grow the child prim, too


            // support negative prim numbers as a delay
            if (fprimNum < 0)
            {
                if (debug) llOwnerSay("Sleeping " + (string) (fprimNum * -1));
                llSleep((float) fprimNum * -1);
            }
            else
            {
                if (fprimNum > 1 )
                {
                    // set the local pos and locat rot to the prims orientation and position
                    rRot  = calcChildRot(rRot);

                    list actions = [PRIM_POSITION,vPos,PRIM_ROTATION,rRot,PRIM_SIZE,vprimSize];
                    if (debug) llOwnerSay("Moving prim :" + (string) fprimNum + ":" + llDumpList2String(actions,":"));

                    llSetLinkPrimitiveParamsFast((integer) fprimNum,actions);
                }
            }
        }
    }
}

MakeMenu()
{
    list amenu = ["Reset","Record","Help","Name","Notecard","Pause"] + LoadedAnims;

    llListenRemove(listener);
    listener = llListen(dialogchannel,"","","");

    amenu = llDeleteSubList(amenu,12,99);

    llDialog(llGetOwner(), "Pick a command",amenu,dialogchannel);
}



default
{
    state_entry()
    {
        InitSize = llGetScale();            // save the size  when we recorded the prims
        nPrims = llGetNumberOfPrims();      // how many we are recording
        if (debug) llOwnerSay(" Total Prims = " + (string) nPrims);
        Clear();

        string notecardname = llGetInventoryName(INVENTORY_NOTECARD,0);

        if (llStringLength(notecardname) > 0)
        {
            kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
            kGetIndexLines = llGetNotecardLine(NOTECARD,0);
        }
        else
        {
            llOwnerSay("If you add a notecard, you can save your animations permanently in a notecard named " + NOTECARD);
        }
        dialogchannel = (integer) (llFrand(100) +600);

    }

    // read notecard on bootup
    dataserver(key queryid, string data)
    {
        if (queryid == kNoteCardLines)
        {
            iIndexLines = (integer) data;
        }

        if (queryid == kGetIndexLines)
        {
            if (data != EOF)
            {
                queryid = llGetNotecardLine(NOTECARD, inotecardIndex);
                list lLine = (llParseString2List(data, ["|"], []));

                string junk = llList2String(lLine,0);
                string aniname = llList2String(lLine,1);
                string aNum = (string) Getline(lLine,2);

                // check for the prim size,and save it, the fiorst line will look like this:
                // [18:06]  prim position 1.2: |start|<1.02306, 1.02306, 1.02306>

                if (inotecardIndex == 0 && aniname == "start")
                {
                    InitSize = (vector) aNum;
                }
                else if (inotecardIndex == 0 && aniname != "start")
                {
                    llOwnerSay("The notecard " + NOTECARD  + " is incorrect, it must begin with 'start|<x,y,z>' with the size of the original prim");
                }
                else
                {

                    float Num = (float) aNum;

                    vector vPos = (vector) Getline(lLine,3);          // global for calcChild()
                    rotation rRot = (rotation) Getline(lLine,4);        // global for calcChild()
                    vector Size  = (vector) Getline(lLine,5);

                    vector scale = llGetScale();
                    float delta =  scale.x / InitSize.x ;   // see if the root prim has grown or shrunk as a percentage


                    if (aniname != priorname)
                    {
                        llOwnerSay("Loading animation " + aniname);
                        priorname = aniname;
                        LoadedAnims += aniname;
                    }

                    if(Num != 1)        // skip root prim
                    {
                        masterlist += [aniname];
                        masterlist += [Num];
                        masterlist += [vPos];
                        masterlist += [rRot];
                        masterlist += [Size];

                        if (Num > 1)  // not the pauses
                        {
                            rRot = calcChildRot(rRot);
                            vPos *= delta;                           // add any difference in size to it positions there
                            Size *= delta;                          // grow the child prim, too

                            llSetLinkPrimitiveParamsFast((integer) Num,[PRIM_POSITION,vPos,PRIM_ROTATION,rRot,PRIM_SIZE,Size]);
                            move++;
                        }

                    }
                }
                inotecardIndex++;
                integer     InitPerCent = (integer) llRound(( (inotecardIndex+1) / (float) iIndexLines) * 100);
                llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
                if (InitPerCent >= 100)
                    llSetText(""  , <1,1,1>, 1.0);
                kGetIndexLines = llGetNotecardLine(NOTECARD,inotecardIndex);

            }
            else
            {
                llOwnerSay("initialized with " + (string) move + " movements");
                llSetText(""  , <1,1,1>, 1.0);
            }
        }
    }


    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner() && ! runtime)
        {
            MakeMenu();
        }

        // add any control code here
        // example:
        // llMessageLinked(LINK_SET,playchannel,"All","");  // will play Animation named "All"

    }

    listen( integer channel, string name, key id, string message )
    {

        if (channel == dialogchannel)
        {
            if (message == "Reset")
            {
                Clear();
                if (debug)    llOwnerSay("Reset = " + llDumpList2String(llastPrimList,":"));
                MakeMenu();
            }
            else if (message =="Pause")
            {
                masterlist += curranimation;
                masterlist += -1;
                masterlist += <0,0,0>;  // pos
                masterlist += <0,0,0,1>;// rot
                masterlist += <0,0,0>;  // size
                MakeMenu();
            }
            else if (message == "Record")
            {
                Record();

                MakeMenu();
            }
            else if (message == "Name")
            {
                llOwnerSay("Type the current animation name on channel /" + (string) dialogchannel);
                wantname++;
                MakeMenu();
            }
            else if (message =="Menu")
            {
                MakeMenu();
            }
            else if (message == "Notecard")
            {
                DumpBack();
                MakeMenu();
            }
            else if (message == "Help")
            {
                llLoadURL(llGetOwner(),"View online help", "http://secondlife.mitsi.com/secondlife/Posts/Prim-Animator");
            }
            else if (wantname)
            {
                curranimation = message;

                LoadedAnims += message;

                MakeMenu();
                llOwnerSay("Recording is ready for animation '" + curranimation + "'");
                llOwnerSay("Position all child  prims, then select the Menu item 'Record', and repeat as necessary. When finished, click 'PlayBack' to play back the animation, or click the animation name.  Click 'Name' to start a new animation sequence");
                wantname = 0;
                PrimsCounter = 0;
                timercounter  = 0;
                llSetTimerEvent(1.0);
            }
            else
            {
                if (llListFindList(LoadedAnims,[message]) != -1)
                {
                    PlayBack(message);
                    MakeMenu();
                }
            }


        }
    }



    link_message(integer sender_num, integer num, string message, key id)
    {
        if (num == playchannel)
        {
            if (debug) llOwnerSay("playback animation " + message);
            PlayBack(message);
        }
    }




}


