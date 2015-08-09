// :CATEGORY:Presentations
// :NAME:SL_Pie_Chart_Maker
// :AUTHOR:Angrybeth Shortbread 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:03
// :ID:788
// :NUM:1077
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// There's nothing like a pie chart for displaying survey results. Set this up in three steps - Rez the base, get its email address, send it formatted results. Bang! A fine little 3D chart builds before your eyes. // // The system uses three scripts:// //     * Pie Chart Maker = the controller - receives email and sends the subject line to Title maker. Then it rezzes segment objects, calculates segment shapes and sends settings to Pie Segment//     * Title Maker = a label - simply displays the title of the incoming email.
//     * Pie Segment = the colored wedges - rezzed by Pie Chart Maker and changes cut shapes and colors. 
// :CODE:
//Pie Chart Maker
//by Angrybeth Shortbread, 2006
//Concept by Jeremy Kemp / www.simteach.com
//Distrubute Freely and adapt....

//This script works by creating a list of the value of each segment , based on the string provided by an email...
//The email needs to be in the format
//Subject - What the Title of the Pie Chart is
//Message - Percentage Value,Colour,Description
//the message body would look like - 45,red,Labour,30,blue,Conservative,25,yellow,Liberal

//Colour names can be customised in the piesegment script, if you want to add additional hues.

//It then rezzes a number of segment blocks.
//Each Segment block is given is own private chat channel via the start_param function of llRez
//Once all Segment blocks are in place
//They are inturn told the data nessecary to visualise the information.


integer numofsegments;

integer chatchannel = 300000; // The starting number of private chat channels that are added to incrementely

integer chatchannelrez; // and assigned to this

vector mypos;

float segmentheight; 

list segments;

list segmentsize;

list segmentdesc; 

list segmentcolour;

list backup; // this is a list that copies the data and truncates it for striding reasons


default
{
    
    on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        
    llSetTimerEvent(2.5); // A timer is needed so emails sent to the object are read.
    
    mypos = llGetPos();
    
    segmentheight = 0.3; // the gap between each segment - to give an exploded pie chart - make this zero - if you want it to be flat.
  
    
    }
    
    touch_start(integer param)  // This only allows the owner to get the email address of the piechartmaker
    {
       key who = llDetectedKey(0);
       if (who == llGetOwner() )
       {
       string myname = llGetKey();
       llSay(0, (string)myname + "@lsl.secondlife.com");
       }
       
       // *** addition could be on touch - to send an email to the server outside Second life that is providing the data
    }
    
    timer() 
    {
        llGetNextEmail("", "");  // Every 2.5 seconds - the object sees if there's been an email sent - if so then it triggers the email event
    }
    
    //This version uses email - but the following below could be used in a listen event instead...
    
    email(string time, string address, string subj, string message, integer num_left) {
    {
        llOwnerSay("Recieving data...."); // - Tells the owner I've got data from an email
        
        // llSay(0, message); - Debug to display the email message body recieved   
        
        segments = llParseString2List(message, [","], []); // takes the messagebody of the email and converts it into a list of strings.
        llSleep(0.2); // probably not needed
        segmentsize = llList2ListStrided(segments, 0, -1, 3); // this is making a new list - that only contains the percentage value
        
        integer lengthy = llGetListLength(segments); 
        backup = llList2List(segments, 1, lengthy); // as lists are annoying to stride - this is making a backup - where it is removing the first bit from the list to make it easier to stride
        segmentcolour = llList2ListStrided(backup, 0 ,-1, 3); // this is making a list - that only contains the colour information for the pie segment
        
        lengthy = llGetListLength(backup); 
        backup = llList2List(backup, 1, lengthy);  // and one more time
        segmentdesc = llList2ListStrided(backup, 0 ,-1 ,3); // this is making a list - that only contain the description
        
      //  llSay(0, llDumpList2String(segmentsize, " + "));
      //  llSay(0, llDumpList2String(segmentdesc, " + "));   // a bunch of chat debugs to see if its sliced up the original email message properly
      // llSay(0, llDumpList2String(segmentcolour, " + "));
        
        llMessageLinked(LINK_SET, 0, subj, NULL_KEY); // this sends the subject line of the email to a linked prim so it can display it as the title of the pie chart.
        
        state create; // its prepare all the lists it needs to create the chart 
        
    
    }
}
    
}

state create
{
    state_entry()
    {
    
    llSay(0, "creating pie chart..."); // a public message to get attention.. ohhhhh!
    
    llSay(400000, "delete");  // if there are already segments from a previous pie chart - this sends a command to delete them.
    
    llSleep (1.0); // Just have a sleep - to make sure all the segments got the instruction to delete..
    
    numofsegments = llGetListLength(segmentsize); // this works out how many pie segments to make
    
    integer i;
    
    for (i = 0; i < numofsegments; ++i) // the For loop - keeps rezzing piesegment (from the piemaker content's ) until the number needed is met
    {
        
    chatchannelrez = chatchannel + i; // each segment will have a unique private chat channel associated with it
    
    llRezObject("piesegment",mypos + <0,0,segmentheight>, ZERO_VECTOR, ZERO_ROTATION, chatchannelrez); // this rezzes the piesegment - above the piemaker and sets the chatchannel as the new segements starting param.
    
    segmentheight = segmentheight + 0.3; // to make the pie segments keep on going up ...
    
    llSleep(0.2); 
    
          
    } 
    
    //Once the For loop is done - of to the next event
                
    state piedata; 

}
    
}

state piedata
{

state_entry()
    {
    
    float slicedend = 0.0;
    float previoussliceend = 0.0;
    string slicestart = "";
    string sliceend = "";
    string slicedesc = "";
    string slicecolour;
    
    // llSay(0, "now sending data to segments..."); 
    
    numofsegments = llGetListLength(segmentsize);
    
    // The first pie segment - needs to be handled outside the for loop ( well just to make life easier for myself )
    
    llSay(chatchannel, "0" + "," + llList2String(segmentsize, 0) + "," + llList2String(segmentcolour, 0) + "," + llList2String(segmentdesc, 0) );
    
    string first = (llList2String(segmentsize, 0));
    
    previoussliceend =  (float)(first); // this is important as it helps sort out the value of were the data for the next path cut begins
    
    integer i;
    
    for (i = 1; i < numofsegments; ++i) // another For Loop to cycle thru sending data to each segment in turn.
    {
        
        chatchannelrez = chatchannel + i;
        
        slicestart = (llList2String(segmentsize, i - 1 )); 
        sliceend = (llList2String(segmentsize, i ));
        slicedesc = (llList2String(segmentdesc, i ));
        slicecolour = (llList2String(segmentcolour, i ));
        
        float slicedstart = previoussliceend; // were the next part cut begins
        slicedend = (float)(sliceend) + previoussliceend; // and ends
        
        
         
        previoussliceend = slicedend; // then retain that info for the nexts segments part start
        
        llSleep(0.2); // have a kip between each chat message
        
        llSay(chatchannelrez, (string)(slicedstart) + "," +(string)(slicedend) + "," + (string)(slicecolour) + "," + (string)(slicedesc));
        
    }
    
    state default; // its done all the work so its back to the start again - to wait for a new email.
}

state_exit()
{
    llSay(0, "Compiled Pie Chart"); // on state exit - just tell everyone that you've done the job...yay!!
    
}
       
}

