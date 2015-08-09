// :CATEGORY:Flight Assist
// :NAME:Cyberflight_1_1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:207
// :NUM:281
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cyberflight 1.0 1.lsl
// :CODE:

// This Script is distributed under the terms of the modified BSD license, reproduced at the end of
// the script. The license and acknowledgments listed must be included in some fashion if this script
// is redistributed in a non-readable or non-modifiable form.

// Cyberflight (gentle flight boost)

float last_alt;
float last_time;
float last_move;
float boost;
integer controls;

float MIN_SPEED = 2.0;
float WANT_SPEED = 20.0;
float MAX_SPEED = 25.0;
float MIN_TIME = 1.0;
float DEFAULT_BOOST = 0.5;

float FAST_TICK = 0.1;
float SLOW_TICK = 1.0;
float LONG_TIME = 5.0; // reset boost if no work in a long time

float MIN_BOOST_HEIGHT = 72.0;
float MIN_BOOST_CLEARANCE = 36.0;

integer flying = -1;
integer falling = -1;
integer hovering = -1;
integer dimmed = -1;

integer HUD_OFF = 0;
integer HUD_ALWAYS = -1;
integer HUD_ON = 1;
integer hud_state = 1; // default HUD_ON

string last_hud_text;
integer hud_active = 0;
float last_hud_time = 0; 
show_hud()
{
    if(hud_state == HUD_ALWAYS)
        hud_active = 1;
    else if(hud_state == HUD_ON)
    {
        if(hud_active >= 0 && flying == 0 && hovering == 0 && falling == 0) hud_active = 0;
        else if(hud_active <= 0 && (flying > 0 || hovering > 0 || falling > 0)) hud_active = 1;
    }
    else if(hud_active == 1)
        hud_active = 0;

    if(hud_active == 1) {
        float time = llGetTime();
        if(last_hud_time > time - 1) return;
        vector v = llGetVel();
        vector p = llGetPos();
        string hover_text = "";
        if(hovering && controls == 0)
            hover_text = " (hover)";
        string boost_text = "Standby";
        if(!hovering)
            boost_text = "Passive";
        if(falling)
            boost_text = "Inactive";
        if(boost > 0 && controls > 0)
            boost_text = "Boost "+((string)llFloor(boost * 100.0 / 6.0 + 0.5))+"%";
        string hud_text = "";
        if(hud_state == HUD_ALWAYS)
            hud_text = "\nHUD locked";

        string t =
            "<"+((string)llFloor(p.x+0.5))+","+((string)llFloor(p.y+0.5))+","+((string)llFloor(p.z+0.5))+">"+
            " ("+((string)(llFloor(p.z-llGround(<0,0,0>)+0.5)))+"m AGL)\n"+
            "<"+((string)llFloor(v.x+0.5))+","+((string)llFloor(v.y+0.5))+","+((string)llFloor(v.z+0.5))+">"+
            " ("+((string)llFloor(llVecMag(v)))+"m/s)\n"+
              boost_text+hover_text+hud_text;
        if(last_hud_text != t) {
            vector color = <1,1,1>;
            if(hud_state == HUD_ALWAYS)
                color = <.3,1,.3>;
            llSetText(t, color, 1);
            last_hud_text = t;
            last_hud_time = time;
        }
    } else if(hud_active == 0) {
        last_hud_text = "";
        last_hud_time = 0;
        llSetText("", ZERO_VECTOR, 0);
        hud_active = -1;            
    }
}

set_hover(integer active)
{
    if(active == hovering) return;
    hovering = active;
    if(hovering)
        llSetForce(<0,0,9.8> * llGetMass(), FALSE);
    else
        llSetForce(<0,0,0>, FALSE);
}

float last_tick = -1;
set_tick(float tick)
{
    if(tick == last_tick) return;
    last_tick = tick;
    llSetTimerEvent(tick);
}

float last_boost_height;
float average_boost;
check_boost()
{
    flying = 1;
    falling = 0;

    integer info = llGetAgentInfo(llGetOwner());

    if((info & AGENT_FLYING) == 0)
    {
        set_hover(FALSE);
        falling = (info & AGENT_IN_AIR) != 0;
        flying = 0;
        boost = 0;
        set_tick(SLOW_TICK);
        return;
    }

    vector pos = llGetPos();
    if(pos.z < last_boost_height / 2) // trim running average of boost if big altitude drop
        average_boost = average_boost * (pos.z / last_boost_height)
                      + DEFAULT_BOOST * (1.0 - pos.z / last_boost_height);

    if(pos.z < MIN_BOOST_HEIGHT || pos.z - llGround(<0,0,0>) < MIN_BOOST_CLEARANCE)
    {
        set_hover(FALSE);
        set_tick(SLOW_TICK);
        boost = 0;
        return;
    }

    set_hover(TRUE);
    
    if(controls <= 0) return;

    vector vel = llGetVel();
    float time = llGetTime();
    float speed = vel.z;
    float target = WANT_SPEED;
    float window = WANT_SPEED / 20;
    
    if(speed > 0)
        last_move = time;

    if(time - last_time >= LONG_TIME)
        boost = 0;
    else
    {
        if(speed < target - window)
        {
            if(boost == 0)
                boost = average_boost;
            if(time - last_move > MIN_TIME) boost += 0.4;
            else if(speed < target * 0.25) boost += 0.2;
            else if(speed < target * 0.5 ) boost += 0.1;
            else if(speed < target * 0.75) boost += 0.05;
            else if(speed < target - window * 4) boost += 0.02;
            else boost += 0.01;
        }
        else if(speed > MAX_SPEED) boost -= 0.5;
        else if(speed > target + window * 4) boost -= 0.1;
        else if(speed > target + window * 2) boost -= 0.03;
        else if(speed > target + window) boost -= 0.01;

        if(boost <= 0)
            boost = 0;
        if(boost > 0) {
            llApplyImpulse(<0,0,boost> * llGetMass(), FALSE);
            average_boost = average_boost * 0.9 + boost * 0.1; // 10 sample running average
            last_boost_height = pos.z;
        }
    }
    
    if(boost) set_tick(FAST_TICK);
    else set_tick(SLOW_TICK);
    last_alt = pos.z;
    last_time = time;
}

take_controls()
{
    llTakeControls(CONTROL_UP|CONTROL_DOWN,TRUE,TRUE);
}

request_perms()
{
    if(llGetPermissions() & PERMISSION_TAKE_CONTROLS)
        take_controls();
    else
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
}

init()
{
    boost = 0;
    
    flying = -1;
    falling = -1;
    hovering = -1;
    dimmed = -1;
    hud_state = HUD_ON;

    set_tick(SLOW_TICK);
    if(llGetAttached()) request_perms();
}

default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer param)
    {
        init();
    }

    run_time_permissions(integer mask)
    {
        if(mask & PERMISSION_TAKE_CONTROLS) take_controls();
    }
    
    control(key id, integer level, integer edge)
    {
        controls = 0;
        if(level & CONTROL_UP) controls++;
        if(level & CONTROL_DOWN) controls--;
        check_boost();
    }
    
    timer()
    {
        check_boost();
        show_hud();
        if(flying && boost > 0)
        {
            if(dimmed != 0)
                llSetAlpha(1.0,ALL_SIDES);
            dimmed = 0;
        }
        else
        {
            integer dimness = 4;
            if(hud_state == HUD_ON) dimness = 5;
            else if(hud_state == HUD_ALWAYS) dimness = 6;
            if(dimmed != dimness) {
                float alpha = ((float)dimness) / 10;
                llSetAlpha(alpha,ALL_SIDES);
            }
            dimmed = dimness;
        }
    }
    
    touch_start(integer num)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            hud_state++;
            if(hud_state > 1)
                hud_state = -1;
        }
    }
}


//Copyright (c) 2005, Argent Stonecutter & player
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//    * Redistributions in modifiable form must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in non-modifiable form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Argent Stonecutter nor his player may be used to endorse or promote products derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// END //
