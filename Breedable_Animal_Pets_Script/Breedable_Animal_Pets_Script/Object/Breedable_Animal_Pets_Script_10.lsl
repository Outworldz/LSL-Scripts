// :CATEGORY:Animal
// :NAME:Breedable_Animal_Pets_Script
// :AUTHOR:Xundra Snowpaw
// :CREATED:2011-07-25 13:48:33.917
// :EDITED:2013-09-18 15:38:49
// :ID:115
// :NUM:165
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// EggCup: xs_eggcup.lsl
// :CODE:
integer API_CHANNEL = -999198;

float VERSION = 0.22;

string  SECRET_PASSWORD = "top secret";
integer SECRET_NUMBER = 99999;
key     YOUR_UUID = "00000000-0000-0000-0000-000000000000";
integer EGG_CHANNEL = -999193;
integer BOX_CHANNEL = -999195;

// DON'T CHANGE THE FOLLOWING! (Unless you know what you are doing!)

integer XTEA_DELTA      = 0x9E3779B9; // (sqrt(5) - 1) * 2^31
integer xtea_num_rounds = 6;
list    xtea_key        = [0, 0, 0, 0];

integer hex2int(string hex) {
    if(llGetSubString(hex,0,1) == "0x")
        return (integer)hex;
    if(llGetSubString(hex,0,0) == "x")
        return (integer)("0"+hex);
    return(integer)("0x"+hex);
}


// Convers any string to a 32 char MD5 string and then to a list of
// 4 * 32 bit integers = 128 bit Key. MD5 ensures always a specific
// 128 bit key is generated for any string passed.
list xtea_key_from_string( string str )
{
    str = llMD5String(str,0); // Use Nonce = 0
    return [    hex2int(llGetSubString(  str,  0,  7)),
        hex2int(llGetSubString(  str,  8,  15)),
        hex2int(llGetSubString(  str,  16,  23)),
        hex2int(llGetSubString(  str,  24,  31))];
}

// Encipher two integers and return the result as a 12-byte string
// containing two base64-encoded integers.
string xtea_encipher( integer v0, integer v1 )
{
    integer num_rounds = xtea_num_rounds;
    integer sum = 0;
    do {
        // LSL does not have unsigned integers, so when shifting right we
        // have to mask out sign-extension bits.
        v0  += (((v1 << 4) ^ ((v1 >> 5) & 0x07FFFFFF)) + v1) ^ (sum + llList2Integer(xtea_key, sum & 3));
        sum +=  XTEA_DELTA;
        v1  += (((v0 << 4) ^ ((v0 >> 5) & 0x07FFFFFF)) + v0) ^ (sum + llList2Integer(xtea_key, (sum >> 11) & 3));

    } while( num_rounds = ~-num_rounds );
    //return only first 6 chars to remove "=="'s and compact encrypted text.
    return llGetSubString(llIntegerToBase64(v0),0,5) +
        llGetSubString(llIntegerToBase64(v1),0,5);
}

// Decipher two base64-encoded integers and return the FIRST 30 BITS of
// each as one 10-byte base64-encoded string.
string xtea_decipher( integer v0, integer v1 )
{
    integer num_rounds = xtea_num_rounds;
    integer sum = XTEA_DELTA*xtea_num_rounds;
    do {
        // LSL does not have unsigned integers, so when shifting right we
        // have to mask out sign-extension bits.
        v1  -= (((v0 << 4) ^ ((v0 >> 5) & 0x07FFFFFF)) + v0) ^ (sum + llList2Integer(xtea_key, (sum>>11) & 3));
        sum -= XTEA_DELTA;
        v0  -= (((v1 << 4) ^ ((v1 >> 5) & 0x07FFFFFF)) + v1) ^ (sum + llList2Integer(xtea_key, sum  & 3));
    } while ( num_rounds = ~-num_rounds );

    return llGetSubString(llIntegerToBase64(v0), 0, 4) +
        llGetSubString(llIntegerToBase64(v1), 0, 4);
}

// Encrypt a full string using XTEA.
string xtea_encrypt_string( string str )
{
    // encode string
    str = llStringToBase64(str);
    // remove trailing =s so we can do our own 0 padding
    integer i = llSubStringIndex( str, "=" );
    if ( i != -1 )
        str = llDeleteSubString( str, i, -1 );

    // we don't want to process padding, so get length before adding it
    integer len = llStringLength(str);

    // zero pad
    str += "AAAAAAAAAA=";

    string result;
    i = 0;

    do {
        // encipher 30 (5*6) bits at a time.
        result += xtea_encipher(llBase64ToInteger(llGetSubString(str,   i, i + 4) + "A="), llBase64ToInteger(llGetSubString(str, i+5, i + 9) + "A="));
        i+=10;
    } while ( i < len );

    return result;
}

// Decrypt a full string using XTEA
string xtea_decrypt_string( string str ) {
    integer len = llStringLength(str);
    integer i=0;
    string result;
    //llOwnerSay(str);
    do {
        integer v0;
        integer v1;

        v0 = llBase64ToInteger(llGetSubString(str,   i, i + 5) + "==");
        i+= 6;
        v1 = llBase64ToInteger(llGetSubString(str,   i, i + 5) + "==");
        i+= 6;

        result += xtea_decipher(v0, v1);
    } while ( i < len );

    // Replace multiple trailing zeroes with a single one

    i = llStringLength(result) - 1;
    while ( llGetSubString(result, i - 1, i) == "AA" ){
        result = llDeleteSubString(result, i, i);
        i--;
    }
    i = llStringLength(result) - 1;
    //    while (llGetSubString(result, i, i + 1) == "A" ) {
    //        i--;
    //    }
    result = llGetSubString(result, 0, i+1);
    i = llStringLength(result);
    integer mod = i%4; //Depending on encoded length diffrent appends are needed
    if(mod == 1) result += "A==";
    else if(mod == 2 ) result += "==";
    else if(mod == 3) result += "=";

    return llBase64ToString(result);
}

string base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

vector colour1;
vector colour2;
integer gen;
integer shine;
float glow;
key uuid;
integer listener;
integer owner_touch;
string special;

say_details()
{

    string myshine;

    if (shine == 0) {
        myshine = "None";
    } else
    if (shine == 1) {
        myshine = "Low";
    } else
    if (shine == 2) {
        myshine = "Medium";
    } else
    if (shine == 3) {
        myshine = "High";
    }

    llWhisper(0, "Head/Body Colour: " + (string)colour1);
    llWhisper(0, "Tail/Wing Colour: " + (string)colour2);
    llWhisper(0, "Shine: " + myshine);
    llWhisper(0, "Glow: " + (string)((integer)(glow * 100)) + "%");
    llWhisper(0, "Special: " + special);
    llWhisper(0, "Generation: " + (string)gen);

    llSay(API_CHANNEL, "XSQuail^" + (string)llGetKey() + "^"+ (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^XSQuailEnd");
}

set_colours(vector c1, vector c2, integer shine, float glow)
{
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, c2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
    llSetLinkPrimitiveParams(3, [PRIM_COLOR, ALL_SIDES, c1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
}

default
{
    state_entry()
    {
        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
        uuid = NULL_KEY;
        listener = llListen(BOX_CHANNEL, "", "", "");
    }

    listen(integer channel, string name, key id, string msg)
    {

        if (llGetOwnerKey(id) != llGetOwner()) {
            return;
        }

        list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);

        if (uuid == NULL_KEY) {
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 2) == "CUP_PING") {
                uuid = id;
                llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^CUP_PONG^" + (string)VERSION));
                llSetTimerEvent(15.0);
            }
        } else if (uuid == id) {
                if (llList2String(data, 0) == "XSPET" && llList2Key(data, 1) == llGetKey()) {
                    llSetTimerEvent(0.0);
                    colour1 = (vector)llList2String(data, 2);
                    colour2 = (vector)llList2String(data, 3);
                    shine = llList2Integer(data, 4);
                    glow = llList2Float(data, 5);
                    gen = llList2Integer(data, 6);
                    special = llList2String(data, 7);
                    llListenRemove(listener);
                    llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^CUP_DIE^"));
                    state full;
                } else
            if (llList2String(data, 0) == "XSPET" && llList2Key(data, 1) != llGetKey()) {
                uuid = NULL_KEY;
            }
        }
    }
    timer()
    {
        llSetTimerEvent(0.0);
        uuid = NULL_KEY;
    }
}

state full
{
    state_entry()
    {
        string my_special = "";
        if (special != "Normal") {
            my_special = "(" + special + ") ";
        }
        llSetObjectName("XS Egg Cup: " + my_special + "S:" + (string)shine + " G:" + (string)((integer)(glow * 100)) + "% <" + llGetSubString((string)colour1.x, 0, 3) + "," + llGetSubString((string)colour1.y, 0, 3) + "," + llGetSubString((string)colour1.z, 0, 3) + ">/<" + llGetSubString((string)colour2.x, 0, 3) + "," + llGetSubString((string)colour2.y, 0, 3) + "," + llGetSubString((string)colour2.z, 0, 3) + ">");
        set_colours(colour1, colour2, shine, glow);
        llListen(API_CHANNEL, "", "", "");
        if (special != "Normal") {
            llSetText(special, <1,1,1>, 1.0);
        }
    }

    touch_start(integer num)
    {
        owner_touch = 0;

        say_details();

        if (llKey2Name(llGetOwner()) == "Ami Pollemis") {
            llOwnerSay("Sorry Ami, you have been banned.");
            return;
        }

        if (llDetectedKey(0) == llGetOwner()) {
            owner_touch = 1;
            integer chan = (integer)llFrand(10000.0) + 1000;
            listener = llListen(chan, "", llGetOwner(), "");

            llDialog(llGetOwner(), "Would you like to unpackage me?", ["Yes", "No"], chan);
        }
        llSetTimerEvent(20.0);
    }

    timer()
    {
        //llOwnerSay("Menu timeout.");
        if (owner_touch == 1) {
            llListenRemove(listener);
        }
        llSetTimerEvent(0.0);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == API_CHANNEL) {
            list data = llParseString2List(msg, ["^"], []);
            if (llList2String(data, 0) == "XSQuail" && llList2Key(data, 1) == llGetKey()) {
                llSay(API_CHANNEL, "XSQuail^" + (string)llGetKey() + "^"+ (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^XSQuailEnd");
            }
        } else {
                llListenRemove(listener);
            if (msg == "Yes") {
                state unbox;
            }
        }
    }
}

state unbox
{
    state_entry()
    {
        llRezObject("XS Egg", llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
    }

    object_rez(key id)
    {
        listener = llListen(BOX_CHANNEL, "", id, "");
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == BOX_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 2) == "EGG_READY") {

                llGiveInventory(id, "XS Egg");
                llGiveInventory(id, "Quail");

                llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^UNBOX^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)gen + "^" + (string)shine + "^" + (string)glow + "^" + special));
                llDie();
            }
        }
    }
}
