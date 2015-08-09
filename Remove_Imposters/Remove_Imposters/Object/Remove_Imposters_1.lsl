// :CATEGORY:Security
// :NAME:Remove_Imposters
// :AUTHOR:Zena Juran
// :CREATED:2010-11-16 11:12:46.430
// :EDITED:2013-09-18 15:39:01
// :ID:692
// :NUM:946
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Remove_Imposters
// :CODE:
// Sensor Detect/Remove Display Name Impostor by Zena Juran



////////////////////////////////////////////////////////////////////////////

// This script will detect and remove (from owner's land) any avatars using the same Display Name as the owner's User Name.

// Place one copy of script into any prim and rez on your owned land.

// Touch prim to toggle on and off.

// Ejection and TPHome are immediate with NO WARN TIME or MESSAGE

////////////////////////////////////////////////////////////////////////////




////////////////////////////////////////////////////////////////////////////

// Change These Values to Match Specific Needs

// Set Scan Range (meters)
float range = 96;

//Set Scan Time (seconds) 
float rate = 5;

// Set Method of Impostor Removal to TRUE (only one integer TRUE at a time)

integer eject = FALSE; //Eject from Land Only
integer tp = TRUE; //Teleport Home Only
integer ejectb = FALSE; // Eject and Ban from Land
integer tpb = FALSE; //Teleport Home and Ban from Land

// Notify via IM Impostor Removal
integer IM = FALSE; 

///////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////

// Do Not Change These Variables

list ParcelDetails;
string ParcelName;
string owner;
integer Timer;
list impostorlist;
integer k;
integer status;

//////////////////////////////////////////////////////////////////////////


default
{
    state_entry()
    {
        ParcelDetails = llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_NAME, PARCEL_DETAILS_OWNER, PARCEL_DETAILS_GROUP]);
        ParcelName = llList2String(ParcelDetails,0);
        owner = llToLower(llKey2Name(llGetOwner()));
        Timer = FALSE;
        status = FALSE;
        llSetText("Sleeping", <1,1,1>, 1.0);
        impostorlist = [];
        llSensorRemove();
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            status = !status;
            if(status)
            {
                llSetText("Scanning for Impostors", <1,1,1>, 1.0);
                llSensorRepeat("", NULL_KEY, AGENT, range, PI, rate);
            }
            else
            {
                llSetText("Sleeping", <1,1,1>, 1.0);
                impostorlist = [];
                llSetTimerEvent(0.0);
                llSensorRemove();
            }
        }
            
    }
    
    sensor(integer nr)
    {
        integer i;
        for(i = 0; i < nr; ++i)
        {
            key avatar = llDetectedKey(i);
            string davatar = llToLower(llGetDisplayName(avatar));
            if((davatar == owner) && (avatar != llGetOwner()) && (llOverMyLand(avatar)==TRUE))
            {
                if(llListFindList(impostorlist,[avatar])==-1)
                {
                    impostorlist = impostorlist + [avatar];
                }
            }
        }
        
        k = llGetListLength(impostorlist);
        if((Timer==FALSE) && (k>0))
        {
            Timer = TRUE;
            llSetTimerEvent(1.0);
        }
    }
    
    no_sensor()
    {
        impostorlist=[];
        Timer = FALSE;
        llSetTimerEvent(0.0);
    }
    
    timer()
    {
        k = llGetListLength(impostorlist);
        if(k>0)
        {
            integer j;
            for(j=0; j<k; ++j)
            {
                key impostor1 = llList2Key(impostorlist,j);
                if (llOverMyLand(impostor1))
                {
                    if(eject)
                    {
                        llEjectFromLand(impostor1);
                    }
                    if(tp)
                    {
                        llTeleportAgentHome(impostor1);
                    }
                    if(ejectb)
                    {
                        llEjectFromLand(impostor1);
                        llAddToLandBanList(impostor1,0.0);
                    }
                    if(tpb)
                    {
                        llTeleportAgentHome(impostor1);
                        llAddToLandBanList(impostor1,0.0);
                    }
                    impostorlist = llDeleteSubList(impostorlist,j,j);
                    if(IM)
                    {
                        string impostor2 = llKey2Name(impostor1);
                        llInstantMessage(llGetOwner(),"Removing " + impostor2 + " from " + ParcelName);
                    }
                }
                else
                {
                    impostorlist = llDeleteSubList(impostorlist,j,j);
                }
            }
        }
        else
        {
            Timer = FALSE;
            llSetTimerEvent(0.0);
        }
    }
}
