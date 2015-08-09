// :CATEGORY:Particles
// :NAME:blue_light
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:106
// :NUM:141
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// blue light.lsl
// :CODE:

    float age = 0.0;
    vector color = <.25,.5,1>;
    float gLampLevel = 0.0;
    vector Brightness = <0.0, 0.0, 0.0>;    
        
updateParticles()
{
        llParticleSystem([PSYS_PART_FLAGS,
        PSYS_PART_EMISSIVE_MASK,
        PSYS_PART_START_COLOR,color,
        PSYS_SRC_MAX_AGE,age,
        PSYS_SRC_BURST_RADIUS,0.0,
        PSYS_PART_MAX_AGE,.16,
        PSYS_SRC_BURST_RATE,0.042,
        PSYS_SRC_BURST_PART_COUNT,2, 
        PSYS_SRC_BURST_SPEED_MAX,0.0,
        PSYS_PART_FLAGS,PSYS_PART_FOLLOW_SRC_MASK,
        PSYS_PART_START_SCALE,<1.0,1.0,1.0>,
        PSYS_PART_END_SCALE,<2,2,2>,
        PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_EXPLODE]);
        
        if(age==0.0) gLampLevel=2;
        else gLampLevel=1;
        
    Brightness.x = gLampLevel/5;
    Brightness.y = gLampLevel/5;
    Brightness.z = gLampLevel/2;
    llSetColor(Brightness, ALL_SIDES);
}

default
{
    on_rez(integer a)
    {
     llListen(456456456,"",NULL_KEY,"");   
    }   
     
     listen(integer chan,string strn,key id,string message)
     {
         if(chan==456456456 && message=="blue off")
                age = 0.01;
         if(chan==456456456 && message=="blue on")
                age = 0.0;           
            updateParticles();
    }
         
     
       touch_start(integer total_number)
    {
            if(age==0.0)
                age = 0.01;
            else
                age = 0.0;
            updateParticles();
    }
}// END //
