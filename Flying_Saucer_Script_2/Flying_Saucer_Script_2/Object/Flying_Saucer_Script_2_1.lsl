// :CATEGORY:Vehicles
// :NAME:Flying_Saucer_Script_2
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:328
// :NUM:441
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Flying Saucer Script 2.lsl
// :CODE:

float LINEAR_TAU = 0.75;             
float TARGET_INCREMENT = 0.5;
float ANGULAR_TAU = 1.5;
float ANGULAR_DAMPING = 0.85;
float THETA_INCREMENT = 10;// 0.3 
integer LEVELS = 0;
vector pos;
vector face;
float brake = 0.5;
key gOwnerKey; 
string gOwnerName;
key gToucher;
key Driver;
string Name1 = "Mark Coffee"; 
string Name2 = "Mom's Paintings"; 
string gFLYING = "FALSE";
string sound="hum.wav";
key id;
integer nudge = FALSE;
vector POSITION; 
integer auto=FALSE;
integer CHANNEL = 6;

help()
{
    llWhisper(0,"Commands:");
    llWhisper(0,"Left click craft = Start ");
    llWhisper(0,"Left click craft = Stop and release contol");
    llWhisper(0,"/" + (string)CHANNEL + " 1! through" + " /" + (string)CHANNEL + " 9!," + " /" + (string)CHANNEL + " slow or" + " /" + (string)CHANNEL + " warp = Set power");
    llWhisper(0,"/" + (string)CHANNEL + " ask! = Craft asks permission for your control. (Only when outside craft)");
    llWhisper(0,"/" + (string)CHANNEL + " menu = Display this list");
    llWhisper(0,"PgUp or PgDn = Gain or lose altitude");
    llWhisper(0,"Arrow keys = Left, right, Forwards and Back");
    llWhisper(0,"Shift + Left or Right arrow = Rotate but maintain view");
    llWhisper(0,"PgUp + PgDn or combination similar = Set cruise on or off");
}

default
{
    state_entry()
    {

        gOwnerKey = llGetOwner();
        gOwnerName = llKey2Name(llGetOwner());
        llSoundPreload(sound);
        llStopSound();
        llLoopSoundMaster(sound, 0.0);
        llSetTimerEvent(0.0);
        llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", id);
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, TRUE);
        llSleep(0.1);
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y, FALSE); 
        llSetStatus(STATUS_PHYSICS, FALSE);
        llMoveToTarget(llGetPos(), 0);
        llRotLookAt(llGetRot(), 0, 0);
        llSetStatus(STATUS_PHYSICS, FALSE);
        LEVELS = CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_UP | CONTROL_DOWN | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ML_LBUTTON;

        TARGET_INCREMENT = 0.5;
        llSitTarget(<0.4, 0.0, 0.4>, ZERO_ROTATION); 
        llSetCameraEyeOffset(<-10.0, 0.0, 4.0>);
        llSetSitText("Pilot");
        llSetCameraAtOffset(<0, 0.0, 0>);
        llWhisper(0,"Deactivated ... Security conditions set. Type /" + (string)CHANNEL + " menu for a list of options.");
        
        //  this sets a Listen with no callback in this state...
        llListen(CHANNEL, "", "", "");

        state Listening;
    }
    
}

state Listening
{
    //  Here we set up the Listen that is used in the Listening state...
    state_entry()
    {
        llListen(CHANNEL, "", "", "");
    }
    
    // the rest was here before...
    //  This is the click callback
    touch_start(integer total_number)
    {
        if (llSameGroup(llDetectedKey(total_number - 1))==1 || llDetectedName(total_number - 1)==Name1 || llDetectedName(total_number - 1)==Name2)
        {
            if (gFLYING == "FALSE")
            {
                gFLYING = "TRUE";
                llStopSound();
                llLoopSoundMaster(sound, 95.0);
                llSetStatus(STATUS_PHYSICS, TRUE);
                llSetSitText("Ride");
                Driver=llDetectedKey(total_number - 1);
                state StateDriving;
            }
        }
        else
        {
            llWhisper(0,"You must own or belong to this group to fly craft.");
            llStopSound();
            llLoopSoundMaster(sound,0.0);
            llInstantMessage(gOwnerKey,llDetectedName(total_number - 1) + " is touching your craft");
        } 
    }  
    
    //  Here is the Listen callback
    listen(integer CHANNEL, string name, key id, string msg)
    {
        if (llSameGroup(id)==1)
        {
            if (llToLower(msg) == "menu")
            {
                help();        
            }
        }
    }
    
    //  and this is an on-rez callback
    on_rez(integer start_param)
    {
        llResetScript();
    } 
}

state StateDriving
{
    state_entry()
    {
        llWhisper(0, "All systems go !!");
        llRequestPermissions(Driver, PERMISSION_TAKE_CONTROLS);
        llMoveToTarget(llGetPos(), LINEAR_TAU);
        llRotLookAt(llGetRot(), ANGULAR_TAU, 1.0);
        
        //  Added listen here as well....  for same reason...
        llListen(CHANNEL, "", "", "");
    }
    
    touch_start(integer total_number)
    {
        if (llDetectedKey(total_number - 1)==Driver)
        {
            llWhisper(0,"You now have control.");
            gFLYING = "FALSE";
            auto=FALSE;
            llSleep(1.5);
            llStopSound();
            llLoopSoundMaster(sound, 0.0);
            llSetSitText("Pilot");
            llSetStatus(STATUS_PHYSICS, FALSE);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", id);
            llSetTimerEvent(0.0);
            llReleaseControls();
            llResetScript();
        }
    }
        
    listen(integer CHANNEL, string name, key id, string msg)
    {
        if (id==Driver)
        {
            if (llToLower(msg) == "ask!")
            {
                llReleaseControls();
                llRequestPermissions(Driver, PERMISSION_TAKE_CONTROLS);
            }
            if (llToLower(msg) == "menu")
            {
                help();
            }
            if (llToLower(msg) == "warp")
            {
                TARGET_INCREMENT = 10.0; 
                string TIspew = (string)TARGET_INCREMENT;
                TIspew = llGetSubString(TIspew,0,3);
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "slow")
            {
                TARGET_INCREMENT = 0.5;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "1!")
            {
                TARGET_INCREMENT = 0.75;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "2!")
            {
                TARGET_INCREMENT = 1.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "3!")
            {
                TARGET_INCREMENT = 1.5;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "4!")
            {
                TARGET_INCREMENT = 2.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "5!")
            {
                TARGET_INCREMENT = 3.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "6!")
            {
                TARGET_INCREMENT = 4.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "7!")
            {
                TARGET_INCREMENT = 5.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");  
            }
            if (llToLower(msg) == "8!")
            {
                TARGET_INCREMENT = 6.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");
            }
            if (llToLower(msg) == "9!")
            {
                TARGET_INCREMENT = 7.0;
                llWhisper(0,"Power: " + llGetSubString((string)(TARGET_INCREMENT * 10.0),0,3) + "%");                                                                         
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm == PERMISSION_TAKE_CONTROLS)
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "slow", id);
            llTakeControls(LEVELS, TRUE, FALSE);

        }
        else
        {
            llWhisper(0,"Stopped");
            llSetTimerEvent(0.0);
            gFLYING = "FALSE";
            llSleep(1.5);
            llResetScript();
        }
    }
    control(key driver, integer levels, integer edges)
    {
        pos *= brake;
        face.x *= brake;
        face.z *= brake;
        nudge = FALSE;
        llMessageLinked(LINK_ALL_CHILDREN, 0, "slow", id);
        if (levels & CONTROL_FWD)
        {
            if (pos.x < 0) { pos.x=0; }
            else { pos.x += TARGET_INCREMENT; }
            nudge = TRUE;
        }
        if (levels & CONTROL_BACK)
        {
            if (pos.x > 0) { pos.x=0; }
            else { pos.x -= TARGET_INCREMENT; }
            nudge = TRUE;
        }
        if (levels & CONTROL_UP)
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "fast", id);
            if(pos.z<0) { pos.z=0; }
            else { pos.z += TARGET_INCREMENT; }
            face.x=0;
            nudge = TRUE;
        }
        if (levels & CONTROL_DOWN)
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "fast", id);
            if(pos.z>0) { pos.z=0; }
            else { pos.z -= TARGET_INCREMENT; }
            face.x=0;
            nudge = TRUE;
        }
        if ((levels) & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            if (face.z < 0) { face.z=0; }
            else { face.z += THETA_INCREMENT; }
            nudge = TRUE;
        }
        if ((levels) & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            if (face.z > 0) { face.z=0; }
            else { face.z -= THETA_INCREMENT; }
            nudge = TRUE;
        }
        if ((levels & CONTROL_UP) && (levels & CONTROL_DOWN))
        {
            if (auto) 
            { 
                auto=FALSE;
                llWhisper(0,"Cruise off"); 
                llSetTimerEvent(0.0);
            }
            else 
            { 
                auto=TRUE; 
                llWhisper(0,"Cruise on");
                llSetTimerEvent(0.5);
            }
            llSleep(0.5); 
        }
        
        if (nudge)
        {
            vector world_target = pos * llGetRot(); 
            llMoveToTarget(llGetPos() + world_target, LINEAR_TAU);
    
            vector eul = face; 
            eul *= DEG_TO_RAD; 
            rotation quat = llEuler2Rot( eul ); 
            rotation rot = quat * llGetRot();
            llRotLookAt(rot, ANGULAR_TAU, ANGULAR_DAMPING);
        }
    }
    
    timer()
    {
        pos *= brake;
        if (pos.x < 0) { pos.x=0; }
        else { pos.x += TARGET_INCREMENT; }
        vector world_target = pos * llGetRot(); 
        llMoveToTarget(llGetPos() + world_target, LINEAR_TAU);
    }
    
}
// END //
