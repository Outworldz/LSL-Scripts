// :CATEGORY:Particles
// :NAME:vomit
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:959
// :NUM:1381
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// vomit.lsl
// :CODE:

key target = "";

MakeParticles()              
{
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
                    
    llParticleSystem([                    
        PSYS_PART_FLAGS , 0 
    //| PSYS_PART_BOUNCE_MASK           
    //| PSYS_PART_WIND_MASK             
    | PSYS_PART_INTERP_COLOR_MASK       
    | PSYS_PART_INTERP_SCALE_MASK       
    //| PSYS_PART_FOLLOW_SRC_MASK         
    | PSYS_PART_FOLLOW_VELOCITY_MASK    
    //| PSYS_PART_TARGET_POS_MASK       
    | PSYS_PART_EMISSIVE_MASK           
    //| PSYS_PART_TARGET_LINEAR_MASK
    ,
    //PSYS_SRC_TARGET_KEY,target,  
    //Patterns:
    //PSYS_SRC_PATTERN_DROP                 
    //PSYS_SRC_PATTERN_EXPLODE              
    //PSYS_SRC_PATTERN_ANGLE                
    //PSYS_SRC_PATTERN_ANGLE_CONE           
    //PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY     
    
    PSYS_SRC_PATTERN,          PSYS_SRC_PATTERN_ANGLE_CONE
    
    ,PSYS_SRC_TEXTURE,           "75f7ceed-1b02-6579-92e2-6464363139b3"                 
    ,PSYS_PART_MAX_AGE,          2.5                
    ,PSYS_SRC_BURST_RATE,        0.01               
    ,PSYS_SRC_BURST_PART_COUNT,  1                  
    ,PSYS_SRC_BURST_RADIUS,      0.01                
    ,PSYS_SRC_BURST_SPEED_MIN,   .4                
    ,PSYS_SRC_BURST_SPEED_MAX,   .6                
    ,PSYS_SRC_ACCEL,             <0.0,0.0,-1.50>     
    ,PSYS_PART_START_COLOR,      <.52,.02,.0>      
    ,PSYS_PART_END_COLOR,        <.40,.10,.0>      
    ,PSYS_PART_START_ALPHA,      1.0                
    ,PSYS_PART_END_ALPHA,        0.0                
    ,PSYS_PART_START_SCALE,      <.07,.07,.07>      
    ,PSYS_PART_END_SCALE,        <.6,.6,.6>      
    ,PSYS_SRC_ANGLE_BEGIN,       PI                
    ,PSYS_SRC_ANGLE_END,         170 * DEG_TO_RAD                
    ,PSYS_SRC_INNERANGLE,         PI
    ,PSYS_SRC_OUTERANGLE,         170 * DEG_TO_RAD
    ,PSYS_SRC_OMEGA,             <0.0,0.0,0.0>       
            ]);
}

string ANIM = "express_open_mouth";
string ANIM2 = "express_anger";
vector pos;

default {
    state_entry() 
    {
        llSetTimerEvent(0.0);
    }
    
    attach(key attached) 
    {
        if (attached != NULL_KEY) 
        {
            llRequestPermissions(attached, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            llListen(23468723,"",NULL_KEY,"");
        } else 
        {
            llSetTimerEvent(0.1);
        }
    }

    run_time_permissions(integer perms) 
    {
        if(perms & (PERMISSION_TRIGGER_ANIMATION)) 
        {
            llTakeControls(CONTROL_LBUTTON,TRUE,TRUE);
        }
    }

    control(key id, integer level, integer edge)
    {
        pos = llGetAgentSize(id);
        float zee = pos.z;
        if(edge & level & CONTROL_LBUTTON)
        {   
            llParticleSystem([]);
            llStartAnimation(ANIM);
            llStartAnimation(ANIM2);
            integer rand = llRound(llFrand(4));
            if(rand == 0)
                llTriggerSound("60edd6cd-6dd8-4520-d545-eca32e0ad7bc",1.0);
            if(rand == 1)
                llTriggerSound("efbda044-dc6c-c9f0-e622-1079c8c1a566",1.0);
            if(rand == 2)
                llTriggerSound("a7abc081-58b5-39c4-fd5e-8fc77362cfca",1.0);
            if(rand == 3)
                llTriggerSound("dd54d31d-9640-46e7-1cd1-33507182c2c5",1.0);
            if(rand == 4)
                llTriggerSound("36b4dc22-e5d0-4cb9-03c9-573bab173de3",1.0);
            
            MakeParticles();
            llSleep(1.25);
            llRezObject("puke",llGetPos() + <1.0,0,-zee/1.85> * llGetRot(),ZERO_VECTOR,ZERO_ROTATION,1);
            llParticleSystem([]);
        }
    }
    listen(integer channel, string name, key id, string msg)
    {
        pos = llGetAgentSize(llGetOwner());
        float zee = pos.z;
        list tokens = llParseString2List(msg, [" "],[]);
        if(llList2Key(tokens,0)==llGetOwner() && llList2String(tokens,1)=="drink")
        {
            llParticleSystem([]);
            llStartAnimation(ANIM);
            llStartAnimation(ANIM2);
            integer rand = llRound(llFrand(4));
            if(rand == 0)
                llTriggerSound("60edd6cd-6dd8-4520-d545-eca32e0ad7bc",1.0);
            if(rand == 1)
                llTriggerSound("efbda044-dc6c-c9f0-e622-1079c8c1a566",1.0);
            if(rand == 2)
                llTriggerSound("a7abc081-58b5-39c4-fd5e-8fc77362cfca",1.0);
            if(rand == 3)
                llTriggerSound("dd54d31d-9640-46e7-1cd1-33507182c2c5",1.0);
            if(rand == 4)
                llTriggerSound("36b4dc22-e5d0-4cb9-03c9-573bab173de3",1.0);MakeParticles();
            llSleep(1.25);
            llRezObject("puke",llGetPos() + <1.0,0,-zee/1.85> * llGetRot(),ZERO_VECTOR,ZERO_ROTATION,1);
            llParticleSystem([]);    
        }
    }
}
 // END //
