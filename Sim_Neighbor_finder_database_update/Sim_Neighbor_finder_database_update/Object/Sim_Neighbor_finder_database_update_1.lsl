// :CATEGORY:Lag Meter
// :NAME:Sim_Neighbor_finder_database_update
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-01-21 11:24:34.590
// :EDITED:2013-09-18 15:39:02
// :ID:755
// :NUM:1039
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The free Sim Neighbor database requires updates from either the Ferd Free Translator, a bot that visits weekly or so, or this script.  You can view who your neighbors are and update the db by putting this script into a prim on your land.  If you carry the prim to your detected neighbor, you can update the db with their data.  This flushes older IP addresses from the system
// :CODE:
string url = "http://secondlife.mitsi.com/cgi/llsims.plx?type=report";
default
{
    state_entry()
    {
        llHTTPRequest(url, [], "");
    }
    
    http_response(key request_id, integer status, list metadata, string body)
    {
    }
   

    changed(integer what)
    {
        if(what & CHANGED_REGION ||  what & CHANGED_REGION_START)
            llHTTPRequest(url, [], "");       
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
   
}
