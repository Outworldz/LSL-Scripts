// :CATEGORY:Halloween
// :NAME:Broomsticks
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:119
// :NUM:178
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Smoke
// :CODE:

vector prior;


default
{
    state_entry()
    {
        llParticleSystem([]);
        llSetTimerEvent(0.5);
    }


    on_rez(integer p)
    {
        llParticleSystem([]);
    }
    
    timer()
    {        
        if (llVecDist(prior,llGetPos()) > 0.1)
        {
            prior = llGetPos();
            llParticleSystem( 
                [
                PSYS_PART_FLAGS,        PSYS_PART_EMISSIVE_MASK,
                PSYS_SRC_PATTERN,      
                PSYS_SRC_PATTERN_ANGLE_CONE, 
                PSYS_SRC_ANGLE_BEGIN,0.1,
                PSYS_PART_START_ALPHA , 0.1,
                PSYS_PART_END_ALPHA , .3,
                PSYS_PART_START_COLOR, <0.0, 0.0, 0.1>,
                PSYS_PART_END_COLOR, <0.5, 0.5, 0.5>,
               PSYS_PART_START_SCALE ,<.5,.3,.3>,
               PSYS_PART_END_SCALE ,<1,1,.6>,
               PSYS_SRC_BURST_PART_COUNT, 10
              ]);
        }
        else
        {
            llParticleSystem([]);
        }
        
    }

}

