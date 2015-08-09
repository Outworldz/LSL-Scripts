// :CATEGORY:AO
// :NAME:KDC_smallest_Animation_overrider
// :AUTHOR:Kyrah Abbatoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:416
// :NUM:572
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// KDC smallest Animation overrider by Kyrah Abattoir.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







// KDC's shortest Aniamtion overrider in SL
//OKOK i wrote this little script in the hope of less clunky server eating animation overriders that are widely used in sl, this AO is as small as i have been able to do it, and as you can see it is also using very few instructions.
//by the way the pulse speed do not affect the time between the animation change




// KDC's shortest Aniamtion overrider in SL
// Copyright (C) 2005 Kyrah Abattoir
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

//there we go...
float pulse = 0.01;//the time between each check, adjust it to your liking
//bigger == slower == low resources

//if a state isnt in the list its just ignored, you can add new overriding states here
list states = ["Standing","Walking","Hovering","Crouching","Hovering","Jumping","PreJumping","Running","Sitting","Sitting on Ground",
"Flying","FlyingSlow","Falling Down","Soft Landing","CrouchWalking"];

//list of ther anims yo will use instead if the value == pass on, we let the anim play. One anim per state
list anims = ["ballet stand","ballet walk 2","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots","ballet foots"];
//ok this is filled with MY animations of course you will change it to yours if you want it to work, right?

string anim_overrided= "";
string curr_anim= "";
default
{
    attach(key id)
    {
        if(id == NULL_KEY && curr_anim != "")//IF detached and an animation is running
            llStopAnimation(curr_anim);//stop the anim
        else
            llResetScript();
    }
    state_entry()
    {
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);//we ask for permissions
    }
    run_time_permissions(integer perms)
    {
        llSetTimerEvent(pulse);//we set the main pulse
    }
    timer()
    {
        string anim_state = llGetAnimation(llGetPermissionsKey());
        if(anim_state == "Turning Left" || anim_state == "Turning Right")//this is a little HACK to remove the turn left and right
            anim_state = "Standing";
        integer anim_index = llListFindList(states,[anim_state]);
        if((anim_index != -1) && (anim_overrided != anim_state))//IF we havent specified this anim must be ignored
        {
            anim_overrided = anim_state;
            //llSetText("",<1,1,1>,1.0);//DEBUG displaying the state
            if(llList2String(anims,anim_index) == "PASS_ON")
            {
                if(curr_anim != "")
                    llStopAnimation(curr_anim);
                curr_anim = "";
            }
            else
            {
                string stop_anim = curr_anim;
                curr_anim = llList2String(anims,anim_index);
                if(stop_anim != "")
                    llStopAnimation(stop_anim);
                if(curr_anim != stop_anim)//if its the same anim we already play no need to change it
                    llStartAnimation(curr_anim);
                if(anim_state == "Walking")//another lil hack so the av turn itself 180 when walking backward
                    llStopAnimation("walk");//comment these 2 lines if you have a real backward animation
            }
        }
    }
} // END //
