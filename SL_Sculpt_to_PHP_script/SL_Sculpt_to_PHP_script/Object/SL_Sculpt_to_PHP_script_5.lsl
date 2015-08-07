// :CATEGORY:Sculpt
// :NAME:SL_Sculpt_to_PHP_script
// :AUTHOR:Falados Kapuskas 
// :CREATED:2012-09-18 15:38:34.433
// :EDITED:2013-09-18 15:39:03
// :ID:790
// :NUM:1083
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// encloser.lsl
// :CODE:
integer CHANNEL_MASK = 0xFFFFFF00;
integer BROADCAST_CHANNEL;
integer ENCLOSE_CHANNEL;
integer ACCESS_LEVEL = 2;
integer ROWS;
integer gListenHandle_Enclose;
integer gScaleResponses;
vector gMax;
vector gMin;
float MAX_RESPONSE_TIME = 15.0;
key gOperator;
integer gAutoEnclose;
vector gScale;
vector gPos;

processRootCommands(string message)
{
    if( llSubStringIndex(message,"#setup#") == 0)
    {
        list l = llCSV2List(llGetSubString(message,7,-1));
        ACCESS_LEVEL = (integer)llList2String(l,1);
        ROWS =  (integer)llList2String(l,2);
    }
    if( message == "#die#" || message == "#enc-die#") { llDie(); }
}

//Get Access Allowed/Denited
integer has_access(key agent)
{
    //Everyone has access
    if(ACCESS_LEVEL == 0) return TRUE;
    else
        //Owner has access
        if(ACCESS_LEVEL == 2)
        {
            return agent == llGetOwner();
        }
    else
        //Group has access
        if(ACCESS_LEVEL == 1)
        {
            return llSameGroup(agent);
        }
    //Failed
    return FALSE;
}

minmax(vector vert) {
    //Min
    if( vert.x < gMin.x ) gMin.x = vert.x;
    if( vert.y < gMin.y ) gMin.y = vert.y;
    if( vert.z < gMin.z ) gMin.z = vert.z;

    //Max
    if( vert.x > gMax.x ) gMax.x = vert.x;
    if( vert.y > gMax.y ) gMax.y = vert.y;
    if( vert.z > gMax.z ) gMax.z = vert.z;
}

default
{
    on_rez(integer i)
    {
        BROADCAST_CHANNEL = (i & CHANNEL_MASK);
        llListen(BROADCAST_CHANNEL, "","","");
        llSetText("Touch to Enclose",<1,1,1>,1.0);
        llSetTimerEvent(0.1);
    }
    listen(integer channel, string name, key id, string message)
    {
        key k = llGetOwnerKey(id);
        if(!has_access(k)) return;
        if(channel == BROADCAST_CHANNEL)
        {
            processRootCommands(message);
            return;
        }
        //Size Reponses
        if( channel == ENCLOSE_CHANNEL )
        {
            llResetTime();
            ++gScaleResponses;
            integer break = llSubStringIndex(message,"|");
            if( break != -1 )
            {
                minmax((vector)llGetSubString(message,0,break-1));
                minmax((vector)llGetSubString(message,break+1,-1));
            } else {
                    minmax((vector)message);
            }

            if( gScaleResponses >= ROWS ) {

                vector pos = (gMin + gMax)*0.5;
                vector scale = <99,99,99>;
                if( llFabs(gMax.x-pos.x) > llFabs(gMin.x-pos.x) ) scale.x = 2*llFabs(gMax.x-pos.x);
                else scale.x = 2*llFabs(gMin.x-pos.x);

                if( llFabs(gMax.y-pos.y) > llFabs(gMin.y-pos.y) ) scale.y = 2*llFabs(gMax.y-pos.y);
                else scale.y = 2*llFabs(gMin.y-pos.y);

                if( llFabs(gMax.z-pos.z) > llFabs(gMin.z-pos.z) ) scale.z = 2*llFabs(gMax.z-pos.z);
                else scale.z = 2*llFabs(gMin.z-pos.z);

                if( llVecMag(scale) < 17.4 ) {
                    gScale = scale*1.01;
                    gPos = pos;
                    llSetPos(gPos);
                    llSetScale(gScale);
                    llSetRot(ZERO_ROTATION);
                    llRegionSay(BROADCAST_CHANNEL,"#enc-size#" + llList2CSV([gPos,gScale]));
                } else {
                        llInstantMessage(gOperator,"Enclose Failed - Size Too Big");
                }
                gAutoEnclose = FALSE;
                llListenRemove(gListenHandle_Enclose);
                llSetText("Touch to Enclose",<1,1,1>,1.0);
            }
        }

    }
    touch_start(integer i)
    {
        key k = llDetectedKey(0);
        if(!has_access(k)) return;
        gOperator = k;
        llSetText("",<1,1,1>,1.0);
        ENCLOSE_CHANNEL = (integer)(llFrand(-1e6) - 1e6);
        gScaleResponses = 0;
        llListenRemove(gListenHandle_Enclose);
        gListenHandle_Enclose = llListen(ENCLOSE_CHANNEL,"","","");
        gMin = <9999,9999,9999>;
        gMax = <-9999,-9999,-9999>;
        llShout(BROADCAST_CHANNEL,"#enclose#" + (string)ENCLOSE_CHANNEL);
        gAutoEnclose = TRUE;
        llResetTime();
    }
    timer() {
        if(llGetScale() != gScale || llGetPos() != gPos)
        {
            gScale = llGetScale();
            gPos = llGetPos();
            if(BROADCAST_CHANNEL != 0) llRegionSay(BROADCAST_CHANNEL,"#enc-size#" + llList2CSV([gPos,gScale]));
        }
        if( gAutoEnclose && llGetTime() > MAX_RESPONSE_TIME)
        {
            gAutoEnclose = FALSE;
            llSetText("Touch to Enclose",<1,1,1>,1.0);
            llListenRemove(gListenHandle_Enclose);
            llInstantMessage(gOperator,"Enclose Failed - Not all nodes responded in time");
        }
    }
}
