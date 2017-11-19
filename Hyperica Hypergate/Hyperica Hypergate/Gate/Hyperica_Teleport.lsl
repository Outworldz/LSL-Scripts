string URL ="http://www.hyperica.com/lookup/?cat="; 

//Cat (category) numbers:
//0: WELCOME
//3: EDUCATION   
//8: RETAIL    
//10: VENUES

//Sort codes: 1=popularity  2=latest additions


string SimAddress;     //the hypergrid address
string SimName;        //the destination region name
string SimSnapshotURL; //URL of the photo -- this script doesn't use it, but you can use 
string GridName;        //name of the destination's grid
string SimLocation;    //Upper, middle or lower

key httpkey;//This stores the key for the HTTP request we send.
string body_retrieved; // this will hold what is returned from  http request

vector LandingPoint = <128.0, 128.0, 22.0>;
vector LookAt       = <1.0,1.0,1.0>;
 
list LastFewAgents; 

LoadDestination ()
{
    list Description = llParseString2List(llGetObjectDesc(),[","," "],[]);
    
    string Category = llList2String(Description,0);
    
    integer CatNum = 0;
    
    if (llToUpper(Category)=="EDUCATION") CatNum=3;
    if (llToUpper(Category)=="RETAIL") CatNum=8;
    if (llToUpper(Category)=="VENUES") CatNum=10;
    
    
    URL = URL+(string) CatNum+"&region="+llList2String(Description,1)+"&sort=1";
    
    llSay(0, URL);
    
    httpkey=llHTTPRequest(URL, [] ,"");
    
    llSetText("No destination set.",<1,1,1>,1);
    
}


PerformTeleport( key WhomToTeleport )
{
    integer CurrentTime = llGetUnixTime();
    integer AgentIndex = llListFindList( LastFewAgents, [ WhomToTeleport ] );      // Is the agent we're teleporting already in the list?
    if (AgentIndex != -1)                                                          // If yes, check to make sure it's been > 5 seconds
    {
        integer PreviousTime = llList2Integer( LastFewAgents, AgentIndex+1 );      // Get the last time they were teleported
        if (PreviousTime >= (CurrentTime - 30)) return;                             // Less than five seconds ago? Exit without teleporting
        LastFewAgents = llDeleteSubList( LastFewAgents, AgentIndex, AgentIndex+1); // Delete the agent from the list
    }
    LastFewAgents += [ WhomToTeleport, CurrentTime ];                              // Add the agent and current time to the list
    llMapDestination(SimAddress, LandingPoint, LookAt);  
           
    //IF OS scripts are enabled, you can use this:
    //osTeleportAgent( WhomToTeleport, SimAddress, LandingPoint, LookAt );
                             
}


default
{
    state_entry()
    { 
    
    LoadDestination();
    
     }

      http_response(key id, integer status, list meta, string body)

        {
            body_retrieved = body;

            SimName = llGetSubString(body_retrieved, llSubStringIndex(body,"<!--REGION NAME-->")+18, llSubStringIndex(body, "<!--END REGION NAME-->")-1);

            GridName = llGetSubString(body_retrieved, llSubStringIndex(body,"<!--GRID NAME-->")+16, llSubStringIndex(body, "<!--END GRID NAME-->")-1);

            SimLocation = llGetSubString(body_retrieved, llSubStringIndex(body,"<!--LOCATION-->")+15, llSubStringIndex(body, "<!--END LOCATION-->")-1);

            SimAddress = llGetSubString(body_retrieved, llSubStringIndex(body,"<!--HGURL-->")+12, llSubStringIndex(body, "<!--END HGURL-->")-1);

            llSetText("Hypergate to\n"+ SimName +"\non\n"+GridName,<1,1,1>,1);

 string CommandList = ""; 
  
        CommandList = osMovePen( CommandList, 25, 75 );
        CommandList += "FontSize 16;";
        CommandList = osDrawText( CommandList, SimName +" on "+GridName );
        osSetDynamicTextureDataBlendFace( "", "vector", CommandList, "width:256,height:256", FALSE, 2, 0, 255, 3 );

        }

    touch_start(integer number)
        {    LoadDestination();  }

    collision(integer number)
        {    PerformTeleport( llDetectedKey( 0 ));  }

}