// :CATEGORY:Presentations
// :NAME:SimPerformanceCollector_Web_and_RRD
// :AUTHOR:denise
// :CREATED:2011-03-08 01:38:19.877
// :EDITED:2013-09-18 15:39:02
// :ID:756
// :NUM:1040
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is the lsl-script. Rezz a box, texture it like a server and place it elsewhere on the sim. No need to be a simowner, no need to deed this prim.// This script collects the internal grabable informations: FPS, DIL, servername and simname and sends it via HTTP to a PHP-Script on your website. The PHP-script is below. Attention! Watch, that the path to your php-script is correct!
// :CODE:
integer Count; // counter for averaging FPS
integer FPS_Total; // total fps for averaging
key SimStatusQuery;
string simstatus;  //Needed to show Simstatus on Website
string RegName = "";
string url_inform;
string website = "http://www.yourdomainhere.de/php/write_rrd.php";
string avg;
string fps_condition;
string dil_cond;
string s_count;
string server;
float TimeDil;

send_data(float dil, integer fps)
{
    //fps = fps - 10; //just for testing!
    //dil = dilationtime;
url_inform = llHTTPRequest(website,[HTTP_METHOD,"POST",HTTP_MIMETYPE, "application/x-www-form-urlencoded"],"dil="+(string)dil+"&fps="+(string)fps+"&region="+RegName+"&server="+server+"&method=set");
}

default
{

state_entry()
    {
        RegName = llGetRegionName();
        server=llGetSimulatorHostname();
        Count = 0;
        FPS_Total = 0;

        llSetText("Collecting Performance-Data for \n" + llGetSimulatorHostname() + "\n" + RegName + "...",<1,0,0>,1);
        llSetTimerEvent(60.0);
    }
    
    on_rez(integer peram)
    {
        llResetScript();
    }
    
    timer()
    {
        Count += 1;
        integer RegFPS = llFloor(llGetRegionFPS());
        FPS_Total += RegFPS;
        integer avgFPS = FPS_Total / Count;
        avg = (string)avgFPS;
        RegName = llGetRegionName();
        TimeDil = llGetRegionTimeDilation();
        s_count = (string)Count;
            
        SimStatusQuery = llRequestSimulatorData(RegName, DATA_SIM_STATUS);
        
        send_data((float)TimeDil,(integer)RegFPS);
        //simstatus == "up"/"down"/"starting"/"stopping"/"crashed"/"unknown"
    }

    http_response(key id, integer status, list meta, string body)
    {
        //llSay(0,body);
        string result;
        if (id==url_inform)
        {
            integer stringpartposition = llSubStringIndex(body,"result = ");
            if(stringpartposition != 0)
            {
                result = llGetSubString(body,stringpartposition + 9,-1);
                llStringTrim(result,STRING_TRIM);
            
                if (result == "ERROR occured")
                {
                    llInstantMessage(llGetOwner(),"An error has occured with the Simperformance-Grapher for sim " + RegName + "! Check the rrd and the PHP-Script!");
                }
            }
        }
    }

    dataserver(key queryId, string data) 
        {
            if (queryId == SimStatusQuery) {
                SimStatusQuery = "";
                simstatus = (data);
            }
        }
}
