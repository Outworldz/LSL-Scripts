// :SHOW:
// :CATEGORY:Prim
// :NAME:Prim_Animation_Compiler
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2013-02-25 10:47:09.853
// :EDITED:2015-04-14  11:57:51
// :ID:648
// :NUM:878
// :REV:2.0
// :WORLD:Second Life
// :DESCRIPTION:
// For more details on how this script works, see <a href="http://www.outworldz.com/secondlife/posts/prim-compiler/">http://www.outworldz.com/secondlife/posts/prim-compiler/</a>// // This is the Animator menu system.  You will also need to the compiler script.  You can adjust the script for OpenSim or Second Life with one variable set to TRUE or FALSE for memory checking.   
// :CODE:

// Rev 2:  allow anyone to use it - just click Finish and others can get an animation menu.

// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// 2-19-2012

// Animator front-end for Compiler Script
// This is free software, it is not for sale at any price

integer playchannel = 1;    // the playback channel, this is the channel you use in LinkMessages
integer debug = FALSE;      // if set to TRUE, debug info appears
integer dialogchannel ;         // dialog boxes
integer nPrims;                 // total number of prims
integer wantname;               // flag indicating we are waiting for a name to be chatted
integer wantnum;                // flag asking for numbers to be chatted.
integer finished = FALSE;        // flag to only show the recorded animations
// Link messages
integer CLEAR = -234756;
integer DATA = -234757;
integer COMPILE = -234758;
integer DIE = -234759;

// the list of coords
list masterlist;        // master list of all positions
list llastPrimList;      // storage of the last prim position we learned
string curranimation;   // what we are playing
integer STRIDE = 5;     // size of the master list
integer lastSTRIDE = 3; // size of the last prim list
integer listener;       // temp listener when we are waiting for them to give us a name
vector InitSize;        // the initial size when the prims were recorded
list LoadedAnims;       // animations added to the Menu display

DEBUG(string msg)
{
    if (debug) llOwnerSay("// " + msg);
}

Record()
{
    if (llStringLength(curranimation) > 0)
    {
        integer foundmovement = 0;      // will be set if any child moved
        integer PrimCounter ;        // skip past the root prim
        for (PrimCounter =2; PrimCounter <= nPrims; PrimCounter++ )
        {
            //DEBUG("Checking Prim " + (string) PrimCounter);

            list my_list = llGetLinkPrimitiveParams(PrimCounter,[PRIM_POSITION,PRIM_ROTATION, PRIM_SIZE ]);
            // position is always in region coordinates, even if the prim is a child or the root prim of an attachment.
            // rot is always the global rotation, even if the prim is a child or the root prim of an attachment.
            // get current prim pos, rot and size
            vector      vrealPrimPos    = llList2Vector (my_list,0) - llGetPos();   // position subtract Global Pos
            vrealPrimPos /= llGetRot();
            rotation    rrealPrimRot    = llList2Rot    (my_list,1) / llGetRot();   // rotation subtract Global Rot
            vector      vrealPrimSize   = llList2Vector (my_list,2);                 // size

            // compare it to the last one we had
            integer iindex = (PrimCounter - 2) * lastSTRIDE;    // zeroth position is PrimCounter - start, or 2

            // get the last thing we remembered about this prim
            vector      vlastPrimPos    = llList2Vector     (llastPrimList, iindex);
            rotation    rlastPrimRot    = llList2Rot        (llastPrimList, iindex+1);
            vector      vlastPrimSize   = llList2Vector     (llastPrimList, iindex+2);

            //if (debug)
            //{
            //    vrealPrimPos = <1,2,llFrand(1)>; // make a small change for debugging in LSL Editor
            //}

            // if anything changed on this prim, we must record it.
            if (vlastPrimPos != vrealPrimPos ||
                rlastPrimRot != rrealPrimRot ||
                vlastPrimSize!= vrealPrimSize
                    )
                    {
                        foundmovement++;

                        //Save changes in the master list of all animations
                        masterlist += curranimation;
                        masterlist += (float) PrimCounter;
                        masterlist += vrealPrimPos;
                        masterlist += rrealPrimRot;
                        masterlist += vrealPrimSize;

                        string msg =  curranimation + "|" + (string) PrimCounter + "|" + (string) vrealPrimPos + "|" + (string) rrealPrimRot + "|" + (string) vrealPrimSize ;
                        llMessageLinked(LINK_ROOT,DATA,msg,"");

                        // update the last movement list
                        llastPrimList = llListReplaceList(llastPrimList,[vrealPrimPos],iindex,iindex);
                        llastPrimList = llListReplaceList(llastPrimList,[rrealPrimRot],iindex+1,iindex+1);
                        llastPrimList = llListReplaceList(llastPrimList,[vrealPrimSize],iindex+2,iindex+2);

                    } // if
            else
            {
                //DEBUG( (string) PrimCounter);
            }
        } // for

        //DEBUG("history:" + llDumpList2String(llastPrimList,":"));

        if (foundmovement)
        {
            llOwnerSay("Recorded " + (string) foundmovement + " prims" );
        }
        else
        {
            llOwnerSay("You must move at least one child prim.");
        }
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
    llMessageLinked(LINK_ROOT,CLEAR,"","");
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
        primpos /= llGetRot();
        rotation primrot    = llList2Rot    (my_list,1) / llGetRot();
        vector primsize     = llList2Vector (my_list,2) ;


        llastPrimList += primpos;
        llastPrimList += primrot;
        llastPrimList += primsize;
        counter++;
    }
    llOwnerSay("There are " + (string) counter + " animatable prims");
}

DumpBack ()
{
    integer imax = llGetListLength(masterlist);
    integer howmany = imax / STRIDE ;
    llOwnerSay("Preprocessing " + (string) howmany + " movements. " );
    llMessageLinked(LINK_ROOT,COMPILE,"","");
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

        vector scale = llGetScale();
        float delta =  scale.x / InitSize.x ;   // see if the root prim has grown or shrunk as a percentage
        if (saniName == name)
        {
            float fprimNum      = llList2Float(masterlist,i+1);
            vector  vPos        = llList2Vector(masterlist,i+2);
            rotation rRot       = llList2Rot(masterlist,i+3) ;
            vector vprimSize    = llList2Vector(masterlist,i+4) ;

            vPos *= delta;                           // add any difference in size to it positions there
            vprimSize *= delta;                      // grow the child prim, too

            // support negative prim numbers as a delay
            if (fprimNum < 0)
            {
                // DEBUG("Sleeping " + (string) (fprimNum * -1));
                llSleep((float) fprimNum * -1);
            }
            else
            {
                // set the local pos and locat rot to the prims orientation and position
                rRot  = calcChildRot(rRot);

                list actions = [PRIM_POSITION,vPos,PRIM_ROTATION,rRot,PRIM_SIZE,vprimSize];
                //DEBUG("Moving prim :" + (string) fprimNum + ":" + llDumpList2String(actions,":"));

                llSetLinkPrimitiveParamsFast((integer) fprimNum,actions);
            }
        }
    }
}

MakeMenu()
{
    list amenu ;
    if (finished)
           amenu = LoadedAnims;
    else
        amenu = ["Reset","Record","Help","Name","Compile","Pause", "Finish"] + LoadedAnims;

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
        llOwnerSay("Prim count = " + (string) nPrims);
        Clear();

        dialogchannel = (integer) (llFrand(100) +600);
        MakeMenu();
    }


    touch_start(integer total_number)
    {
        MakeMenu();
    }

    listen( integer channel, string name, key id, string message )
    {
        if (message == "Finish")
        {
            finished =TRUE;
            MakeMenu();
        }
        else if (message == "Reset")
        {
            llResetScript();
        }
        else if (wantnum)
        {
            float num = (float) message;
            if (num > 0.0)
            {
                num = -1 * (num /1000);
                masterlist += curranimation;
                masterlist += num;
                masterlist += <0,0,0>;  // pos
                masterlist += <0,0,0,1>;// rot
                masterlist += <0,0,0>;  // size
                string msg =  curranimation + "|" + (string) num + "|<0,0,0>|<0,0,0,1>|<0,0,0>" ;
                llMessageLinked(LINK_ROOT,DATA,msg,"");
            }
            else
            {
                llOwnerSay("Please enter numbers in milliseconds. 1000=1000ms = 1 second. 500=500ms = 1/2 a second.");
                llOwnerSay("What is a milliHelen?  A milliHelen is a face that can launch one ship!");
            }
            wantnum = FALSE;
            MakeMenu();
        }
        else if (message =="Pause")
        {
            wantnum= TRUE;
            llListenRemove(listener);
            listener = llListen(dialogchannel,"","","");
            llTextBox(llGetOwner(), "Enter a delay in milliseconds:\n1000 = 1 second\n500 = 1/2 second",dialogchannel);
        }
        else if (message == "Record")
        {
            Record();
            MakeMenu();
        }
        else if (message == "Name")
        {
            llOwnerSay("Enter a new name, or type the animation name on channel /" + (string) dialogchannel);

            wantname = TRUE;
            MakeMenu();
            llTextBox(llGetOwner(),"Enter an Animation Name",dialogchannel);
        }
        else if (message == "Compile")
        {
            DumpBack();
            MakeMenu();
        }
        else if (message == "Help")
        {
            llLoadURL(llGetOwner(),"View online help", "http://secondlife.mitsi.com/secondlife/Posts/Prim-Compiler");
        }
        else if (wantname)
        {
            curranimation = message;
            LoadedAnims += message;

            MakeMenu();
            llOwnerSay("Recording is ready for animation '" + curranimation + "'");
            llOwnerSay("Position any child  prims, then select the menu item 'Record', and repeat as necessary. When finished, click 'Compile' to save the animation, or click the animation name to play it back.  Click 'Name' to start a new animation sequence");
            wantname = 0;
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
