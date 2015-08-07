// :CATEGORY:TExture
// :NAME:Texture_Writer_Display_arbitrary_texture
// :AUTHOR:Sparti Carroll
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:881
// :NUM:1243
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Each character uses one prim - in this incarnation.// // This can be used to build a HUD (tiny prims) which can display messages or have a variable user interface. It can also be used to create large signs on which you can show messages.// // There is a demonstration large sign in the Chessport sandbox. This one was created to display anything said on channel 0... this simple implementation doesn't feature a controller object for the display and so you need to shout, otherwise only prims near to you will react (try speaking normally to see what I mean).// 
// There are two scripts involved. The first rezzes a set of tiles and the second is the script in the tile. The size of the final display depends on the size of the prims used for the tiles. The texture on the tiles must be set to
// "bf84f91e-549f-e094-1693-278b6b521b12"
// :CODE:


//Rez Tiles Large (for linked sets - if that can be made to work)
// NB NegX is a temporary solution, it offsets tiles to negative X and  uses different rotation (Zaxis 0) for writing along south edge of island
//21nov06 PG based on Rez Word Speakers
//Tells them which character position they are handling on rez
// should speak to children objects and tell them where to go etc. perhaps via bundled messages which they can split apart easily !={!} etc.
// option to vary size of wheels; select different fonts ? (drop in a new font texture not possible due child thing... hmmm)
// LOL - work of art.  Make a wordprocessor, but a bit like moveable type, so if select different fonts etc then new wheels fly into place, can include images too... hmmm
// and spreadsheet ?
// make fruit machines !, or other gaming machines - have a small number of special prizes - vouchers for shops ? / start establishing chains of voucher accepting shops and
// have customer service level guarantees etc.

// Big cooperation game. 2 teams, randomly assigned
// Have to create a word, but at each location the player(s) only have control over 1 letter (each) - or perhaps as many as needed to make game work
// Or use coloured symbols/shapes instead of words... but still with a large texture map.
// Added listen and repeat to channel

// Fruit machine/ noughts and crosses machine

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

integer iAbsoluteNumberOfObjects = 50;

key kOwner;
vector vMyPosition;
vector vRezOffset = <0,0,1>;

integer iFlagDebug = 0;

integer iFlagListenToOwnerOnly = 1;
integer iChannelListenToAvatars = 0;
integer iCommandChannel = 510;        // normal speech in an area  !!! DO NOT USE CHANNEL ZERO WITH OBJECTS IN DEBUG, OR IT GETS A BIT SILLY...!

DEBUG(list lBits) {
    if (iFlagDebug) {
        llSay(0, llList2CSV(lBits));
    }
}

RezSingleObject(integer iObjectNumber) {
    vector vRezPos = vMyPosition + vRezOffset;
    DEBUG(["Try to rez at ",vRezPos," for object ",iObjectNumber]);
    vector vRezRotEuler = <0,0,0> * DEG_TO_RAD;
    rotation rRezRot = llEuler2Rot(vRezRotEuler);
    // ZZZ note channel numbers are cannot be as large (/1000) compared to integer normally allowed. Also communication should be secured.
    llRezObject("Texture Tile Hud Large",vRezPos,<0,0,0>,rRezRot,(iCommandChannel * 1000) + iObjectNumber +1);  // +1 because start param of zero means rezzed as linked item not initial rez
}

RezObjects(integer iNumberOfObjects) {
    integer i;
    for (i = 0; i

Reset() {
    kOwner = llGetOwner();
    vMyPosition = llGetPos();
    llListen(iChannelListenToAvatars,"","","");
}

default {
    state_entry() {
        DEBUG(["State entry"]);
        Reset();
    }
    
    on_rez(integer start_param) {
        Reset();
    }
    
    moving_end() {
        Reset();
    }
    
    // ZZZ also listen to tile talkback channel
    listen(integer iChannel,string sName,key kId,string sMessage) {
        if (iChannel == iChannelListenToAvatars) {
            if (iFlagListenToOwnerOnly == 0 || kId == kOwner) {
                string sCommand = "SAY" + sMessage;
                llShout(iCommandChannel,sCommand);
            }
        }
    }
    
    // XXX simple version rez when touched
    touch_start(integer num_detected) {
        key kAvatar = llDetectedKey(0);
        if (kAvatar == kOwner) {
            DEBUG(["Touched"]);
            RezObjects(iAbsoluteNumberOfObjects);
        }
    }
    
}
