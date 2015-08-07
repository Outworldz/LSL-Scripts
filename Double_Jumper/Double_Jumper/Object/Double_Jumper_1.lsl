// :CATEGORY:Animation
// :NAME:Double_Jumper
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:260
// :NUM:351
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Double_Jumper
// :CODE:
integer jumped;
integer pre;
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION|PERMISSION_TAKE_CONTROLS);
   
    }
    run_time_permissions(integer perm)
    {
        if(perm)
        {
            llTakeControls(CONTROL_UP,TRUE,TRUE);  
        }
    }
    collision_start(integer num_detected)
    {
        jumped = 0;   
    }
    land_collision_start(vector pos)
    {
        jumped = 0; 
    }
    control(key id, integer level, integer edge)
    {
       if(level & edge & CONTROL_UP)
       {
            if(llGetAgentInfo(llGetOwner()) != AGENT_IN_AIR && jumped == 0 && pre == 0)
            {
                pre = 1;
                llStartAnimation("prejump");
                llSleep(1.0);
            }
            else if(llGetAgentInfo(llGetOwner()) & AGENT_IN_AIR && jumped == 0 && pre == 1 && llGetAgentInfo(llGetOwner()) != AGENT_FLYING)
            {
                pre = 0;
                llParticleSystem([      PSYS_PART_MAX_AGE,2.0,
                        PSYS_PART_FLAGS,1,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <1,1,1>,
                        PSYS_PART_START_SCALE,<2.0,2.0,2.0>,
                        PSYS_PART_END_SCALE,<2.0,2.0,2.0>,
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
                        PSYS_SRC_BURST_RATE,0.5,
                        PSYS_SRC_ACCEL, <0,0,0>,
                        PSYS_SRC_BURST_PART_COUNT,2,
                        PSYS_SRC_BURST_RADIUS,0.1,
                        PSYS_SRC_BURST_SPEED_MIN,0.0,
                        PSYS_SRC_BURST_SPEED_MAX,0.0,
                        PSYS_SRC_TARGET_KEY,llGetOwner(),
                        PSYS_SRC_ANGLE_BEGIN,0.0,
                        PSYS_SRC_ANGLE_END,0.0,
                        PSYS_SRC_OMEGA, <0.2,0.2,0.2>,
                        PSYS_SRC_MAX_AGE, 1.0,
                    PSYS_SRC_TEXTURE, "cf26f908-cf57-086d-b629-ee73937b4c7f",
                        PSYS_PART_START_ALPHA, 1.0,
                        PSYS_PART_END_ALPHA, 0.1
                        ]); 
                llStartAnimation("advanced jump");
                jumped = 1;
                llApplyImpulse(<0,0,15>,FALSE);
            }
        }
    }
}
