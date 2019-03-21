// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1455
// :REV:0.50
// :WORLD:Second Life, OpenSim, Opensim
// :DESCRIPTION:
// XS Pet xs_texture plug in

// :CODE:

//xs_texture plug in

// 12-3-2012 - no longer dorks with the offset, repeat, or rotation when applying a texture

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



//////////////////////////////////////////////////////////
//                   CONFIGURATION                      //
//////////////////////////////////////////////////////////
// you must put in a UUID from this web site here and in the Server script
// http://gridurl.appspot.com/random

string UUID = "48246356-a7c5-474b-a6fe-f2cec98926b2"; // do not use this number, use your own from http://gridurl.appspot.com/random
integer debug = TRUE;  // set to TRUE to see debug messages
//////////////////////////////////////////////////////////
//                     INTERNALS                        //
//////////////////////////////////////////////////////////

integer LINK_TEXTURE = 801;        // ask for a new texture, or paint a color
integer LINK_BREEDNAME = 802;      // the name of the pet texture from the texture server notecard
key URLRqstKey;
key textureRqstKey;
string newpath ;

// globals to hold the params linked in from the brain
vector colorCode1;
vector colorCode2;
integer sex;
integer shine;
float glow;
float breed;



DEBUG(string msg)
{
    if (debug)
        llOwnerSay(llGetScriptName() + " : " + msg);
}

key Request(string cmd)
{
    DEBUG("Sending:"+newpath+"?"+cmd);
    return llHTTPRequest( newpath+"?"+cmd, [HTTP_METHOD, "GET"], "");
}

key TextureRequest()
{
    string URL = newpath + "?breed="  + llEscapeURL((string) breed) ;
    DEBUG("Sending: "+ URL);
    return llHTTPRequest( URL, [HTTP_METHOD, "POST"], "");
}


// change texture of amny prims named texture1 to texture6
TextureIt(list textures)
{

    // :texture|Breed Type 2|Body|fa8b0052-3a8d-48ce-ac56-6d14bfb956a9|Wing|dda55c64-46c7-4ed8-88c0-7b159ffa3b24|

    
    integer nPrims = llGetNumberOfPrims();
    integer i;
    for (i = 0; i <= nPrims; i++)
    {
        list param = llGetLinkPrimitiveParams(i,[PRIM_NAME]);        // name holds the texture number
        string primName = llList2String(param,0);

        // root is special
        if (  i == 1)
            primName = "root";

        integer where = llListFindList(textures,[primName]);

        if (where >= 0)
        {
            key UUID = (key) llList2String(textures,where+1);

            // DEBUG("Set Texture: " + primName + " on prim #" + (string) i);
            // apply texture and the other params
            llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, <1,1,1>, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);        // delete the prim texture
            llSetLinkTexture(i,UUID,ALL_SIDES);        // add this line which sets the texture with no offset or repeat or rotation changes
        }
    }
}


default
{
    state_entry()
    {
        // not a lot to do
    }

    on_rez(integer param)
    {
        llResetScript();
    }

    link_message(integer who, integer num, string str, key id)
    {

        // there are two vectors, sent in one packet
        if (num == LINK_TEXTURE)
        {
            DEBUG("received LINK_TEXTURE");
            list params = llParseString2List(str,["^"],[]);
            colorCode1 = (vector) llList2String(params,0);
            colorCode2 = (vector) llList2String(params,1);
            sex = (integer) llList2String(params,2);
            shine = (integer) llList2String(params,3);
            glow = (float) llList2String(params,4);
            breed = colorCode1.x;        // the breed is based on the Red value of Color 1

            URLRqstKey = llHTTPRequest( "http://gridurl.appspot.com/get/"+ llEscapeURL(UUID ), [HTTP_METHOD, "GET"], "");  // find the other object/script

        }

    }



    http_response(key request_id, integer status, list metadata, string body)
    {
        if (URLRqstKey == request_id)
        {
            URLRqstKey = NULL_KEY;       // the same event sometimes shows up more then once
            if(status != 200)
                llOwnerSay("The internet is broken! status="+(string)status+" "+body);
            else
            {
                DEBUG(body);
                newpath= body;

                textureRqstKey = TextureRequest();   // request the object name
            }
        }
        else if (textureRqstKey ==  request_id)
        {
            if(status != 200)
                llOwnerSay("request failed status="+(string)status+" "+ body);
            else            {
                DEBUG("response:" + body);     // report what was returned from  request
                list textures = llParseString2List(body,["|"],[]);
                if (llList2String(textures,0) == "texture")
                {
                    string sName = llList2String(textures,1);    // the texture name
                    llMessageLinked(LINK_SET,LINK_BREEDNAME,sName,"");
                    textures = llDeleteSubList(textures,1,1); // put it back the old way
                    TextureIt(textures);
                }
            }
        }
    }
}



