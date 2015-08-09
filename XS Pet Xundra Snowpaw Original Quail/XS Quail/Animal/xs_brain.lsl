// :CATEGORY:XS Pet
// :NAME:XS Pet Xundra Snowpaw Original Quail
// :AUTHOR:Xundra Snowpaw
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:10
// :ID:989
// :NUM:1472
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Original Pet Quail
// :CODE:

float VERSION = 0.22;

string  SECRET_PASSWORD = "top secret";
integer SECRET_NUMBER = 99999;
key     YOUR_UUID = "00000000-0000-0000-0000-000000000000";
integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer EGG_CHANNEL = -999193;
float   FOOD_BOWL_SCAN_INTERVAL = 1800.0;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;

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


integer food_left;
integer random_number;
integer random_number2;
//list    food_bowl_keys;
//list    food_bowl_locations;
integer hunger_amount;
vector colour1;
vector colour2;
                
integer sex;
                
integer shine;
float glow;
                
integer gen;
integer age;

vector mcolour1;
vector mcolour2;
  
integer mshine;
float mglow;
                
integer mgen;
vector home_loc;
key new_egg_key;

integer glow_gene;
string special;

integer mglow_gene;

integer locked;

integer pregnancy_time;

default
{
    state_entry()
    {
        if (llGetOwner() != YOUR_UUID) {
            // someone not the creator reset the script. Thats naughty.
            state dead;
        }
        llSetText("", <1,1,1>, 1.0);
        random_number = 0;
        random_number2 = 0;
        hunger_amount = 0;
        locked = 0;

        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
        llListen(ANIMAL_CHANNEL, "", "", "");
    }
    
    changed(integer change)
    {
        
        if (change & CHANGED_ALLOWED_DROP) {
            if (llGetInventoryType("Quail") != INVENTORY_NONE && llGetInventoryType("XS Egg") != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
            }
        }
        
        if (change & CHANGED_INVENTORY) {
            if (llGetOwner() != YOUR_UUID) {
            
                integer inventory_count = llGetInventoryNumber(INVENTORY_ALL);
                integer extras = 3;
            
            
                if (llGetInventoryType("xs_ager") == INVENTORY_NONE || !llGetScriptState("xs_ager")) {
                    state dead;
                }
                if (llGetInventoryType("xs_infomatic") == INVENTORY_NONE || !llGetScriptState("xs_infomatic")) {
                    state dead;
                }
                if (llGetInventoryType("xs_breeding") == INVENTORY_NONE || !llGetScriptState("xs_breeding")) {
                    state dead;
                }
                if (llGetInventoryType("xs_eater") == INVENTORY_NONE || !llGetScriptState("xs_eater")) {
                    state dead;
                }
                if (llGetInventoryType("xs_movement") == INVENTORY_NONE || !llGetScriptState("xs_movement")) {
                    state dead;
                }
                if (llGetInventoryType("bird_sound") == INVENTORY_NONE) {
                    state dead;
                }
            
            
                if (llGetInventoryType("xs_special") == INVENTORY_NONE) {
                    extras--;
                }
            
                if (llGetInventoryType("XS Egg") == INVENTORY_NONE) {
                    extras--;
                }
            
                if (llGetInventoryType("Quail") == INVENTORY_NONE) {
                    extras--;
                }
                
                if (llGetInventoryType("XS Home Object") == INVENTORY_NONE) {
                    state dead;
                }
            
                if (8 + extras != inventory_count) {
                    state dead;
                }
            
            }
        }
    }
    
    timer()
    {

        llMessageLinked(LINK_SET, 920, "", "");
        // llWhisper(0, "Scanning for food bowls.");
        random_number = (integer)(llFrand(10000.0) + 1);
	llSay(FOOD_CHANNEL, xtea_encrypt_string("XSPET^FOOD_LOCATION^" + (string)random_number + "^" + (string)llGetKey()));
	llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (channel == ANIMAL_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(message), ["^"], []);
            if (llList2String(data, 0) == "XSPET") {
                if (llList2String(data, 1) == "FOOD_LOCATION") {
                    llMessageLinked(LINK_SET, 921, llList2String(data, 3), id);
                } else
                if (llList2String(data, 1) == "FOOD_CONSUME") {
                    if (llList2Integer(data, 2) == random_number2 && llList2Key(data, 3) == llGetKey()) {
                        hunger_amount--;
                        llMessageLinked(LINK_SET, 901, "", "");
                        random_number2 = 0;
                        if (llList2Integer(data, 4) == 1 && glow_gene < 10) {
                            glow_gene ++;
                        }
                    }
                } else
                if (llList2String(data, 1) == "HOME_LOCATION") {
                    vector n_home_loc = (vector)llList2String(data, 2);
                    float home_dis = llList2Float(data, 3);
                    vector my_loc = llGetPos();
    //                llOwnerSay((string)llVecDist(home_loc, my_loc) + " " + (string)my_loc + (string)home_loc + (string)home_dis + llList2String(data, 2));
                    if (llVecDist(n_home_loc, my_loc) <= home_dis && llFabs(llFabs(n_home_loc.z) - llFabs(my_loc.z)) < 1) {
                        if (llGetOwnerKey(id) == llGetOwner()) {
			    home_loc = n_home_loc;
                            llMessageLinked(LINK_SET, 910, (string)n_home_loc + "^" + (string)home_dis, "");
                        }
                    }
                } else
                if (llList2String(data, 1) == "CONFIG" && llList2Key(data, 2) == llGetKey()) {
                    colour1  = (vector)llList2String(data, 3);;
                    colour2 = (vector)llList2String(data, 4);
                
                    sex = llList2Integer(data, 5);
                
                    shine = llList2Integer(data, 6);
                    glow = llList2Float(data, 7);
                
                    gen = llList2Integer(data, 8);
                    integer mage = llList2Integer(data, 9);
                    integer hamount = llList2Integer(data, 10);
                    string myname = llList2String(data, 11);
                    glow_gene = llList2Integer(data, 12);
                    special = llList2String(data, 13);
                
                    llSetLinkPrimitiveParams(5, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(1, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);

    //                llSetLinkColor(8, colour1, ALL_SIDES);
    //                llSetLinkColor(1, colour1, ALL_SIDES);
    
                    llSetLinkPrimitiveParams(7, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(4, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(9, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);                
    //                llSetLinkColor(3, colour2, ALL_SIDES);
    //                llSetLinkColor(2, colour2, ALL_SIDES);
    //                llSetLinkColor(7, colour2, ALL_SIDES);
                
                    llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));
               
                
                    llMessageLinked(LINK_SET, 930, (string)colour1, "");
                    llMessageLinked(LINK_SET, 931, (string)colour2, "");
                    llMessageLinked(LINK_SET, 932, (string)sex, "");
                    llMessageLinked(LINK_SET, 933, (string)shine, "");
                    llMessageLinked(LINK_SET, 934, (string)glow, "");
                    llMessageLinked(LINK_SET, 935, (string)gen, "");
                

                    llMessageLinked(LINK_SET, 940, (string)mage, "");

                
                    if (hamount > 0) {
                        llMessageLinked(LINK_SET, 904, (string)hamount, "");
                    }
                
                    if (name != "Quail") {
                        llSetObjectName(myname);
                    }
                
                    llSetObjectDesc("XS Quail v" + (string)VERSION + " (c) 2010 Xundra Snowpaw");
                
                
                    llMessageLinked(LINK_SET, 1010, special, "");
                
                    llMessageLinked(LINK_SET, 941, "", "");
                
                    llSay(HOME_CHANNEL, "XSPET_PING_HOME");
                 
                    llSetText("", <1,1,1>, 1.0);       
                } else
                if (llList2String(data, 1) == "UPDATE_CONFIG" && llList2Key(data, 2) == llGetKey()) {
                    colour1  = (vector)llList2String(data, 3);;
                    colour2 = (vector)llList2String(data, 4);
                
                    sex = llList2Integer(data, 5);
                
                    shine = llList2Integer(data, 6);
                    glow = llList2Float(data, 7);
                
                    gen = llList2Integer(data, 8);
                    integer mage = llList2Integer(data, 9);
                    integer hamount = llList2Integer(data, 10);
                    string myname = llList2String(data, 11);
                    glow_gene = llList2Integer(data, 12);
                    special = llList2String(data, 13);
                    mcolour1 = (vector)llList2String(data, 14);
                    mcolour2 = (vector)llList2String(data, 15);
                    mshine = llList2Integer(data, 16);
                    mglow = llList2Float(data, 17);
                    mgen = llList2Integer(data, 18);
                    mglow_gene = llList2Integer(data, 19);
                    pregnancy_time = llList2Integer(data, 20);

                    llSetLinkPrimitiveParams(5, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(1, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);

    //                llSetLinkColor(8, colour1, ALL_SIDES);
    //                llSetLinkColor(1, colour1, ALL_SIDES);
    
                    llSetLinkPrimitiveParams(7, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(4, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(9, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);                
    //                llSetLinkColor(3, colour2, ALL_SIDES);
    //                llSetLinkColor(2, colour2, ALL_SIDES);
    //                llSetLinkColor(7, colour2, ALL_SIDES);
                
                    llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));
               
                
                    llMessageLinked(LINK_SET, 930, (string)colour1, "");
                    llMessageLinked(LINK_SET, 931, (string)colour2, "");
                    
                    if (sex == 1) {
                        llMessageLinked(LINK_SET, 932, (string)sex, "");
                    } else {
                        llMessageLinked(LINK_SET, 5000, (string)pregnancy_time, "");
                    }
                    
                    llMessageLinked(LINK_SET, 933, (string)shine, "");
                    llMessageLinked(LINK_SET, 934, (string)glow, "");
                    llMessageLinked(LINK_SET, 935, (string)gen, "");
                

                    llMessageLinked(LINK_SET, 940, (string)mage, "");

                
                    if (hamount > 0) {
                        llMessageLinked(LINK_SET, 904, (string)hamount, "");
                    }
                
                    if (name != "Quail") {
                        llSetObjectName(myname);
                    }
                
                    llSetObjectDesc("XS Quail v" + (string)VERSION + " (c) 2010 Xundra Snowpaw");
                
                
                    llMessageLinked(LINK_SET, 1010, special, "");
                
                    llMessageLinked(LINK_SET, 941, "", "");
                    
                    
                
                    llSay(HOME_CHANNEL, "XSPET_PING_HOME");
                 
                    llSetText("", <1,1,1>, 1.0);       
                } else                
                if (llList2String(data, 1) == "CRATE_PONG" && llList2Key(data, 2) == llGetKey()) {
                    if (llList2Float(data, 3) >= VERSION && locked == 0) {
                        locked = 1;
                        llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^" + (string    )colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^" + (string)hunger_amount + "^" + llGetObjectName() + "^" + (string)glow_gene + "^" + special));
                    }
                } else
                if (llList2String(data, 1) == "CRATE_DIE" && llList2Key(data, 2) == llGetKey()) {
                    llDie();
                } else
                if (llList2String(data, 1) == "MALE_BREED_CALL") {
                    llMessageLinked(LINK_SET, 961, "", "");
                } else
                if (llList2String(data, 1) == "FEMALE_ELIGIBLE" && home_loc == (vector)llList2String(data, 2)) {
                    llMessageLinked(LINK_SET, 963, "", id);
                } else
                if (llList2String(data, 1) == "MALE_ON_THE_WAY" && llList2Key(data, 2) == llGetKey()) {
                    llMessageLinked(LINK_SET, 965, "", id);
                    llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^FEMALE_LOC^" + (string)id + "^" + (string)llGetPos()));
                } else
                if (llList2String(data, 1) == "FEMALE_LOC" && llList2String(data, 2) == llGetKey())
                {
                    llMessageLinked(LINK_SET, 966, llList2String(data, 3), "");
                } else
                if (llList2String(data, 1) == "MALE_INFO" && llList2Key(data, 2) == llGetKey()){
                    // pregnant
                    mcolour1 = (vector)llList2String(data, 3);
                    mcolour2 = (vector)llList2String(data, 4);
  
                    mshine = llList2Integer(data, 5);
                    mglow = llList2Float(data, 6);
                
                    mgen = llList2Integer(data, 7);
                    mglow_gene = llList2Integer(data, 8);
                    pregnancy_time = llGetUnixTime();
                    llMessageLinked(LINK_SET, 972, "", "");
                } else
                if (llList2String(data, 1) == "BREEDING_FAIL" && llList2String(data, 2) == llGetKey())
                {
                    llMessageLinked(LINK_SET, 969, "", "");
                } else
                if (llList2String(data, 1) == "EGG_READY" && id == new_egg_key)
                {
                    llGiveInventory(id, "XS Egg");
                    llGiveInventory(id, "Quail");
                
                    llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^BORN^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)gen + "^" + (string)shine + "^" + (string)glow + "^" + (string)glow_gene + "^" + (string)mcolour1 + "^" + (string)mcolour2 + "^" + (string)mgen + "^" + (string)mshine + "^" + (string)mglow + "^" + (string)mglow_gene));
                } else
                if (llList2String(data, 1) == "SHINE_GOO" && llList2String(data, 2) == llGetKey()) {
                    if (shine == 0) {
                        shine = 1;
                        llMessageLinked(LINK_SET, 933, (string)shine, "");
                        llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^SHINE_GOO_DIE"));
                        llSetLinkPrimitiveParams(5, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        llSetLinkPrimitiveParams(1, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);

    //                llSetLinkColor(8, colour1, ALL_SIDES);
    //                llSetLinkColor(1, colour1, ALL_SIDES);
    
                        llSetLinkPrimitiveParams(7, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        llSetLinkPrimitiveParams(4, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        llSetLinkPrimitiveParams(9, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        if (sex == 1) {
                            llWhisper(0, "Look out ladies, Mr Slick has arrived!");
                        } else {
                            llWhisper(0, "Look out gentlemen! Miss Slick has arrived!");
                        }
                        
                        
                    } else {
                        llWhisper(0, "I'm already shiny!");
                        llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^SHINE_GOO_FAIL"));

                    }
                } else 
                if (llList2String(data, 1) == "DIE" && llList2String(data, 2) == llGetKey()) {
                    llDie();
                } else
                if (llList2String(data, 1) == "VERSION" && VERSION < llList2Float(data, 2) && llGetOwnerKey(id) == llGetOwner()) {
                    llShout(UPDATE_CHANNEL, "VERSION^" + (string)VERSION);
                } else
                if (llList2String(data, 1) == "UPDATE" && llList2String(data, 2) == llGetKey() && llGetOwnerKey(id) == llGetOwner()) {
                    state update;
                }
            }
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 903 || num == 904) {
            hunger_amount = (integer)str;
            if (hunger_amount > 30) {
                state dead;
            }
        } else 
        if (num == 900) {
            random_number2 = (integer)(llFrand(10000.0) + 1);
            llSay(FOOD_CHANNEL, xtea_encrypt_string("XSPET^FOOD_CONSUME^" + (string)id + "^" + (string)random_number2 + "^" + (string)llGetKey()));
        } else
        if (num == 940) {
            age += (integer)str;
        } else
        if (num == 950) {
            llWhisper(0, "Looking for a cryo-crate...");
            llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)llGetKey() + "^CRATE_PING^" + (string)VERSION));
        } else
        if (num == 960) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^MALE_BREED_CALL^" + (string)llGetKey()));
        } else
        if (num == 962) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^FEMALE_ELIGIBLE^" + (string)home_loc));
        } else
        if (num == 964) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^MALE_ON_THE_WAY^" + (string)id));
        } else
        if (num == 968) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^MALE_INFO^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)glow_gene));
            llMessageLinked(LINK_SET, 969, "", "");
        } else
        if (num == 970) {
            // lay an egg
            pregnancy_time = 0;
            llRezObject("XS Egg", llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
        } else
        if (num == 971) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^BREEDING_FAIL^" + (string)id));
            pregnancy_time = 0;
        } else
        if (num == 990) {
            llSetLinkPrimitiveParams(3, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
            llSetLinkPrimitiveParams(8, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
        } else
        if (num == 991) {
            llSetLinkPrimitiveParams(3, [PRIM_COLOR, ALL_SIDES, <0,0,0>, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, 1, PRIM_BUMP_NONE]);
            llSetLinkPrimitiveParams(8, [PRIM_COLOR, ALL_SIDES, <0,0,0>, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, 1, PRIM_BUMP_NONE]);            
        } else
        if (num == 9999) {
            state dead;
        } else
        if (num == 8000) {
            llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));
        }
    }
    
    object_rez(key id)
    {
        new_egg_key = id;
    }
    
    on_rez(integer param)
    {
        if (param == SECRET_NUMBER) {
            llSetText("Rezzing...", <1,0,0>, 1.0);
            llMessageLinked(LINK_SET, 800, "", "");
            
            llSleep(5.0);
            if (llGetOwner() != YOUR_UUID) {
                llAllowInventoryDrop(TRUE);
            }
            llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^READY^" + (string)llGetKey() + "^XSPET"));
            llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^READY^" + (string)llGetKey() + "^XSPET"));
        } else {
	  llOwnerSay("I died in your inventory, please use a cryo-crate next time.");
	  state dead;
	}
    }
}

state dead
{
    state_entry()
    {
        llSetText("Dead", <1,0,0>, 1.0);
        llRemoveInventory("xs_ager");
        llRemoveInventory("xs_breeding");
        llRemoveInventory("xs_eater");
        llRemoveInventory("xs_infomatic");
        llRemoveInventory("xs_movement");
        if (llGetInventoryType("xs_special") != INVENTORY_NONE) {
            llRemoveInventory("xs_special");
        }
        llListen(ANIMAL_CHANNEL, "", "", "");
    }
    
    touch_start(integer number)
    {
        llWhisper(0, "I've died. You could re-animate me with a jar of Xtra Strong Mojo");
        if (llDetectedKey(0) == llGetOwner()) {
            llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^STRONG_MOJO^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^" + (string)glow_gene + (string)VERSION));
            
        }
    }
    
    listen(integer channel, string name, key id, string message) {
        list data = llParseString2List(xtea_decrypt_string(message), ["^"], []);
        if (llList2String(data, 0) == "XSPET") {
            if (llList2String(data, 1) == "STRONG_MOJO_DIE" && llList2Key(data, 2) == llGetKey()) {
                llDie();
            }
        }
    }
}

state update
{
    state_entry()
    {
        llSetText("Updating.", <1,0,0>, 1.0);
        llRemoveInventory("Quail");
        llRemoveInventory("XS Egg");
        llAllowInventoryDrop(TRUE);
        llShout(UPDATE_CHANNEL, "UPDATE_READY");
    }
    
    changed(integer change)
    {
        if (change & CHANGED_ALLOWED_DROP) {
            if (llGetInventoryType("Quail") != INVENTORY_NONE && llGetInventoryType("XS Egg") != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
                llRezObject("Quail", llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
            }
        }
        
    }
    object_rez(key id)
    {
        llListen(BOX_CHANNEL, "", id, "");
    }
    
    listen(integer channel, string name, key id, string msg)
    {
        if (channel == BOX_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 1) == "READY") {
                
                llGiveInventory(id, "XS Egg");
                llGiveInventory(id, "Quail");
                llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^UPDATE_CONFIG^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)sex + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)age + "^" + (string)hunger_amount + "^" + llGetObjectName() + "^" + (string)glow_gene + "^" + special + "^" + (string)mcolour1 + "^" + (string)mcolour2 + "^" + (string)mshine + "^" + (string)mglow + "^" + (string)mgen + "^" + (string)mglow_gene + "^" + (string)pregnancy_time));
                llDie();            
            }
        }
    }
}

