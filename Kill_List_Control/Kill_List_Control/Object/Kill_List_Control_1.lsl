// :CATEGORY:Weapons
// :NAME:Kill_List_Control
// :AUTHOR:Charlie Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:423
// :NUM:579
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Kill List Control.lsl
// :CODE:

// Xavier#s Gun Control Script
// : Master Computer Relay on 2167811067 ( send / receive )
// : Updates guns Friends list on 2167812300 ( transmit list)
// : Receives Gun reply#s on 2166617540 / Set ON/OFF / Confirm list, Confirmed On / Off)

// Init Lists
list Ops = ["Charlie Omega"];
list kos;

integer guns_on = FALSE;

integer talk_channel = 0;

// Function to Talk
talk(integer atchan, string saydis)
{
  if (talk_channel == 0)
  {
  llSay(talk_channel,saydis);
  }
  else
  {
  llShout(talk_channel,saydis);
  }

}   

// Functions to check Ops list
integer isNameOnList( string name, list test )
{
    list single_name_list;
    single_name_list += name;
    
    return (-1 != llListFindList( test, single_name_list ) );
}

// Function Display List Data
display(string test)
{ 
    string textstring = "";
            
    if (test == "OPS")
    {
        textstring = llList2CSV(Ops);
        
      }
    
    if (test == "kos")
    {
        textstring = llList2CSV(kos);
       }
    
    if ( textstring == "" )
    {        
     talk( talk_channel, test + " - Returned no Data");   
    }
    else
    {
         talk( talk_channel, textstring); 
    }
                  
}

// Function Add to Friends List
addlist(string name)
{
   kos += name;
       
}

// Function Kill from kos list
offlist(string name)
{
    
    list single_name_list;
    single_name_list += name;
    
   integer nameat = llListFindList(kos, single_name_list );
   if (nameat > -1)
   {
    kos = llDeleteSubList(kos, nameat,nameat );
   }
   else
   {
            talk( talk_channel, name + " - Invalid Data");
    }   
}

// Function to shout to all Guns
tellgun(string commands)
{

if (commands == "ON" )
{
llShout(2166617540,"GON");
guns_on = TRUE;
}

if (commands == "OFF" )
{
llShout(2166617540,"GOFF");
guns_on = FALSE;
}
    
if (commands == "UPDATE" )
{
string textstring = llList2CSV(kos);
llShout(2167812300, textstring);
}    


} 


status()
{

string report;

if (guns_on == TRUE)
{
    report = " Status - Online"; 
    
}   
else
{
     report = " Status - Offline"; 
} 

talk(talk_channel, report);
    
}


help()
{
    talk(talk_channel,"__________________________________");
    talk(talk_channel,"|                                                                  |");
    talk(talk_channel,"| Combat Computer Options                        |");
    talk(talk_channel,"|--------------------------------------------|");
    talk(talk_channel,"| ADD < Name > - add to kill list                 |");
    talk(talk_channel,"| REMOVE < Name > - remove from kill list |");
    talk(talk_channel,"| LIST ( ops / koss ) - display list                |");
    talk(talk_channel,"| GUNS ( on / off ) - turn guns on / off         |");
    talk(talk_channel,"| GUNS Update - copy friends list to guns   |");    
    talk(talk_channel,"| STATUS - Display current system status    |");
    talk(talk_channel,"|_________________________________|");  
}

default
{
    state_entry()
    {
       llListen(0, "", "", ""); // Local Reception
       llListen(2167811067, "", "", ""); // Relay Reception    
       llListen(2166617540, "", "", ""); // Gun Transmission Reception
    }

        listen(integer channel, string name, key id, string message)
        {

            talk_channel = channel;

            string temp_message = llToUpper(message);
            integer strlong = llStringLength(message);
            
           if( isNameOnList(name,Ops)==TRUE | channel == 2167811067 )
           {
           
               if(llGetSubString(temp_message, 0, 3)=="LIST")
               {
                string test = llGetSubString(temp_message, 5, strlong);
                display(test);
               }
                
               if(llGetSubString(temp_message, 0, 2)=="ADD")
               {
                string test = llGetSubString(message, 4, strlong);
                addlist(test);
                     }                

               if(llGetSubString(temp_message, 0, 5)=="REMOVE")
               {
                string test = llGetSubString(message, 5, strlong);
                offlist(test);
                           }    
                
                 if(llGetSubString(temp_message, 0, 3)=="GUNS")
               {
                string test = llGetSubString(temp_message, 5, strlong);
                tellgun(test);
                           }
                if(llGetSubString(temp_message, 0, 7)=="COMMANDS")
               {
                string test = llGetSubString(temp_message, 5, strlong);
                help();
                
                           }                                     
                if(llGetSubString(temp_message, 0, 5)=="STATUS")
               {
                string test = llGetSubString(temp_message, 5, strlong);
                status();
                
                           } 
                
            } // end commands reception
            
            if (channel == 2166617540)
            {
                llSay(0, name + " - " + message);
                llShout(2167811067, name + " - " + message);
            }
    
        }

}// END //
