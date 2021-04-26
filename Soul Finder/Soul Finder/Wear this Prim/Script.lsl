// :CATEGORY:Sensor
// :NAME:Soul Finder
// :AUTHOR:CyberGlo CyberStar
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// it will point a stream of particles toward any persons location 
// :CODE:
//CyberGlo CyberStar
//Soul Finder
// put this script in a small prim and wear it.
// type on channel 7 on
// like this /7 on
// type /7 nameofavatar
// it will point a stream of particles toward this persons location 
// no matter where they are on the sim.
// even if they walk around it will follow them
// this makes it easy to find people in crowded sims, even if you cant rez an object or tp to them.
// email: pctek.cyberstar@gmail.com

string gStrAgentName;
key gStrAgentId;

integer listenHandle;
 
remove_listen_handle()
{
    llListenRemove(listenHandle);
}

updateParticles(key target)
{
 
 llParticleSystem([
         PSYS_PART_FLAGS, 0 | PSYS_PART_EMISSIVE_MASK | 
         PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | 
         PSYS_PART_FOLLOW_SRC_MASK | PSYS_PART_FOLLOW_VELOCITY_MASK |PSYS_PART_TARGET_POS_MASK ,
         PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE,
         PSYS_PART_MAX_AGE, 2.0,
         PSYS_PART_START_COLOR,<1,0,0>,
         PSYS_PART_END_COLOR,<1,0,0>,
         PSYS_PART_START_SCALE,<0.3, 0.8, 0.3>,
         PSYS_PART_END_SCALE,<0.1, 0.2, 0.1>,
         PSYS_PART_START_GLOW, 1.0,
         PSYS_SRC_BURST_RATE,0.01,
         PSYS_SRC_ACCEL,<0.0, 0.0, 0.0>,
         PSYS_SRC_BURST_PART_COUNT,3,
         PSYS_SRC_BURST_RADIUS,0.10,
         PSYS_SRC_BURST_SPEED_MIN,0.10,
         PSYS_SRC_BURST_SPEED_MAX,0.50,
         PSYS_SRC_TARGET_KEY,target,
         PSYS_SRC_INNERANGLE,1.55,
         PSYS_SRC_OUTERANGLE,1.54,
         PSYS_SRC_OMEGA,<0.0, 0.0, 5.0>,
         PSYS_SRC_MAX_AGE,0.00,
         PSYS_PART_START_ALPHA,0.50,
         PSYS_PART_END_ALPHA,0.10
         ]);   
   
}
default
{
    state_entry()
    {

        listenHandle = llListen(7, "", llGetOwner(), "");
    }
 
    listen(integer channel, string name, key id, string message)
    {
        gStrAgentName = message;
        if ( message == "off" )
        {
            llParticleSystem([]);
            
        }
        else
        {
            gStrAgentId = llName2Key(gStrAgentName);
            if(llGetAgentSize(gStrAgentId)) 
            {
                vector pos   = llList2Vector(llGetObjectDetails(gStrAgentId, [OBJECT_POS]), 0);
                llOwnerSay("I found: " + gStrAgentName + " at " + (string)pos);
                updateParticles(gStrAgentId);
            } 
            else 
            {
                llOwnerSay("The person named: " + gStrAgentName + " isn't in this Land.");
            }
        }
    }
 
    on_rez(integer start_param)
    {
        llResetScript();
    }
 
    changed(integer change)
    {
        if (change & CHANGED_OWNER)
        {
            llResetScript();
        }
    }
}