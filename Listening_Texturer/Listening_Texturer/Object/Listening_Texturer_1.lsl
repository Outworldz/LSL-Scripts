// :CATEGORY:Texture
// :NAME:Listening_Texturer
// :AUTHOR:Virus Collector
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:482
// :NUM:649
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script, when placed into an object, will listen for "text *", where * is the key of the texture to use.// It can get annoying if you place it into a lot of prims, so don't use it a lot.
// :CODE:
//Listening Texturer script by Aldar Rayner
default
{
    state_entry()
    {
        //Listen to my owner.
        llListen(0,"",llGetOwner(),"");
    }

    listen(integer chan, string name, key id, string msg)
    {
        //Figure out what the key is and use it.
        list parsed = llParseString2List(msg,[" "],[]);
        string text = llList2String(parsed,0);
        string texture = llList2String(parsed,1);
        //Edit the word text in quotes to change the trigger keyword.
        if(text == "text")
        {
            llSetPrimitiveParams([PRIM_TEXTURE,ALL_SIDES,(key)texture,<1,1,0>,<0,0,0>,0.0]);
        }
    }
}
