// :SHOW:
// :CATEGORY:Clothing
// :NAME:PrimSkirt Builder
// :AUTHOR:Dalien Talbot
// :KEYWORDS:
// :CREATED:2015-03-17 10:43:59
// :EDITED:2015-03-17  09:43:59
// :ID:1075
// :NUM:1739
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Prim Skirt Builder 
// :CODE:
// 
// Copyright (c) 2007 Dalien Talbot and few other folks thanks to whom this exists:
//
// Vint Falken, of course - the inspiration, pushing me to the idea, testing, and finding the software bugs :-) 
// LSL wiki - the function reference
// Posing stand code - unknown author 
// LoopRez v0.6, by Ged Larsen, 20 December 2006 - the math for placement of the skirt prims
// 
// This work is distributed "as-is" with no warranty whatsoever.
//
//
// It is distributed under GPL license. Please have a look at the "EULA" and the "GNU License" notecards in the inventory
// to get familiar with the terms and conditions.
//
// All the derivatives of this work obviously have to comply with the GPL as well. Contact me (Dalien Talbot) if you require alternative licensing.
//
//

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NOTE:
// Unless you know what you are doing, do NOT change anything below ! 
// 
// The standard consulting fees mentioned in the manual will apply for the works on fixing the breakages :-)
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



key mkLoungingAgentKey = NULL_KEY;
integer miPermissionsAcquired = FALSE;
vector vLoungeTarget = <0.00, 0.00, 1.50>;
vector myPos;

// prim constants
integer PRIM_FIRSTMISC = -10;

integer PRIM_CONTROL = -10;
integer PRIM_LINKCENTER = -11;
integer PRIM_GEOMETRY = -12;

// pseudo constant - this is the last misc prim number
integer PRIM_LASTMISC = -12;

////////////////////////////////////////////////////////////////////////////////
// CONFIGURATION PARAMETERS for the looprez, these will be changed by the gui editor elements

string objectName = "prim";            // object to use; will need to be in the inventory of the prim containing this script
integer numObjects = 12;                // how many objects
float xRadius = .05;                    // waist ellipse x-axis radius in meters
float yRadius = .07;                        // waist ellipse y-axis radius in meters
float flareAngle = 45.0;                // how many DEGREES the bottom of object will flare outwards, the "poof" factor
float bendCoefficient = 0.0;            // makes a "saddle shape", bends DOWN this number of meters at extremes of X-axis
vector rotOffset = <0.0, 180.0, 0.0>;     // rotation offset in DEGREES -- fixes the rotation of ALL objects; for flexi prims, often you will want <180.0, 0.0, 0.0>
vector posOffset = <0.0, 0.0, 1.0>;        // position offset

// channel to talk to the prims
integer commChannelBase = 0;


integer CHANNEL = 77; // dialog channel
list MENU_MAIN = ["More", "Less", "Rez...", "News..."]; // the main menu

// 0: default state, selecting the number of prims/allowing to rez
// 1: objects are rezzing
// 2: objects have rezzed, tweaking

integer script_state = 0; 

// iterator - runs while rezzing through the whole range, to make the process sequential
integer current_rez_prim_num = 0;

// string with all the init parameters that are same for all the prims
string init_string = "";

show_main_dialog()
{
    list menu = MENU_MAIN;
    if (script_state == 2) {
        menu = menu + [ "Wipe all...", "Link..." ];
    }
    llDialog(llGetOwner(), "Number of prims: " + (string)numObjects, menu, CHANNEL);
}

rez_one_prim()
{

    vector pos = llGetPos() + posOffset;
    // the master prim
    if (current_rez_prim_num == PRIM_CONTROL) {
        // control prim
        pos = pos + <0., 1.5, 0.5>;
    } else if (current_rez_prim_num == PRIM_LINKCENTER) {
        // linkage prim
    } else if (current_rez_prim_num == PRIM_GEOMETRY) {
        // radius/tilt control prim - on the right
        pos = pos + <0., -1.5, 0.5>;
    }
     
    llRezObject(objectName, pos, ZERO_VECTOR, ZERO_ROTATION, commChannelBase);
}


make_init_string()
{
    init_string = llDumpList2String([myPos, numObjects, xRadius, yRadius, flareAngle, bendCoefficient, rotOffset, posOffset], ":");
}

reposition_all()
{
    integer i;
    make_init_string();
    //for(i=0; i<numObjects; i++) {
    //    llSay(commChannelBase + 1 + i, "bulk:" + init_string);
    //}
    llSay(commChannelBase - 1, "bulk:" + init_string);
}

// tell something unicast to a rezzed prim on its channel
unicast(integer child, string message)
{
    llSay(commChannelBase + 1 + child, message);
}

// try to ping the prim, and set up the watchdog
check_or_rez_next_misc_prim()
{
    unicast(current_rez_prim_num, "echo");
    llSetTimerEvent(1);
}

// rez a next misc prim
make_next_misc_prim()
{
    current_rez_prim_num = current_rez_prim_num - 1;
    if (current_rez_prim_num >= PRIM_LASTMISC) {
        check_or_rez_next_misc_prim();
        
    } else {
        // done with rezzing all the prims
        llSetTimerEvent(0);
        llOwnerSay("Rezzed all " + (string)numObjects + " prims, please edit the prims on the left and right to edit the skirt, when done, click the stand and hit 'Link...'");
        script_state = 2;
        // ask the control prims to push their config - in case they were already there...
        llSay(commChannelBase - 1, "repost");
        // start sending the keepalives every minute, so the control prims do not die
        llSetTimerEvent(60);
        
    }
}

wipe_all() {
    llSay(commChannelBase - 1, "die");
    script_state = 0;
    llOwnerSay("Wiped all elements... touch the platform to get the menu again.");
}

// check the replies from the dialog
integer check_dialog_replies(string message)
{
    if (message == "More") {
        if (numObjects < 30) {
            numObjects = numObjects + 2;
        }
        show_main_dialog();
        return 1;
    } else if (message == "Less") {
        if (numObjects > 2) {
            numObjects = numObjects - 2;
        }
        show_main_dialog();
        return 1;
    } else if (message == "Rez...") {
        script_state = 1;
        myPos = llGetPos();
        // wipe all the skirt prims
        llSay(commChannelBase - 1, "die_skirt");
        llOwnerSay("Rezzing " + (string)numObjects + " prims...");
        llListen(commChannelBase, "", "", "");
        // start with the first prim - the rest will go in a loop
        current_rez_prim_num = 0;
        make_init_string();
        rez_one_prim();
        return 1;
    } else if (message == "Wipe all...") {
        wipe_all();
        llOwnerSay("Resetting the script...");
        llResetScript();
        return 1;
    } else if (message == "Link...") {
        unicast(PRIM_LINKCENTER, "link");
    } else if (message == "News...") {
        llLoadURL(llGetOwner(),"Prim skirt builder news @Daltonic blog",  "http://daltonic.blogspot.com/search/label/primskirtbuilder");
    }
    return 0;
}


// we use the description as a "one time run" flag
// it stores the hash of the key of the last owner that ran the script
// if the owner changes - the hash changes too.
run_once()
{
    string hash = llMD5String((string)llGetOwner(), 777);
    if (llGetObjectDesc() != hash) {
        llOwnerSay("Please read through the Introduction, the license, and the manual before asking any questions.");
        llOwnerSay("The author is available for consulting help, the rates are mentioned in the manual.");
        llSetObjectDesc(hash);
        llGiveInventory(llGetOwner(), "Introduction");
    }    
}


default
{
    state_entry()
    {
        //overriden sit target
        //lower them a bit
        
        
        rotation rX;
        rotation rY;
        rotation rZ;
        rotation r;
        
        vector size;
        
        size = llGetAgentSize(llGetOwner());
        
        // approximation.. but still better than nothing
        vLoungeTarget.z = size.z / 2.0;

        
        //build rotations
        //Note: this is broken out like this to simplify the
        //        process of finding the correct sit angle.  I 
        //        use the following form until I have the rotation 
        //        that I want perfect, and then I simply 
        //        hardcode the perfected quaterion and remove   
        //        this mess.
        //
        rX = llAxisAngle2Rot( <1,0,0>, 0 * DEG_TO_RAD);         //cartwheel
        rY = llAxisAngle2Rot( <0,1,0>, 0 * DEG_TO_RAD);       //sumersault
        rZ = llAxisAngle2Rot( <0,0,1>, 0 * DEG_TO_RAD);       //turn in place
        
        //combine rotations
        r = rX * rY * rZ;
        
        //override 'sit' on pie menu
        llSetSitText( "Stand" );

        //override default sit target and rotation on prim
        llSitTarget( vLoungeTarget, r );
        llSetRot(ZERO_ROTATION); // align to global coordinates
        
        llListen(CHANNEL, "", llGetOwner(), ""); 
        commChannelBase = 100000 + (integer)llFrand(100000000);
        // run the stuff that needs to be run once...
        run_once();
        
        // testing
        //mkLoungingAgentKey = llGetOwner();
        //commChannelBase = 123456;
        
    }
    on_rez(integer n)
    {
        llResetScript();
    }
    timer()
    {
        if (script_state == 1) {
            // rezzing on timeout - no echo reply
            llSetTimerEvent(0);
            rez_one_prim();
        }
        // send a keepalive so the others know we are still here
        llSay(commChannelBase - 1, "keepalive");
    }
    
    
    changed(integer change) 
    {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if ( mkLoungingAgentKey == NULL_KEY && agent != NULL_KEY ) 
            {

                //changed user
                //cache new user key and request their permissions
                mkLoungingAgentKey = agent;
                llRequestPermissions(mkLoungingAgentKey, PERMISSION_TRIGGER_ANIMATION);
                // show the dialog
                if (agent == llGetOwner()) {
                    show_main_dialog();
                } else {
                    llInstantMessage(agent, "The owner now should rez/edit the skirt. You can take your own copy by buying it for L$0.");
                }
            }
            else if ( mkLoungingAgentKey != NULL_KEY && agent == NULL_KEY) 
            {
                
                //user is getting up
                if ( miPermissionsAcquired ) 
                {
                    
                    //restore anims
                    llStopAnimation("turn_180");
                               
                }
                mkLoungingAgentKey = NULL_KEY;
                //reset the script to release permissions
                //llResetScript();
            }
        }        
    }
    
    run_time_permissions(integer parm) 
    {
        if(parm == PERMISSION_TRIGGER_ANIMATION) 
        {
            
            //set permission flag
            miPermissionsAcquired = TRUE;
            
            //cancel the sit anim
            llStopAnimation("sit");
            
            llStartAnimation("turn_180");
        }
    }
    
    touch_start(integer total_number)
    {
        key who = llDetectedKey(0);
        if (who == llGetOwner())
        {
            show_main_dialog();
        } else {
            llInstantMessage(who, "Only the owner can edit the skirt. Right-click and buy your copy for L$0 to try it yourself");
        }
        
    }
    
    
    listen(integer channel, string name, key id, string message) 
    {
        integer i;
        
        if (script_state == 0) {
            if (channel == CHANNEL) {
                check_dialog_replies(message);
            }
        } else if (script_state == 1) {
            if (channel == commChannelBase) {
                // newly awaken child comes back to us
                if (message == "boot") {
                    string msg = "init:" + (string)current_rez_prim_num + ":" + init_string;
                    // need to supply this little boy with his parameters, once it replies - we rez a new one  
                    llSay(commChannelBase, msg);
                    // debug to see what exactly is in bootmsg
                    //llOwnerSay("bootmsg: " + msg);
                                   
                } else if (message == "echo_reply") {
                    // one of the control prims we have pinged already exists - so we can just decrement 
                    // to the next one
                    //llOwnerSay("echo reply!");
                    make_next_misc_prim();
                } else if (message == "init_ok") {
                    // this guy has acked our parameters, has stopped listening on the base channel,
                    // renamed itself into its number
                    // and is listening on the commChannelBase + 1 + childNumber
                    if (current_rez_prim_num >= 0) {
                        // rezzing normal prims
                        current_rez_prim_num = current_rez_prim_num + 1;
                        if (current_rez_prim_num < numObjects) {
                            rez_one_prim();
                        } else {
                            // start rezzing misc prims
                            current_rez_prim_num = PRIM_FIRSTMISC;
                            check_or_rez_next_misc_prim();
                        }
                            
                        
                    } else {
                        // supply misc parameters to control prims...
                        if (current_rez_prim_num == PRIM_LINKCENTER) {
                            // turn it into a small ball...
                            // set shape
                            unicast(PRIM_LINKCENTER, "lc_prim_params:9:3:0:<0.000000, 1.000000, 0.000000>:0.000000:<0.000000, 0.000000, 0.000000>:<0.000000, 1.000000, 0.000000>");
                            // reset flex and set size
                            unicast(PRIM_LINKCENTER, "lc_prim_params:21:0:2:0.300000:2.000000:0.000000:1.000000:<0.000000, 0.000000, 0.000000>:7:<0.050000, 0.050000, 0.050000>");
                            // set texture (none)
                            unicast(PRIM_LINKCENTER, "lc_prim_params:17:0:5748decc-f629-461c-9a36-a35a221fe21f:<1.000000, 1.000000, 0.000000>:<0.000000, 0.000000, 0.000000>:0.000000");
                        }
                        
                        if (current_rez_prim_num == PRIM_GEOMETRY) {
                            string cmds = "";
                            integer i;
                            // set shape
                            unicast(PRIM_GEOMETRY, "gc_prim_params:9:0:0:<0.000000, 1.000000, 0.000000>:0.000000:<0.000000, 0.000000, 0.000000>:<1.000000, 1.000000, 0.000000>:<0.000000, 0.000000, 0.000000>");
                            // reset flex 
                            unicast(PRIM_GEOMETRY, "gc_prim_params:21:0:2:0.300000:2.000000:0.000000:1.000000:<0.000000, 0.000000, 0.000000>");
                            // size is set at boot...
                            // :7:<0.010000, 0.600000, 0.400000>");
                            // all textures to white
                            unicast(PRIM_GEOMETRY, "gc_prim_params:17:-1:5748decc-f629-461c-9a36-a35a221fe21f:<1.000000, 1.000000, 0.000000>:<0.000000, 0.000000, 0.000000>:0.000000");
                            // waist size texture
                            unicast(PRIM_GEOMETRY, "gc_prim_params:17:4:3515e3e5-f7c3-ffbe-8eb1-f7ede3bbc831:<1.000000, 1.000000, 0.000000>:<0.000000, 0.000000, 0.000000>:0.000000");
                        }
                        // rezzing misc prims - descending
                        make_next_misc_prim();
                    }
                } else {
                    llOwnerSay("Unknown message '" + message + "'");
                }
                
            } 
        } else if (script_state == 2) {
            if (channel == commChannelBase) {
                list aList = llParseString2List(message, [":"], []);
                string command = llList2String(aList, 0);
                if (command == "move") {
                    posOffset = posOffset + (vector)llList2String(aList, 1);
                    //llOwnerSay("moving by " + llList2String(aList, 1));
                    reposition_all();
                } else if (command == "geometry") {
                    // waist size / bend coeff
                    vector v = (vector)llList2String(aList, 1);
                    bendCoefficient = v.x;
                    yRadius = v.y;
                    xRadius = v.z;
                    reposition_all();
                } else if (command == "flare") {
                    //llOwnerSay("flare set: " + message);
                    flareAngle = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "menu") {
                    show_main_dialog();
                }
                
            } else if (channel == CHANNEL) {
                list aList = llParseString2List(message, [" "], []);
                string command = llList2String(aList, 0);
                
                if (check_dialog_replies(message)) {
                    // already done all
                    //llOwnerSay("dialog reply!");
                    // the below commands are for debug via the command line
                    
                } else if (command == "reset") {
                    wipe_all();
                } else if (command == "dz") {
                    posOffset.z = posOffset.z + (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "dx") {
                    posOffset.x = posOffset.x + (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "dy") {
                    posOffset.y = posOffset.y + (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "z") {
                    posOffset.z = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "x") {
                    posOffset.x = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "y") {
                    posOffset.y = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "flare") {
                    flareAngle = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "xradius") {
                    xRadius = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "yradius") {
                    yRadius = (float)llList2String(aList, 1);
                    reposition_all();
                } else if (command == "bend") {
                    bendCoefficient = (float)llList2String(aList, 1);
                    reposition_all();
                
                }
                
                
            }
        }

    }
    
}
