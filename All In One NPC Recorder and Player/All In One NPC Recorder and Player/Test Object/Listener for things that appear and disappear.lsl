// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2015-07-17 13:15:19
// :EDITED:2016-07-10  09:24:25
// :ID:27
// :NUM:1904
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// This script can be put in objects to make them appear and disappear on command
// :CODE:

// send commands to this @cmd
// such as @cmd=99|Appear  to make this prim appear
// such as @cmd=99|Disppear  to make this prim disappear

integer debug = FALSE;
integer channel = 99; // change this for each item you want to speak to
integer visible = TRUE; // set this if you want rhe item to start visible. Set it to FALSE if you want it to start invisible

default
{
	on_rez(integer start_param)
	{
		// when rezzed, this needs to reset so we can establish a listener
		if (debug) llSay(0,"rezzed- resetting");
		llResetScript();
	}
	// when attached, this needs to resetso we can establish a listener
	attach(key attached)
	{
		if (debug) llSay(0,"Attachment successful, resetting");
		llResetScript();
	}
	state_entry()
	{
		// set the initial visibility.   I use llSetLinkAlpha because llSetAlpha causes scripts to stop so it should be avoided in Opensim.
		if (visible) {
			llSetLinkAlpha(LINK_SET,1,ALL_SIDES);
		} else {
				llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
		}

		// set up a lustener on 'channel'
		if (debug)llSay(0,"Listener on channel " +(string) channel + " is ready!");
		llListen(channel,"","","");
	}
	listen(integer channel, string name, key id, string message)
	{
		if (message=="Appear")
		{
			if (debug)llSay(0,"Appear");
			llSetLinkAlpha(LINK_SET,1.0,ALL_SIDES);
		}
		if (message=="Disappear")
		{
			if (debug)llSay(0,"Disappear");
			llSetLinkAlpha(LINK_SET,0,ALL_SIDES);
		}
	}

}
