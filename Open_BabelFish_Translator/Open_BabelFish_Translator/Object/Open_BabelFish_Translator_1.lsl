// :CATEGORY:Translator
// :NAME:Open_BabelFish_Translator
// :AUTHOR:falados
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:587
// :NUM:804
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Open BabelFish Query
// :CODE:
//	This file is part of Open Babel Fish.
//
//	Open Babel Fish is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	Open Babel Fish is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with Open Babel Fish.  If not, see <http://www.gnu.org/licenses/>
//
//	  Author: Falados Kapuskas
//	  Date: 3/25/2008
//	  Version: 1.3


string URL;

key owner;
integer ENCODE = 0;
integer DECODE = 1;
string MY_NAME = "Babel Fish";

//Rate Limit Queueing
key gDataserverRequest;
float rate = 1.0;	//Every second
integer MessageQueue_length;
list MessageQueue_lp;
list MessageQueue_data;
list MessageQueue_name;

//Translation Stuff
list trans_requests;
list http_parm = [
	HTTP_METHOD, "POST",
	HTTP_MIMETYPE,"application/x-www-form-urlencoded"
		];

//Function: queue_message
//Description: Queues a message for translation later
queue_message(string data, string langpair, string name) {
	//Hack for english to english
	if( langpair == "en|en" ) {
		llSetObjectName(name);
		llOwnerSay(data);
	} else {
			++MessageQueue_length;
		MessageQueue_lp += langpair;
		MessageQueue_data += data;
		MessageQueue_name += name;
	}
}

//Function: send_queued_message
//Description: Sends the first message on the queue
send_queued_message() {
	if( MessageQueue_length > 0 )
	{
		//Prepare the request
		string request = translate_text( llList2String(MessageQueue_data,0), llList2String(MessageQueue_lp,0) );
		string translate_name = llList2String(MessageQueue_name,0);

		//Remove the queued item
		MessageQueue_lp = llDeleteSubList(MessageQueue_lp,0,0);
		MessageQueue_data = llDeleteSubList(MessageQueue_data,0,0);
		MessageQueue_name = llDeleteSubList(MessageQueue_name,0,0);

		//Fire it
		trans_requests += [llHTTPRequest( URL, http_parm, request ),translate_name];
		--MessageQueue_length;
	}
}

//Function: translate_text
//Description: This funciton simply assemples the proper POST data that must
//be sent to the php script.  It returns that data
string translate_text( string in, string pair )
{
	llOwnerSay(pair);
	string request = "action=translate&langpair=" + pair + "&text=" + llEscapeURL(in);
	return request;
}

default {
	state_entry()
	{
		gDataserverRequest = llGetNotecardLine("URL",0);
		owner = llGetOwner();
	}
	changed( integer change )
	{
		if(change && CHANGED_INVENTORY ) llResetScript();
	}
	dataserver(key req, string data)
	{
		if( req == gDataserverRequest )
		{
			URL = data;
			state active;
		}
	}
}
state active
{
	state_entry()
	{
		if( URL == "" || URL == EOF ) {
			llOwnerSay("Add a URL in the URL Notecard");
		} else {
				llSetTimerEvent(rate);
		}
	}
	changed( integer change )
	{
		if(change && CHANGED_INVENTORY ) llResetScript();
	}
	link_message(integer sender_number, integer number, string message, key id)
	{
		if( number == -10 ) {
			list opts = llCSV2List((string)id);
			queue_message(message,llList2String(opts,0),llList2String(opts,1));
		}
	}
	timer()
	{
		//Pop 1 off the message queue every RATE seconds
		send_queued_message();
	}
	//From the server - Say the message that was received
	http_response( key request_id, integer status, list metadata, string body )
	{
		//Find the request in the pending queue
		integer i = llListFindList(trans_requests,[request_id]);
		string translate_name = llList2String(trans_requests,i+1);
		if(status != 200)
		{
			if( status == 499 ) llOwnerSay("Request Timed Out.");
			else llOwnerSay("ERROR " + (string)status);
			return;
		}
		//If found, procede with textual display
		if( i != -1 ) {
			llSetObjectName(translate_name );
			if( translate_name == llKey2Name(owner) ) {
				//If the owner's text is being translated, the Babel Fish should speak it to others
				llSay( 0 , llUnescapeURL( body  ) );
			} else {
					//Otherwise, this is the translation you hear.
					llOwnerSay( llUnescapeURL( body  ) );
			}
			llSetObjectName(MY_NAME); //Reset name
			//Remove the request from the queue
			trans_requests = llDeleteSubList(trans_requests,i,i+1);
		}
	}
}
