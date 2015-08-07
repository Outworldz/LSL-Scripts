// :CATEGORY:IM
// :NAME:Anonymous_messaging_to_anyone
// :AUTHOR:Psycotic
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:40
// :NUM:53
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// An SL Script that will allow you to send a message to anyone in world as any name.. Simply create a prim and name it whatever you want the message to come from. Add this script to it.. I wear mine on a hud so it's always available as long as scripts are enabled in the sim you're in.// // The name2key function is from w-hat.com..// // The command is: /111 UserFirstName UserLastName Message you wish to send to them.. Updated to check to make sure the person is online. If they were offline, and had their IM's forwarded to e-mail, it would tell them who it came from.. (Or perhaps from the owner of the prim)..
// :CODE:
string NAME; // name to look up
string URL = "http://w-hat.com/name2key"; // name2key url
key reqid; // http request id
string Message;
integer x;
key onlineReq;
key avatarId;
integer channel=111;
default
{
state_entry()
{
llSetText("",<0,0,0>,0);
llListen(channel,"",llGetOwner(),"");
}
on_rez(integer start_param)
{
llResetScript();
}
touch_start(integer num_detected)
{
llOwnerSay("Type: /" + (string)channel + " FirstName LastName Message to send to the person");
}
listen(integer channel,string name, key id, string message)
{
Message = "";
list templist = llParseString2List(message, [" "],[]);
integer length = llGetListLength(templist);
for (x=2;x<length;x++)
{
Message = Message + llList2String(templist,x) + " ";
}
NAME = llList2String(templist,0) + " " + llList2String(templist,1);
if (Message == "")
{
llOwnerSay("You must enter a message to send");
}
else
{
reqid = llHTTPRequest( URL + "?terse=1&name=" +llEscapeURL(NAME), [], "" );
}
}
http_response(key id, integer status, list meta, string body) {
if ( id != reqid )
return;
if ( status == 499 )
llOwnerSay("name2key request timed out");
else if ( status != 200 )
llOwnerSay("the internet exploded!!");
else if ( (key)body == NULL_KEY )
llOwnerSay(NAME + " not found");
else
{
avatarId = (key)body;
onlineReq = llRequestAgentData((key)body,DATA_ONLINE);
}
}
dataserver(key queryid, string data)
{
if ( queryid != onlineReq )
return;
if ( (integer)data )
{
llInstantMessage(avatarId, Message);
llOwnerSay("[" + NAME + "] " + Message);
llSetText(NAME + "\n" + Message,<1.0,0.0,0.0>,1.0);
}
else
llOwnerSay(NAME + " is not online");
}
}
