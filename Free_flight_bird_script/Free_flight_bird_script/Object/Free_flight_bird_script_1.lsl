// :CATEGORY:Animal
// :NAME:Free_flight_bird_script
// :AUTHOR:Fritz Kakapo
// :CREATED:2010-09-02 13:40:43.347
// :EDITED:2013-09-18 15:38:53
// :ID:338
// :NUM:456
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// I am posting this script with the warnimg that it is delicatly tuned to fly as I wanted it to, and so one should be very cautions about changing the parameters of the flight model.  That is like making changes in a free flight model airplane before you understand why it flies as it does.  Changes in the logic, on the other hand, are like changes in any other script.  If you really want to understand why it flies as is does, I suggest starting with my Air Camper script, also posted here.
// 
// I post it here, none the less, because it is my most popular product, and because it can be used, as is or with new sounds and such, in other birds of about the same weight.  I don't really expect anyone else to make such an effort to script birds, but sl airplanes have become very detailed and well made, and this bird flight illustrates the possibility of making the flight behavior of airplanes more appropriate to their appearance.
// 
// You rez the bird, move it to the center of the available space and click it to set the center position and start flying.  It attempts to fly aerobatically but stay near the launch point.  It needs at least 128x128 m. to fly in.  That is the best I could do withing the constraints of the sl physics engine.  It can now cross sim boundaries without getting lost, but of course that is a bit hazardous.
// 
// 
// To use this script in other birds, I un-comment the line that outputs the weight and then adust the weght to be the same, 0.19 virtual kilograms, by making prims more or less hollow.  That has worked for birds so far, but for an airplane the distribution of mass also mattered.  Perhaps birds are small enough that the distribution is not important.  (Apparently sl physics calculates some approximation to the angular inertia.)
// :CODE:
//

//                          Bird Flight Script

//

//      Move the bird high enough that it won't hit anything right away and then click on it.

//  It will fly around the location vector set at the top of "timer".  It will stay on about a quarter sim.

//  The z omponent of this vector is the maximum height.

//  (If it won't let you change the script, find a copy with full permissions.)

//      It attempts to resume flying after various problems, but if it stops or gets stuck,

//  move it where there is space to fly and click again once or twice.  If that fails, reset the script.

//  (It may fail to climb if you launch it more than about 50 m below the set hight.)

//

//

//      There are no "if" statements controling the normal flight!  The whole thing is done by simulating aerodynamics.

//  That is, by coupled differectial equations (approximated by difference equations), simulating a free flight model airplane.

//  It uses the SL physical vehicle type, and much additional dynamics and tuning is done by the script.

//      The bird (or airplane) is not forced to stay on the sim, it is steared, as a bird would stay above a food area.

//      Vertically, it stays off the ground by simulating a stable free flight model,

//  such as a Guillows rise off ground rubber powered model from a toy store or Langley's pioneering steam powered models.

//  To make long flights more interesting, the parametres are gradually varried with hight,

//  so that a stall is assured by the time it reaches the hight set in the top of "timer", below.

//      Mathematically the motion is deterministic at low altitude, in the strong sense of

//  the coupled differential equations being uniformly integrable.  But the motion is chaotic at high altitude.

//  That is, the recovery from a stall can be arbitrarily sensetive to the exact motion at the point of stall.

//      The numerical solution captures some of the chaotic nature of a real world stalling airplane.

//

//

//  Based on:

//      Li'l Stinker Flight Script, by Fritz t. Cat (Fritz Kakapo)

//

//      Since the version I started with was public domain, with free software intentions expressed,

//  I, Fritz t. Cat, hereby publish my modified version, below, under the GNU General Public License,

//  on 2009 July 14 and subsequent versions as available.  This means that it is a copyright violation to set

//  no-copy, no-modify, no-transfer or turn off "allow anyone to copy" on this script,

//  the Li'l Stinker Airplane for which it was written, or anything derived from either of them. 

//  And also that a GNU Licence statement and credits, according to the current version of the license,

//  must accompany anything derived from this script or airplane.  I have reproduced the public domain script,

//  in a note card, for use in proprietary products.

//      The aerodynamics and algorithms used are not copyrightable and may be used as a guide to other scripts.

//      Please refer to some source, such as Wikipedia, for the exact license terms.

//

//  I have kept some of the earlier comments here:

//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

// Simple airplane script example

// THIS SCRIPT IS PUBLIC DOMAIN! Do not delete the credits at the top of this script!

// Nov 25, 2003 - created by Andrew Linden and posted in the Second Life scripting forum

// Jan 05, 2004 - Cubey Terra - minor changes: customized controls, added enable/disable physics events

// Feel free to copy, modify, and use this script.

// Always give credit to Andrew Linden and all people who modify it in a read me or in the object description.

//""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

//

//      The script assumes that the root primitive is oriented such that its:

//  local x-axis points toward the nose of the plane, and its

//  local z-axis points toward the top.

//

//  This bird script is tuned for a flight weight of 0.194306 virtual kilegrams, as of 2009.12.19.

//

//=============================================================================================================

//

//      Particle System         This is not bird-like but can be used to see the flight path more clearly.

//

//float rate =  0.1; // Adujusted in timer.

//

StartSteam()

{

                                // MASK FLAGS: set  to "TRUE" to enable

integer glow = TRUE;                                // Makes the particles glow

integer bounce = FALSE;                             // Make particles bounce on Z plane of objects

integer interpColor = TRUE;                         // Color - from start value to end value

integer interpSize = TRUE;                          // Size - from start value to end value

integer wind = FALSE;                               // Particles effected by wind

integer followSource = FALSE;                       // Particles follow the source

integer followVel = TRUE;                           // Particles turn to velocity direction



 



 



                                                    // Choose a pattern from the following:

                                                    // PSYS_SRC_PATTERN_EXPLODE

                                                    // PSYS_SRC_PATTERN_DROP

                                                    // PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY

                                                    // PSYS_SRC_PATTERN_ANGLE_CONE

                                                    // PSYS_SRC_PATTERN_ANGLE



    integer pattern = PSYS_SRC_PATTERN_EXPLODE;



 



                                                    // Select a target for particles to go towards

                                                    // "" for no target, "owner" will follow object owner

                                                    //    and "self" will target this object

                                                    //    or put the key of an object for particles to go to



 



 



 



                            // Particle paramaters

                           

    float age = 255.;                                  // Life of each particle

    float maxSpeed = 0.03;                          // Max speed each particle is spit out at

    float minSpeed = 0.0;                           // Min speed each particle is spit out at

    string texture = "cloud for smoke";             // Texture used for particles, default used if blank

    float startAlpha = .8;                         // Start alpha (transparency) value

    float endAlpha = 0.05;                           // End alpha (transparency) value

    vector startColor =  < 0.99, 0.99, 0.99 >;        // Start color of particles <R,G,B>

    vector endColor =  < 0.2, 0.7, 0.2 >;         // End color of particles <R,G,B> (if interpColor == TRUE)

    vector startSize = < 0.2, 0.2, 0>;               // Start size of particles

    vector endSize = < 2., 2., 0 >;                       // End size of particles (if interpSize == TRUE)

    vector push = < 0., 0., 0. >;                        // Force pushed on particles



 



                            // System paramaters

                           

    float rate = 0.15;                               // How fast (rate) to emit particles

    float radius = 0.1;                             // Radius to emit particles for BURST pattern

    integer count = 1;                             // How many particles to emit per BURST

    float outerAngle = 0.;                         // Outer angle for all ANGLE patterns

    float innerAngle = 0.;                        // Inner angle for all ANGLE patterns

    vector omega = <0,0,0>;                         // Rotation of ANGLE patterns around the source

    float life = 0;                                 // Life in seconds for the system to make particles



 



                            // Script variables

                           

    integer flags;



 





      flags = 0;



 



    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;

    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;

    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;

    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;

    if (wind) flags = flags | PSYS_PART_WIND_MASK;

    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;

    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;



 





    llParticleSystem([  PSYS_PART_MAX_AGE,age,

                        PSYS_PART_FLAGS,flags,

                        PSYS_PART_START_COLOR, startColor,

                        PSYS_PART_END_COLOR, endColor,

                        PSYS_PART_START_SCALE,startSize,

                        PSYS_PART_END_SCALE,endSize,

                        PSYS_SRC_PATTERN, pattern,

                        PSYS_SRC_BURST_RATE,rate,

                        PSYS_SRC_ACCEL, push,

                        PSYS_SRC_BURST_PART_COUNT,count,

                        PSYS_SRC_BURST_RADIUS,radius,

                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,

                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,

                        PSYS_SRC_INNERANGLE,innerAngle,

                        PSYS_SRC_OUTERANGLE,outerAngle,

                        PSYS_SRC_OMEGA, omega,

                        PSYS_SRC_MAX_AGE, life,

                        PSYS_SRC_TEXTURE, texture,

                        PSYS_PART_START_ALPHA, startAlpha,

                        PSYS_PART_END_ALPHA, endAlpha

                            ]);

     

}

//

StopSteam()

{

    llParticleSystem( [ PSYS_SRC_BURST_PART_COUNT, 0 ] );

}

//

//=====================================================================================================

//

// The thrust is saved and restored as it decays, to continue cruising.

vector gLinearMotor = <0, 0, 0>;

//

//      Used to handle exceptions:

float last_time;        // previously stored time of day

vector last_pos_1a =  <-7,-7,-7>;

vector last_pos_1b =  <-7,-7,-7>;

vector last_pos_2a =  <-7,-7,-7>;

vector last_pos_2b =  <-7,-7,-7>;

integer kownt_1 = 0;

integer kownt_2 = 0;

float leap =  10.;

integer flying = FALSE;     //  Keeps track of whether flying or pearched.

integer pause =  1;

//

//      Base values of dynamically varied parameters:

float ANGULAR_DEFLECTION_TIMESCALE_0 =  8.;   // Can be used to decrease stability with altitude.

//

float LINEAR_DEFLECTION_TIMESCALE_0  =  27.;     // fuselage lift

//

float ANGULAR_MOTOR_TIMESCALE_0  =      1.0;   // This is shortened in timer, to increase control effectiveness with speed.

//

vector ANGULAR_FRICTION_TIMESCALE_0 =  < 0.10, 0.08, 0.58 >;    // Along with angular motor time scale,

//

//

vector steady_torque = < 0, 0, 0. >;         // Aerodynamic torque, to add trim and dynamics.

//

integer new_collision =  5;     // Decremented in timer.

vector global_pos;              // position relative to launch point, counting 246 m for each sim

vector  Center_0;

//

//--------------------------------------------------------------------------------------------------------

    init()

    {

        llSetStatus( STATUS_PHYSICS, FALSE );   // Stop if already flying.

        //

        //

        //              Set initial values of vehicle parameters.

        //

        llSetVehicleType( VEHICLE_TYPE_AIRPLANE );    // Sets default airplane-like parameters.

        //

        // action of the fin and stabilizer:  Points toward velocity.

        // The front turns toward the current velocity.

         llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1. );

        //                                              "behave much like the deflection time scales"

         llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, ANGULAR_DEFLECTION_TIMESCALE_0 / 2. );

        //

        // fuselage lift.

        //      Wing lift is handled with VEHICLE_LINEAR_FRICTION_TIMESCALE below.

        // The velocity turns toward the front.  (Exact formula unknown.)

         llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1. );

         //                                               "behave much like the deflection time scales"

         llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, LINEAR_DEFLECTION_TIMESCALE_0 );

        //

        // propeller thrust strength

        //  Shorter time scale makes it more stable.  Longer makes a wider speed range.

         llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2.0 );       // 1/strength

        // "it cannot be set longer than 120 seconds"

         llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 15.);

        //  Throttle gradually closes with time, but defeated:  Refreshed below in timer.

        //

        //  This controls the strength of the torques set in timer.

        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0 );   //  1/strength

        //

        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 1.5 );

        //  Control returns to neutral when released.  But it is reset in timer, so this ony matters when there is lag.

        //

        //--------------------- linear friction ------------------------------------------------

        //      The x component is parasite drag (along with VEHICLE_LINEAR_MOTOR_TIMESCALE).

        //      The y component contributes to fuselage transverse lift and to drag due to yaw.

        //  The effect of dyhedral depends on side slip.

        //      The z component might seem to be just a vertical damping, but when pitch changes by a small amount,

        // most of the motion in the direction that was previously forward, becomes motion in the new forward direction,

        // with initially only a small transverse (up or down) component.  With a short decay time scale

        // in the z direction, that component is lost quickly, so the motion continues to follow the pitch angle, with little loss.

        // The larger the z time constant is, the more "induced drag" there is.  That is VEHICLE_LINEAR_FRICTION_TIMESCALE.z

        // greater than zero causes a drag that increases with lift, similarly to induced drag of a physical airplane.

        //

        //      The z component gives the wing lift.  Decreasing it allows the airplane to fly more slowly,

        //  without loss of speed or altitude.  But it seems to be near the limit, to fly slower one may need buoyancy.

         llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, < 14., 2.0, 0.008 > );

         //

         // This is damping of rotation.  Physically it would increase with the length and wing span.

         // The z component is neccesary for the dihedral and sweepback to be effective.

         llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, ANGULAR_FRICTION_TIMESCALE_0 );

         // Along with angular motor time scale,  this damps the rotational motion.

         //

         llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1000 );    // CG below center of lift, pendulum period.

         llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0 );  // damping, 0–1: 1. is fully damped.

         // This needs to be weak for a stunt airplane, that should fly nearly the same upside down as right side up.

         // It is desirable especially in free flight models, such as paper gliders.  See the dynamic coupling in timer.

        //

        //  This drives yaw in the direction of roll, imitating use of rudder by the pilot.

        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 0 );    // Is there a difference between time scale

        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 1000 );     //   and efficiency?

        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0 );          // more yaw control when moving, 0 = none at rest.

        //  Since this imitates a manual control, any convenient value set is physical (assuming a rotating tail wheel).

        //      The Wright brothers found that mechanical coupling of the rudder and ailerons was not sufficient,

        //  because of the delays involved.

        // It is not used here, because it was not intended for attitudes far from right side up.

        //

        // "hover can be better than sliding along the ground during takeoff and landing

        // but it only works over the terrain (not objects)"

        //llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 3.0);

        //llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.5);

        //llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 2.0);

        //llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY);

        //

        // "non-zero buoyancy helps the airplane stay up

        // set to zero if you don't want this crutch"

        // This was useful in the initial stages of tuning.  I think it simply reduces the gravitational

        //  contribution to downward acceleration.  It, here, is supposed to allow a longer timer setting.

        llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0. );

        //

        //  Start with only vehicle torques.  This is set in timer.

        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0> );

        //

        //-------------------------------------------------------------------------------------------------------

        flying = FALSE;         // Keep track of not flying.

        llSetTimerEvent( 0. );  // Stop timer.

        //StopSteam();          // Stop particles.

        llStopSound();

        //llSetSoundQueueing( TRUE );     // This is supposed to make sounds wait for eachother, but it doesn't work.

        //          So llSleep is used below to force wait.

        //

        //llSay(0, (string)llGetMass()+" virtual kilograms." );

        llSay(0, "Cogito ergo sum.");     // (quote from 1952 Galaxy science fiction story)

        llSay(0, "Touch to set center and start.");     //

        //

    }   //  End init().

//

//-------------------------------------------------------------------------------------------------------------------

default

{

    state_entry()

    {

        init();

    }

    //

    on_rez(integer start_param)

    {

        init();

    }

    //

    //----------------------------------------------------------------------------------------------------------------

    touch_start(integer total_number)

    {

        if (  llDetectedOwner( 0 )  !=  llGetOwner()  )

        {

            // only the owner can use this vehicle

            llSay(0, "Please take a copy of this airplane or bird and fly your own copy.

            (If it is not set \"Free to copy\" or \"For sale l$ 0\", contact the owner or the creator.)

            You aren't the owner -- only the owner can fly this plane.");

        }

        else

        {

    //

        if ( ! flying )

        {

            Center_0 =  llGetPos();

            global_pos =  Center_0;         // location relative to launch point

            llPlaySound( "parrot2", 1.0 );

            //

            //StartSteam();     // Start paricle tracer smoke trail.

            //

            gLinearMotor =  < 11., 0, 0. >;        // Set thrust.

            llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor );

            //

            llSetStatus( STATUS_PHYSICS, TRUE );    // Enable physics.

            //

            llApplyImpulse( < 0.3, 0, 0.05 >, TRUE ); // Except for humbingbirds, birds run or push off with their feet.

            //

            flying = TRUE;

            llSay(0, "Started.");

            last_time = llGetTimeOfDay();       //  to test for lag

            llSetTimerEvent( 0.5 );        // seconds  Timer controls flight.

            //

            llSleep( 2. );

            llLoopSound( "parrot1", 0.25 );

            //

        }

        else

        {

            llSetStatus( STATUS_PHYSICS, FALSE );

            llSay(0, "Stopped manually.");

            llSetTimerEvent( 0. );         // Stop timer.

            flying = FALSE;

            llStopSound();

            //StopSteam();

            //

        }

    //

        }   // End owner.

    }

    //

    //======================================================================================================

    timer()

    {

        //----------------------------------- Set parcel center. -------------------------------------------

        //

        //          This vector should be changed to match the location available for flight.    <--------------------<<<<

        //

        //vector  Center =  <  128.,  128.,  30.+20.+llFabs(llGround(<0,0,0>)-20.)  >;    //   Use constant east, north.

        //vector  Center =  Center_0  +  <  0.,  0.,  30.  >;    //   Use starting hight as flat ground level.

        Center_0.z =  0.;

        vector  Center =  Center_0  +  <  0.,  0.,  30.+20.+llFabs(llGround(<0,0,0>)-20.)  >;    //   higher over water

        //vector  Center =  Center_0  +  <  0.,  0.,  30.+10.+llGround(<0,0,0>)  >;             //   lower over water

        //

        //      This is the locaiton that it flies around.  The z component is about the top of the flight pattern

        //  and should be high enough to keep it off the ground most of the time.

        //      The bird will stear to stay near the horizontal part and below the vertical value.

        //

        //---------------------------- Update position + 256 * sim count. ------------------------------------

        //

        vector pos =  llGetPos();

        //

        vector delta_pos =  pos-global_pos;

        //

        if ( delta_pos.x < -128. )    delta_pos.x =  delta_pos.x + 256.;

        else if ( delta_pos.x > 128. )    delta_pos.x =  delta_pos.x - 256.;

        //

        if ( delta_pos.y < -128. )    delta_pos.y =  delta_pos.y + 256.;

        else if ( delta_pos.y > 128. )    delta_pos.y =  delta_pos.y - 256.;

        //

        global_pos +=  delta_pos;

        //

        //----------------------------- Get some flight data used below. ------------------------------------

        rotation rot =  llGetRot();

        vector glob_dorsal =  <0,0,1> * rot;     // dorsal direction in global coordinates

        float horizontal =  glob_dorsal * <0,0,1>;

        //

        vector v =  llGetVel();

        //

        float speed =  llSqrt( v * v );

        //

        //llShout( 0, (string) speed ); // debug and tuning

        //

        //--------------------------------  Refresh motor settings. -----------------------------------------

        //

        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor );

        //                                          This is to defeat VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE.

        //

        //---------------- Include speed increase of contol surface effectiveness. ----------------------------------

        //

         llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, LINEAR_DEFLECTION_TIMESCALE_0

                      /   (  0.5  +  0.5 * speed / 8.  )   ); // fuselage lift

        //

        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0

                      /   (  0.15  +  0.85 * llSqrt( speed*speed ) / 8.  )   );   //  1/strength of controls

        //

        //

        //---------------------------------------------  Dynamics  ------------------------------------------------------

        //

        //

        steady_torque = <  0., 0, 0. >;

        //

        //  >>>>>>------------------------->   Stear toward parcel center.   <--------------------------------------<<<<<<

        //                          (It can be allowed to wander by removing this section.)

        //

        vector  toCenter =  Center - global_pos;  // global vector to center of parcel

        //

        if ( toCenter.z < 0. )   {  jump skip_dynamics;  }  // None of this dynamics makes any sense if we are above ceiling!

        //

        //      Roll and yaw to the port of center, moving inward and to starboard when moving away from center.

        //  This moves it toward center, when circling right.

        vector  h_toCenter =  toCenter;   

        h_toCenter.z = 0;        // No vertical here.

        vector  loc_h_toCenter =  h_toCenter  / rot;   // global to local coordinate transformation;

        vector  left =  -loc_h_toCenter;

        left.y = 0;

        left.z = -2. * left.x;        // Roll component goes to roll and yaw.

        steady_torque +=  left * 0.0016 * speed;       // Roll to left of center, to right away.

        //

        //      Turn toward center.  This tends to move it to center when not circeling.

        vector turn_toCenter =  < 1, 0, 0 > % loc_h_toCenter;

        //                                      Forward x [vector cross product] redius = torque toward center.

        steady_torque +=  turn_toCenter * 0.0030 * speed;       // Adjust strength.  Add to torque.

        //

        //

        //      This replaces the code above, to move cross country:

        //steady_torque +=  < -1, 1, 0 > / llSqrt(2.) * 1.2  / llGetRot();   // Turn to east.

        //  This line directs the average direction approximatly East.  Rotate for other directions.

        //  That is, the version tested goes around 135 degrees to the right of the above constant vector.

        //

        //

        //-------------------------------------- Reduce stability at high altitude. --------------------------------

        float stability =  toCenter.z / 30.;

        stability =  llFabs( stability ) + 0.001;  // There have been run time math errors.

        float sqr_stab =  llSqrt(  stability  );

        float fourR_stab =  llSqrt( sqr_stab ) ;

        float eightR_stab =  llSqrt( fourR_stab ) ;

        //

         llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, ANGULAR_DEFLECTION_TIMESCALE_0

                    / ( 0.6 + 0.4*speed/8. )   *    ( 0.1 + 0.9*stability )    ); // fin and stabalizer

        //      Too much fin and stabalizer reduces dynamic stability, at maximum height.

        //

        llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, ANGULAR_FRICTION_TIMESCALE_0

                    /   (  sqr_stab  )   );

        //                                               Along with angular motor time scale,

        //      Less angular friction reduces static (angle only) stability damping.

        //

        //

        //---------------------------  Dynamic Coupling and Trim Tuneing  -----------------------------------------------

        //

        vector local_vel = v / rot;      // global to local coordines

        //

        //      Spiral right to help stay in sim (and stabalize phugoid).

        float right =  0.;

        right +=  0.04 * local_vel.x * fourR_stab;

        right +=  0.024   * local_vel.x * local_vel.x * fourR_stab;

        right +=  0.002   * local_vel.x * local_vel.x * local_vel.x;

        steady_torque.x +=  right;

        steady_torque.z -=  1.5 * right;

        //

        //          Dihedral:  Wing tip on the downward side lifts when moving sideways.

        //          If VEHICLE_ANGULAR_FRICTION_TIMESCALE.z holds the nose back from the turn

        //  and VEHICLE_LINEAR_FRICTION_TIMESCALE.y lets it slip slip sideways,

        //  then the dihedral lifts the inside wing in a turn.

        //

        steady_torque.x +=  4. * local_vel.y;    //

        steady_torque.x +=  0.5 * local_vel.y * speed * fourR_stab;    //

        steady_torque.x +=  0.06 * local_vel.y * speed * speed * fourR_stab;    //

        //

        //          Wing sweep-back  ---  similar to dyhedral but only works when lifting

        //      The wing that is yawed forward and the body is sideslipping toward has more lift.

        steady_torque.x -=  0.5 *( local_vel.y * local_vel.z * local_vel.x );

        steady_torque.x -=  0.5 *( local_vel.y * local_vel.z * local_vel.x * local_vel.x );

        //

        //      Turn upward:  This is the trim incidence of the stabalizer.

        steady_torque.y -=  0.10 * speed;

        //      Low powers of speed control the climb angle.

        steady_torque.y -=  0.30 * local_vel.x * speed * speed;

        //      The high powers of speed make it recover quickly from steep dives.

        steady_torque.y -=  0.03  * speed * speed * speed * speed / fourR_stab;

        //

        //      Turn downward:  Like the paper clip on the nose of a paper airplane.

        steady_torque.y +=  1.;                 //      A steep slope of this torque with speed

        steady_torque.y +=  1.3 * horizontal     //  makes the phugoid unstable.

                                * sqr_stab;    // Fades out to make it stall.

        //

        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, steady_torque );  // Apply the torque.

        //

        @skip_dynamics;

        //----------------------------------- Handle Exceptions --------------------------------------------

        //

        //                      Lag

        float time =  llGetTimeOfDay();

        //

        if ( time > last_time + 5. )    // Usually when crossing sim boundaries.

        {

            llSetStatus( STATUS_PHYSICS, FALSE );         //   Turn off physics.

            llSay( 0, "Flight suspended, for timer timeout." );

            pause = -20;

        }

        last_time =  time;

        //

        //                      Recovers from trying to enter restricted space.

        if ( !llGetStatus(STATUS_PHYSICS) && flying && pause>0 )

        {

            llSetRot(  llGetRot()  *  llAxisAngle2Rot( <0,0,1>, PI*2./3. )  );

            pause = -10;

        }

        //

        //                      Low "energy"

        float e = llGetEnergy();

        //

        if ( e < 0.95 )

        {

            llSay( 0, (string) e );

            //

            if ( e < 0.5 )

            {

                llSetStatus( STATUS_PHYSICS, FALSE );          //   Pause physics.

                llSay( 0, "Flight suspended, to catch his breath." );

                pause = -30;

            }

        }

        //

        //                      Continue after timed pause.

        pause += 1;

        if ( pause == 0 && flying )

        {

            llPlaySound( "parrot2", 1.0 );

            llSetStatus( STATUS_PHYSICS, TRUE );

            llSleep( 2. );

            llLoopSound( "parrot1", 0.25 );

        }

        //

        //-------------------------------------------------------------------------------------------------------------

        //

        //                      Break away if stuck.

        if   (   llGetStatus( STATUS_PHYSICS )   )

        {

            if (   kownt_1 == 40 )

            {

                vector diff_a =  pos - last_pos_1a;

                vector diff_b =  pos - last_pos_1b;

                if (  diff_a*diff_a + diff_b*diff_b  < 2.  )

                {

                    llPlaySound( "parrot2", 1.0 );

                    llSay( 0, "Stuck!" );

                    llSetStatus(STATUS_PHYSICS, FALSE);

                    pos.z +=  leap;                 // Attempt to jump over obsticle.

                    if ( pos.z > Center.z )

                    {   pos.z =  Center.z; }        // But not above set ceiling.

                    llSetPos( pos );

                    llSetStatus(STATUS_PHYSICS, TRUE);

                    leap +=  10.;

                    llSleep( 2. );

                    llLoopSound( "parrot1", 0.25 );

                }

                last_pos_1b =  last_pos_1a;

                last_pos_1a =  pos;

                kownt_1 =  0;

            }

            //

            if (   kownt_2 == 400 )

            {

                vector diff_a =  pos - last_pos_2a;

                vector diff_b =  pos - last_pos_2b;

                if (  diff_a*diff_a + diff_b*diff_b  < 6.  )

                {

                    llPlaySound( "parrot2", 1.0 );

                    llSay( 0, "Stuck!" );

                    llSetStatus(STATUS_PHYSICS, FALSE);

                    pos.z +=  leap;                 // Attempt to jump over obsticle.

                    if ( pos.z > Center.z )

                    {   pos.z =  Center.z; }        // But not above set ceiling.

                    llSetPos( pos );

                    llSetStatus(STATUS_PHYSICS, TRUE);

                    leap +=  10.;

                    llSleep( 2. );

                    llLoopSound( "parrot1", 0.25 );

                }

                last_pos_2b =  last_pos_2a;

                last_pos_2a =  pos;

                kownt_2 =  0;

            }

            kownt_1 +=  1;

            kownt_2 +=  1;

        }       // End STATUS_PHYSICS.

        //

        new_collision  -= 1;

        //

        //

    }       // End timer.   -------------------------------------------------------------------------------------------

    //

    land_collision( vector pos )  // It tends to get stuck on its back like a turtle.

    {

        if ( flying )

        {

            if ( new_collision <= 0 )

            {

            llStopSound();  // ?

            llPlaySound( "parrot2", 1.0 );

            //

            llSetStatus( STATUS_PHYSICS, FALSE );   // Must be non-physical to set pos and rot.

            //

            llSetPos(  llGetPos()  +  < 0, 0, 7. >  );

            //

            rotation rot =  llGetRot();

            vector forward =  llRot2Fwd( rot );

            forward.z =  0.;         // Keep only the rotation around the vertical axis.

            rot =  llAxes2Rot( forward, <0,0,1.>%forward, <0,0,1.> );

            rot =  llAxisAngle2Rot( <0, -1. ,0>, 30.*PI/180. ) * rot;

            rot =  llAxisAngle2Rot( <0,0, -1. >, 45.*PI/180. ) * rot;

            rot =  llAxisAngle2Rot( < 1., 0,0>, 10.*PI/180. ) * rot;

            llSetRot(  rot  ); 

            //

            llSetStatus( STATUS_PHYSICS, TRUE );

            //

            //llSay(0, "Ouch!" );

            //

            llApplyImpulse( < 0.05, 0, 0.002 >, TRUE ); // Except for humbingbirds, birds run or push off with there feet.

            //

            last_time =  llGetTimeOfDay();  // Don't time out for the time it took to do this.

            //llSleep( 2. );    This was for the sound, but I think the script engine is not multi-threaded.

            llStopSound();  // ?    Otherwise it loops the wrong sound !?

            llLoopSound( "parrot1", 0.25 );

            new_collision =  10;

            }

        }

        else

        {

            llSetStatus( STATUS_PHYSICS, FALSE );

        }

    }   // End land_collision.

    //

    collision( integer n )  // It tends to get stuck on its back like a turtle.

    {

        if ( flying )

        {

            if ( new_collision <= 0 )

            {

            llStopSound();  // ?

            llPlaySound( "parrot2", 0.1 );

            //

            llSetStatus( STATUS_PHYSICS, FALSE );   // Must be non-physical to set pos and rot.

            //

            rotation rot =  llGetRot();

            vector forward =  llRot2Fwd( rot );

            forward.z =  0.;         // Keep only the rotation around the vertical axis.

            rot =  llAxes2Rot( forward, <0,0,1.>%forward, <0,0,1.> );

            rot =  llAxisAngle2Rot( <0, -1. ,0>, 30.*PI/180. ) * rot;

            rot =  llAxisAngle2Rot( <0,0, -1. >, 45.*PI/180. ) * rot;

            rot =  llAxisAngle2Rot( < 1., 0,0>, 10.*PI/180. ) * rot;

            llSetRot(  rot  );

            //

            llSetPos(  llGetPos()  +  < 0, 0, 2. >  );

            llSetStatus( STATUS_PHYSICS, TRUE );

            //

            //llSay(0, "Ouch!" );

            //

            llApplyImpulse( < 0.1, 0, 0.07 >, TRUE ); // Except for humbingbirds, birds run or push off with there feet.

            //

            last_time =  llGetTimeOfDay();  // Don't time out for the time it took to do this.

            //llSleep( 2. );    This was for the sound, but I think the script engine is not multi-threaded.

            llStopSound();  // ?    Otherwise it loops the wrong sound !?

            llLoopSound( "parrot1", 0.05 );

            new_collision =  10;

            }

        }

        else

        {

            llSetStatus( STATUS_PHYSICS, FALSE );

        }

    }   // End collision.

}   // End default.
