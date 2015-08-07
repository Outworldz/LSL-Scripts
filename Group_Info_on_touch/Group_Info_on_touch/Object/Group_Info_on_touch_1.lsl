// :CATEGORY:Groups
// :NAME:Group_Info_on_touch
// :AUTHOR:Ferd Frederix
// :CREATED:2013-04-12 11:54:42.040
// :EDITED:2013-09-18 15:38:54
// :ID:366
// :NUM:499
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script gets the group key that the prim belongs to and prints out the information:// See http://wiki.secondlife.com/wiki/World_API for more info on groups.
//For example, you cannot just get a groups info without first knowing the key.
// :CODE:
//
// [09:50] Object: Touch me for this prims group info
// [09:50] Object: Description:Wiki Wiki means a meta wiki, or a wiki of wikis
// [09:50] Object: member_count:22
// [09:50] Object: open_enrollment:N
// [09:50] Object: membership_fee:0
// [09:50] Object: founderid:a4dd7d22-071e-47d3-98c7-4d793e07124a
// [09:50] Object: founder:Ferd Frederix the Blue Adept (ferd.frederix)
// [09:50] Object: groupid:9045d102-57c5-cea1-a1b1-b42ec27d8e25
// [09:50] Object: imageid:2446d7da-0e11-a83b-6d84-6dedc375de46
// [09:50] Object: founder:Ferd Frederix the Blue Adept (ferd.frederix)
// License:  Creative Commons/BY   
// http://creativecommons.org/licenses/by/2.0/
// author: Ferd Frederix 

string url = "http://world.secondlife.com/group/";
key http_request_id;

string parse(string input,string name )
{
     return left(right(input, name + "\" content=\""),"\" />");
}

string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index , -1);
    return src;
}

string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}


default
{
    state_entry()
    {
        llSay(0, "Touch me for  group info");
    }

    touch_start(integer total_number)
    {
        
        list groupKeys = llGetObjectDetails(llGetKey(),[OBJECT_GROUP]);   // get this objects group key
        key groupKey = llList2Key(groupKeys,0);
        string urx = url + (string) groupKey;
        http_request_id = llHTTPRequest(urx, [], "");
        
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
        if (request_id == http_request_id)
        {
           // llOwnerSay(body);

            llOwnerSay("Description:" + parse(body,"description"));
            llOwnerSay("member_count:" + parse(body,"member_count"));
            llOwnerSay("open_enrollment:" + parse(body,"open_enrollment"));
            llOwnerSay("membership_fee:" + parse(body,"membership_fee"));
            llOwnerSay("founderid:" + parse(body,"founderid"));
            llOwnerSay("founder:" + parse(body,"founder"));
            llOwnerSay("groupid:" + parse(body,"groupid"));
            llOwnerSay("imageid:" + parse(body,"imageid"));
            llOwnerSay("founder:" + parse(body,"founder"));
            
        }
    }
}
