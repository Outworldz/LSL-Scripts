// :CATEGORY:Sim Texture
// :NAME:Put_a_sim_map_on_a_texture
// :AUTHOR:Tyche Shepherd
// :CREATED:2010-07-16 14:25:07.520
// :EDITED:2013-09-18 15:39:00
// :ID:669
// :NUM:910
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This version returns the Object Layer Map (i,e the default map image) but shows how you can also request the Terrain Layer Map.
// :CODE:
/*
   Example script to apply a Region Map as a texture on a Prim
   Author: Tyche Shepherd
   Date: 2010-02-11
   Copyright: Tyche Shepherd 2008-2010
   License: Creative Commons Attribution 2.0 UK:England & Wales License
   
   Basically you can do anything with this script including making derivative commercial works as long as you credit
   Tyche Shepherd and gridsurvey.com . This credit should be distributed with any product.  
   See http://www.gridsurvey.com/api.php for more details on this license as well as any caveats.
   
   The script sets up a listen  when the container prim is touched. 
   The user then speaks the name of the desired region on the channel (default is channel 87)
   A llHTTPRequest is sent to http://api.gridsurvey.com which returns the UUID of that Region's Map if it's found.
   The Container Prim's texture is then changed to this UUID
   The Listen times out after 10 seconds.
   
   The gridsurvey.com Region Database is normally updated on a daily basis with the latest Region Maps.
   
*/
key requestID; 
integer handle;
integer channel;
string currentsim;
string query_string;

default
{

    state_entry()
    { 
     handle=0;
     //use channel 87 for listening
     channel=87;  
    }

    touch_start(integer total_number)
    {
      if(handle!=0){
          llListenRemove(handle);
          handle=0;
      }  
      llSay(0,"Say name of Region you want on channel " + (string)channel);
      handle=llListen(channel,"","","");
      //set listen time out to 10 seconds
      llSetTimerEvent(10.0);
 
    }
    listen(integer channel, string name, key id, string message)
    {
       currentsim=message;
       /*urlencode region name and create the query string  
       &item=objects_uuid requests the object map layer 
       &item=terrain_uuid requests the terrain map layer 
       */
       query_string="region=" + llEscapeURL(message) + "&item=objects_uuid"; 
       
       //send the request to api.gridsurvey.com
       requestID = llHTTPRequest("http://api.gridsurvey.com/simquery.php",[HTTP_METHOD, "POST",HTTP_MIMETYPE,"application/x-www-form-urlencoded"], query_string);


        //close the current listen
        llSetTimerEvent(0.0);
        if(handle!=0)llListenRemove(handle);
        handle=0;

     }



    http_response(key req_id, integer status, list meta, string body)
    {
        if (req_id == requestID)
        {
            if(llGetSubString(body, 0, 4)=="Error") {
               //the api returned an error so report it   
               llSay(0,body);
            } else {  
               //set the prim texture     
              llSetTexture(body, ALL_SIDES);
              llSay(0,"Current Region Map UUID for "+ currentsim + " is "+ body);

            }
             
        }
        else
        {
            llSay(0,"Error: " + (string)status);
         }
    }
    timer()
    {  
       //if fired due to timeout close the listen 
       if(handle!=0){
           llSay(0,"Region Map change timed out after 10 seconds. Please touch again to change the Region Map");
           llListenRemove(handle);
           handle=0; 
      }    
      llSetTimerEvent(0.0);
    }

}
