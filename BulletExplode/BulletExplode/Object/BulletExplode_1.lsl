// :CATEGORY:Weapons
// :NAME:BulletExplode
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:129
// :NUM:192
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BulletExplode
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

//
//  Encog's MultiBullet Gun Bullet
//
//  Explode Bullet: This bullet will do no damage, but will explode
// 

fakeMakeExplosion(integer particle_count, float particle_scale, float particle_speed, 
                 float particle_lifetime, float source_cone, string source_texture_id, 
                 vector local_offset) 
{
    //local_offset is ignored
    llParticleSystem([
        PSYS_PART_FLAGS,            PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_EMISSIVE_MASK|PSYS_PART_WIND_MASK,
        PSYS_SRC_PATTERN,           PSYS_SRC_PATTERN_ANGLE_CONE,
        PSYS_PART_START_COLOR,      <1.0, 1.0, 1.0>,
        PSYS_PART_END_COLOR,        <1.0, 1.0, 1.0>,
        PSYS_PART_START_ALPHA,      0.50,
        PSYS_PART_END_ALPHA,        0.25,
        PSYS_PART_START_SCALE,      <particle_scale, particle_scale, 0.0>,
        PSYS_PART_END_SCALE,        <particle_scale * 2 + particle_lifetime, particle_scale * 2 + particle_lifetime, 0.0>,
        PSYS_PART_MAX_AGE,          particle_lifetime,
        PSYS_SRC_ACCEL,             <0.0, 0.0, 0.0>,
        PSYS_SRC_TEXTURE,           source_texture_id,
        PSYS_SRC_BURST_RATE,        1.0,
        PSYS_SRC_ANGLE_BEGIN,       0.0,
        PSYS_SRC_ANGLE_END,         source_cone * PI,
        PSYS_SRC_BURST_PART_COUNT,  particle_count / 2,
        PSYS_SRC_BURST_RADIUS,      0.0,
        PSYS_SRC_BURST_SPEED_MIN,   particle_speed / 3,
        PSYS_SRC_BURST_SPEED_MAX,   particle_speed * 2/3,
        PSYS_SRC_MAX_AGE,           particle_lifetime / 2,
        PSYS_SRC_OMEGA,             <0.0, 0.0, 0.0>
        ]);
}

explode()
{
            fakeMakeExplosion(80, 1.0, 13.0, 2.2, 1.0, "fire", <0.0, 0.0, 0.0>);
        llSleep(.5);
        fakeMakeExplosion(80, 1.0, 13.0, 2.2, 1.0, "smoke", <0.0, 0.0, 0.0>);
        llSleep(1);
        llParticleSystem([]);
}





default
{   
    on_rez(integer delay)
    {
        llSetStatus( STATUS_DIE_AT_EDGE, TRUE);
        llSetDamage(0);
        llSetBuoyancy(1.0);                 //  Make bullet float and not fall 
        llCollisionSound("", 1.0);          //  Disable collision sounds
        
        if (delay >0 ) 
        {
            llSetTimerEvent(delay);            
        }
    }

    collision_start(integer total_number)
    {
        explode();
    }

    land_collision_start(vector pos)
    {
        explode();
    }
    
    timer()
    {
        llDie();
    }
    
}

