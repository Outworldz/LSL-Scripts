// :SHOW:
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:15:19
// :ID:27
// :NUM:1807
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// test script for chatting commands to the NPC
// :CODE:

default
{
	state_entry() {
		llSetText("Type commands in chat to control the NPC, such as '@say=Hello'",<1,1,1>,1.0);
		llListen(0,"","","");
	}

	listen(integer channel, string name, key id, string message)
	{
		llMessageLinked(LINK_ROOT,0, message,"");
	}
}
