// :CATEGORY:Walk
// :NAME:Walk Anywhere
// :AUTHOR:Adeon Writer
// :KEYWORDS:
// :CREATED:2015-01-15 20:52:37
// :EDITED:2015-01-15
// :ID:1066
// :NUM:1711
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Walk anywhere on any surface with a ray caster
// :CODE:

// BOF
// Raycasting Wall Walker v1 by Adeon Writer
// This script is licenced under the following terms and conditions: http://www.wtfpl.net/txt/copying/

//// Global Constants (Mod these!)
float Z_MODIFIER = 0.8; // Move avatar up or down along prim's z axis (mod while sitting on it to put your avatar's feet on the ground)
float JUMP_FORCE = 0.35; // Initial upward boost from jumps. (careful, this is powerful.)
float MOVE_SPEED = 0.075; // Movement speed in meters per server step
float TURN_SPEED = 0.05; // Turn speed in radians per server step
float RUN_BOOST = 2.5; // Speed multiplier while running instead of walking (to run, hold forward and back at the same time... yeah I know it's dumb.)
vector CAMERA_FLOATAT_POSITION = <-2.5, 0, 2.0>; // Local position that camera will be positioned relative to the vehicle
vector CAMERA_LOOKAT_POSITION = <0, 0, 1.0>; // Local position that camera point at relative to the vehicle
string STAND_ANIM = "Stand";
string WALK_ANIM = "Walk";
string RUN_ANIM = "Run";

//// Internal global varables, script will modify these values during runtime.
float boost;
float jumpHeight;
float jumpSpeed;
float jumpGravity = 0.02;
vector rot2fwd;
vector rot2left;
vector rot2up;
vector movementOffset;
integer left;
integer right;
integer notJumping = TRUE;
rotation rot;

//// Methods
// Spherical linear interpolation from a to b at t (where a is t=0.0 and b is t=1.0)
rotation slerp(rotation a, rotation b, float t)
{
   return llAxisAngle2Rot(llRot2Axis(b/=a), t*llRot2Angle(b))*a; // Example taken from http://wiki.secondlife.com/wiki/Slerp
}

// Positional interpolation from a to b at t (where a is t=0.0 and b is t=1.0)
vector perp(vector a, vector b, float t) 
{
    return a+(b-a)*t;
}

// Tweens object's rotation from A to B while position from C to D over 'steps' steps.
smoothRotate(rotation A, rotation B, vector C, vector D, integer steps) 
{
    integer i;
    for(i=1; i<steps; i++) llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_ROTATION, slerp(A, B, i/(float)steps), PRIM_POSITION, perp(C, D, i/(float)steps)]);
    jumpHeight = 0.0; // Cancel any jump velocity.
}

// Terribly akward simulation of acceleration due to gravity!
gravity() 
{
    jumpSpeed -= jumpGravity;
    jumpHeight += jumpSpeed;
    if(jumpHeight < 0.0)
    {
        if(!notJumping)
        {
            notJumping = TRUE;
            if(movementOffset == ZERO_VECTOR) llStartAnimation(STAND_ANIM);
            else llStartAnimation(WALK_ANIM);
            llStopAnimation("jump");
        }
        jumpHeight = 0;
    }
    // prevent float precission errors by capping the values:
    if(jumpHeight < -10) jumpHeight = -5;
    if(jumpSpeed < -5) jumpSpeed = -2;
}

zMod() // Sets avatar's height based on Z_MODIFIER
{
    llSetLinkPrimitiveParamsFast(2, [PRIM_POS_LOCAL, <0,0,Z_MODIFIER>]);
}

default
{
    on_rez(integer start)
    {
        vector scale = llGetScale();
        llSetPos(llGetPos() - <0,0,scale.z*0.4>);
    }
    
    state_entry()
    {
        zMod();
        llSetCameraEyeOffset(CAMERA_FLOATAT_POSITION);
        llSetCameraAtOffset(CAMERA_LOOKAT_POSITION);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSetVehicleType(VEHICLE_TYPE_SLED);
        llRemoveVehicleFlags(VEHICLE_FLAG_MOUSELOOK_STEER);
        llSetVehicleFlags(VEHICLE_FLAG_CAMERA_DECOUPLED); // When in mouselook, object rotation should not cause mouselook rotation.
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetClickAction(CLICK_ACTION_SIT);
        llSetColor(<1,1,1>, ALL_SIDES);
        llSitTarget(<0.0,0,0.18>, ZERO_ROTATION);
        if(llAvatarOnSitTarget() != NULL_KEY)
        {
            llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TAKE_CONTROLS|PERMISSION_CONTROL_CAMERA|PERMISSION_TRIGGER_ANIMATION|PERMISSION_TRACK_CAMERA);
            llSetTimerEvent(0.01);
        }
    }
    
    changed(integer change)
    {
        if(change & CHANGED_LINK)
        {
            if(llAvatarOnSitTarget() != NULL_KEY)
            {
                llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TAKE_CONTROLS|PERMISSION_CONTROL_CAMERA|PERMISSION_TRIGGER_ANIMATION|PERMISSION_TRACK_CAMERA);
                llOwnerSay("Ok. Arrows or WASD move you. You can also jump. Press M for mouselook (it's neat).");
                llSetTexture(TEXTURE_TRANSPARENT, ALL_SIDES);
                zMod();
                llSetTimerEvent(0.01);
            }
            else
            {
                llSetTexture(TEXTURE_PLYWOOD, ALL_SIDES);
                llResetScript();
            }
        }
    }
    
    timer()
    {
        gravity();
        rot = llGetRot();
        rot2fwd = llRot2Fwd(rot);
        rot2left = llRot2Left(rot);
        rot2up = llRot2Up(rot);
        vector pos = llGetPos();
        list cast = llCastRay(pos, pos + movementOffset*0.25, [RC_REJECT_TYPES, RC_REJECT_PHYSICAL, RC_DATA_FLAGS, RC_GET_NORMAL, RC_MAX_HITS, 2]); // Our first cast is to check for walls in direction of movement.
        integer smooth = TRUE;
        if(llList2Key(cast, 0) == llGetOwner()) cast = llDeleteSubList(llListReplaceList(cast, [llList2Integer(cast, -1)-1], -1, -1), 0, 2);
        if(llList2Integer(cast, -1) <= 0)
        {
            smooth = FALSE;
            cast = llCastRay(pos, pos + rot2up*(-1-jumpHeight), [RC_REJECT_TYPES, RC_REJECT_PHYSICAL, RC_DATA_FLAGS, RC_GET_NORMAL, RC_MAX_HITS, 2]); // There's no walls, so check down at our riding surface.
        }
        if(llList2Key(cast, 0) == llGetOwner()) cast = llDeleteSubList(llListReplaceList(cast, [llList2Integer(cast, -1)-1], -1, -1), 0, 2);
        if(llList2Integer(cast, -1) <= 0) // Ground is gone, we must have just walked off a ledge, so check rail-wise under us to hit the ledge face.
        {
            smooth = TRUE;
            cast = llCastRay(pos + (rot2up*-0.275) + (movementOffset*0.275), pos + (rot2up*-0.275) + (movementOffset*-0.275), [RC_REJECT_TYPES, RC_REJECT_PHYSICAL, RC_DATA_FLAGS, RC_GET_NORMAL, RC_MAX_HITS, 2]);
        }
        if(llList2Key(cast, 0) == llGetOwner()) cast = llDeleteSubList(llListReplaceList(cast, [llList2Integer(cast, -1)-1], -1, -1), 0, 2);
        if(llList2Integer(cast, -1) <= 0) // There's no ledge face either? Do a big cast down to see if we hit something.
        {
            smooth = FALSE;
            cast = llCastRay(pos, pos+<0,0,-30>, [RC_REJECT_TYPES, RC_REJECT_PHYSICAL, RC_DATA_FLAGS, RC_GET_NORMAL, RC_MAX_HITS, 2]);
        }
        if(llList2Key(cast, 0) == llGetOwner()) cast = llDeleteSubList(llListReplaceList(cast, [llList2Integer(cast, -1)-1], -1, -1), 0, 2);
        if(llList2Integer(cast, -1) > 0)
        {
            integer i;
            vector normal = llList2Vector(cast, i+2);  
            rot *= llRotBetween(rot2up, normal);
            if(smooth) jumpHeight = 0;
            pos = llList2Vector(cast, i+1) + normal*(0.25+jumpHeight);      
            if(left) rot = llEuler2Rot(<0,0,TURN_SPEED>) * rot;
            if(right) rot = llEuler2Rot(<0,0,-TURN_SPEED>) * rot;      
            pos += llVecNorm(movementOffset)*MOVE_SPEED*boost;
            if(llVecDist(llGetPos(), pos) < 10.0)
            if(smooth) smoothRotate(llGetRot(), rot, llGetPos(), pos, 300);
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POSITION, pos, PRIM_ROTATION, rot]);
        }   
        else // ... There was nothing when we casted from below either! We're lost. Continue acceleration due gravity and fall. We're bound to hit something eventually.
        {
            if(!notJumping)
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_POSITION, llGetPos() + <0,0,jumpSpeed>*rot]);
        }
    }
    
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llTakeControls(CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_DOWN|CONTROL_UP, TRUE, FALSE);
            llStopAnimation("sit");
            llStartAnimation(STAND_ANIM);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        rot = llGetRot();
        rot2fwd = llRot2Fwd(rot);
        rot2left = llRot2Left(rot);
        rot2up = llRot2Up(rot);
        integer info = llGetAgentInfo(llAvatarOnSitTarget());
        boost = 1.0;
        integer run; // simple test to see if we should run or not.
        movementOffset = <0,0,0>;
        if(info & AGENT_MOUSELOOK)
        {
            vector eul = llRot2Euler(llGetCameraRot() / llGetRot());
            rotation face = llEuler2Rot(<0,0,eul.z>);
            llSetLinkPrimitiveParamsFast(2, [PRIM_ROT_LOCAL, face]);
            if(CONTROL_FWD & level)
            {
                run++;
                movementOffset += llRot2Fwd(face * llGetRot());
            }
            if(CONTROL_BACK & level)
            {
                run++;
                movementOffset -= llRot2Fwd(face * llGetRot());
            }
            if(CONTROL_LEFT & level)
            {
                movementOffset += llRot2Left(face * llGetRot());
            }
            if(CONTROL_RIGHT & level)
            {
                movementOffset -= llRot2Left(face * llGetRot());
            }
            if(run == 2)
            {
                if(notJumping)
                llStartAnimation(RUN_ANIM);
                movementOffset += llRot2Fwd(face * llGetRot());
                boost = 2.5;
            }
            else if(notJumping)
            {
                llStartAnimation(WALK_ANIM);
            }
        }
        else
        {
            llSetLinkPrimitiveParamsFast(2, [PRIM_ROT_LOCAL, ZERO_ROTATION]);
            if(CONTROL_FWD & level)
            {
                run++;
                movementOffset += rot2fwd;
            }
            if(CONTROL_BACK & level)
            {
                run++;
                movementOffset -= rot2fwd;
            }
            if(CONTROL_LEFT & level) movementOffset += rot2left;
            if(CONTROL_RIGHT & level) movementOffset -= rot2left;
            if(run == 2)
            {
                if(notJumping)
                llStartAnimation(RUN_ANIM);
                movementOffset += rot2fwd;
                boost = RUN_BOOST;
            }
            else if(notJumping) llStartAnimation(WALK_ANIM);
        }     
        if(movementOffset == ZERO_VECTOR)
        {
            if(notJumping) llStartAnimation(STAND_ANIM);
            llStopAnimation(WALK_ANIM);
            llStopAnimation(RUN_ANIM);
        }
        if(CONTROL_FWD & ~level && CONTROL_BACK & ~level && CONTROL_LEFT & ~level && CONTROL_RIGHT & ~level)
        {
            llStopAnimation(WALK_ANIM);
            llStopAnimation(RUN_ANIM);
        }      
        if(CONTROL_ROT_LEFT & level)
        {
            left = TRUE;
        }
        else
        {
            left = FALSE;
        }
        if(CONTROL_ROT_RIGHT & level)
        {
            right = TRUE;
        }
        else
        {
            right = FALSE;
        }
        if(CONTROL_UP & level & edge)
        {
            if(notJumping)
            {
                notJumping = FALSE;
                llStartAnimation("jump");
                llStopAnimation(WALK_ANIM);
                llStopAnimation(RUN_ANIM);
                llStopAnimation(STAND_ANIM);
                jumpSpeed = JUMP_FORCE;
            }
        }
    }
}
//EOF