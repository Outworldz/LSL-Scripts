// :CATEGORY:Animation
// :NAME:Walking_Script
// :AUTHOR:Zepp Zaftig
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:961
// :NUM:1383
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Walking Script.lsl
// :CODE:

//Copyright 2006 Zepp Zaftig - GNU Lesser General Public License http://www.gnu.org/copyleft/lesser.html 
//This script or any modified versions of it may not be distributed without source code. 

//Settings 
//Edit these to configure the script 
string WALKANIM = "female_walk";    //Name of the walk animation to use 
string FLYANIM = "fly";             //Flying animation 
string HOVERANIM = "hover";         //Hover animation 
string UPANIM = "hover_up";         //Flying up animation 
string DOWNANIM = "hover_down";     //Flying down animation 
integer WALKSPEED = 1;            //Change to an integer higher than 1 to walk faster 
integer FLYSPEED = 10;              //How many times faster the flying speed should be compared to default speed 
integer PHANTOM = TRUE;             //Set to TRUE for walking through solid objects, FALSE to disable 
integer TOUCHABLE = TRUE;           //Rotate 90 degrees on touch when set to TRUE 
//End settings 

float zoffset; 
integer flying = FALSE; 

default { 
    state_entry() { 
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, FALSE); 
        llCollisionFilter(llKey2Name(llGetOwner()), llGetOwner(), FALSE); 
        vector avatarsize = llGetAgentSize(llGetOwner()); 
        zoffset = avatarsize.z / 1.3; 
        llSitTarget(<0, 0, -0.5>, ZERO_ROTATION); 
        llCollisionSound("", 0); 
    } 

    changed(integer change) { 
        if(change & CHANGED_LINK) { 
            key agent = llAvatarOnSitTarget(); 
            if(agent) { 
                if(agent != llGetOwner()) { 
                    llUnSit(agent); 
                } else { 
                    llSetAlpha(0, ALL_SIDES); 
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS); 
                } 
            } else { 
                llSetAlpha(1, ALL_SIDES); 
                llSetStatus(STATUS_PHYSICS, FALSE); 
                llReleaseControls(); 
                llResetScript(); 
            } 
        } 
    } 

    run_time_permissions(integer perm) { 
        if(perm) { 
            llStopAnimation("sit"); 
            llStartAnimation("stand");             
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_UP | CONTROL_DOWN | 
                CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE); 
        } 
    } 
     
    control(key id, integer level, integer edge) { 
        //Any button pressed 
        if(edge & level) { 
            llSetStatus(STATUS_PHYSICS, TRUE); 
            llStopAnimation(HOVERANIM); 
        } 
         
        //Forward or backwards pressed 
        if(edge & level & (CONTROL_FWD|CONTROL_BACK)) { 
            if(flying == TRUE) { 
                llStartAnimation(FLYANIM); 
            } else { 
                llStartAnimation(WALKANIM); //Start the walk animation 
            } 
        } 
        //All buttons released 
        if((~level & CONTROL_FWD) && (~level & CONTROL_BACK) && (~level & CONTROL_RIGHT) && 
                (~level & CONTROL_LEFT) && (~level & CONTROL_ROT_RIGHT) && (~level & CONTROL_ROT_LEFT) 
                && (~level & CONTROL_UP) && (~level & CONTROL_DOWN) ) { 
                     
            llTargetOmega(<0,0,0>, 0, 1);             
            llSetStatus(STATUS_PHYSICS, FALSE); 
             
            llSetPos(llGetPos()); //Workaround for weird prim movement behavior 
            llSetRot(llGetRot()); 
             
            llStopAnimation(WALKANIM); 
            llStopAnimation(UPANIM); 
            llStopAnimation(DOWNANIM); 
            llStopAnimation(FLYANIM); 
            if(flying == TRUE) { 
                llStartAnimation(HOVERANIM); 
            } else { 
                llStartAnimation("stand"); 
            } 
        } 
        //Turning key released 
        if((~level & edge & CONTROL_RIGHT) || (~level & edge & CONTROL_LEFT) || 
                (~level & edge & CONTROL_ROT_RIGHT) || (~level & edge & CONTROL_ROT_LEFT)) { 
            llTargetOmega(<0,0,1>, 0, 1); 
            llTargetOmega(<0,0,-1>, 0, 1);         
        } 
        //Turn right 
        if(level & edge & (CONTROL_RIGHT|CONTROL_ROT_RIGHT)) { 
            llTargetOmega(<0,0,-1>, PI / 3.5, 1);      
        //Turn left        
        } else if(level & edge & (CONTROL_LEFT|CONTROL_ROT_LEFT)) { 
            llTargetOmega(<0,0,1>, PI / 3.5, 1); 
        } 
        //Forward 
        if(level & CONTROL_FWD) { 
           vector pos; 
            if(flying == FALSE) { 
                pos   = llGetPos() + WALKSPEED*llRot2Fwd(llGetRot()); 
                pos.z = zoffset + llGround(ZERO_VECTOR); 
            } else { 
                pos = llGetPos() + FLYSPEED*llRot2Fwd(llGetRot()); 
            } 
            llMoveToTarget(pos, 0.1);             
        //Backwards 
        } else if(level & CONTROL_BACK) { 
            vector pos; 
            if(flying == FALSE) { 
                pos   = llGetPos() - WALKSPEED*llRot2Fwd(llGetRot()); 
                pos.z = zoffset + llGround(ZERO_VECTOR); 
            } else { 
                pos   = llGetPos() - FLYSPEED*llRot2Fwd(llGetRot()); 
            } 
            llMoveToTarget(pos, 0.1);          
        } 
        //Flying 
        if(level & CONTROL_UP) { 
            flying = TRUE; 
            llStartAnimation(UPANIM); 
            llMoveToTarget(llGetPos() + <0,0,3.5>, 0.1); 
        } else if(level & CONTROL_DOWN) { 
            llStartAnimation(DOWNANIM); 
            vector pos = llGetPos(); 
            if( (pos.z - llGround(ZERO_VECTOR)) < 2.5 ) { 
                flying = FALSE; 
            } 
            llMoveToTarget(llGetPos() - <0,0,3.5>, 0.1); 
        } 
    } 
     
    //Move through solid objects 
    collision(integer det_num) { 
        if(PHANTOM == TRUE) { 
            llSetStatus(STATUS_PHYSICS, FALSE); 
            llSetPos(llGetPos() + llRot2Fwd(llGetRot())); 
            llSetStatus(STATUS_PHYSICS, TRUE); 
        } 
    }    
     
    touch_start(integer det_num) { 
        if(TOUCHABLE == TRUE) { 
            llSetRot(llGetRot() * llEuler2Rot(<90*DEG_TO_RAD,0,0>)); 
        }       
    } 
} 
// END //
