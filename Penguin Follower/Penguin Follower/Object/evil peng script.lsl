// :CATEGORY:Follower
// :NAME:Penguin Follower
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:59
// :ID:619
// :NUM:843
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Make a pet follow you
// :CODE:

////////////////////////////////////////////
// Follow Me Script
//
// Written by Xylor Baysklef
// Adapted and added by Garth Fairlight
////////////////////////////////////////////

/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "-y";
vector POSITION_OFFSET  = <0.0, 0.75, -0.8>; // Local coords
float   SCAN_REFRESH    = 0.2;
string FOLLOW   = "/follow";
string STAY     = "/stay";
integer FOLLOW_STOP     = 5000;
integer FOLLOW_START    = 5001;
float   MOVETO_INCREMENT    = 6.0;
///////////// END CONSTANTS /////////////////

///////////// GLOBAL VARIABLES ///////////////
key gOwner;
rotation gFwdRot;
float   gTau;
float   gMass;
integer count;
integer repeat;
/////////// END GLOBAL VARIABLES /////////////

help()
{
    llWhisper(0,"You can say the following commands:");
    llWhisper(0,"/follow <-- I will follow you around");
    llWhisper(0,"/stay <-- I will stay where I am.");
    llWhisper(0,"/help <-- I will repeat this message.");
    llWhisper(0,"if I lose you I will IM my position to you unless");
    llWhisper(0,"I am in a no script area, then I can do nothing.");
}

StartScanning() 
{
    llSetStatus(STATUS_PHYSICS, TRUE);
    llSensorRepeat("", gOwner, AGENT, 96.0, PI, SCAN_REFRESH);
    llWhisper(0, "Greetings Master !");
}

StopScanning() 
{
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSensorRemove();
    llWhisper(0, "Dont leave This one Mistress :(");
}

// Move to a position far away from the current one.
MoveTo(vector target) 
{
    vector Pos = llGetPos();
    
    while (llVecDist(Pos, target) > MOVETO_INCREMENT) 
    {
        Pos += llVecNorm(target - Pos) * MOVETO_INCREMENT;
        llSetPos(Pos);
    }
    llSetPos(target);    
}

rotation GetFwdRot() 
{
    // Special case... 180 degrees gives a math error
    if (FWD_DIRECTION == "-x") 
    {
        return llAxisAngle2Rot(<0, 0, 1>, PI);
    }
    
    string Direction = llGetSubString(FWD_DIRECTION, 0, 0);
    string Axis = llToLower(llGetSubString(FWD_DIRECTION, 1, 1));
    
    vector Fwd;
    if (Axis == "x")
        Fwd = <1, 0, 0>;
    else if (Axis == "y")
        Fwd = <0, 1, 0>;
    else
        Fwd = <0, 0, 1>;
        
    if (Direction == "-")
        Fwd *= -1;
       
    return llRotBetween(Fwd, <1, 0, 0>); 
}

rotation GetRotation(rotation rot) 
{
    vector Fwd;
    Fwd = llRot2Fwd(rot);
    
    float Angle = llAtan2( Fwd.y, Fwd.x );
    return gFwdRot * llAxisAngle2Rot(<0, 0, 1>, Angle);
}

default 
{
    state_entry() 
    {
        llSetStatus(STATUS_PHANTOM, TRUE);
        gOwner = llGetOwner();
        gFwdRot = GetFwdRot();
        gMass = llGetMass();
        gTau = 0.2;
        llListen(0, "", "", "");
        llSetTimerEvent(1.5);
        StartScanning();
        llMoveToTarget(llGetPos(), gTau);
    }
    
    sensor(integer num_detected) 
    {
        rotation TargetRot;
        vector Pos = llDetectedPos(0);
        rotation Rot = llDetectedRot(0);
        vector size = llGetAgentSize(llDetectedKey(0));
        if((llGetAnimation(gOwner) == "Flying") || (llGetAnimation(gOwner) == "FlyingSlow"))
        {
            TargetRot = llEuler2Rot( <80, 0, 10> * DEG_TO_RAD) * GetRotation(Rot);
            POSITION_OFFSET  = <2.0, 0.75, 0.0>;
        }
        else 
        { 
            TargetRot = GetRotation(Rot); 
            POSITION_OFFSET  = <0.0, 0.75, (-size.z / 2) + 0.1>;        
        }
        vector Offset = POSITION_OFFSET * Rot;
        Pos += Offset;
        llRotLookAt(TargetRot, gTau * 5.0, gTau);
        llMoveToTarget(Pos, gTau);
        count=0;
        repeat=0;
    }
    
    no_sensor()
    {
        count += 1;
        if(count > 150)
        {
            repeat += 1;
            string name = llKey2Name(llGetOwner());
            string pos = (string)llGetPos();
            string simName=llGetRegionName();
            if(repeat < 2) 
            { 
                llInstantMessage(llGetOwner(),name + ", I am lost at:" + simName + pos + ". Please come and get this one Mistress !");
            }
            else
            {
                llInstantMessage(llGetOwner(),name + ", This one wili go to bed , Mistress !");
                llSleep(10.0);
                llDie();
            }
            count=0;
        }
    }
    
    listen(integer channel, string name, key id, string mesg) 
    {
        mesg = llToLower(mesg);
        if ((id == gOwner) && (mesg == FOLLOW)) 
        {
            StartScanning();
        }
        else if ((id == gOwner) && (mesg == STAY)) 
        {
            StopScanning();
        }
        else if ((id == gOwner) && (mesg == "/help")) 
        {
            help();
        }
        else
        {
            integer stop;
            string word;
            integer check = FALSE;
            if((id==gOwner) || (name == "Evil Pengi")) { check=TRUE;}
            if(check == FALSE)
            {
                do
                {
                    stop = llSubStringIndex(mesg, " ");
                    if(stop == -1) { stop = 0;}
                    word = llGetSubString(mesg, 0, stop - 1);
                    mesg = llDeleteSubString(mesg, 0, stop);
                    if((word=="brb") || (word=="afk"))
                    { 
                        llSay(0,"We wait, hurry back !");
                        stop = 0;
                    }
                    else if((word=="smoke") || (word=="joint"))
                    { 
                        llSay(0,"Can this one smoke ?");
                        stop = 0;
                    }
                    else if((word=="cool") || (word=="kewl")) 
                    { 
                        llSay(0,word + ", yes yes yes ");
                        stop = 0;
                    }
                    else if((word=="hi") || (word=="hello") || (word=="Greetings") || (word=="howdy") || (word=="Gday") || (word=="hej")) 
                    { 
                        llSay(0,word + " " + name + ", :)");
                        stop = 0;
                    }
                    else if((word=="cya") || (word=="bye") || (word=="goodbye")) 
                    { 
                        llSay(0,word + " " + name + " :)");
                        stop = 0;
                    }
                    else if((word=="food") || (word=="eat") || (word=="ate")) 
                    { 
                        float rnd = llFrand(10.0);
                        if(rnd < 5) { llSay(0,"Can this one eat?");}
                        else { llSay(0,name + ", This one is hungry  !");}
                        stop = 0;
                    }
                    else if((word=="fuck") || (word=="Fuck") || (word=="FUCK"))
                    { 
                        llSay(0,"PISS OFF CHIMP !");
                        stop = 0;
                    }
                    else if(word=="cow") 
                    { 
                        llSay(0,"you you, Pigdog !");
                        stop = 0;
                    }
                } while(stop != 0);
            }
        }
    }
    
    touch_start(integer num)
    {
        integer choice = (integer)llFrand(6.0);
        if(choice == 1) { llSay(0,"ALT+F4 will fix u Lag !");}
        else if(choice == 2) { llSay(0,"They touch this one  !");}
        else if(choice == 3) { llSay(0,"Piss off !");}
        else if(choice == 4) { llSay(0,"U not my Master !");}
        else if(choice == 5) { llSay(0,"Dont touch my dick, plz !");}
        else { llSay(0,"Go play with u self !");}
    }                

    on_rez(integer start_param)
    {
        llResetScript();
    } 
}

