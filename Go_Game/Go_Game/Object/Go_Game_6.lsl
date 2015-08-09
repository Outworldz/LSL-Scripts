// :CATEGORY:Games
// :NAME:Go_Game
// :AUTHOR:Jonathan Shaftoe
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:357
// :NUM:485
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Due to script length restrictions, it wouldn't all fit in one, so there's another script required here, GoTileFaceScript
// :CODE:
// GoTileFaceScript
// Jonathan Shaftoe
// Texture-handling side of functionality required by GoTiles. Wouldn't all fit in one
// script due to script size limits. Also has problems with runtime size, hence the way
// the lists are joined together in bits. Contains a mapping from all of the possible
// game states of a 2x2 grid of squares, each of which being 0 - empty 1 - black or
// 2 - white, to the texture to be used to display it, and with what rotation/flipping.
// Also, each of the three faces on a tile has a different rotation to apply to make
// things all be the right way around.
// Some heavy borrowing from XYText in here - thank you!
// For usage, see GoTileScript


// List of 20 textures used to display board pieces.
list gTextureIndex = ["701917a8-d614-471f-13dd-5f4644e36e3c",
                        "b51f6506-2156-a8ea-15f5-172d80add211",
                        "d48ab9c0-c49d-e009-a893-84bd7326de84",
                        "3823e129-e09f-b0fb-8717-90bc88e8ef46",
                        "0f3113bb-39c2-e0b9-475e-00e59afd85b0", 
                        "bc806a54-3b0e-8f96-c105-d9da31160be5",
                        "58b6e53a-8b13-726f-24e7-ec94798bc9c4",
                        "760aa9bf-c25f-6880-2292-0c3c56421985",
                        "633464b2-2d1b-b050-2af9-f6dd2427465f",
                        "9f71ccc5-63e1-f5f0-6407-43577019f408",
                        "ad62bcb5-a607-21da-66eb-15548aad6b0a",
                        "d56bad91-3d05-e90e-080f-31224b353c42",
                        "00e8a3c3-996e-ed81-5e37-a86b099a9be7",
                        "5b206598-0c5d-352f-14e2-d18b520919a6",
                        "cf839003-eaf4-4af3-abe9-5d8bf3f28f0a",
                        "ab6e5d0b-16b9-3aee-b898-8c532c5e691c",
                        "e05ef3e7-f2a3-4b8c-f4ea-86d8b00a1c20",
                        "b5014c6e-d0b6-c6c7-6c25-d532fe08476f",
                        "15c19f1d-ee3f-22ba-541c-c44c62ea75c7",
                        "3f563f39-1c4d-297a-3956-cc174a9209e6",
                        "6879b0ca-a295-dd20-1e08-cc60da377a1a"];
                        
// Will contain complete list, put together from parts below. Striped list of 4 items,
// first is game state represented as a string, second is index into texture list for
// which texture to use, third is mirroring/flipping required of texture, fourth is
// rotation.                      
list gStateList = [];

// Index of prim faces for each of the three faces we're using to display textures
list gFaceIndex = [4, 0, 2];
// hack for apparent bug, can't just negate PI_BY_TWO.
float MINUS_PI_BY_TWO = -1.5707963267948966192313216916398;
// rotation needed for each of the three faces.
list gFaceRotations = [PI_BY_TWO, 0, MINUS_PI_BY_TWO];

// parts used to create gStateList, see boave.
list part1 =    ["0000", 0, <1, 1, 0>, 0.0,
                "1000", 1, <1, -1, 0>, 0.0,
                "0100", 1, <-1, -1, 0>, 0.0,
                "0010", 1, <1, 1, 0>, 0.0,
                "0001", 1, <-1, 1, 0>, 0.0,
                "2000", 2, <1, -1, 0>, 0.0,
                "0200", 2, <-1, -1, 0>, 0.0,
                "0020", 2, <1, 1, 0>, 0.0,
                "0002", 2, <-1, 1, 0>, 0.0,
                "1200", 3, <1, -1, 0>, 0.0,
                "2100", 3, <-1, -1, 0>, 0.0,
                "0012", 3, <1, 1, 0>, 0.0,
                "0021", 3, <-1, 1, 0>, 0.0,
                "1020", 3, <1, 1, 0>, PI_BY_TWO,
                "2010", 3, <-1, 1, 0>, PI_BY_TWO];
list part2 = [
                "0102", 3, <1, -1, 0>, PI_BY_TWO,
                "0201", 3, <-1, -1, 0>, PI_BY_TWO,
                "1002", 4, <1, -1, 0>, 0.0,
                "0120", 4, <-1, -1, 0>, 0.0,
                "2001", 4, <-1, 1, 0>, 0.0,
                "0210", 4, <1, 1, 0>, 0.0,
                "1100", 5, <1, -1, 0>, 0.0,
                "0011", 5, <1, 1, 0>, 0.0,
                "1010", 5, <1, 1, 0>, PI_BY_TWO,
                "0101", 5, <1, -1, 0>, PI_BY_TWO,
                "1001", 6, <-1, 1, 0>, 0.0,
                "0110", 6, <1, 1, 0>, 0.0,
                "2200", 7, <1, -1, 0>, 0.0,
                "0022", 7, <1, 1, 0>, 0.0,
                "2020", 7, <1, 1, 0>, PI_BY_TWO];
list part3 = [
                "0202", 7, <1, -1, 0>, PI_BY_TWO,
                "2002", 8, <-1, 1, 0>, 0.0,
                "0220", 8, <1, 1, 0>, 0.0,
                "1110", 9, <-1, -1, 0>, 0.0,
                "1101", 9, <1, -1, 0>, 0.0,
                "1011", 9, <-1, 1, 0>, 0.0,
                "0111", 9, <1, 1, 0>, 0.0,
                "0211", 10, <1, 1, 0>, 0.0,
                "2011", 10, <-1, 1, 0>, 0.0,
                "1102", 10, <1, -1, 0>, 0.0,
                "1120", 10, <-1, -1, 0>, 0.0,
                "1012", 10, <1, 1, 0>, PI_BY_TWO,
                "1210", 10, <-1, 1, 0>, PI_BY_TWO,
                "0121", 10, <1, -1, 0>, PI_BY_TWO,
                "2101", 10, <-1, -1, 0>, PI_BY_TWO];
list part4 = [
                "0112", 11, <1, 1, 0>, 0.0,
                "1201", 11, <1, -1, 0>, 0.0,
                "1021", 11, <-1, 1, 0>, 0.0,
                "2110", 11, <-1, -1, 0>, 0.0,
                "0122", 12, <1, 1, 0>, 0.0,
                "2201", 12, <1, -1, 0>, 0.0,
                "1022", 12, <-1, 1, 0>, 0.0,
                "2210", 12, <-1, -1, 0>, 0.0,
                "2021", 12, <1, 1, 0>, PI_BY_TWO,
                "2120", 12, <-1, 1, 0>, PI_BY_TWO,
                "0212", 12, <1, -1, 0>, PI_BY_TWO,
                "1202", 12, <-1, -1, 0>, PI_BY_TWO,
                "0221", 13, <1, 1, 0>, 0.0,
                "2102", 13, <1, -1, 0>, 0.0,
                "2012", 13, <-1, 1, 0>, 0.0];
list part5 = [
                "1220", 13, <-1, -1, 0>, 0.0,
                "2220", 14, <-1, -1, 0>, 0.0,
                "2202", 14, <1, -1, 0>, 0.0,
                "2022", 14, <-1, 1, 0>, 0.0,
                "0222", 14, <1, 1, 0>, 0.0,
                "1111", 15, <1, 1, 0>, 0.0,
                "1121", 16, <1, 1, 0>, 0.0,
                "2111", 16, <1, -1, 0>, 0.0,
                "1112", 16, <-1, 1, 0>, 0.0,
                "1211", 16, <-1, -1, 0>, 0.0,
                "1122", 17, <1, 1, 0>, 0.0,
                "2211", 17, <1, -1, 0>, 0.0,
                "2121", 17, <1, 1, 0>, PI_BY_TWO,
                "1212", 17, <1, -1, 0>, PI_BY_TWO];
list part6 = [
                "1221", 18, <1, 1, 0>, 0.0,
                "2112", 18, <-1, 1, 0>, 0.0,
                "1222", 19, <1, 1, 0>, 0.0,
                "2212", 19, <1, -1, 0>, 0.0,
                "2122", 19, <-1, 1, 0>, 0.0,
                "2221", 19, <-1, -1, 0>, 0.0,
                "2222", 20, <1, 1, 0>, 0.0];
                // 2111
                
default {
    state_entry() {
        gStateList = part1 + part2 + part3 + part4 + part5 + part6;
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if (num == 301) {
            integer face = (integer)((string)id) % 10;
            integer rotated = (integer)((string)id) / 10;
            integer realface = llList2Integer(gFaceIndex, face);
            string mystate;
            if (rotated == 1) {
                // need to horizontally flip the state we're looking for if we're part of a rotated tile.
                mystate = llGetSubString(str, 1, 1) + llGetSubString(str, 3, 3) + llGetSubString(str, 0, 0) + llGetSubString(str, 2, 2);
            } else {
                mystate = str;
            }
            integer pos = llListFindList(gStateList, [mystate]);
            if (pos == -1) {
                llWhisper(0, "Failed to find state for: " + mystate);
                return;
            }
            integer texture = llList2Integer(gStateList, pos + 1);
            key realtexture = llList2Key(gTextureIndex, texture);
            llSetPrimitiveParams([PRIM_TEXTURE, realface, realtexture, llList2Vector(gStateList, pos + 2), <0, 0, 0>, llList2Float(gStateList, pos + 3) + llList2Float(gFaceRotations, face)]);
        }
    }
}
