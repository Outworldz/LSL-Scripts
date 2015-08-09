// :CATEGORY:Camping
// :NAME:Camp
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:147
// :NUM:214
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Camp
// :CODE:
integer campmoney = 0;
integer campadd = 2;
integer camptime = 300;
integer campcycle = 2;
integer cyclesLeft = 0;
string reciever;

// for loading notecard
string notecardName;
key notecardQuery;
integer notecardIndex;

displayText()
{
    if( reciever!=NULL_KEY )
    {
        if( campcycle>0 )
        {
            llSetText("Money:"+(string)campmoney + "\nCycles Left: " + (string)cyclesLeft,<0,0,0>,1);
        }
        else
        {
            llSetText("Money:"+(string)campmoney,<0,0,0>,1);            
        }
    }
    else
    {
        llSetText("Sit here for free money,\nL$"
            +(string)campadd+" every "
            +(string)(camptime/60)+" minutes.",<0,0,0>,1);
    }
    
    
}

default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT );  
    }

    on_rez(integer s)
    {
        llResetScript();
    }

    run_time_permissions (integer perm)
    {
        if(perm & PERMISSION_DEBIT)
        {
            notecardName = "Config";
            state loading;     
        }
    }
}

state ready 
{
    state_entry() 
    {
        reciever = NULL_KEY;
        displayText();        
        llSitTarget(<0, 0, 1>, ZERO_ROTATION); 
    }
    
    touch_start(integer num_detected)
    {
        if( llDetectedKey(0)==llGetOwner() )
        {
            llSay(0,"Camping pad resetting.");
            llResetScript();
        }
    }

    changed(integer change) 
    { 
        if (change & CHANGED_LINK) 
        {
            if (llAvatarOnSitTarget() != NULL_KEY) 
            { 
                cyclesLeft = campcycle;
                reciever = llAvatarOnSitTarget();
                displayText();
                llSetTimerEvent(camptime);
            }
            else
            {
                if( campmoney<1 )
                {
                    llInstantMessage(reciever, "You did not stay long enougn to earn any money.");
                }
                else
                {
                    llGiveMoney(reciever,campmoney);
                }
                
                reciever=NULL_KEY;
                campmoney=0;
                displayText();
                llSetTimerEvent(0);
            }
        }
    }
    
    

    timer()
    {
        campmoney = campmoney+campadd;
        if( campcycle>0 )
        {
            cyclesLeft--;
            if( cyclesLeft<=0 )
            {
                llSay(0,"Standing avatar after " + (string)campcycle + " cycles.");
                llUnSit(reciever);                
            }
        }
        displayText();
    }
}

state loading
{
    state_entry()
    {
        llSay(0,"Camping pad loading data...");
        notecardIndex = 0;
        notecardQuery = llGetNotecardLine(notecardName,notecardIndex++);    
    }
    
    dataserver(key query_id, string data) 
    {
        if ( notecardQuery == query_id) 
        {
            // this is a line of our notecard
            if (data == EOF) 
            {    
                llSay(0,"Data loaded...");
                state ready;

            } else 
            {
                if( notecardIndex==1 )
                {
                    camptime = ((integer)data)*60;
                }
                else if( notecardIndex==2 )
                {
                    campadd = (integer)data;                    
                }
                else if( notecardIndex==3 )
                {
                    campcycle = (integer)data;
                }
                
                notecardQuery = llGetNotecardLine(notecardName,notecardIndex++); 
            }
        }
    }
}
