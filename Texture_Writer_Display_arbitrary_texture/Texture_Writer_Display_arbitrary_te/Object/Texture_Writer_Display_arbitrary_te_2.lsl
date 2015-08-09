// :CATEGORY:TExture
// :NAME:Texture_Writer_Display_arbitrary_texture
// :AUTHOR:Sparti Carroll
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:881
// :NUM:1244
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Tile script
// :CODE:
// Writer Tile Script
// NB NegX is a temporary solution, it offsets tiles to negative X and  uses different rotation (Zaxis 0) for writing along south edge of island
// 16nov06 PG experiments with moving textures around in SL
// 21nov06 PG formerly Texture Wheel
// ZZZ use general block script, or derivative of it, so that instructions are spoken to block after rezzing, rather than all via start_param
// ZZZ use private high channel numbers for children - told via start_param
// make script which listens... when they are touched they increment their cell number
// they listen on private iMyChannel and pick out letter position to spin to from word said - for their cell number. Normally told cell number when rezzed by maker

//Simple OpenSource Licence (I am trusting you to be nice)
//1.  PLEASE SEND ME UPDATES TO THE CODE
//2.  You can do what you want with this code and object including selling it in other objects and so on. 
//You can sell it in closed source objects if you must, but please try to send any updates or
//improvements back to me for possible inclusion in the main trunk of development.
//3.  You must always leave these instructions in any object created; notecard written; posting to
//any electronic medium such as Forum, Email &c. of the source code & generally be nice (as
//already requested!)
//4.  You must not claim that anyone apart from sparti Carroll wrote the original version of this software.
//5.  You can add and edit things below =THE LINE= but please try  to keep it all making sense.
//Thank you for your co-operation
//sparti Carroll


integer iMyChannel = -1;    //I display things from messages spoken on this channel
integer iListen;
integer iMyCellNumber;
float fXStep;
float fYStep;
vector vRezPos;  // Where I was rezzed
vector vBaseOffset = <0,0,1>;    // all are shifted by this
vector vOffsetDelta;

integer iFlagDebug = 0;        // really needs preprocessor

// characters in grid
string sGrid;

string sCurrentChar = "";

// HUD constants
integer HUDcenter2 = 31;
integer HUDtopright = 32;
integer HUDtop = 33;
integer HUDtopleft = 34;
integer HUDcenter = 35;
integer HUDbottomleft = 36;
integer HUDbottom = 37;
integer HUDbottomright = 38;

DEBUG(list lBits) {
    if (iFlagDebug) {
        llSay(0, llList2CSV(lBits));
    }
}

set_hudpos(integer whereami) {
    vector my_size = llGetScale();
    vector v_atpos;
    if (whereami == HUDbottomleft) v_atpos = <0,-my_size.y/2,0.06+my_size.z/2>;
    else if (whereami == HUDtopleft) v_atpos = <0,-my_size.y/2,-0.06-my_size.z/2>;
    else if (whereami == HUDbottom) v_atpos = <0,0,0.06 + my_size.z/2>;
    else if (whereami == HUDbottomright) v_atpos = <0,0.5 + my_size.y,0.06 + my_size.z/2>;
    else if (whereami == HUDtop) v_atpos = <0,0,-0.06-my_size.z/2>;
    else if (whereami == HUDtopright) v_atpos = <0,0.5 + my_size.y,-0.06-my_size.z/2>;
    else if (whereami == HUDcenter || whereami == HUDcenter2) v_atpos = <0,0,0>;
    llSetPos(v_atpos);
}

DoAttach(key kAttachedTo) {
    if (kAttachedTo != NULL_KEY) {
        // something
        if (iFlagDebug || iMyCellNumber == 0) {
            // YYY move if cell 0 as only one need do it - might need cell 0 to be base of linked set...
            // adjust position for HUD
            integer whereami = llGetAttached();
            if (whereami == 0) {
                llOwnerSay("Please wear on the HUD");
            } else {
                set_hudpos(whereami);
            }
        }
    }
}

Reset() {
    fXStep = 16;
    fYStep = 10;
    if (iMyChannel != -1) {
        AnnounceChannel();
    }
    sGrid = " !\"#$%&'()*+,-./0123456789:;<=>?";
    sGrid += "@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_";
    sGrid += "'abcdefghijklmnopqrstuvwxyz{|}~";
    // ZZZ bear in mind we could do entities/smilies even coloured ones!
    // ZZZ could also include an escaping syntax so can refer to textures explicitly ??
    list lMyPrim = llGetPrimitiveParams([PRIM_SIZE]);
    vector vMyPrimSize = llList2Vector(lMyPrim,0);
    DEBUG(["My Size is",vMyPrimSize]);
    vOffsetDelta =  <0,-vMyPrimSize.y,0>;
}

AnnounceChannel() {
    DEBUG(["Channel",iMyChannel,", Cell Number",iMyCellNumber]);
}

SetPosition(vector targetpos) {
   while (llVecDist(llGetPos(),targetpos) > 0.001) llSetPos(targetpos);
}

SetCorrectPosition() {
    DEBUG(["Offset Delta is",vOffsetDelta]);
    SetPosition(vRezPos + vBaseOffset + (iMyCellNumber * vOffsetDelta));
}

RotateToGridpos(integer iX,integer iY) 
{
    float fX = ((iX +- 0.5)/ fXStep);
    float fY = ((iY - 0.5)/ fYStep);
    DEBUG(["Cell ",iMyCellNumber,"moving to",fX,",",fY]);
    llOffsetTexture(fX,fY,ALL_SIDES);        // 0-5|ALL_SIDES
}

RotateToGridposForChar(string sChar) {
    // calculate position to use for display, for now we only do fairly standard characters
    integer iX;
    integer iY;
    integer iPos = llSubStringIndex(sGrid,sChar);
    if (iPos == -1) {
        // unknown so rotate to blank
        iX = -7;
        iY =5;
    } else {
        integer iRow = iPos / 16;
        integer iCol = iPos % 16;
        iY = 5 - iRow;
        iX = iCol - 7;
    }
    RotateToGridpos(iX,iY);
}

SetTextureCharacter(string sChar) {
    if (iFlagDebug) {
        DEBUG(["Cell ",iMyCellNumber,"setting char [",sChar,"]"]);
        llSetText(sChar,<1,1,1>,1.0);
    }
    RotateToGridposForChar(sChar);
    sCurrentChar = sChar;    
}

Command_Say(string sMessage) {
    if (iMyCellNumber > llStringLength(sMessage)) {
        SetTextureCharacter(" ");
    }
    else {
        string sOneChar = llGetSubString(sMessage,iMyCellNumber,iMyCellNumber);
        SetTextureCharacter(sOneChar);
    }
}

Command_Sax(string sMessage) {
    // say command for one recipient
    list lBits = llParseString2List(sMessage,[":"],[]);
    integer iCellNumber = llList2Integer(lBits,0);
    if (iCellNumber == iMyCellNumber) {
        string sSetTo = llList2String(lBits,1);
        // ZZZ could have extended character shift, or do that via different command, e.g. _Saw
        SetTextureCharacter(sSetTo);
    }
}

ProcessListen(string sMessage) {
    DEBUG(["Message heard by ",iMyCellNumber," is [",sMessage,"]"]);
    integer iMessageLength = llStringLength(sMessage);
    if (iMessageLength >= 3) {
        string sCommand = llGetSubString(sMessage,0,2);
        string sParams = llGetSubString(sMessage,3,-1);
        if (sCommand == "SAY") {
            Command_Say(sParams);
        } else if (sCommand == "SAX") {
            Command_Sax(sParams);
        }
    }
}

default
{
    state_entry()
    {
        DEBUG(["state_entry, channel=",iMyChannel]);
        Reset();
        DEBUG(["state_entry.after_Reset, channel=",iMyChannel]);
    }
    
    on_rez(integer start_param) {
        DEBUG(["on_rez, channel=",iMyChannel]);
        Reset();
        if (start_param != 0) {
            start_param -= 1;
            iMyCellNumber = start_param % 1000;    // 3 digits for cell number, so max limit 1000 cells in single rez - probably enough ?
            iMyChannel = start_param / 1000;    // channel number I will listen on
            vRezPos = llGetPos();
            SetCorrectPosition();
        }
        if (iMyChannel != -1) {
            iListen = llListen(iMyChannel,"","","");
        }
        // ZZZ if cell 0 then link to others/request permission
        DEBUG(["on_rez.after_Reset, channel=",iMyChannel]);
        if (iMyCellNumber == 0) {
            state master;
        }
    }
    
    touch_start(integer total_number)
    {    // Send message back to control object: YYY would have to be llSay or llShout for non hud things
        string sGoBack = "0";    // "1" will be 'go back area touched'
        vector vTouchPos = llDetectedPos(0);
        // ZZZ determine whether 'go back' clicked
        string sNotify = (string)iMyCellNumber + ":" + sGoBack + ":" + sCurrentChar;
        llMessageLinked(LINK_ALL_OTHERS,100,sNotify,NULL_KEY);
    }
    
    listen(integer iChannel, string sName, key kID, string sMessage) {
        ProcessListen(sMessage);
    }
    
    attach(key kAttachedTo) {
        DoAttach(kAttachedTo);
    }
}

// Same but different for master object (0)
state master {
    state_entry() {
        DEBUG(["Muhahaha I am the master"]);
        if (iMyChannel != -1) {
            iListen = llListen(iMyChannel,"","","");
        }
    }
    
    on_rez(integer start_param) {
        // if rezzed and in master state we stay here (becoming master is irreversible and happens only once in objects lifetime
        if (iMyChannel != -1) {
            iListen = llListen(iMyChannel,"","","");
        }
        // ZZZ if cell 0 then link to others/request permission
        DEBUG(["on_rez(MASTER).after_Reset, channel=",iMyChannel]);
    }

    touch_start(integer total_number)
    {    // Send message back to control object: YYY would have to be llSay or llShout for non hud things
        string sGoBack = "0";    // "1" will be 'go back area touched'
        vector vTouchPos = llDetectedPos(0);
        // ZZZ determine whether 'go back' clicked
        string sNotify = (string)iMyCellNumber + ":" + sGoBack + ":" + sCurrentChar;
        DEBUG([iMyCellNumber," was touched"]);
        llMessageLinked(LINK_SET,100,sNotify,NULL_KEY);
    }  
    
    link_message(integer iSender,integer iNum,string sMessage,key kId) {
        // message received, something touched
        llOwnerSay("Controller received [" + (string)iNum + "=" + sMessage + "]");        // ZZZ could actually rez a different object for the controller if we get short of single script space, or have extra script with link_message() only in controller
        list lBits = llParseString2List(sMessage,[":"],[]);
        integer iCellNumber = llList2Integer(lBits,0);    // ok im not using it as integer here, but might later
        integer iGoBack = llList2Integer(lBits,1);
        string sNotifyChar = llList2String(lBits,2);
        // YYY for testing: send back commands to swap with my char.
        // Also note that these should be via message linked in first place (after hearing AV commands)
        llSay(iMyChannel,"SAX:" + (string)iCellNumber + ":" + sCurrentChar);
        SetTextureCharacter(sNotifyChar);
    }

    listen(integer iChannel, string sName, key kID, string sMessage) {
        ProcessListen(sMessage);
    }

    attach(key kAttachedTo) {
        DoAttach(kAttachedTo);
    }
}
