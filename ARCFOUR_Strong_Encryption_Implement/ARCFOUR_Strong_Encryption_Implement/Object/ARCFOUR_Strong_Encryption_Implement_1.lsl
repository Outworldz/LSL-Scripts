// :CATEGORY:Encryption
// :NAME:ARCFOUR_Strong_Encryption_Implement
// :AUTHOR:Nekow42 Zarf
// :CREATED:2010-12-27 12:48:55.667
// :EDITED:2013-09-18 15:38:48
// :ID:50
// :NUM:68
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Contributors// //     * Nekow42 Zarf (nekow42ATgmail.com)//     * Strife Onizuka -- Combined Library//     * Nardok Corrimal -- Memory optimization and help with the hex2byte function // 
// License
// 
// This work is licensed under a Creative Commons Attribution 3.0 Unported License
// 
// You are free:
// 
//     * to Share — to copy, distribute and transmit the work
//     * to Remix — to adapt the work 
// 
// Under the following conditions
// 
//     * Attribution. You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work). 
// 
//    1. For any reuse or distribution, you must make clear to others the license terms of this work. The best way to do this is with a link to this web page.
//    2. Any of the above conditions can be waived if you get permission from the copyright holder.
//    3. Nothing in this license impairs or restricts the author's moral rights. 
// 
// Disclaimer
// 
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// Documentation
// 
// The same password can be used more than once, but the nonce always has to be different. (something random). You can use this to secure inter-object communication by having a shared (but secret) password, and have the two objects exchange a nonce beforehand. A warning, there is no garbage fitering, so the state array could be polluted by someone injecting fake strings. To prevent this, the first thing exchanged encrypted could be a negative port number, and the two objects could listen only for each other's key. For proper decryption, messages must arrive in the exact order they were encrypted.
// 
// The key setup is very slow, but encryption itself is quite fast.
// 
// Note: The EncryptText() and DecryptText() functions are NOT compatible. They CANNOT be used in the same script.
// About ARCFOUR
// 
// ARCFOUR (also known by the trademarked name RC4) is the most popular stream cipher still in use today. It was invented in 1987 by Ron Rivest of RSA Security. It is used in high security protocals such as Secure Sockets Layer (SSL).
// 
// ARCFOUR works by creating a pseudorandom stream of bits, and then XORing that stream with the plaintext to produce the ciphertext. Since it operates in this manner, the same identical key should never be used twice. This implementation works to prevent that by adding a nonce to the end of the key.
// About this implementation
// 
// This implementation of ARCFOUR performs 128-bit encryption. It uses the MD5sum of the password and the nonce to prevent all known related key attacks against ARCFOUR.
// 
// Each script contains two functions. One to set up the key, and another to perform the actual encryption and decryption. Additional calls to the encrypt or decrypt function will continue to encrypt with the same key stream.
// 
// To encrypt, call the following functions:
// 
// KeySetup(string password, string nonce)
// string EncryptText(string plaintext)
// 
// The nonce should be a randomly generated string and should only be used once.
// 
// This will return a hex string.
// 
// To decrypt, call the following functions:
// 
// KeySetup(string password, string nonce)
// string DecryptText(string ciphertext)
// 
// using the same nonce.
// Changes
// Version 1.3
// 
//     * Corrected typecasting error. Anyone using this script prior to 2009-08-22 MUST update their copy to address this issue. 
// 
// Version 1.2
// 
//     * Outputs to Hex instead of a CSV of bytes 
// 
// Version 1.1
// 
//     * Hashes the key and the nonce with MD5, as per the RSA Laboratories suggestion. This prevents all related key attacks against ARCFOUR.
//     * Memory optimizations 
// 
// Version 1.0
// 
//     * Initial Release 
// 
// Future Recommendations
// 
//     * Support UTF-8
//     * By version 2.0, have a full protocol with automatic nonce generation, exchange, and object key filtering. 
// :CODE:
// Encryption
//This is an exact implementation of ARCFOUR that passes the test vectors.
 
//Note: Key setup is a long
//process taking over 20 seconds.
 
//Notes on use: The same password can be used more than once, but the nonce always has to be different
//(something random). You can use this to secure inter-object communication by having a shared (but secret)
//password, and have the two objects exchange a nonce beforehand. A warning, there is no garbage fitering,
//so the state array could be polluted by someone injecting fake strings. 
//To prevent this, the first thing exchanged encrypted
//could be a negative port number, and the two objects could listen only for each other's key. For proper
//decryption, messages must arrive in the exact order they were encrypted.
 
//This work is licensed under a http://creativecommons.org/licenses/by/3.0/ Creative Commons Attribution 3.0 Unported License
//Please credit Nekow42 Zarf.
//Nardok Corrimal, and Strife Onizuka contributed and need credit too.
list theState;
integer i;
integer j;
//===================================================//
//                 Combined Library                  //
//             "Nov  3 2007", "00:46:15"             //
//  Copyright (C) 2004-2007, Strife Onizuka (cc-by)  //
//    http://creativecommons.org/licenses/by/3.0/    //
//===================================================//
//{
integer UTF8ToUnicodeInteger(string input)//Mono Safe, LSO Safe
{
    integer result = llBase64ToInteger(llStringToBase64(input = llGetSubString(input,0,0)));
    if(result & 0x80000000){
        return 0;
    }
    return result >> 24;
}
 
 
string UnicodeIntegerToUTF8(integer input)//Mono Safe, LSO Safe
{
    integer bytes = llCeil(llLog(input) / 0.69314718055994530941723212145818);
    bytes = (input >= 0x80) * (bytes + ~(((1 << bytes) - input) > 0)) / 5;//adjust
    string result = "%" + byte2hex((input >> (6 * bytes)) | ((0x3F80 >> bytes) << !bytes));
    while (bytes)
        result += "%" + byte2hex((((input >> (6 * (bytes = ~-bytes))) | 0x80) & 0xBF));
    return llUnescapeURL(result);
}
 
string byte2hex(integer x)//Mono Safe, LSO Safe
{//Helper function for use with unicode characters.
    integer y = (x >> 4) & 0xF;
    return llGetSubString(hexc, y, y) + llGetSubString(hexc, x & 0xF, x & 0xF);
}//This function would benifit greatly from the DUP opcode, it would remove 19 bytes.
 
string hexc="0123456789ABCDEF";
 
//} Combined Library
KeySetup(string password, string nonce)
{
    //All addition is done modulous
    list WholePassword;
    list statePartOne = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75];
    list statePartTwo = [76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150];
    list statePartThree = [151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225];
    list statePartFour = [226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255];
    theState = (statePartOne = statePartTwo = statePartThree = statePartFour = []) + statePartOne + statePartTwo + statePartThree + statePartFour;
    integer swapper;
    //setup the plaintext list
    integer ThePerpetualMax;
    //setup the password. Use i since we already have it.
    //New addition in 1.1, use an MD5 hashing function on the password
    password = llMD5String(password + nonce,0);
    for(i = 0; i < 31; i+=2) 
    {
        WholePassword = (WholePassword = []) + WholePassword + (integer)("0x"+llGetSubString(password,i,i+1));
    }
    //Now WholePassword is equal to a list of the hex digits of the MD5 of the password plus the nonce
    i=0;
    j=0;
    //mix init, this sets up the ARCFOUR PRNG
        ThePerpetualMax = llGetListLength(WholePassword);
        for(i=0 ; i < 256; i++)
        {
            //Mix step one
            //Add to the variable j the contents of the ith element of the state array and the nth element of the key, where n is equal to i modulo the length of the key.
            j = (j + llList2Integer(theState, i) + llList2Integer(WholePassword,i % ThePerpetualMax)) % 256;
            //Mix step two. Swap the ith element and the jth element of the state array
            swapper = llList2Integer(theState, i);
            theState=llListReplaceList(theState, [llList2Integer(theState,j)] ,i,i);
            theState=llListReplaceList(theState, [swapper],j,j);
        }
    i=0;
    j=0;
    //Key setup is complete!
 
}
string EncryptText(string plaintext)
//This does not repeat key setup, but continues with the same state array and values for i and j
{
    //All addition is done modulous
    list PlaintextBytes;
    string CipheredBytes;
    integer n;
    integer counter;
    integer swapper;
    integer ByteToAdd;
    //setup the plaintext list
    integer ThePerpetualMax;
    ThePerpetualMax = llStringLength(plaintext);
    for(counter = 0; counter < ThePerpetualMax; counter++) 
    {
        PlaintextBytes = (PlaintextBytes = []) + PlaintextBytes + [UTF8ToUnicodeInteger(llGetSubString(plaintext,counter,counter))];
 
    }
    ThePerpetualMax = llGetListLength(PlaintextBytes);
    for(counter=0;counter < ThePerpetualMax;counter++)
    {
        //The variable i is incremented by one
        i = (i + 1) % 256;
        //The contents of the ith element of the state array is then added to j
        j = (j + llList2Integer(theState, i)) % 256;
        //The ith and jth elements of the state array are swapped and their contents are added together to form a new value n.
            swapper = llList2Integer(theState, i);
            theState=llListReplaceList(theState, [llList2Integer(theState,j)] ,i,i);
            theState=llListReplaceList(theState, [swapper],j,j);
            n = (llList2Integer(theState, i) + llList2Integer(theState, j)) % 256;
            //The nth element of the state array is then combined with the message byte, using a bit by bit exclusive-or operation, to form the output byte.
            ByteToAdd = llList2Integer(theState, n) ^ llList2Integer(PlaintextBytes, counter);
            CipheredBytes = CipheredBytes + byte2hex(ByteToAdd);
    }
 
 
    return CipheredBytes;
}
default
{
 
    touch_start(integer total_number)
    {
        llOwnerSay("Key is 'Key', plaintext is 'Plaintext'. Output:");
        KeySetup("Key","");
        llOwnerSay("Key setup complete. Encrypting now...");
        llOwnerSay(EncryptText("Plaintext"));
    }
}
