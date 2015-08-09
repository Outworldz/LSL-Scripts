// :CATEGORY:Animal
// :NAME:Breedable_Animal_Pets_Script
// :AUTHOR:Xundra Snowpaw
// :CREATED:2011-07-25 13:48:33.917
// :EDITED:2013-09-18 15:38:49
// :ID:115
// :NUM:171
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// xs_debug - a script tointercept messages inside and outside your bird// Version 2, 10-2-2011 by Ferd Frederix// Prints out the channel and the link number
// :CODE:
integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;
integer EGG_CHANNEL = -999193;


list channels = [
 "FOOD_CHANNEL" , -999191,
 "ANIMAL_CHANNEL" , -999192,
 "HOME_CHANNEL" , -999194,
 "BOX_CHANNEL" , -999195,
 "ACC_CHANNEL" , -999196,
 "UPDATE_CHANNEL" , -999197,
 "EGG_CHANNEL" , -999193
];

list messages = [
" LINK_AGE_START " , 800,
" LINK_FOOD_CONSUME " , 900,
" LINK_FOODMINUS " , 901,
" LINK_HUNGRY " , 903,
" LINK_HAMOUNT " , 904,
" LINK_SET_HOME " , 910,
" LINK_MOVER " , 911,
" LINK_FOODIE_CLR " , 920,
" LINK_FOODIE " , 921,
" LINK_COLOR1 " , 930,
" LINK_COLOR2 " , 931,
" LINK_SEX " , 932,
" LINK_SHINE " , 933,
" LINK_GLOW " , 934,
" LINK_GEN " , 935,
" LINK_MAGE " , 940,
" LINK_DAYTIME " , 941,
" LINK_GET_AGE " , 942,
" LINK_PUT_AGE " , 943,
" LINK_PACKAGE " , 950,
" LINK_SEEK_FEMALE " , 960,
" LINK_MALE_BREED_CALL " , 961,
" LINK_SIGNAL_ELIGIBLE"  , 962,
" LINK_FEMALE_ELIGIBLE " , 963,
" LINK_CALL_MALE " , 964,
" LINK_MALE_ON_THE_WAY " , 965,
" LINK_FEMALE_LOCATION " , 966,
" LINK_CALL_MALE_INFO " , 968,
" LINK_RQST_BREED ", 967,
" LINK_MALE_INFO " , 969,
" LINK_LAY_EGG " , 970,          
" LINK_BREED_FAIL " , 971,
" LINK_PREGNANT " , 972,
" LINK_SLEEPING " , 990,
" LINK_UNSLEEPING " , 991,
" LINK_SOUND " , 1001,
" LINK_SPECIAL " , 1010,
" LINK_PREGNANCY_TIME " , 5000,
" LINK_SLEEP " , 7999,
" LINK_TIMER " , 8000,
" LINK_DIE " , 9999
];




string  SECRET_PASSWORD = "top secret";
integer SECRET_NUMBER = 99999;


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

default
{
    state_entry()
    {
        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
        llListen(FOOD_CHANNEL,"","","");
        llListen(ANIMAL_CHANNEL,"","","");
        llListen(HOME_CHANNEL,"","","");
        llListen(BOX_CHANNEL,"","","");
        llListen(ACC_CHANNEL,"","","");
        llListen(UPDATE_CHANNEL,"","","");
        llListen(EGG_CHANNEL,"","","");
    }

    listen(integer channel,string name, key id, string message)
    {
        integer index = llListFindList(channels,[channel]);    // see if a valid channel
        string aname = "unkown";
        if (index >= 0)
        {
             aname =   llList2String(channels,index-1); 
        }
        llOwnerSay(llGetObjectName() + ":channel:" + aname + ":" + xtea_decrypt_string(message) );
    }
    
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        integer index = llListFindList(messages,[num]);    // see if a valid channel
        string aname = "unkown";
        if (index >= 0)
        {
             aname =   llList2String(messages,index-1); 
        }

        llOwnerSay(llGetObjectName() + ":" + aname + " : string:" + str + " : key:" + (string) id);
        
    }
    
    touch_start(integer total_number)
    {
        llSay(0, "Touched.");
    }
}
