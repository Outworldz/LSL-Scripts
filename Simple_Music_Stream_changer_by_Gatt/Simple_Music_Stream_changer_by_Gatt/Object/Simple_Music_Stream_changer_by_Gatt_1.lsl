// :CATEGORY:Music
// :NAME:Simple_Music_Stream_changer_by_Gatt
// :AUTHOR:Gattz Gilman
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:764
// :NUM:1051
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple Music Stream changer by Gattz Gilman.lsl
// :CODE:

//Simple Music Stream changer by Gattz Gilman 

//It real simple, you click on it, then say the url in chat.

//Put the script into an object. The object must belong to the owner of the land, but anyone can change the stream.




key per; //key of person who clicked 
integer lis; 
default 
{ 
on_rez(integer start_param) { llResetScript(); 
} 
touch_start(integer total_number) 
{ 
per = llDetectedKey(0); 
lis = llListen(0,"",per,""); 
llSay(0, llKey2Name(per) + ", please enter the url through chat."); 
} 
listen(integer channel,string name, key id, string message) 
{ 
llSetParcelMusicURL(message); 
llSay(0,"Parcel URL set to: " + message); 
llListenRemove(lis); 
} 
}

// END //
