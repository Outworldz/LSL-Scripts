// :CATEGORY:Weapons
// :NAME:saber_script_v2
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:717
// :NUM:982
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// saber script v2.lsl
// :CODE:

//END-USER LICENSE AGREEMENT

//I. Terms and Conditions:
//Per the terms and conditions under the GNU General Public License, you may:

//1) Freely modify the source code of this script, so long as those modifications are properly documented within the body of the source code up to and including derivative works based upon this script under the understanding that such works fall under the GPL license. Stand-alone works (animations, sounds, textures, prims, or precompiled modules) designed to operate in conjunction with this script do not fall under this agreement and are not subject to the GPL.

//2) Freely distribute this script to any third party as deemed appropriate for public or private use so long as this notice and a copy of the GNU GPL are included.

//Per the agreement, you may NOT:

//1) Sell modified versions of this script without the express written permission of the original author unless the derivative work uses less than 20% of the original source code.


//II. Warranty Information
//This product comes "as-is" with no express or implied warranty. You may not hold the original author or any authors of derived work accountable for damages associated with the use or modification of this script unless those authors provide a statement of warranty in writing.

//III. Retroactive License.
///The terms and conditions of this script, upon entering into public domain, affect all prior versions of this script that carry the same name. All previous versions of this script, whether written by the original author or others who claim association with said author, now fall under the jurisdiction of the GPL and are subject to the terms and conditions contained therein.

//Please refer to the included GNU GPL license notecard for additional information.

/////////////////////////////////////////////////////////////////////////////////////////////////////////
integer saberOn = FALSE;
vector saberColor;

string style;
float version = 1.5;

//integer atk = FALSE;

integer dmg;
integer dmgMult;
integer atk = FALSE;

float pushPower;
string mode;

integer damagestatus = FALSE;
integer defense = FALSE;

integer BLUR = TRUE;

default
{
    on_rez(integer params)
    {
        llStopSound();
        integer atk = FALSE;
        dmg = 0;
        saberOn = FALSE;
        damagestatus = FALSE;
        defense = FALSE;
        
       
    }
    state_entry()
    {
        style = "basic";
        mode = "normal";
        llListen(72,"","","");
        
    }

    attach(key attached)
    {
        if(attached == llGetOwner())
        {
            llListen(0,"",llGetOwner(),"");
            llSetStatus(STATUS_BLOCK_GRAB,TRUE);
           // atk = FALSE;
            //llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
        llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);

        }
    }
    run_time_permissions(integer perms)
    {
        if(perms & PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
        }
    }
        
    listen( integer channel, string name, key id, string msg )
    {
        if(llGetOwnerKey(id) == llGetOwner())
        {
            if(llToLower(msg) == "/ls on")
            {
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                saberOn = TRUE;
                llTriggerSound("ignite",1);
                llLoopSound("hum",1);
                llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
                llTakeControls(CONTROL_ML_LBUTTON | CONTROL_LBUTTON | CONTROL_UP | CONTROL_FWD | CONTROL_BACK | CONTROL_ROT_LEFT | CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_RIGHT | CONTROL_DOWN, TRUE, TRUE);
                llStartAnimation(style + "_ready");           
            }
            else if(llToLower(msg) == "/ls off")
            {
                llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                saberOn = FALSE;
                llTriggerSound("powerdown",1);
                llStopSound();
                llReleaseControls();
                llStopAnimation(style + "_ready");
            }
            else if(llToLower(msg) == "/ls anim off")
            {
                llReleaseControls();
                llStopAnimation(style + "_ready");
                //llWhisper(0,"Animations off.");
            }
            else if(llToLower(msg) == "/ls anim on")
            {
                if(saberOn == TRUE)
                {
                llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
            
                llStartAnimation(style + "_ready");
                //llWhisper(0,"Animations on.");
                }
            }
            else if(llToLower(msg) == "/ls hide cal")
            {
                llMessageLinked(LINK_SET,0,"HIDE CAL",NULL_KEY);
            }
            else if(llToLower(msg) == "/ls show cal")
            {
                llMessageLinked(LINK_SET,0,"SHOW CAL",NULL_KEY);
            }            
            else if(llToLower(llGetSubString(msg,0,8)) == "/ls color")
            {
                saberColor = (vector)llGetSubString(msg,10,-1);
            
                //saberColor /= 255;
                //llSay(0,(string)saberColor);
                llMessageLinked(LINK_SET,0,"COLOR " + (string)saberColor,NULL_KEY);
                //llSay(0,"Color set");
            }
            else if(llToLower(llGetSubString(msg,0,8)) == "/ls style")
            {
                llStopAnimation(style + "_ready");
                style = llGetSubString(msg,10,-1);
                //llSay(0,"Style set to: " + style + ".");
                llStartAnimation(style + "_ready");
            }
            else if(llToLower(msg) == "/ls mode low")
            {
                defense = FALSE;
                //llSay(0,"Practice Mode.");
                dmgMult = 0;
                pushPower = 0;
            }
            else if(llToLower(msg) == "/ls mode normal")
            {
                defense = FALSE;
                //llSay(0,"Normal Mode");
                dmgMult = 1;
                pushPower = 1000;
            }
            else if(llToLower(msg) == "/ls mode high")
            {
                defense = FALSE;
                //llSay(0,"High Combat Mode");
                dmgMult = 2;
                pushPower = 7500000;
            }
            else if(llToLower(msg) == "/ls mode 1hitkill")
            {
                //llSay(0,"1-Hit Kill Mode");
                dmgMult = 100;
                pushPower = 15000000;
            }
            else if(llToLower(msg) == "/ls mode defense")
            {
                //llSay(0,"Defensive Mode.");
                defense = TRUE;
                dmgMult = 0;
                pushPower = 1;
            }
            else if(llToLower(msg) == "/ls dmg on")
            {
                //llSay(0,"Damage on. Push off.");
                damagestatus = TRUE;
            }
            else if(llToLower(msg) == "/ls dmg off")
            {
                //llSay(0,"Damage off, Push on.");
                damagestatus = FALSE;
            }
            else if(llToLower(msg) == "/ls blur off")
            {
                BLUR = FALSE;
                llOwnerSay("Motion blur off.");
            }
            else if(llToLower(msg) == "/ls blur on")
            {
                BLUR = TRUE;
                llOwnerSay("Motion blur on.");
            }

        }
    }
    control(key id,integer held,integer change)
    {
        if(held & CONTROL_LBUTTON || held & CONTROL_ML_LBUTTON)
        {
            llStopAnimation(style + "_ready");
            llStartAnimation(style + "_enguard");
            if((change & held & CONTROL_ROT_LEFT) | (change & ~held & CONTROL_LEFT))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                llStopAnimation(style + "_enguard");
                llTriggerSound("SND_" + style + "_sleft",2);
                llStartAnimation(style + "_sleft");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY); 
            }
            if((change & held & CONTROL_ROT_RIGHT) | (change & ~held & CONTROL_RIGHT))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                llStopAnimation(style + "_enguard");
                llTriggerSound("SND_" + style + "_sright",2);
                llStartAnimation(style + "_sright");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
            }
            if(change & held & CONTROL_FWD)
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"X_BLUR",NULL_KEY);
                }
                llStopAnimation(style + "_enguard");
                llTriggerSound("SND_" + style + "_sup",2);
                llStartAnimation(style + "_sup");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
            }
            if(change & held & CONTROL_BACK)
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                llStopAnimation(style + "_enguard");
                llTriggerSound("SND_" + style + "_sdown",2);;
                llStartAnimation(style + "_sdown");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
            }
            if((change & ~held & CONTROL_BACK) && (change & ~held & CONTROL_FWD))
            {
                llStopAnimation(style + "_enguard");
                //llApplyImpulse(llGetMass() * <7,0,0>,TRUE);
                llTriggerSound("SND_" + style + "_strong2",2);
                llStartAnimation(style + "_strong2");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 8 * dmgMult;
            }
            if((change & ~held & CONTROL_FWD) && ((change & ~held & CONTROL_LEFT) || (change & ~held & CONTROL_ROT_LEFT)))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                llStopAnimation(style + "_enguard");
                //llApplyImpulse(llGetMass() * <0,0,3.5>,TRUE);
                llTriggerSound("SND_" + style + "_strong3",2);
                llStartAnimation(style + "_strong3");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 10 * dmgMult;
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
            }
            if((change & ~held & CONTROL_FWD) && ((change & ~held & CONTROL_RIGHT) || (change & ~held & CONTROL_ROT_RIGHT)))
            {
                
                if(BLUR == TRUE)
                {
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"X_BLUR",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"OFF",NULL_KEY);
                    llMessageLinked(LINK_SET,0,"Y_BLUR",NULL_KEY);
                }
                llStopAnimation(style + "_enguard");
                llTriggerSound("SND_" + style + "_strong1",2);
                llStartAnimation(style + "_strong1");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 10 * dmgMult;
                llMessageLinked(LINK_SET,0,"ON",NULL_KEY);
                llMessageLinked(LINK_SET,0,"HIDE BLUR",NULL_KEY);
            }
            if(((change & ~held & CONTROL_LEFT) || (change & ~held & CONTROL_ROT_LEFT)) && ((change & ~held & CONTROL_RIGHT) || (change & ~held & CONTROL_ROT_RIGHT)))
            {
                llStopAnimation(style + "_enguard");
                llTriggerSound("SND_" + style + "_power",2);
                llStartAnimation(style + "_power");
                atk = TRUE;
                llSetTimerEvent(0.25);
                dmg = 12 * dmgMult;
            }
            llSetDamage(dmg);
        }
        else if(~held & CONTROL_LBUTTON || ~held & CONTROL_ML_LBUTTON)
        {
            llStopAnimation(style + "_enguard");
            llStartAnimation(style + "_ready");
            llSetDamage(0);
        }

    }
    timer()
    {
        if(defense == TRUE)
        {
            llMoveToTarget(llGetPos(),0.2);
            llRezObject("defender",llGetPos(),<0,0,0>,ZERO_ROTATION,0);
            llSetTimerEvent(0);
            atk = FALSE;
            llStopMoveToTarget();
        }
        else
        {
            llSensor("","",AGENT | ACTIVE,4.0,PI_BY_TWO);
            atk = FALSE;
        }

    }
    sensor(integer num)
    {
        if(saberOn == TRUE)
        {
            if(num != 0)
            {
                float distance = llVecDist(llGetPos(),llDetectedPos(0));
                //llSay(0,(string)distance);
                float mass = llGetObjectMass(llDetectedKey(0)); 
                if(distance < 1.0)
                {
                    distance = 1.0;
                }
                
                float mod = llPow(distance,3.0) + mass;
                //llSay(0,(string)mod);
                key target = llDetectedKey(0);
                llTriggerSound("hit",2);
                if(damagestatus == TRUE)
                {
                    llRezObject("saber damager",llDetectedPos(0),<0,0,0>,ZERO_ROTATION,dmg);
                }
                else
                {
                    llPushObject(target,<-pushPower,0,pushPower> * mod ,ZERO_VECTOR,TRUE);
                }
                llSetTimerEvent(0);
            }
        }
        else
        {
        }
    }
    no_sensor()
    {
        llSetTimerEvent(0);
    }

}// END //
