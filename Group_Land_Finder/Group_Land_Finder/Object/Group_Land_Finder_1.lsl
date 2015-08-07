// :CATEGORY:Group Land
// :NAME:Group_Land_Finder
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:367
// :NUM:500
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Group_Land_Finder
// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei
//Method found by Vince Bosen
//Modified by Vince so that it always works without the land owner in the sim
request(string owner)
{
    llHTTPRequest("http://teen.world.secondlife.com/group/" + (string)owner, [HTTP_METHOD, "GET"], "");
}
string owner;
default
{
    	state_entry()
	{
		owner = (string)llGetLandOwnerAt(llGetPos());
		llRequestAgentData(owner,DATA_NAME);
	}
	dataserver(key i,string d){
		if(d=="")
			request(owner);
		else
			llSay(0,"Owner of this plot is: "+d);
	}
    	http_response(key id, integer status, list metadata, string body)
    	{
        	integer start = llSubStringIndex(body, "<title>");
        	integer end = llSubStringIndex(body, "</title>");
        	string name = llGetSubString(body, start+7, end-1);
        	llSay(0, "(Group) Owner is: " + name);
    	}
}
