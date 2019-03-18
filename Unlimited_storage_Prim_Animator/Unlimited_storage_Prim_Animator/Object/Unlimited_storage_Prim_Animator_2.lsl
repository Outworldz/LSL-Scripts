// :CATEGORY:Animation
// :NAME:Unlimited_storage_Prim_Animator
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-09-07 21:37:12.857
// :EDITED:2013-09-18 15:39:08
// :ID:936
// :NUM:1345
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script must be named 'Store 0'.   Yeasch script saves about 200 prim animations when compiled into mono.  You can add additional storage scripts by naming them sequentially Store 1, STore 2, and so on.
// :CODE:
// Prim Animator DB
// 06/20/2011
// Author Fred Beckhusen (Ferd Frederix)

// Prim Storage script.
// Copyright 2011 Fred Beckhusen - all rights reserved


integer debug =FALSE;
// return codes
integer playchannel = 2000; // the script to do the actual playback
integer countchannel= 2001; // the script to do the actual playback

// constants
integer MAX = 999;        // Maximum number of anims per script, if set to very high, oit clamps with free memory < 1000
integer full  = FALSE;  // this script RAM is full


// Commands
integer Erase   = 100;    // erase  command
integer Add     = 101;      // add a coordinate
integer Publish = 102;  // save to db
integer Name    = 103;     // send Name to db
integer Password = 104; // send Password to db
integer Play    = 105;     //

// vars
integer myNum = 0;  // the number at the end of this script name 0, 1, 2....
integer imax;       // total records in store
integer datum;      // the load counter increments as we load anims from db
string MyName;
string MyPassword;


// remote db reading
key kHttpRequestID;

// lists
list names;     // a list of distnct animation names stored here
list db;        // name, prin num, pos, rot, size
integer STRIDE = 5; // 4 items in the above list
integer recordcount = 0;    // how many anims are stored


vector vRootScale ;             // the initial size when the prims were recorded
vector vScaleChange = <1,1,1>;  // The change percent if resized

GetScale(vector orig_size)
{
    //Debug ("Size:" + (string) orig_size);
    vRootScale = orig_size;            // save the size  when we recorded the prims
    vector newScale = llGetScale();
    vScaleChange.x = newScale.x / vRootScale.x;
    vScaleChange.y = newScale.y / vRootScale.y;
    vScaleChange.z = newScale.z / vRootScale.z;

}


rotation calcChildRot(rotation rdeltaRot)
{
    if (llGetAttached())
        return rdeltaRot/llGetLocalRot();
    else
        return rdeltaRot/llGetRootRotation();
}
// Start saving records.  The first record is the prim size.

StartPublishing ()
{
    imax = llGetListLength(db);
    datum = 0;      // point to the first record, counts as we load records
    integer howmany = imax / STRIDE ;
    llOwnerSay((string) howmany + " movements recorded - now saving to server.");
    string url;

    // cannot save or delete unless we are the first prim to Publish
    string save;
    string erase = "0";
    if (myNum == 0) {
        erase = "1";
        save = "Save";
    }

    //Debug( "Saving Size:" + (string) llGetScale());
    url = "http://secondlife.mitsi.com/cgi/animate.plx?Type=";
    url += save;
    url += "&Name=" + llEscapeURL(MyName) + "&Password=" + llEscapeURL(MyPassword);
    url += "&Delete=";
    url += erase;
    url += "&aniName=RootPosition" ;
    url += "&PrimNum=" + (string) 0;
    url += "&Size=" + (string) llGetScale();       // save the scale as the first record
    url += "&Pos=<1,1,1>" ;
    url += "&Rot=<0,0,0,1>" ;

    Debug(url);
    kHttpRequestID = llHTTPRequest(url, [], "");
}



Put()
{
    if (datum < imax)
    {
        string sAniName     = llList2String (db,    datum);
        float fprimNum      = llList2Float  (db,    datum+1);
        vector  vprimPos    = llList2Vector (db,    datum+2);
        rotation rprimRot   = llList2Rot    (db,    datum+3) ;
        vector  vprimSize   = llList2Vector (db,    datum+4);

        string url = "http://secondlife.mitsi.com/cgi/animate.plx?Type=Save&Name=" + llEscapeURL(MyName) + "&Password=" + llEscapeURL(MyPassword);
        url += "&aniName="  + llEscapeURL(sAniName);
        url += "&PrimNum="  + (string) fprimNum;
        url += "&Pos="      + (string) vprimPos;
        url += "&Rot="      + (string) rprimRot;
        url += "&Size="     + (string) vprimSize;

        Debug(url);
        if ((datum/STRIDE) % 10 == 0 && datum)
            llMessageLinked(LINK_THIS,countchannel,"Saved " + (string) (datum/STRIDE) + " records","");


        kHttpRequestID = llHTTPRequest(url, [], "");
        llSleep(1);
        datum += STRIDE;
    }
    else
    {
        llMessageLinked(LINK_THIS,countchannel,(string) (datum/STRIDE) + " movements saved.","");
        llSleep(2.0);
        llMessageLinked(LINK_THIS,countchannel,"","");
    }

}


Debug(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + ":" + msg);
}


default
{
    state_entry()
    {
        string name = llGetScriptName();
        list parts = llParseString2List(name,[" "],[""]);
        myNum = llList2Integer(parts,1);

        vRootScale = llGetScale();
        Add  += 10 * myNum;
    }

    link_message(integer sender_num, integer num, string msg, key id)
    {

        Debug("cmd:" + (string) num + ":" + msg);

        // valid commands only.
        if (num != Erase && num !=  Play && num != Add && num != Publish && num != Name && num!= Password)
            return;

        Debug("cmd:" + (string) num + ":" + msg);


        if (num == Erase)
        {
            db = [];
            Debug((string) myNum + " erased " );
            full   = FALSE;
            recordcount = 0;
            return;
        }
        else if (num == Add)
        {
            if (full)
            {
                Debug((string) myNum + " pass Add on to " + (string) (num +10));
                llMessageLinked(LINK_THIS,num +10,msg,id);
                return;
            }

            //Debug("Add");
            list vecs = llParseString2List(msg,["|"],[""]);

            // Debug(llDumpList2String(vecs,"---"));
            string name= llList2String(vecs,0);
            if (llListFindList(names,[name]) == -1)
                names += name;

            float  fNum         = (float) (llList2String(vecs,1));
            vector  vPos         = (vector) (llList2String(vecs,2));
            rotation  rRot         = (rotation) (llList2String(vecs,3));
            vector  vprimSize    = (vector) (llList2String(vecs,4));

            db += name;
            db += fNum;
            db += vPos;
            db += rRot;
            db += vprimSize;

            recordcount ++;
            Debug("Store contains " + (string) recordcount  + "Records");
            //if (recordcount> MAX)
            //{
            //    Debug("Full, record count = " + (string) recordcount);
            //    full++;
            //}
            if (llGetFreeMemory() < 1000)
            {
                Debug("Full");
                full++;
            }

            Debug("Free:" + (string) llGetFreeMemory());
        }
        else if (num == Name)
        {
            MyName = msg;
        }
        else if (num == Password)
        {
            MyPassword = msg;
        }
        else if (num == Play)
        {
            if (llListFindList(names,[msg]) == -1)
            {
                Debug("Animation " + msg + " not found");
                return;
            }
            integer currpos;
            integer end = recordcount * STRIDE;
            // play back all we find
            for (currpos = 0; currpos < end; currpos+= STRIDE)
            {
                if ( msg == llList2String(db,currpos) )
                {
                    float fPrim         = (float) llList2String(db,currpos+1);
                    vector vPos         = (vector) llList2String(db,currpos+2);
                    rotation rRot         = (rotation) llList2String (db,currpos+3);
                    vector vprimSize     = (vector) llList2String(db,currpos+4);

                    //Debug(msg + "|" +  spos + "|" + srot + "|" + sthesize);
                    GetScale(vRootScale);      // original prim size

                    // set the local pos and locat rot to the prims orientation and position
                    rRot  = calcChildRot(rRot);

                    if (fPrim < 0)
                    {
                        //DebugllOwnerSay("Sleeping " + (string) (fprimNum * -1));
                        llSleep( fPrim * -1);
                    }
                    else if (fPrim > 1 ) // skip root prim
                    {
                        vPos.x *= vScaleChange.x;
                        vprimSize.x *= vScaleChange.x;

                        vPos.y *= vScaleChange.y;
                        vprimSize.y *= vScaleChange.y;

                        vPos.z *= vScaleChange.z;
                        vprimSize.z *= vScaleChange.z;

                        Debug("p=" + (string) fPrim
                            + " l=" + (string) vPos
                            + " r=" + (string) rRot
                            + " s=" + (string) vprimSize);

                        llSetLinkPrimitiveParamsFast((integer) fPrim,[PRIM_POSITION,vPos,PRIM_ROTATION,rRot,PRIM_SIZE,vprimSize]);
                    }
                }
            }
        }
        else if (num == Publish)
        {
            if (myNum)
                llSleep(5);  // time to delete the database and save the root prim
            StartPublishing();
        }
        else
        {
            Debug("Bad command");
        }
    }


    // use for publishing in parallel
    http_response(key queryid, integer status, list metadata, string data)
    {
        if (queryid == kHttpRequestID )
        {
            if (status == 200) // HTTP success status
            {
                Debug(data);
                if (data == "ok")
                {
                    Put();
                    return;
                }
            }
            else
            {
                llOwnerSay("Server Error loading animations");
            }
        }
    }


}
