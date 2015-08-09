// :CATEGORY:Group Inviter
// :NAME:Auto_Set_Group_Joiner_script
// :AUTHOR:Fred Gandt
// :CREATED:2011-01-02 23:02:06.457
// :EDITED:2013-09-18 15:38:48
// :ID:64
// :NUM:91
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This work uses content from the Second Life® Wiki article Viewer Architecture. Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 Licens
// :CODE:
// V2 //
 
key group_key;
 
Function()
{
    group_key = llList2Key(llGetObjectDetails(llGetKey(), [OBJECT_GROUP]), 0);
    if(group_key != NULL_KEY)
    llHTTPRequest("http://world.secondlife.com/group/" + ((string)group_key), [], "");
    else
    {
        llSay(0, "\nSince you are not wearing a group tag I am not set to any group." +
                 "\nWear a group tag and try again." +
                 "\nThis script will self delete.");
        llRemoveInventory(llGetScriptName());
    }
}
 
default
{
    state_entry()
    {
        Function();
    }
    on_rez(integer param)
    {
        Function();
    }
    http_response(key q, integer status, list metadata, string body)
    {
        if(status == 200)
        {
            integer name_start = (llSubStringIndex(body, "<title>") + 7);
            integer name_end = (llSubStringIndex(body, "</title>") - 1);
            integer tex_key_start = (llSubStringIndex(body, "imageid") + 18);
            integer tex_key_end = (tex_key_start + 35);
            string group_name = llGetSubString(body, name_start, name_end);
            llSetObjectName("Join " + group_name);
            key group_tex = llGetSubString(body, tex_key_start, tex_key_end);
            if(group_tex != NULL_KEY)
            llSetTexture(group_tex, ALL_SIDES);
            else
            llSetTexture(TEXTURE_BLANK, ALL_SIDES);
        }
        else
        {
            llOwnerSay("HTTP Request failed. Trying again in 60 seconds. Please wait.");
            llSleep(60.0);
            llHTTPRequest("http://world.secondlife.com/group/" + ((string)group_key), [], "");
        }
    }
    touch_start(integer nd)
    {
        llSay(0, "/me by clicking this link\nsecondlife:///app/group/" + ((string)group_key) + "/about");
    }
}
