// :CATEGORY:TV
// :NAME:FreeView_12_WebGuide_TV_Set
// :AUTHOR:CrystalShard Foo
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:339
// :NUM:457
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// FreeView_12_WebGuide_TV_Set
// :CODE:
/FreeView 1.2 WebGuide - By CrystalShard Foo
//Multifunctional Picture viewer and Video control script with webguide support
//This script is distributed for free and must stay that way. DO NOT SELL THIS SCRIPT UNDER ANY CIRCUMSTANCE.

//Help for using this script can be obtained at: http://www.slguide.com/help

//Feel free to modify this script and post your improvement. Leave the credits intact but feel free to add your name at its bottom.


//Constants
integer PICTURE_ROTATION_TIMER = 30;   //In whole seconds

integer DISPLAY_ON_SIDE = ALL_SIDES; //Change this to change where the image will be displayed

key VIDEO_DEFAULT = "6e0f05ad-1809-4edc-df29-fae3d2a6c9b8";  //Test pattern - Used as default video texture when one is missing in parcel media
key BLANK = "5748decc-f629-461c-9a36-a35a221fe21f"; //Blank texture - Used when there are no textures to display in Picture mode
string NOTECARD = "bookmarks";  //Used to host URL bookmarks for video streams

integer VIDEO_MATERIAL = PRIM_MATERIAL_LIGHT;    //Note - Side 0 automaticly gets colored <0,0,0> to prevent light lag!
integer PICTURE_MATERIAL = PRIM_MATERIAL_LIGHT;  //All this does is make the prim bright. No worries about light related lag.

integer REMOTE_CHANNEL = 9238742;

integer mode = 0;           //Freeview mode.
                            //Mode 0 - Power off
                            //Mode 1 - Picture viewer
                            //Mode 2 - Video

integer listenHandle = -1;      //Dialog menu listen handler
integer listenUrl = -1;         //listen handler for channel 1 for when a URL is being added
integer listenTimer = -1;       //Timer variable for removing all listeners after 2 minutes of listener inactivity
integer listenRemote = -1;      //listen handler for the remote during initial setup
integer encryption = 0;
integer numberofnotecardlines = 0;  //Stores the current number of detected notecard lines.
integer notecardline = 0;       //Current notecard line

integer loop_image = FALSE;     //Are we looping pictures with a timer? (picture mode)
integer current_texture = 0;    //Current texture number in inventory being displayed (picture mode)
integer chan;                   //llDialog listen channel
integer notecardcheck = 0;
key video_texture;              //Currently used video display texture for parcel media stream

string moviename;
string tempmoviename;
key notecardkey = NULL_KEY;
key tempuser;                   //Temp key storge variable
string tempurl;                 //Temp string storge variable

integer isGroup = TRUE;
key groupcheck = NULL_KEY;
key last_owner;
key XML_channel;

pictures()      //Change mode to Picture Viewer
{
    //Initilize variables
    
    //Change prim to Light material while coloring face 0 black to prevent light-lag generation.
    llSetPrimitiveParams([PRIM_BUMP_SHINY,DISPLAY_ON_SIDE,PRIM_SHINY_NONE,PRIM_BUMP_NONE,PRIM_COLOR,DISPLAY_ON_SIDE,<1,1,1>,1.0,PRIM_MATERIAL,PICTURE_MATERIAL]);
    llSetColor(<0,0,0>,0);

    integer check = llGetInventoryNumber(INVENTORY_TEXTURE);
     
    if(check == 0)
    {
        report("No pictures found.");
        llSetTexture(BLANK,DISPLAY_ON_SIDE);
        return;
    }
    else    
        if(current_texture > check)
            //Set to first texture if available
            current_texture = 0;
            
    display_texture(current_texture);
}

video()         //Change mode to Video
{
    //Change prim to Light material while coloring face 0 black to prevent light-lag generation.
    llSetPrimitiveParams([PRIM_BUMP_SHINY,DISPLAY_ON_SIDE,PRIM_SHINY_NONE,PRIM_BUMP_NONE,PRIM_COLOR,DISPLAY_ON_SIDE,<1,1,1>,1.0,PRIM_MATERIAL,VIDEO_MATERIAL,PRIM_TEXTURE,DISPLAY_ON_SIDE,"62dc73ca-265f-7ca0-0453-e2a6aa60bb6f",llGetTextureScale(DISPLAY_ON_SIDE),llGetTextureOffset(DISPLAY_ON_SIDE),llGetTextureRot(DISPLAY_ON_SIDE)]);
    llSetColor(<0,0,0>,0);
    
    report("Video mode"+moviename+": Stopped");
    if(finditem(NOTECARD) != -1)
        tempuser = llGetNumberOfNotecardLines(NOTECARD);
    video_texture = llList2Key(llParcelMediaQuery([PARCEL_MEDIA_COMMAND_TEXTURE]),0);
    if(video_texture == NULL_KEY)
    {
        video_texture = VIDEO_DEFAULT;
        llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_TEXTURE,VIDEO_DEFAULT]);
        llSay(0,"No parcel media texture found. Setting texture to default: "+(string)VIDEO_DEFAULT);
        if(llGetLandOwnerAt(llGetPos()) != llGetOwner())
            llSay(0,"Error: Cannot modify parcel media settings. "+llGetObjectName()+" is not owned by parcel owner.");
    }
    
    llSetTexture(video_texture,DISPLAY_ON_SIDE);
}

off()
{
    report("Click to power on.");
    llSetPrimitiveParams([PRIM_BUMP_SHINY,DISPLAY_ON_SIDE,PRIM_SHINY_LOW,PRIM_BUMP_NONE,PRIM_COLOR,DISPLAY_ON_SIDE,<0.1,0.1,0.1>,1.0,PRIM_MATERIAL,PRIM_MATERIAL_PLASTIC,PRIM_TEXTURE,DISPLAY_ON_SIDE,BLANK,llGetTextureScale(DISPLAY_ON_SIDE),llGetTextureOffset(DISPLAY_ON_SIDE),llGetTextureRot(DISPLAY_ON_SIDE)]);
}

integer finditem(string name)   //Finds and returns an item's inventory number
{
    integer i;
    for(i=0;i<llGetInventoryNumber(INVENTORY_NOTECARD);i++)
        if(llGetInventoryName(INVENTORY_NOTECARD,i) == NOTECARD)
            return i;
    return -1;
}

seturl(string url, key id)  //Set parcel media URL
{
    if(mode != 2)
    {
        video();
        mode = 2;
    }
    moviename = tempmoviename;
    if(moviename)
        moviename = " ["+moviename+"]";
    tempmoviename = "";
    string oldurl = llList2String(llParcelMediaQuery([PARCEL_MEDIA_COMMAND_URL]),0);
    if(oldurl != "")
        llOwnerSay("Setting new media URL. The old URL was: "+oldurl);

    llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_URL,url]);
    if(id!=NULL_KEY)
        menu(id);
    else
    {
        report("Video mode"+moviename+": Playing");
        llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_PLAY]);
    }
       
    if(isGroup)
        llSay(0,"New media URL set.");
    else
        llOwnerSay("New media URL set: "+url);
}

string mediatype(string ext)    //Returns a string stating the filetype of a file based on file extension
{
    ext = llToLower(ext);
    if(ext == "swf")
        return "Flash";
    if(ext == "mov" || ext == "avi" || ext == "mpg" || ext == "mpeg" || ext == "smil")
        return "Video";
    if(ext == "jpg" || ext == "mpeg" || ext == "gif" || ext == "png" || ext == "pict" || ext == "tga" || ext == "tiff" || ext == "sgi" || ext == "bmp")
        return "Image";
    if(ext == "txt")
        return "Text";
    return "Unknown";
}

browse(key id)      //Image browser function for picture viewer mode
{
    integer check = llGetInventoryNumber(INVENTORY_TEXTURE);
    string header;
    if(check > 0)
        header = "("+(string)(current_texture+1)+"/"+(string)check+") "+llGetInventoryName(INVENTORY_TEXTURE,current_texture);
    else
        header = "No pictures found.";
    llDialog(id,"** Monitor Control **\n Picture Viewer mode\n- Image browser\n- "+header,["Back","Next","Menu"],chan);
    extendtimer();
}

report(string str)
{
    llSetObjectDesc(str);
}

extendtimer()       //Add another 2 minute to the Listen Removal timer (use when a Listen event is triggered)
{
    if(listenHandle == -1)
        listenHandle = llListen(chan,"","","");
    listenTimer = (integer)llGetTime() + 120;
    if(loop_image == FALSE)
        llSetTimerEvent(45);
}

config(key id)      //Configuration menu
{
    extendtimer();
    llDialog(id,"Current media URL:\n"+llList2String(llParcelMediaQuery([PARCEL_MEDIA_COMMAND_URL]),0)+"\nTip: If the picture is abit off, try 'Align ON'",["Set URL","Align ON","Align OFF","Menu","Set Remote"],chan);
}

tell_remote(string str)
{
    llShout(REMOTE_CHANNEL,llXorBase64Strings(llStringToBase64((string)encryption + str), llStringToBase64((string)encryption)));
}

menu(key id)        //Dialog menus for all 3 modes
{
    list buttons = [];
    string title = "** Monitor control **";
    
    extendtimer();

    if(mode != 0)
    {
        if(mode == 1)       //Pictures menu
        {
            title+="\n  Picture Viewer mode";
            buttons+=["Browse"];
            if(loop_image == FALSE)
                buttons+=["Loop"];
            else
                buttons+=["Unloop"];
            buttons+=["Video","Power off","Help"];
        }
        else                //Video menu
        {
            title+="\n Video display mode\n"+moviename+"\nTip:\nClick 'Web Guide' to view the Online bookmarks.";
            buttons+=["Pictures","Configure","Power off","Loop","Unload","Help","Play","Stop","Pause","Web Guide","Bookmarks","Set URL"];
        }
    }
    else
        buttons += ["Pictures","Video","Help"];
    
    llDialog(id,title,buttons,chan);
}

display_texture(integer check)  //Display texture and set name in description (picture mode)
{                               //"Check" holds the number of textures in contents. The function uses "current_texture" to display.
    string name = llGetInventoryName(INVENTORY_TEXTURE,current_texture);
    llSetTexture(name,DISPLAY_ON_SIDE);
    report("Showing picture: "+name+" ("+(string)(current_texture+1)+"/"+(string)check+")");
}
    

next()  //Change to next texture (picture mode)
{       //This function is used twice - by the menu and timer. Therefor, it is a dedicated function.
    current_texture++;
    integer check = llGetInventoryNumber(INVENTORY_TEXTURE);
    if(check == 0)
    {
        llSetTexture(BLANK,DISPLAY_ON_SIDE);
        current_texture = 0;
        report("No pictures found.");
        return;
    }
    if(check == current_texture)
        current_texture = 0;
    
    display_texture(check);
    return;
}

default
{
    state_entry()
    {
        chan = (integer)llFrand(1000) + 1000;   //Pick a random listen channel for the listener
        if(PICTURE_ROTATION_TIMER <= 0)         //Ensure the value is no less or equal 0
            PICTURE_ROTATION_TIMER = 1;
        llListenRemove(listenHandle);
        listenHandle = -1;
        last_owner = llGetOwner();
        groupcheck = llRequestAgentData(llGetOwner(),DATA_NAME);
        off();
        llOpenRemoteDataChannel();
    }
    
    on_rez(integer i)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        //-------------------------------------------------------------------------------
        //Listen only to owner or group member. Edit this code to change access controls.
        if(llDetectedKey(0) != llGetOwner() && llDetectedGroup(0) == FALSE)
            return;
        //-------------------------------------------------------------------------------

        if(llGetOwnerKey(llGetKey()) != last_owner)  //Sense if object has been deeded to group for Web Guide function
        {
            isGroup = TRUE;
            last_owner = llGetOwner();
            groupcheck = llRequestAgentData(llGetOwner(),DATA_NAME);
        }

        menu(llDetectedKey(0));
    }
    
    changed(integer change)
    {
        if(change == CHANGED_INVENTORY) //If inventory change
            if(mode == 1)   //If picture mode
            {
                integer check = llGetInventoryNumber(INVENTORY_TEXTURE);
                if(check != 0)
                {
                    current_texture = 0;
                    display_texture(check);
                }
                else
                {
                    llSetTexture(BLANK,DISPLAY_ON_SIDE);
                    report("No pictures found.");
                }
            }
            else
                if(mode == 2)   //If video mode
                    if(finditem(NOTECARD) != -1)    //And bookmarks notecard present
                        if(notecardkey != llGetInventoryKey(NOTECARD))
                            tempuser = llGetNumberOfNotecardLines(NOTECARD);    //Reload number of lines
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if(message == "Pictures")
        {
            if(mode == 2)
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_STOP]);
            pictures();
            mode = 1;
            menu(id);
            return;
        }
        if(message == "Video")
        {
            video();
            mode = 2;
            menu(id);
            return;
        }
        if(message == "Power off")
        {
            if(mode == 2)
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_UNLOAD]);
            off();
            mode = 0;
            return;
        }
        if(message == "Help")
        {
            llSay(0,"Help documentation is available at: http://www.slguide.com/help");
            if(isGroup)
                tell_remote("HELP"+(string)id+(string)XML_channel);
            else
                llLoadURL(id,"Help pages for FreeView","http://www.slguide.com?c="+(string)XML_channel+"&help=1");
        }
        if(mode == 1)
        {
            if(message == "Browse")
            {
                loop_image = FALSE;
                browse(id);
                return;
            }
            if(message == "Next")
            {
                extendtimer();
                next();
                browse(id);
            }
            if(message == "Back")
            {
                extendtimer();
                current_texture--;
                integer check = llGetInventoryNumber(INVENTORY_TEXTURE);
                if(check == 0)
                {
                    llSetTexture(BLANK,DISPLAY_ON_SIDE);
                    current_texture = 0;
                    report("No pictures found.");
                    return;
                }
                if(current_texture < 0)
                    current_texture = check - 1;
                
                display_texture(check);
                
                browse(id);
                return;
            }
            if(message == "Menu")
            {
                menu(id);
                return;
            }
            if(message == "Loop")
            {
                llSetTimerEvent(PICTURE_ROTATION_TIMER);
                loop_image = TRUE;
                llOwnerSay("Picture will change every "+(string)PICTURE_ROTATION_TIMER+" seconds.");
                return;
            }
            if(message == "Unloop")
            {
                loop_image = FALSE;
                llOwnerSay("Picture loop disabled.");
                return;
            }
        }
        if(mode == 2)
        {
            if(channel == REMOTE_CHANNEL)
            {
                if(encryption == 0)
                    encryption = (integer)message;
                llListenRemove(listenRemote);
                listenRemote = -1;
                llSay(0,"Remote configured ("+(string)id+")");
            }
                
            if(message == "Web Guide")
            {
                if(isGroup)
                {
                    if(!encryption)
                    {
                        llSay(0,"** Error - This FreeView object has been deeded to group. You must use a Remote control to open the Web Guide.");
                        llSay(0,"You can set up the remote control from the Video -> Configuration menu. Please refer to the notecard for further assistance.");
                        return;
                    }
                    tell_remote((string)id+(string)XML_channel+(string  )llGetOwner());
                }
                else
                    llLoadURL(id, "Come to the Guide to Start Your Viewer Playing!", "http://slguide.com/index.php?v=" + (string)llGetKey() + "&c=" + (string)XML_channel + "&o=" + (string)llGetOwner() + "&");
                return;
            }

            string header = "Video mode"+moviename+": ";
            
            if(message == "<< Prev")
            {
                notecardline--;
                if(notecardline < 0)
                    notecardline = numberofnotecardlines - 1;
                tempuser = id;
                llGetNotecardLine(NOTECARD,notecardline);
                return;
            }
            if(message == "Next >>")
            {
                notecardline++;
                if(notecardline >= numberofnotecardlines)
                    notecardline = 0;
                tempuser = id;
                llGetNotecardLine(NOTECARD,notecardline);
                return;
            }
            if(message == "Use")
            {
                if(tempurl == "** No URL specified! **")
                    tempurl = "";
                seturl(tempurl,id);
                return;
            }
                    
            if(message == "Menu")
            {
                menu(id);
                return;
            }
            if(message == "Configure")
            {
                config(id);
                return;
            }
            if(message == "Bookmarks")
            {
                if(notecardcheck != -1)
                {
                    llDialog(id,"Error: No valid bookmark data found in notecard '"+NOTECARD+"'.",["Menu"],chan);
                    return;
                }
                if(finditem(NOTECARD) != -1)                
                {
                    tempuser = id;
                    if(numberofnotecardlines < notecardline)
                        notecardline = 0;
                    llGetNotecardLine(NOTECARD,notecardline);
                }
                else
                    llDialog(id,"Error: No notecard named "+NOTECARD+" found in contents.",["Menu"],chan);
                return;
            }
            
            if(llGetLandOwnerAt(llGetPos()) != llGetOwner())    //If we do not have permissions to actually do the following functions
            {
                llSay(0,"Error: Cannot modify parcel media settings. "+llGetObjectName()+" is not owned by parcel owner.");
                menu(id);
                return; //Abort
            }
            
            if(listenUrl != -1 && channel == 1) //Incoming data from "Set URL" command (user spoke on channel 1)
            {
                llListenRemove(listenUrl);
                listenUrl = -1;
                seturl(message,id);
            }
            if(message == "Play")
            {
                report(header+"Playing");
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_PLAY]);
                return;
            }
            if(message == "Stop")
            {
                report(header+"Stopped");
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_STOP]);
                return;
            }
            if(message == "Pause")
            {
                report(header+"Paused");
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_PAUSE]);
                return;
            }
            if(message == "Unload")
            {
                report(header+"Stopped");
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_UNLOAD]);
                return;
            }
            if(message == "Loop")
            {
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_LOOP]);
                return;
            }
            //URL , Auto-Scale, 
            if(message == "Set URL")
            {
                report(header+"Stopped");
                listenUrl = llListen(1,"",id,"");
                llDialog(id,"Please type the URL of your choice with /1 in thebegining. For example, /1 www.google.com",["Ok"],938);
                return;
            }
            if(message == "Align ON")
            {
                report(header+"Stopped");
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_AUTO_ALIGN,TRUE]);
                menu(id);
                return;
            }
            if(message == "Align OFF")
            {
                report(header+"Stopped");
                llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_AUTO_ALIGN,FALSE]);
                menu(id);
                return;
            }
            if(message == "Set Remote")
            {
                llSay(0,"Configuring remote...");
                encryption = 0;
                llListenRemove(listenRemote);
                listenRemote = llListen(REMOTE_CHANNEL,"","","");
                llSay(REMOTE_CHANNEL,"SETUP");
            }
        }
    }
    
    dataserver(key queryid, string data)
    {
        if(queryid == groupcheck)       //Test if object is deeded to group
        {
            groupcheck = NULL_KEY;
            isGroup = FALSE;
            return;
        }
        
        if(queryid == tempuser) //If just checking number of notecard lines
        {
            numberofnotecardlines = (integer)data;
            notecardkey = llGetInventoryKey(NOTECARD);
            notecardcheck = 0;
            llGetNotecardLine(NOTECARD,notecardcheck);
            return;
        }
        if(notecardcheck != -1)
        {
            if(data != EOF)
            {
                if(data == "")
                {
                    notecardcheck++;
                    llGetNotecardLine(NOTECARD,notecardcheck);
                }
                else
                {
                    notecardcheck = -1;
                    return;
                }
            }
            else
                return;
        }

        if(data == "" && notecardline < numberofnotecardlines)    //If user just pressed "enter" in bookmarks, skip
        {
            notecardline++;
            llGetNotecardLine(NOTECARD,notecardline);
            return;
        }
        
        if(data == EOF)
        {
            notecardline = 0;
            llGetNotecardLine(NOTECARD,notecardline);
            return;
        }
        list parsed = llParseString2List(data,["|","| "," |"," | "],[]);    //Ensure no blank spaces before "http://".
        string name = llList2String(parsed,0);
        tempurl = llList2String(parsed,1);
        if(tempurl == "")
            tempurl = "** No URL specified! **";
            
        tempmoviename = name;
                
        llDialog(tempuser,"Bookmarks notecard ("+(string)(notecardline+1)+"/"+(string)numberofnotecardlines+")\n"+name+" ("+mediatype(llList2String(llParseString2List(tempurl,["."],[]),-1))+")\n"+tempurl,["<< Prev","Use","Next >>","Menu"],chan);
    }
    
    remote_data(integer type, key channel, key message_id, string sender, integer ival, string sval)
    {
        if (type == REMOTE_DATA_CHANNEL)
        {
            XML_channel = channel;
        } 
        else if(type == REMOTE_DATA_REQUEST)
        {
            list media_info = llParseString2List(sval, ["|"], []);
            tempmoviename = llList2String(media_info,0);
            seturl(llList2String(media_info,1),NULL_KEY);
            llRemoteDataReply(channel, message_id, sval, 1);
        }
    }
    
    timer()
    {
        if(llGetTime() > listenTimer)       //If listener time expired...
        {
            llListenRemove(listenHandle);   //Remove listeneres.
            llListenRemove(listenUrl);
            llListenRemove(listenRemote);
            listenHandle = -1;
            listenUrl = -1;
            listenRemote = -1;
            listenTimer = -1;
            if(loop_image == FALSE || mode != 1) //If we're not looping pictures or are in picture mode at all
                llSetTimerEvent(0.0);   //Remove timer
        }
        
        if(loop_image == TRUE && mode == 1) //If we're looping pictures and and we're in picture mode...
            next(); //Next picture
    }
}

