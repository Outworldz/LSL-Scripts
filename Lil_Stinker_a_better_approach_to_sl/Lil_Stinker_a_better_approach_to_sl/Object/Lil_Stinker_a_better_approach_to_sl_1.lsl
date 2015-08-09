// :CATEGORY:Vehicles
// :NAME:Lil_Stinker_a_better_approach_to_sl
// :AUTHOR:Fritz Kakapo
// :CREATED:2010-09-02 14:27:13.847
// :EDITED:2013-09-18 15:38:56
// :ID:471
// :NUM:632
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Basic flight script for birds
// This script uses the SL physics engine to implement a standard simple linearized model of the flight of an airplane.  As far a the author knows, this is the only real attempt by an sl scripter to model the forces on a flying body.  Other flight scripts (except derivatives of this one) start from a generic sl vehicle and add airplane-like features such as banking and a minimum flight speed, an approach that will not lead to realistic flight without endless correction.
// This script is still distributed under a GNU Free Public License, but, in case the copyright covers more than I realize, I specifically grant permission to use the methods and short sections of this script in proprietary scripts.  Direct derivatives, on the other hand, can be used in proprietary airplanes, but the derived scripts must be distributed in editable form, in some way.

// :CODE:

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

//  Airplanes with scripts derived from this one need to be sold or given along with a copy of the same code version

//  as is in the airplane.  Derived airplanes with other scripts need to be full permissions or distributed

//  along with a full permissions version, but the unrelated script need not be copyable.

//      The aerodynamics and algorithms uses are not copyrightable and may be freely used as a guide to other scripts.

//      Please refer to some source, such as Wikipedia, for the exact license terms.

//

//  I have kept some of the earlier comments here:

//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

// Simple airplane script example

// THIS SCRIPT IS PUBLIC DOMAIN! Do not delete the credits at the top of this script!

// Nov 25, 2003 - created by Andrew Linden and posted in the Second Life scripting forum

// Jan 05, 2004 - Cubey Terra - minor changes: customized controls, added enable/disable physics events

// Feel free to copy, modify, and use this script.

// Always give credit to Andrew Linden and all people who modify it in a read me or in the object description.

//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

//

//      See the accompanying note card for operating instructions.  <-----------------------------------------<<<<

//

//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

//

//      The VICE is taken from "Flight Script EEv3 (VICE 1.2.0)" and "VICE ALA Test Airplane v. 1.2.0".

//

//"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

//

//      Since virtual materials are cheap, I am using carbon nanotubes for most of the structure,

//  so this airplane is very light!

//  (Alos other carbon forms and other materials not easily obtained in rl.

//  The piston rings are osmium boride.  Diamond is used extensively in the engine,

//  because of its good heat conductivity.)

//

//      The script assumes that the root primitive is oriented such that its:

//  local x-axis points toward the nose of the plane, and its

//  local z-axis points toward the top.

//

//  Lift is proportional to the square of the speed, like centrifugal force, so (excluding structural failure)

//  an airplane can turn in the same radius at high speed as at low speed, unlike a car.  (Actually perhaps

//  somewhat smaller, due to Reynolds number effects.)  Without correction, the lift here due to turning the velocity

//  is only proportional to the speed.  Though still better than a car, that is not fully realistic or fun.

//  If this were corrected, one could learn a maneuver and then keep doing it faster, as long as the simulator

//  could support the speed and acceleration.  This has partially been done in the timer routine near the end.

//

//      The physics engine that applies the forces controled by the VEHICLE parameters appears to run at

//  about 40 frames per second.  These functions include lift and drag, as well as applying the torqes and damping

//  set in timer, and calculation of the resulting rotation and motion.  The controls are done with abrupt torques,

//  so the time scale is that of the arrow key input, like ordinary SL movement and flying.  An instantaneous torque is

//  about the same response speed as simple mechanically operated control surfaces.

//  The dynamic coupling and trim added, to make it really fly like an

//  airplane, instead of like a generalized vehicle that flies and banks, runs in timer.  The time interrupt

//  rate is set for 0.5 sec., and the script tries to conpensate for slow response by slowing down.

//

//-----------------------------------------------------------------------------------------------------------------------------------

//

//              Free VICE airplane script credits:

// This airplane is a freebie; it includes a modified freebie flight script (EEV3) designed to support VICE

// In VICE terms, this airplane is an ALA with 2 LMG guns (contained in the gun prims, naturally)

// This VICE mod is by Creem Pye, April 1 2008

// Special thanks to Xenox Snook for supplying the fuselage!

// All the other people credited below worked on the airplane script, as far as I know...

//

// Modified from Cubey Terra DIY Plane 1.0 by Eoin Widget and Kerian Bunin

// which was originaly marked as September 10, 2005

// Distribute freely. Go ahead and modify it for your own uses. Improve it and share it around.

// Some portions based on the Linden airplane script originall posted in the forums.

// ** Last Modified by Eoin Widget on March 26, 2006 **

//

//===================================================================================================================================

//

//

// control flags that we set later

integer gAngularControls = 0;

integer gLinearControls = 0;

//

// The propeller thrust is saved and restored as it decays, to continue cruising.

vector gLinearMotor = < 0, 0, 0 >;

//

float last_time =  99999999.;    // previously stored time of day

integer sit = FALSE; //  keeps track of whether flying or parked

integer motor_idle = TRUE; //  Motor has been set to zero speed by touching the airplane.

//

float torque_factor = 1.;   // Used to increase control effectiveness with speed.

//

vector steady_torque = < 0, 0, 0. >;         // Aerodynamic dynamic torque, independant of controls.

//

float LINEAR_MOTOR_TIMESCALE_0 =  2.;       // 1/strength when going slow

//

float ANGULAR_MOTOR_TIMESCALE_0 =  2.5 ;   //  1/strength.  Damping and dynamic torque.

//

vector LINEAR_FRICTION_TIMESCALE_0 =  < 30., 4., 0.50 >;

//

vector ANGULAR_FRICTION_TIMESCALE_0 =  < 2.5, 2.5, 7.5 >; // Along with angular motor time scale,

//

float speed =  0.;

float maxThrottle =  45;

float timer_dialation =  1.;             // Slow down when lag is bad.

float o_t_d =  1.;             // previous value of slow down

float energy =  1.;             // From the physics engine.

//

float mass;

float mass_factor =  1.;    // Adapt to a particular airplane.

float buoyancy = 0.3;   // buoyancy for no lag, depends on touring or advanced mode

//

integer listenHandle;

integer homing =  FALSE;     // Try to stay in si

//

key pilot=NULL_KEY;

//

integer edges =  0;

integer levels =  0;

//

integer updating =  FALSE;

integer kownt_3;   // time since last control entry

//

//-----------------------------------------------------------------------------------------------------------------------------------

integer HUDon =  TRUE;

string HUDtext="";

vector HUDcolor;

vector local_vel;

//===================================================================================================================================

//

//

//          This is called whenever there is flight control input, from timer, from control, from listen and from touch_start.

Update()

{

    if ( updating ) jump GOTO;  // Skip possible reentrant call, if possible in this system.

    updating =  TRUE;

    //

    vector v =  llGetVel();

    speed =  llSqrt( v * v );

    //

    //----------------------------------------------- Handle Exceptions, Environment-----------------------------------------------------

    //

    //          Slow down for lag.  Pause if too bad.

    float time =  llGetTimeOfDay();

    float time_interval =  time - last_time;

    if ( time_interval <= 0. )  time_interval =  0.5;           // Fix bad times.

    last_time =  time;

    //

    float lag =  1. / llSqrt( time_interval*time_interval + 1. );   // << 1 = laggy, otherwize near 1.

    //

    if ( lag < timer_dialation )

    {       timer_dialation =  lag;      }       // Take new lag if worse.

    else

    {       timer_dialation =  timer_dialation * 0.5  +  lag * 0.5;       }   // Else smooth out a bit.

    //

    vector pos =  llGetPos();

    //

    if ( pos.x < -1.  ||  pos.x > 257.  )  { timer_dialation =  timer_dialation*0.4; }

    // Slow for delayed handover or other problem.

    if ( pos.y < -1.  ||  pos.y > 257.  )  { timer_dialation =  timer_dialation*0.4; }    // But continue along end of world.

    if ( pos.z < -1. )                     { timer_dialation =  timer_dialation*0.4; }

    if ( pos.z > 4000. )

        {

            llApplyImpulse( < -100., 0, -40. >, TRUE ); // Push back and down to stay on world.

            llApplyRotationalImpulse( < 1.7, 1.7, -1.7 >, TRUE );

            gLinearMotor =  gLinearMotor*0.97;

            llWhisper(0, "Altitude ceiling reached." ); 

        }    // But not top.

    //

    if ( timer_dialation < 0.3  &&  timer_dialation < o_t_d )  { llWhisper(0, "Slowed to " + (string)timer_dialation + " for lag."); }

    o_t_d =  timer_dialation;

    //

    //  Now look if we are approaching edge of sim.

    vector projected =  pos + v*time_interval*1.5;       // engeneering margin

    //

    if(  projected.x < 0.  ||  projected.x > 256.  )

    {

        if(  llEdgeOfWorld( pos, < v.x, 0, 0 > )  )

        {

            //  I want to turn away from the edge, but that is not simple.

            //  Can't set the speed, have to apply a force or impulse away from edge of world.

        }

        else        // Expect sim crossing before next entry.

        {

            timer_dialation =  timer_dialation * 0.2;   // Slow down for crossing.

        }

    }

    if(  projected.y < 0.  ||  projected.y > 256.  )

    {

        if(  llEdgeOfWorld( pos, < v.y, 0, 0 > )  )

        {

            //  I want to turn away from the edge, but that is not simple.

            //  Can't set the speed, have to apply a force or impulse away from edge of world.

        }

        else        // Expect sim crossing before next entry.

        {

            timer_dialation =  timer_dialation * 0.2;   // Slow down for crossing.

        }

    }

    //

    //

    llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, ANGULAR_FRICTION_TIMESCALE_0 * timer_dialation );

    //

    llSetVehicleFloatParam( VEHICLE_BUOYANCY, 1. - timer_dialation*(1.-buoyancy) );

    //

    llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, LINEAR_FRICTION_TIMESCALE_0 * timer_dialation / (speed+0.0005)  );

    //

    if (  time_interval  >  20. * (1.+buoyancy)  )

    { llSetStatus(STATUS_PHYSICS, FALSE); llWhisper( 0, "Flight suspended, for timeout.  Click to resume." );  }

    //   Turn off physics.  Wait for user to be able to touch aircraft, showing that a simulator has them back together.

    //    Usually when crossing sim boundaries.

    //

    //      See if the simulator thinks we have been too busy.

    energy = energy * 0.75 + llGetEnergy() * 0.25;  // Smooth over sim crossings.

    if ( energy < 0.45 )

    {

        llWhisper( 0, "Energy reduced to" + (string)energy );

        //

        if (  energy < 0.2  )

        { llSetStatus(STATUS_PHYSICS, FALSE); llWhisper( 0, "Flight suspended, to let the engine cool." );  } //   Pause physics.

    }

    //  End Exeptions.

    //

    //-------------------------Include speed increase of contol surface effectiveness. --------------------------

    //

    torque_factor =   ( 0.15 + 40. * speed/8. * speed/8. )  *  mass_factor  *  timer_dialation  *  (1.-buoyancy) * (1.-buoyancy);

    //

    llSetVehicleFloatParam(  VEHICLE_ANGULAR_MOTOR_TIMESCALE,  ANGULAR_MOTOR_TIMESCALE_0 / torque_factor  );

    //

    //-------------------------------------------------------------------------------------------------------------------------------

    steady_torque = <  0., 0, 0. >;     // Start with no turn.

    //

    //----------------------------------------------------  Control  ----------------------------------------------------------------

    //

    // only change linear motor if one or more of the linear controls is pressed, and only once

    if ( edges & levels & gLinearControls )

    {

        //

        if ( edges & levels & CONTROL_UP )

        {

            if ( gLinearMotor.x < maxThrottle )      // "Damped to about 30."  Over 30 to cover drag.

                gLinearMotor.x += 3.;

        }

        if ( edges & levels & CONTROL_DOWN )

        {

            if ( gLinearMotor.x > -maxThrottle/3. )

                gLinearMotor.x -= 3.;

        }

        //

        if ( levels & CONTROL_DOWN && levels & CONTROL_UP )

        {

            if  ( ! llGetStatus(STATUS_PHYSICS) )

            {

                llSetStatus( STATUS_PHYSICS, TRUE );      // Resume flight, under pilot control.

                llWhisper( 0, "Flight resumed." );

            }

            else

            {

            if ( motor_idle )

                {

                    llSetStatus( STATUS_PHYSICS, FALSE );

                    llWhisper( 0, "Flight suspended, manually." );

                }

                else

                {

                    gLinearMotor =  <0,0,0>;    //  Stop the engine.

                    motor_idle =  TRUE;

                    llWhisper( 0, "Throttle closed." );

                }

            }

        }

        else

        {

            motor_idle =  FALSE;

        }

        //

        float power =  llSqrt(  gLinearMotor * gLinearMotor  +  0.1  );

        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, LINEAR_MOTOR_TIMESCALE_0 / llSqrt(power) * 3. );

        // 1/strength

    }   // End Linear.

    //

    //              Angular Controles

    //      Changed to impulse angular control, but F. t. C.,

    //  for the faster response of a stunt plane.

    //

    if ( levels & gAngularControls )

    {

        vector impulse_torque =  <0,0,0>;

        //

        //      Aileron roll control:

        if ( levels & CONTROL_ROT_LEFT )

        {

            if (  edges & CONTROL_ROT_RIGHT  &&  buoyancy == 0.  )

                impulse_torque.x -= 1.0 * torque_factor;

            //

            steady_torque.x -= 0.7;

        }

        if ( levels & CONTROL_ROT_RIGHT )

        {

            if ( edges & CONTROL_ROT_RIGHT  &&  buoyancy == 0.  )

                impulse_torque.x += 1.0 * torque_factor;

            //

            steady_torque.x += 0.7;

        }

        //

        //      Pitch component, elevator ==> causes vehicle lift nose (in local frame):

        if ( levels & CONTROL_BACK )

        {

            if ( edges & CONTROL_BACK  &&  buoyancy == 0.  ) // up

                impulse_torque.y -= 0.7 * torque_factor;

            //

            steady_torque.y -= 0.5;

        }

        if ( levels & CONTROL_FWD )     // down

        {

            if ( edges & CONTROL_FWD  &&  buoyancy == 0.  )

                impulse_torque.y += 0.7 * torque_factor;

            //

            steady_torque.y += 0.5;

        }

        //

        //      Rudder control:

        if ( levels & CONTROL_RIGHT )

        {

            if ( edges & CONTROL_RIGHT  &&  buoyancy == 0.  )

                impulse_torque.z -= 0.7 * torque_factor;

            //

            steady_torque.z -= 0.5;

        }

        if ( levels & CONTROL_LEFT )

        {

            if ( edges & CONTROL_LEFT  &&  buoyancy == 0.  )

                impulse_torque.z += 0.7 * torque_factor;

            //

            steady_torque.z += 0.5;

        }

        //if ( speed < 1.0 )     {   impulse_torque =  5. * impulse_torque;    }  // Effective turn on ground.

        //

        llApplyRotationalImpulse( impulse_torque, TRUE );

        //

        edges =  0; // We only respond to these once.

     }  // End angular contols.

    //  End Control.

    //

    //-----------------------------------  Routine Flight  --------------------------------------------------------------------------

    //-------------------------------------- Refresh motor settings. ------------------------------------------

    //

    llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor );

    //                                          This is to defeat VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE.

    //

    //

    local_vel = v / llGetRot();      // global to local coordines

    //llWhisper(0, (string)local_vel );

    //

    //------------------------------------Stear Toward Regeon Center.----------------------------------------------

    //

    if ( homing )

    {

        //      This is not realistic for a piloted airplane, but it helps avoid sim boundaries.

        //  It is more like the Cox control line Little Stinker that flies constrained to a hemeshere.

        //

        vector  toCenter =  (  < 128, 128, 0 >  -  pos  );     // global vector to center of sim

        //      This is the locaiton that it flies around.

        //

        //      Roll and yaw to the port of center, moving inward and to starboard when moving away from center.

        //  This moves it toward center, when circling right.

        vector  h_toCenter =  toCenter;   

        h_toCenter.z = 0;        // No vertical here.

        vector  loc_h_toCenter =  h_toCenter  / llGetRot();   // global to local coordinate transformation;

        vector  left =  -loc_h_toCenter * (local_vel.x/5.) * 0.00010;

        left.y = 0; // No pitch.

        left.z = -10 * left.x;              // Roll component goes to roll and yaw.

        steady_torque +=  left;       // Roll to left of center, to right away.

        //

        //      Turn toward center.  This tends to move it to center when not circeling.

        vector turn_toCenter =  < 1, 0, 0 > % loc_h_toCenter * (local_vel.x/5.) * 0.0004;

        //      Forward x [vector cross product] radius = torque toward center.  Adjust strength.

        steady_torque +=  turn_toCenter;       //  Add to torque.

    }

    //

    //

    //

    //---------------------------  Dynamic Coupling and Trim Tuning  -----------------------------------------------

    //

    if ( homing )

    {                  

        //      Spiral right to help stay in sim.  Physically, this comes from the left hand propeller rotation.

        float right =  0.0;                     // (English and American propellers usually rotate like a right

        right += -local_vel.z * 0.010;      //  hand screw, but old German and Swiss engines ran the other way.)

        steady_torque.x +=  right;

        steady_torque.z -=  2.3 * right;

    }

    //

    //      Dihedral:  Wing tip on the downward side lifts when moving sideways.

        steady_torque.x +=  0.05 * local_vel.y;

    //

    //      Wing sweep action:  side slip times lift turns roll back up.

    //      The down side wing has more lift, but only if it is already lifting.

    steady_torque.x -=  0.04 * ( local_vel.y * local_vel.z );

    //

    //

    //      Turn upward:  This is the trim incidence of the stabalizer.  Global down when up side down.

    if ( homing )

    {

        steady_torque.y -=  0.025 * local_vel.x/5. * (1.-buoyancy) * llSqrt(1.-buoyancy);

    }

    //

    //      Turn upward:  I don't know how to do this in rl with a passive shape.  Remains global up when up side down.

    steady_torque.y +=  0.004 * local_vel.x/5. * local_vel.z * (1.-buoyancy) * llSqrt(1.-buoyancy);

    //

    //      Turn up.

    steady_torque.y +=  0.05 * local_vel.z * (1.-buoyancy) * llSqrt(1.-buoyancy);

    //

    //

    llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, steady_torque );

    refreshHUD();

    //

    updating =  FALSE;

    @ GOTO;

}   //  End Update.----------------------------------------------------------------------------------

//

//-----------------------------------------------------------------------------------------------------------------------------------

//

refreshHUD()

{

    if ( !sit )

    {

        HUDtext="Take a copy. \n Full permissions.

        New aerodynamic flight script 4.0 .

        Open the airplane as a box to get the documentation.";

        HUDcolor =  < 0.2, 0.4, 1. >;

        jump early_exit;

    }

    //

    if ( !HUDon )

    {

        llSetText( "", <0,0,0>, 0. );

        jump early_exit;

    }

    //

float fwd =  gLinearMotor.x;

//

        HUDtext="Airpeed: "+(string)llFloor((local_vel.x+0.5)) + " m/sec. = "+(string)llFloor((local_vel.x*1.94+0.5)) + " kts.

        Throttle: "+(string)llFloor(fwd*100.0/maxThrottle)+"%";

        HUDcolor=<1.0,1.0,1.0>;  // white when combat is disabled

    //

    @early_exit;

    //

    llSetText( "", HUDcolor, 1.0);

    //llSetText(HUDtext+"\n \n \n \n \n \n \n ", HUDcolor, 1.0);

    //

    llMessageLinked( 2, 25*(integer)(HUDcolor.x*4.)

                       + 5*(integer)(HUDcolor.y*4.)

                         + (integer)(HUDcolor.z*4.), "HUDcolor", NULL_KEY );

    llMessageLinked( 2, 137, HUDtext+"\n \n \n \n \n \n \n \n ", NULL_KEY );

    //

}   // End refreshHUD().

//

//-----------------------------------------------------------------------------------------------------------------------------------

default

{

    state_entry()

    {

        llSetSitText( "Fly" );

        //llCollisionSound( "", 0.0 );



 



        // the sit and camera placement is very shape dependent

        // so modify these to suit your vehicle

        llSitTarget( < 0.35, 0.0, 0.33 >, ZERO_ROTATION);  //  pilot position, relative to root

        //

        llSetCameraEyeOffset( < -11.5, 0.0, 4.5 > );       // location of camera, relative to vehicle

        llSetCameraAtOffset( < 0.0, 0.0, 2.4 > );          // focus point of camera, " "

        //

        //---------------------------------------------------------------------------------------------------------------------------

        //

        llSetVehicleType( VEHICLE_TYPE_AIRPLANE );    // Sets default airplane-like parameters.



 



        // action of the fin and stabilizer:  Points toward velocity.

        // The front turns toward the current velocity.

         llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1. );    //  "behave much like the deflection time scales"

         llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 1.5 );

        //

        // Fuselage lift.  Wing lift is handled with VEHICLE_LINEAR_FRICTION_TIMESCALE below.

        // The velocity turns toward the front.  (Exact formula unknown.)

         llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1.0 );    //  "behave much like the deflection time scales"

         llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 7. );

        //

        // propeller thrust strength

        //  Shorter time scale makes it more stable.  Longer makes it more physical (aerodynamic).  Too long makes it hard to move.

         llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, LINEAR_MOTOR_TIMESCALE_0 );       // 1/strength

         // "it cannot be set longer than 120 seconds"

         llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 5.); // Throttle gradually closes with time but defeated:

        //                                                                      Refreshed below in timer.

        //

        // control surfaces, ailerons, elevators (and maybe later rudder)

        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, ANGULAR_MOTOR_TIMESCALE_0 );   //  1/strength

        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5. );      // Control returns to neutral when released.

        //

        //--------------------- linear friction ------------------------------------------------

        //      The x component is parasite drag (along with VEHICLE_LINEAR_MOTOR_TIMESCALE).

        //      The y component contributes to fuselage transverse lift and to drag due to yaw.

        //      The z component might seem to be just a vertical damping, but when pitch changes by a small amount,

        // most of the motion in the direction that was previously forward, becomes motion in the new forward direction,

        // with initially only a small transverse (up or down) component.  With a short decay time scale

        // in the z direction, that component is lost quickly, so the motion continues to follow the pitch angle.

        // The larger the z time constant is, the more "induced drag" there is.  That is VEHICLE_LINEAR_FRICTION_TIMESCALE.z

        // greater than zero causes a drag that increases with lift, similarly to induced drag of a physical airplane.

        //

        //      The z component gives the wing lift.  Decreasing it allows the airplane to fly more slowly,

        //  without loss of speed or altitude.  But it seems to be near the limit, to fly much slower one may need buoyancy.

         llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, LINEAR_FRICTION_TIMESCALE_0 );

         //

         llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, < 0.25, 0.5, 0.5 > ); // Along with angular motor time scale,

         // This damps the rotational motion.

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

        //  contribution to downward acceleration.  Try this to make it easier to fly.

        llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.0 );

        //

        // define these here for convenience later

        // CUBEY - modified these as per Shadow's prefs

        gAngularControls = CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_BACK | CONTROL_FWD;

        gLinearControls = CONTROL_UP | CONTROL_DOWN;    // These control the engine throttle.

        //

        llSetStatus( STATUS_PHYSICS, FALSE ); //CUBEY - ensure that physics are disabled when plane is rezzed so it doesn't fly off

        sit = FALSE;         // Keep track of not flying.

        //

        mass =  llGetMass();

        mass_factor =  (mass/12.5)  *  llSqrt( llSqrt(mass/12.5) );

        //llSay(0, (string)mass+" virtual kilograms." );

        llSay(0, "Ready to wash." );

        refreshHUD();

        //

    }   //  End state_entry()

//-----------------------------------------------------------------------------------------------------------------------------------

    //

    // DETECT AV SITTING/UNSITTING AND TAKE CONTROLS

//-----------------------------------------------------------------------------------------------------------------------------------

    changed(integer change)

    {

        if ( change & CHANGED_LINK )

        {

            pilot = llAvatarOnSitTarget();

            if (pilot)

            {

                if (pilot != llGetOwner())

                //if ( FALSE )

                {

                    // only the owner can use this vehicle

                    llWhisper(0,

                    "Please take a copy of this airplane and fly your own copy.

                    (If it is not set \"free to copy\" or \"for sale 0 l$\" contact the owner or the creator.)

                    You aren't the owner -- only the owner can fly this plane.");

                    llUnSit(pilot);

                    //llPushObject(pilot, <0,0,10>, ZERO_VECTOR, FALSE);

                }

                else

                {   // Pilot sits on vehicle

                    // Clear linear motor on successful sit.

                    //llTriggerSound("cbb7a77f-4302-e3b3-4c1f-6dcb30bf3382",1.0);  // engine startup

                    //sit = TRUE;

                    //onGround=TRUE;

                    llMessageLinked(LINK_SET, TRUE, "seated", pilot);

                    llRequestPermissions(pilot, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_CONTROL_CAMERA);

                    listenHandle = llListen( 0, "", pilot, "" );

                }

            }

            else if ( sit ) 

            // When changed is called with flying and CHANGED_LINK, it is usually that the avatar is getting up.

            {

                // Pilot is getting up.

                llWhisper(0, "Ignition off.");

                llMessageLinked(LINK_SET, FALSE, "seated", "");

                //

                // Stop the works.

                llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 2. );   //  Allow it to rotate when it touches.

                //llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0> );

                llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0> ); // Turn off engine.

                llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.0 );        // Allow it to fall or fly.

                //

                // Let friction slow the vehicle rather than pinning it in place.

                //

                llReleaseControls();

                llStopAnimation("sit");

                //

                llSleep( 8. );    // Wait for it to stop.

                //

                llSetStatus( STATUS_PHYSICS, FALSE ); //Turn off "physics" to make sure the parked plane not be move.

                sit = FALSE;             // Keep track of whether sitting.

                llSetTimerEvent( 0 );         // Stop timer.

                llWhisper(0, "Brake set.");

                refreshHUD();

                //

            }

        }

    }   // End changed.

    //-------------------------------------------------------------------------------------------------

    run_time_permissions( integer perm )

    {

        if (perm)

        {

            llStartAnimation("sit");

            llTakeControls( gAngularControls | gLinearControls | CONTROL_LBUTTON, TRUE, FALSE );

            gLinearMotor = < 0., 0., 0. >;

            llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor );

            llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0,0,0> );

            llSetStatus( STATUS_PHYSICS, TRUE );    //CUBEY - enable physics when avatar sits

            sit = TRUE;      // Keep track of whether flying or not.

            //

            llSetTimerEvent( 0.25 );         // seconds   This is to refresh forces and torques that have decayed.

            //                                              Also dynamic coupling, etc.

            last_time = llGetTimeOfDay();   //  Here the script starts do it own "real" time.  Initially only to tell when

            //                                  things are so bad we'd better pause the animation.

            kownt_3 =  0;

            llWhisper(0, "

            Engine started.

           

            Arrow keys -- up, down, roll right, left.

            Shift with arrow keys works the rudder.

            Flight modes are \"t\", \"n\" and \"e\".

            \"s\" to toggle stear to stay in sim.");

            //

            //

        }

    }

    //FLIGHT CONTROLS

//-----------------------------------------------------------------------------------------------------------------------------------

    control( key id, integer control_levels, integer control_edges )

    {

        edges =  control_edges;

        levels =  control_levels;

        //

        Update();   // Do everything.

        //

        kownt_3 =  0;   // time since last control entry

    }   // End control.

    //      (The controls really aught to reverse when going backwards,

    //  but it seems convienient to be able to turn on the ground.)

    //===============================================================================================================================

    //

    //

    listen( integer channel, string name, key id, string message )

    {

        //

        if (  message == "hud on"  ||  message == "HUD ON"  )   // expert mode

        {

            HUDon = TRUE;

            refreshHUD();

        }

        //

        if (  message == "hud off"  ||  message == "HUD OFF"  )   // expert mode

        {

            HUDon = FALSE;

            refreshHUD();

        }

        //---------------------------------------------------------------------------------------------------------------------------

        //

        if (  message == "e"  ||  message == "E"  )   // expert mode

        {

            buoyancy = 0.;

            llWhisper(0, "Expert mode set." );

        }

        else if ( message == "n"  ||  message == "N"  )  // normal mode

        {

            buoyancy = 0.4;

            llWhisper(0, "Normal mode set." );

        }

        else if ( message == "t"  ||  message == "T"  )  // touring mode

        {

            buoyancy = 0.6;

            homing =  FALSE;

            llWhisper(0, "Touring mode set." );

        }

        else if ( message == "s"  ||  message == "S"  )  // Stay on sim on, off.

        {

            if ( homing )

            {

                homing =  FALSE;

                llWhisper(0, "Stear around sim center off." );

            }

            else

            {

                homing =  TRUE;

                llWhisper(0, "Stear around sim center on." );

            }

        }

        //

        //

        Update();   // Periodic tasks

    }   // End listen.

    //

    //===============================================================================================================================

    timer()     //  Added by F. t. C.

    {

        Update();   // Periodic tasks

        //

        //  If timer is running but there has been no control recently, then the airplane must be lost,

        //  unless the auto-pilot is on.

        if (   kownt_3 == 2*60*4   &&   !homing   )

        {

            llInstantMessage( llGetOwner(), llGetRegionName() + (string) llGetPos() );

            kownt_3 =  -2*60*60*4;        //  how long till next IM

        }

        //llOwnerSay( (string)kownt_3 );

        kownt_3 +=  1;   // time since last control entry

        //

    }// End timer.

    //

    //===============================================================================================================================

    touch_start(integer total_number)

    {

        if ( sit )

        {

            if  ( ! llGetStatus(STATUS_PHYSICS) )

            {

                llSetStatus( STATUS_PHYSICS, TRUE );      // Resume flight, under pilot control.

                llWhisper( 0, "Flight resumed." );

            }

            else

            {

                if ( motor_idle )

                {

                    llSetStatus( STATUS_PHYSICS, FALSE );

                    llWhisper( 0, "Flight suspended, manually." );

                }

                else

                {

                    gLinearMotor =  <0,0,0>;    //  Stop the engine.

                    motor_idle =  TRUE;

                    llWhisper( 0, "Throttle closed." );

                }

            }

        }

        //

        Update();   //-------- Handle Exceptions, Environment----------------------------------------------

    }

}       // End default.

//

//      (The controls really aught to reverse when going backwards,

//  but it seems convienient to be able to turn on the ground.)
