// Name:meteors.lsl
// Author:JPvdGiessen IT Consultancy

    integer Debug = FALSE ;
    integer Gchannel =10001;        // Channel for DayChecker

    vector color = <1,1,1>;  // Use to change the color of the light
    float intensity = 1.000; // Use to change the intensity of the light, from 0 to 1
    float radius = 1.000;  //  Use to change the radius of the light, from 0 to 20
    float falloff = 0.150;  //  Use to set the falloff of the light, from 0 to 2

particlesOn()
{
    integer flags = 0;
    flags = flags | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK;
//    flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE, 50.5,
                        PSYS_PART_FLAGS, flags,
                        PSYS_PART_START_COLOR, <1.0, 1.0, 1.0>,
                        PSYS_PART_END_COLOR, <1.0, 1.0, 0.8>,
                        PSYS_PART_START_SCALE, <0.3,0.3,0.3>,
                        PSYS_PART_END_SCALE, <0.5,0.5,0.5>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE, 1,
                        PSYS_SRC_ACCEL, <0,1.0,0>,
                        PSYS_SRC_BURST_PART_COUNT, 5,
                        PSYS_SRC_BURST_SPEED_MIN, 0.05,
                        PSYS_SRC_BURST_SPEED_MAX, 25.0,
                        PSYS_SRC_INNERANGLE, 0.5, 
                        PSYS_SRC_OUTERANGLE, 0.0,
                        PSYS_SRC_OMEGA, <0,0,0>,
                        PSYS_PART_START_ALPHA, 1.0,
                        PSYS_PART_END_ALPHA, 0.25,
                        PSYS_SRC_BURST_RADIUS, 4.5
                        ]);
}

particlesOff()
{
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        llSay(0, "Script running");
        llListen (Gchannel, "", "", "");
    }

    listen(integer channel, string name, key id, string message) 
    {
        if ( message == "Night")
        {
            particlesOn() ;
            llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0.3 ] ) ;
            llSetPrimitiveParams([PRIM_POINT_LIGHT,TRUE,
                                    <1.0,0.7,1.0>,  // light color vector range: 0.0-1.0 *3
                                    intensity,            // intensity    (0.0-1.0)
                                    radius,           // radius       (.1-10.0)
                                    falloff ]);         // falloff      (.01-1.0)     
            llSetAlpha(1.0, ALL_SIDES);       
        } else if ( message == "Day") {
            particlesOff() ;
            llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,FALSE]);
            llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE,   // if this is false, light is off,
                                     <0.0,1.0,0.0>,1.0, 10.0, 0.5]); // rest of params don't matter
            llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0 ] ) ;  
            llSetAlpha(0.0, ALL_SIDES);
        }
    }
}