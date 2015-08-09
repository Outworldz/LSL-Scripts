// :CATEGORY:TV
// :NAME:Media_Player
// :AUTHOR:Regina Public Schools
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:511
// :NUM:684
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Screen Script
// :CODE:
integer VIDEO_START;
integer VIDEO_STOP;
integer LISTEN_VIDEO_START;
integer LISTEN_VIDEO_STOP;

string TrimRight(string src, string chrs)//Mono Unsafe, LSO Safe
{
	integer i = llStringLength(src);
	do {} while(~llSubStringIndex(chrs, llGetSubString(src, i = ~-i, i)) && i);
	return llDeleteSubString(src, -~(i), 0x7FFFFFF0);
}

string TrimLeft(string src, string chrs)//Mono Unsafe, LSO Safe
{
	integer i = ~llStringLength(src);
	do {} while(i && ~llSubStringIndex(chrs, llGetSubString(src, i = -~i, i)));
	return llDeleteSubString(src, 0x8000000F, ~-(i));
}

string TrimBoth(string src, string chrs)//Mono Unsafe, LSO Safe
{
	integer i = ~llStringLength(src);
	do {} while(i && ~llSubStringIndex(chrs, llGetSubString(src, i = -~i, i)));
	i = llStringLength(src = llDeleteSubString(src, 0x8000000F, ~-(i)));
	do {} while(~llSubStringIndex(chrs, llGetSubString(src, i = ~-i, i)) && i);
	return llDeleteSubString(src, -~(i), 0x7FFFFFF0);
}




reset()
{
	llSetText("",<0,0,0>,0);
	llListenRemove(LISTEN_VIDEO_START);
	llListenRemove(LISTEN_VIDEO_STOP);
	VIDEO_START = (integer) llGetObjectDesc();
	VIDEO_STOP = VIDEO_START+20;
	LISTEN_VIDEO_START = llListen(VIDEO_START, "", NULL_KEY, "");
	LISTEN_VIDEO_STOP = llListen(VIDEO_STOP,"",NULL_KEY,"");
	llSetObjectName("RPS Media V6.0");
	list owned=llParcelMediaQuery([PARCEL_MEDIA_COMMAND_TEXTURE]);
	if(llGetListLength(owned)==0)
		llWhisper(0, "Please deed me [ land owner and my owner must be the same ].");
}

default
{
	on_rez(integer start_param)
	{
		reset();
	}

	state_entry()
	{
		reset();
	}

	listen(integer channel, string name, key id, string message)
	{
		if (channel == VIDEO_STOP)
		{
			llParcelMediaCommandList( [ PARCEL_MEDIA_COMMAND_STOP , PARCEL_MEDIA_COMMAND_UNLOAD ] );
		}
		else if (channel == VIDEO_START)
		{
			string mimetype="text/html";
			string code = "text/html";
			string URL = TrimBoth(message," ");
			string protocol = TrimBoth(llToLower(llGetSubString(message,0,4))," ");
			string ext = TrimBoth(llToLower(llGetSubString(message,-3,-1))," ");
			if (protocol == "rtsp") {
				code = "rtsp";
			} else {
					if (ext == "sdp") code="application/sdp";
				if (ext == "mil") code="application/smil";
				if (ext == "mov") code="video/quicktime";
				if (ext == "avi") code="video/quicktime";
				if (ext == "m4v") code="video/quicktime";
				if (ext == "mpg") code="video/mpeg";
				if (ext == ".qt") code="video/quicktime";
				if (ext == "flc") code="video/flc";
				if (ext == "mp4") code="video/mp4";
				if (ext == "sdv") code="video/sd-video";
				if (ext == "aac") code="audio/aac";
				if (ext == "m4p") code="audio/x-m4p";
				if (ext == "m4a") code="audio/x-m4a";
				if (ext == "m4b") code="audio/x-m4b";
				if (ext == "mp3") code="audio/mp3";
				if (ext == "3gp") code="audio/3gpp";
				if (ext == "gif") code="image/gif";
				if (ext == "png") code="image/png";
				if (ext == "peg") code="image/jpeg";
				if (ext == "tga") code="image/tga";
				if (ext == "jpg") code="image/jpeg";
			}
			llSay(0, code);llSay(0,ext);
			llParcelMediaCommandList( [
				PARCEL_MEDIA_COMMAND_URL, URL
					,PARCEL_MEDIA_COMMAND_TYPE, code
						//                  ,PARCEL_MEDIA_COMMAND_SIZE, 800, 600
						]);
			llSleep(1.0);
			llParcelMediaCommandList( [PARCEL_MEDIA_COMMAND_PLAY]);
		}
	}
}
