// :CATEGORY:Weapons
// :NAME:Stalking_lava_Fire
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:832
// :NUM:1160
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sends fire to an avatar
// :CODE:
string victim;
key target;
key sound = "awakebun";
float min = 15;
float max = 25;
integer changed_pos = FALSE;
vector start_pos = <128,128,10>;


warpPos( vector destpos)
{   //R&D by Keknehv Psaltery, 05/25/2006
    //with a little pokeing by Strife, and a bit more
    //some more munging by Talarus Luan
    //Final cleanup by Keknehv Psaltery
    // Compute the number of jumps necessary
    integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 10.0) + 1;
    // Try and avoid stack/heap collisions
    if (jumps > 100 )
        jumps = 100;    //  1km should be plenty
    list rules = [ PRIM_POSITION, destpos ];  //The start for the rules list
    integer count = 1;
    while ( ( count = count << 1 ) < jumps)
        rules = (rules=[]) + rules + rules;   //should tighten memory use.
    llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) );
}



default
{
    state_entry()
    {

        llListen(6645,"",llGetOwner() ,"");
    }
    on_rez(integer start_param)
    {


        start_pos = llGetPos();
        llPlaySound("bambagrowl",1.0);
        llOwnerSay("touch me to start scanning");
    }
    touch_start(integer num_detected)
    {
            if (llDetectedKey(0) == llGetOwner())
            {
                llSensor("",NULL_KEY,AGENT,96,PI);
            }
    }
    no_sensor()
    {
        llSay(0,"waiting...");
        state searching;
    }
    sensor(integer num)
    {
        list targets;
        integer i;
        if(num > 12)
            num = 12;
            for(i=0;i<num;i++)
        {
            targets += [llDetectedName(i)];
        }
        llDialog(llGetOwner(),"select target to trace",targets,6645);
    }
    listen(integer channel, string name, key id, string message)
    {
        victim = message;
        llOwnerSay("touch again to stop assimilation");
        state tracing;
    }
}

state tracing
{


        state_entry()
        {
                        llSetText("", <1,0,0>, 1.0);
            llSetTimerEvent(5.0);
            llSensorRepeat(victim,NULL_KEY,AGENT,96,PI,1.0);

        }
        no_sensor()
        {
            state searching;
        }
        sensor(integer num)
        {

            warpPos(llDetectedPos(0)  + <0, 0, 0> );


        }
        touch_start(integer num_detected)
        {
            if (llDetectedKey(0) == llGetOwner())
            {
                llOwnerSay("touch again to start scanning");


                state default;
            }

        }
        timer()
        {


            float time = min + llFrand(max - min);
            llSetTimerEvent(time);
        }

}



state searching
{
    state_entry()
    {
            llSetTextureAnim(FALSE | SMOOTH | PING_PONG | LOOP | REVERSE, ALL_SIDES, 1, 1, 0.70, 0.2, 0.2);
            llSetText(victim + " out of range...", <1,0,0>, 1.0);
        llSetTimerEvent(1);
    }
    timer()
    {
        llSensor(victim,NULL_KEY,AGENT,96,PI);
        if (changed_pos==FALSE)
        {
            llSetTimerEvent(4);
        } else {
            llSetTimerEvent(20);
        }
    }
    no_sensor()
    {

        if (changed_pos==FALSE)
        {
            llOwnerSay("target out of range - going back to start position " + (string)start_pos);
            warpPos(start_pos);
            changed_pos=TRUE;

        }
    }
    sensor(integer num)
    {
        vector here = llGetPos();
        string str="located "+(string)victim+" at "+(string)here;
        llOwnerSay(str);
        changed_pos=FALSE;
        llPlaySound("bambagrowl",1.0);
        state tracing;
    }
    touch_start(integer num_detected)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            llOwnerSay("touch again to start scanning");
            llSetText("no target", <1,0,0>, 1.0);
            llParticleSystem([]);
            state default;
        }

    }


}

