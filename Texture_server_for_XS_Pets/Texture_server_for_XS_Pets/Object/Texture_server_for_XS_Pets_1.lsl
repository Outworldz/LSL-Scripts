// :CATEGORY:XS Pet
// :NAME:Texture_server_for_XS_Pets
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2012-08-16 11:11:55.200
// :EDITED:2013-09-17 21:48:44
// :ID:879
// :NUM:1239
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Texture Server// An article on how to use this script is located at <a href="http://www.outworldz.com/Secondlife/Posts/Breedable-pet-robot/texture-server.htm">http://www.outworldz.com/Secondlife/Posts/Breedable-pet-robot/texture-server.htm</a>
// :CODE:

// Xs_Pets textures by Fred Beckhusen (Ferd Frederix)

/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike

// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship to me and leave this notice intact.
//
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Fred Beckhusen (Ferd Frederix)


////////////////////////////////////////////////////////////////////y

// You must put any textures you want to send to your pets in the same prim as this server.
//  Colors such as color1 and color2 are stored in the Description of the pet prims.  Use the prim Name for the texture name
//
// The names must match the following pattern:
// PrimName N
// Where PrimName is the name you put in the prim to be textured, and N is a number from 0 to however many sets of skins you have.
//
//  2-prime xample:  Body 0
//                   Head 0
//                   Body 1
//                   Head 1
//
// In this case, there should be two ( or more) prims in the pet whoes prim name is Body or Head
// So you will end up with two possible breeds for your pets, either the 0th or the 1st textures.
//
// If the breedable param Color1.x value (Red coloration) is < 0.5, you get Body 0 and Head 0
// If the breedable param Color1.x value (Red coloration) is > 0.5, you get Body 1 and Head 1


// The pets breed by mixing colors.  If a 1.0 (all Red) breeds with a 0.0 (No Red), you get a code near the average, or 0.5.
// Root prim:
// There is a special name 'root' for the root prim since your pet could be renamed, whioch would change the name of the root prim..
// root 0 would be the name to use for the first root prim texture, root 1 for the second, and so on.
// If your root prim is an invisible prim or is not to be textured, you can ignore this 'root' name.


// Deeper example:
// You have a pet robot with 3 sets of breedable skins, and 4 prims, called 'head'. 'body', 'leg' and 'tail'.
// You will need 3X4, or 12 textures in all.
// edit the pet, and change the name of the head to 'head', change the body name to 'body', the left leg to 'leg', and the right leg to 'leg'.
// each texture must also a single digit after it to represent the breed  type:
// head 0, head 1 and head 2
// body 0, body 1, and body 2
// leg 0, leg 1, and leg 2
// tail 0 , tail 1, and tail 2

// you may have up to 254 total textures in the server. In the above example, there are
// 4 textures per skin set, so you can have 254/4, or 63 skins for your pet.

// What about the root prim?
// The last prim you link to is the root prim.  It holds the xs_pet scripts.
// This prim gets renamed in various objects, so you cannot add a name to the prim that matches a
// texture.   A special texture name 'root 0', 'root 1' etc.  is set aside for this prim.
// Most xs_pets will not need to use the root prim texture, because the root prim is the base of the pet
// and it usually is made invisible.  If your root prim needs to be visible and textured,
// just add a root 0, root1 and so on texture for each texture set.


//////////////////////////////////////////////////////////
//                   CONFIGURATION                      //
//////////////////////////////////////////////////////////

// you must put in a UUID from this web site here and in the brain script
//http://gridurl.appspot.com/random

string UUID = "48246356-a7c5-474b-a6fe-f2cec98926b2";
integer debug = FALSE;  // set to 1 or TRUE for debuging information to the owner
//////////////////////////////////////////////////////////
//                     INTERNALS                        //
//////////////////////////////////////////////////////////



list textureDB;       // texture storage
integer nTextures;    // how many we find
integer nServed;        // how many we served
integer nPrims ;        // how many prims there must be
integer nBreeds;        // how man breeds
list lNames;            // a list of names
key gtextureUUID;       // The UUID of the detected texture
string gtextureName;    // the name of the detected texture
key URLReq = NULL_KEY;
string url;            // sop we can release HTTP-In keys
key urlRequestId;
 
request_url()
{
    llReleaseURL(url);
    url = "";
 
    urlRequestId = llRequestURL();
}

getImage(integer breedNum, string breedName)
{

    DEBUG("Seeking Name " + breedName );
    DEBUG("Seeking Number " + (string) breedNum );

    integer i;
    integer j = llGetListLength(textureDB);
    for (i = 0; i < j; i += 3)      
    {
        integer myBreedParam = llList2Integer(textureDB,i);   
        string humanName = llList2String(textureDB,i+1);
        key UUID = llList2Key(textureDB,i+2);

        if (myBreedParam > breedNum )
        {
            DEBUG("Found it!");
            return;
        }

        if (breedName == humanName)
        {
            gtextureName = humanName;
            gtextureUUID = UUID;;
            DEBUG("saving " +  humanName + " " + (string) myBreedParam);
        }
    }
    
    return;
}

list ListUnique( list lAll ) {
    integer i;
    list lFiltered = llList2List(lAll, 0, 0);
    integer iAll = llGetListLength( lAll );
    for (i = 1; i < iAll; ++i) {
        if ( llListFindList(lFiltered, llList2List(lAll, i, i) ) == -1 ) {
            lFiltered += llList2List(lAll, i, i);
        }
    }
    return lFiltered;
}
list parsePostData(string message)
{
    list postData = [];         
    list parsedMessage = llParseString2List(message,["&"],[]);    
    integer len = ~llGetListLength(parsedMessage);

    while(++len) {
        string currentField = llList2String(parsedMessage, len); 

        integer split = llSubStringIndex(currentField,"=");     
        if(split == -1) { 
            postData += [llUnescapeURL(currentField),""];
        } else {
            postData += [llUnescapeURL(llDeleteSubString(currentField,split,-1)), llUnescapeURL(llDeleteSubString(currentField,0,split))];
        }
    }
    
    return postData ;
}


getTextures()
{
    textureDB = [];
    lNames = [];

    integer j = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer i;

    for (i = 0; i < j ; i++)
    {
        string textureName = llGetInventoryName(INVENTORY_TEXTURE,i);
        list splits = llParseString2List(textureName,[" "],[]);
        integer n = llGetListLength(splits);

        string humanName = llList2String(splits,0);
        string breedParam = llList2String(splits,1);
        key UUID = llGetInventoryKey(textureName);

        textureDB += breedParam;
        textureDB += humanName;
        textureDB += UUID;

        lNames += humanName;
    }
    nTextures = llGetListLength(textureDB)/3;
    lNames = ListUnique(lNames);
    nPrims = llGetListLength(lNames);
    DEBUG("Number of colorable prims = " + (string) nPrims);

    nBreeds = nTextures / nPrims;

    textureDB = llListSort(textureDB,3,1);

    DEBUG("Number of textures = " + (string) nTextures);
    DEBUG("Number of breeds = " + (string) nBreeds);
}
string getTexture(string body)
{
    
    DEBUG("Parsing " + body);
    list incomingMessage = parsePostData(body);
    DEBUG("Params: " + llDumpList2String(incomingMessage,"\n"));

    if (llList2String(incomingMessage,0) == "breed")
    {
        float myBreed = (float) llList2String(incomingMessage,1);
        DEBUG("Scanning for Breed: " + (string) myBreed);

        integer myBreedNum = llCeil((myBreed * nBreeds));

        DEBUG("Looking for myBreed " + (string) myBreedNum);

        llSetText("Served:" + (string) nServed + "\nLast Breed:"+ (string) myBreedNum + "\nParam:" + (string) myBreed ,<1,1,1>,1.0);

        string response;
        integer i;

        for (i = 0; i < nPrims; i++)
        {
            string breedName = llList2String(lNames,i);

            getImage(myBreedNum,breedName);
            response += gtextureName + "|";
            response += (string) gtextureUUID + "|";
        }
        return "texture|" + response;
    }
    return "texture|" + (string) TEXTURE_BLANK;   
}
key Request(string URL)
{
    llSetText("Registering",<1,1,1>,1.0);
    string url = "http://gridurl.appspot.com/reg?service=" + UUID + "&url=" + llEscapeURL(URL) + "/";
    return  llHTTPRequest( url, [HTTP_METHOD, "GET"], "");
}
  

throw_exception(string inputString)
{
    key owner = llGetOwner();
    llInstantMessage(owner, inputString);
    llSleep(60);        // so we do not flood owner with IM's
    llResetScript();
}




DEBUG(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + " : " + msg);
}


default
{
    state_entry()
    {
        getTextures();
        llSetText("Initializing",<1,1,1>,1.0);
        request_url();
    }
    on_rez(integer param)
    {
        llResetScript();
    }

    
    http_request(key id, string method, string body)
    {
        if (method == URL_REQUEST_GRANTED)
        {
            DEBUG(body);
            url = body;    // save body response so we can release it.
            URLReq = Request(body);
            llSetText("Granted",<0,1,0>,1.0);
        }
        else if(method == URL_REQUEST_DENIED)
        {
            llOwnerSay("ERROR: URL REQUEST was DENIED "+body);
            llSetText("ERROR: URL REQUEST was DENIED",<1,0,0>,1.0);
            llSleep(5);
            llResetScript();
        }
        else if(id == URLReq)
        {
            if (body == "OK")
            {
                llSetText("OK",<1,0,0>,1.0);
            }
            else
            {
                llSetText("Unable to register",<0,0,1>,1.0);
            }
        }
        else if(method == "POST")
        {
            nServed++;
            string resp = getTexture(llGetHTTPHeader(id, "x-query-string"));
            llHTTPResponse(id, 200, resp);
        }
        else
        {
            
            llSetText("Not Implemented",<1,0,0>,1.0);
            llHTTPResponse(id, 501, "Not Implemented "+method);
        }
    }
    http_response(key request_id, integer status, list metadata, string body)
    {
        if(URLReq == request_id)
        {
            URLReq = NULL_KEY;       
            if(status == 200)
            {
                llSetText("Ok",<1,1,1>,1.0);
            }
            else
            {
                llSetText("Request failed",<1,0,0>,1.0);
                llOwnerSay("Request failed status="+(string)status+" "+body);
                llSleep(10);
                request_url();
            }
        }
    }


    changed (integer what)
    {
        if (what & CHANGED_INVENTORY)
        {
            getTextures();
        }

         if (what & (CHANGED_REGION_START ))
        {
            llReleaseURL(url);
            llResetScript();
        }

    }
}


