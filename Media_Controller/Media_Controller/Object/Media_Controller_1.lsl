// :CATEGORY:TV
// :NAME:Media_Controller
// :AUTHOR:Bel Linden
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:510
// :NUM:681
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Media Controller.lsl
// :CODE:

// Media Controller 1.0
// by ben linden
//
//
// This makes it very easy to start a streaming movie on your parcel.  It is meant to be easy to use. You can make a much more simple script with similar funtionality - what I am trying to do here is make rez-to-watch in as few mouseclicks as possible.  For more instructions on using this script, please click the question mark.




key default_texture = "8b5fec65-8d8d-9dc5-cda8-8fdf2716e361";
string default_media_url = "http://secondlife.com/community/video/trailer_contest_2005/JavierPuff.mov";

key texture;
string media_url;
 
integer screen_chan = 8904312;
integer command;
integer pause;

media_check()
{
    
    list mediacheck = llParcelMediaQuery([PARCEL_MEDIA_COMMAND_TEXTURE, PARCEL_MEDIA_COMMAND_URL]);
    key start_texture = llList2Key(mediacheck, 0);
    string start_media_url = llList2String(mediacheck, 1);
    
    if(start_texture)
    {
        //if there is a texture already there, use that
        texture = start_texture;
        
    }
    else
    {
        // no texture, set one!
        llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_TEXTURE, default_texture]);
        texture = default_texture;
    }
    
    if(start_media_url)
    {
        //if there is a texture already there, use that
        media_url = start_media_url;
        
    }
    else
    {
        // no texture, set one!
        llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_URL, default_media_url]);
        media_url = default_media_url;
    }
    
    
    
}

screen_check_start()
{
    llSensor("Movie Screen", "", SCRIPTED, 30.0, PI);
}

screen_check_result(integer number)
{       
        
        //Look for screens
        integer i;
        integer screens_found = 0;
        for(i=0; i<number; i++)
        {
            if(llDetectedOwner(i) == llGetOwner())
            {
                //Are screens owned by me?
                screens_found++;
            }
        }
        
        if(screens_found < 1)
        {
            //if no screens, Rez a screen
            vector pos = llGetPos();
            rotation rot = llGetRot();
            
            pos.z += 1.0;
            llRezObject("Movie Screen", pos, ZERO_VECTOR, rot, 0);
        }
        
        llSay(screen_chan, (string)texture);
        llParcelMediaCommandList([command]);
        
        
}

 
// Example media stuff
default
{
    link_message(integer sender, integer num, string message, key id)
    {
    
     if(message == "pause")
     {
         llMessageLinked(LINK_SET, 0, "paused", "");
         llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_PAUSE]);
         pause = TRUE;
         
     }
     
       
     if(message == "play")
     {
          if(pause)
          {
            llMessageLinked(LINK_SET, 0, "unpaused", "");
            llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_PLAY]);
            pause = FALSE;
            
          }
          else
          {
            llMessageLinked(LINK_SET, 0, "playing", "");
            command = PARCEL_MEDIA_COMMAND_PLAY;
            media_check();
            screen_check_start();
          } 
            
     }
     
     if(message == "loop")
     {
          if(pause)
          {
            llMessageLinked(LINK_SET, 0, "unpaused", "");
            llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_LOOP]);
            pause = FALSE;
              
          }
          else
          {
            llMessageLinked(LINK_SET, 0, "playing", "");
            llMessageLinked(LINK_SET, 0, "looping", "");
            command = PARCEL_MEDIA_COMMAND_LOOP;
            media_check();
            screen_check_start();
          }   
     }
     
     
     
        
      if(message == "stop")
     {
         pause = FALSE;
         llMessageLinked(LINK_SET, 0, "unpaused", "");
         llMessageLinked(LINK_SET, 0, "stopped", "");
         
         llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_STOP]);
     }
         
        
        
        
    }
    
    sensor(integer detected)
    {
       screen_check_result(detected);
    }
    
    no_sensor()
    {
        screen_check_result(0);
    }
    
    on_rez(integer param)
    {
        pause = FALSE;
        llMessageLinked(LINK_SET, 0, "unpaused", ""); 
        llMessageLinked(LINK_SET, 0, "stopped", "");
        llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_AUTO_ALIGN, TRUE]);
    }
}

// END //
