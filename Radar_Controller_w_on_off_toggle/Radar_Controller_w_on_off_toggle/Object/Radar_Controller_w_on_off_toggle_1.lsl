// :CATEGORY:Radar
// :NAME:Radar_Controller_w_on_off_toggle
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:672
// :NUM:913
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Radar Controller w on_off toggle.lsl
// :CODE:

float scanWeather = 0.1;
float scanAirTraffic = 1;
float scanTactical = 5;
integer notify = 1;
integer interval = 30;
integer range = 300;
string radarID="";
key id;
float rotSpeed;

//commands for on/off toggle
string gOff= "radaroff";
string gOn = "radaron";

default
{
    state_entry()
    {
        key owner = llGetOwner();
        //listen for owner to turn on
        llListen(0,"",owner,gOn);
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message == gOn)
        {
            state ON;
        }
    }
}

state ON
{
    state_entry()
    {
        key owner = llGetOwner();
        // Figure out who owns me and listen to them
        llListen(0,"",owner,"");
        
        //listen for owner to turn off
        llListen(0,"",owner,gOff);
        
        // Set up initial rotation
        rotSpeed = scanAirTraffic;
        llTargetOmega(<0,0,1>, rotSpeed, 0);

        // Turn on sensor
        if(notify==1)
            llSensorRepeat("","",AGENT,range,PI,interval);
    }

    // Handle sensor events (if turned on)
    sensor(integer n) {
        integer i;
        string preamble;
        vector pos;
        vector me = llGetPos();
        integer dist;
        integer t = (integer)llGetTimeOfDay();
        string dt =
            (string)((t/3600)%24)
            +":"
            +(string)((t%3600)/60)
            +":"
            +(string)(t%60);
        string iSee = " ";
        for(i=0; i<n; i++) {
            pos = llDetectedPos(i);
            dist = (integer)llVecDist(me, pos);
            iSee += " ["+llDetectedName(i)+" @ "+(string)dist+"M] ";
        }
        if(radarID!="")
            preamble="["+radarID+"] : ";
        else
            preamble = "";
        key owner = llGetOwner();
        llInstantMessage(owner, preamble+iSee);
    }

    // Listen for instructions
    listen(integer channel, string name, key id, string message) {
        float magnitude = 2;
        rotSpeed = -1;
        list cmd = llParseString2List(message, [" "], []);
        string auth = llList2String(cmd, 0);
        
        if (message == gOff)
        {
            llResetScript();
        }
        
        if (id != llGetOwner()) {
            //string op = llToUpper(llList2String(cmd, 0));
            //llSay(0, op+" NAK: Control by non-owners is forbidden.");
            return;
        }

        // Handle 'factory'
        if(auth=="factory") {
            llSay(0, "FACTORY ACK: Resetting to factory defaults.");
            llResetScript();
            // This stuff is obsolete, oh well
            notify = 1;
            interval = 60;
            range = 96;
            radarID="";
            rotSpeed = scanAirTraffic;
            llTargetOmega(<0,0,1>, rotSpeed, 2);
            llSensorRemove();
            llSensorRepeat("","",AGENT,range,PI,interval);
        }

        // Handle 'scanctl x y'
        if(auth=="scanctl") {
            integer scanset=0;
            string scan = llList2String(cmd, 1);
            if(scan=="on") {
                llSensorRemove();
                llSensorRepeat("","",AGENT,range,PI,interval);
                scan="Enable scanner";
                scanset=1;
            }
            if(scan=="off") {
                llSensorRemove();
                scan="Disable scanner";
                scanset=1;
            }
            if(scan=="interval") {
                interval = llList2Integer(cmd, 2);
                scan="Set interval "+(string)interval+" and enable scanner";
                llSensorRemove();
                llSensorRepeat("","",AGENT,range,PI,interval);
                scanset=1;
            }
            if(scan=="range") {
                range = llList2Integer(cmd, 2);
                scan="Set range "+(string)range+" and enable scanner";
                llSensorRemove();
                llSensorRepeat("","",AGENT,range,PI,interval);
                scanset=1;
            }
            if(scan=="name") {
                radarID = llList2String(cmd, 2);
                scan="Set name '"+radarID+"'";
                scanset=1;
            }
            if(scanset!=1) {
                llSay(0, "SCANCTL: Try 'on', 'off', 'name xyz', 'interval x' (seconds), or 'range x' (0-96).");
            } else {
                llSay(0, "SCANCTL ACK: ["+scan+"]");
            }
        }
            
        // Handle 'radarctl x y z'
        if(auth=="radarctl") {
            string speed = llList2String(cmd, 1);
            if(speed=="Weather")
                rotSpeed = scanWeather;
            if(speed=="AirTraffic")
                rotSpeed = scanAirTraffic;
            if(speed=="Tactical")
                rotSpeed = scanTactical;
            if(speed=="stop")
                rotSpeed = 0;
            if(speed=="speed") {
                rotSpeed = llList2Float(cmd, 2);
                speed = "Set speed "+(string)rotSpeed;
            }
            if(rotSpeed == -1) {
                llSay(0, "RADARCTL: Try 'Weather', 'AirTraffic', 'Tactical', 'stop', or 'speed n.nn'.");
            }
            if(rotSpeed >= 0) {
                llSay(0, "RADARCTL ACK: ["+speed+"]");
                if(rotSpeed==0)
                    magnitude = 0;
                llTargetOmega(<0,0,1>, rotSpeed, magnitude);
            }
        }
    }
}// END //
