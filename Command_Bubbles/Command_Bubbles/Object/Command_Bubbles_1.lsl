// :CATEGORY:Particles
// :NAME:Command_Bubbles
// :AUTHOR:Mike Zidane
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:199
// :NUM:272
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Command Bubbles.lsl
// :CODE:

//    Particle Script by Mike Zidane
//    Do what you want with this, but keep it free and post your changes to the boards.

//    Give this effect a name, and when it hears it's name called via linkmessage,
//    it will wait for START_DELAY to expire, then then fire.
//    Define your effect in the define_effect() function.

//    Seagel Neville modified this touch control to listen control.



string EFFECT_NAME = "bubbles";

float START_DELAY = 0;


//Don't muck around with the declarations.
///////////////////////////////////////////////////////////////////////////////
integer flags;
integer we_want_the_particle_to_glow;
integer we_want_the_particle_to_bounce;
integer we_want_the_particle_to_change_color;
integer we_want_the_particle_to_change_size;
integer we_want_the_particle_to_follow_wind;
integer we_want_the_particle_to_follow_its_source;
integer we_want_the_particle_to_spin_as_it_turns;
key we_want_the_effect_to_move_towards;
float we_want_each_particle_to_last_for;
float the_fastest_particles_will_be_ejected_at;
float the_slowest_particles_will_be_ejected_at;
string each_particle_should_have_this_texture;
float when_a_particle_is_created_it_will_have_an_alpha_value_of;
float and_then_it_will_gradually_shift_to_an_alpha_value_of;
vector when_a_particle_is_created_it_will_have_a_color_value_of;    
vector and_then_it_will_gradually_shift_to_a_color_value_of; 
vector new_particles_start_at_this_size; 
vector and_change_to_this_size;
vector apply_this_constant_force_to_our_particles;        
float we_want_to_create_new_particles_every;            
float create_new_particles_this_far_from_the_prim;        
integer create_this_number_of_particles_at_a_time; 
float particles_should_fan_out_this_wide;
float spin_the_fan_this_far_around_the_center_of_the_emitter;
vector the_emmitter_will_spin_at_this_rate;        
float the_emmitter_will_create_particles_for_this_long;        
integer burst = PSYS_SRC_PATTERN_EXPLODE;
integer none = PSYS_SRC_PATTERN_DROP;
integer empty_cone  = PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY;
integer cone = PSYS_SRC_PATTERN_ANGLE_CONE;
integer fan = PSYS_SRC_PATTERN_ANGLE;
integer we_want_the_effect_to_be_shaped_like_a;

//Don't muck around with the functions either.
float randBetween(float min, float max)
{
    return llFrand(max - min) + min;
}

wait_for(float delay)
{
        llSleep(delay);
}


//except this one.  This is where you do your thing.
define_effect()
{
    we_want_the_particle_to_glow = FALSE;
        
     we_want_the_particle_to_bounce = FALSE;
        
    we_want_the_particle_to_change_color = FALSE;
        
    we_want_the_particle_to_change_size = TRUE;
        
    we_want_the_particle_to_follow_wind = TRUE;
        
    we_want_the_particle_to_follow_its_source = FALSE;
        
    we_want_the_particle_to_spin_as_it_turns = TRUE;
        
    we_want_the_effect_to_be_shaped_like_a = cone
        // burst
        // empty_cone
        // cone
        // fan
        // none (= DROP)
        ;
    
        we_want_the_effect_to_move_towards = ""; //(use a key,self,or owner inside the quotes)
        
    we_want_each_particle_to_last_for = 10.0;  //seconds.
        
    the_fastest_particles_will_be_ejected_at = 0.750; // meters per second.
        
    the_slowest_particles_will_be_ejected_at = 0.250; // meters per second.
        
    each_particle_should_have_this_texture = "fda6b800-b2c5-e859-5c1a-27a88457f7df";
        //(a key is preferred here.  use "" for none.)
        
    when_a_particle_is_created_it_will_have_an_alpha_value_of = 0.5;
        //(0.0 is transparent, 1.0 is opaque.)
        
    and_then_it_will_gradually_shift_to_an_alpha_value_of = 0.1;
        //over the life of the particle.
        
    when_a_particle_is_created_it_will_have_a_color_value_of = <1.0,1.0,1.0>;
        
    and_then_it_will_gradually_shift_to_a_color_value_of = <1.0,1.0,1.0>;
        //over the life of the particle.
        
    new_particles_start_at_this_size = <0.1,0.1,0.1>;
        
    and_change_to_this_size = <0.25,0.25,0.25>;
        //over the life of the particle.
        
    apply_this_constant_force_to_our_particles = <0.0,0.0,0.0005>;
        
    we_want_to_create_new_particles_every = 0.1; //seconds.
        
    create_new_particles_this_far_from_the_prim = 0.0; //for burst patterns only.
        
    create_this_number_of_particles_at_a_time = 2;
        
        //for angle patterns,
    particles_should_fan_out_this_wide = 0; //in radians
        
    spin_the_fan_this_far_around_the_center_of_the_emitter = 0; //,also in radians.
        
    the_emmitter_will_spin_at_this_rate = <0,0,0>;
        
    the_emmitter_will_create_particles_for_this_long = 2; //in seconds
        
}


//definitely definitely do not mess with this.
update_particle_effect()
{               
    flags = 0;
    if (we_want_the_effect_to_move_towards == "owner") we_want_the_effect_to_move_towards = llGetOwner();
    if (we_want_the_effect_to_move_towards == "self") we_want_the_effect_to_move_towards = llGetKey();
    if (we_want_the_particle_to_glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (we_want_the_particle_to_bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (we_want_the_particle_to_change_color) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (we_want_the_particle_to_change_size) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (we_want_the_particle_to_follow_wind) flags = flags | PSYS_PART_WIND_MASK;
    if (we_want_the_particle_to_follow_its_source) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (we_want_the_particle_to_spin_as_it_turns) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (we_want_the_effect_to_move_towards != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,we_want_each_particle_to_last_for,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, when_a_particle_is_created_it_will_have_a_color_value_of,
                        PSYS_PART_END_COLOR, and_then_it_will_gradually_shift_to_a_color_value_of,
                        PSYS_PART_START_SCALE,new_particles_start_at_this_size,
                        PSYS_PART_END_SCALE,and_change_to_this_size, 
                        PSYS_SRC_PATTERN, we_want_the_effect_to_be_shaped_like_a,
                        PSYS_SRC_BURST_RATE,we_want_to_create_new_particles_every,
                        PSYS_SRC_ACCEL, apply_this_constant_force_to_our_particles,
                        PSYS_SRC_BURST_PART_COUNT,create_this_number_of_particles_at_a_time,
                        PSYS_SRC_BURST_RADIUS,create_new_particles_this_far_from_the_prim,
                        PSYS_SRC_BURST_SPEED_MIN,the_slowest_particles_will_be_ejected_at,
                        PSYS_SRC_BURST_SPEED_MAX,the_fastest_particles_will_be_ejected_at,
                        PSYS_SRC_TARGET_KEY,we_want_the_effect_to_move_towards,
                         PSYS_SRC_INNERANGLE,spin_the_fan_this_far_around_the_center_of_the_emitter, 
                        PSYS_SRC_OUTERANGLE,particles_should_fan_out_this_wide,
                        PSYS_SRC_OMEGA, the_emmitter_will_spin_at_this_rate,
                        PSYS_SRC_MAX_AGE, the_emmitter_will_create_particles_for_this_long,
                        PSYS_SRC_TEXTURE, each_particle_should_have_this_texture,
                        PSYS_PART_START_ALPHA, when_a_particle_is_created_it_will_have_an_alpha_value_of,
                        PSYS_PART_END_ALPHA, and_then_it_will_gradually_shift_to_an_alpha_value_of
                    ]);
}


integer RUNNING = FALSE;

start_particle_effect()
{
        RUNNING = TRUE;
        define_effect();
    update_particle_effect();
}

clear_the_effect()
{
        RUNNING = FALSE;
    llParticleSystem([]);
}

default
{
    
// The followings are original.

//    state_entry()
//    {
//        clear_the_effect();
//    }
//    
//    on_rez(integer NOT_USED)
//    {
//        clear_the_effect();
//    }
//    
//    touch_start(integer NOT_USED)
//    {
//                start_particle_effect();
//    }

// Seagel changed here.
    state_entry()
    {
        clear_the_effect();
        llListen( 0, "", NULL_KEY, "" );
    }
    
    on_rez(integer NOT_USED)
    {
        clear_the_effect();
    }
    listen( integer channel, string name, key id, string message )
    {
        if ( message == "Mmmm" )
        {
            start_particle_effect();
        }
    }
// That's all.    
    
    link_message(integer NoT_USED, integer NOt_USED, string the_passed_name, key NOT_uSED)
    {
        if (the_passed_name == EFFECT_NAME)
        {
            if (RUNNING == FALSE)
            {
                wait_for(START_DELAY);
                                start_particle_effect();
            }
            else
            {
                clear_the_effect();
            }
        }
    }
}// END //
