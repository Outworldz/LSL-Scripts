// :CATEGORY:Walls
// :NAME:Changing_walls_via_command
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:165
// :NUM:236
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Door Script - Behaves like normal wall most of the time, but command "open" moves the wall like a garage door which automatically closes 10 seconds later.
// :CODE:
//garage door script x-axis version
//use on a wall 10x0.01x10 facing the y-axis
//by Ariane Brodie

integer Handle;
integer DOORCOUNT = 11;
integer WAITTIME = 100;
integer n = 0;


default {
    state_entry() {
        Handle = llListen(10, "", NULL_KEY, ""); // start listening

    }

    touch_start(integer total_number) {
        // when touched...
        llListenControl(Handle, TRUE); // ...enable listen
    }
    
    timer() {
        n++;
        if (n < DOORCOUNT) {
            rotation x_10 = llEuler2Rot( <0, 9 * DEG_TO_RAD, 0> );//for y-axis door switch x and y values
            vector currentPos = llGetPos();
            vector newPos = llGetPos() + <.5, 0, .5>; //for y-axis door switch x and y values
            rotation new_rot = llGetRot() * x_10; 
            llSetRot(new_rot);
            llSetPos(newPos);
        }
        else {
            if (n > (DOORCOUNT+WAITTIME) && n < (2*DOORCOUNT+WAITTIME)) {
            rotation x_r10 = llEuler2Rot( <0, -9 * DEG_TO_RAD, 0> );//for y-axis door switch x and y values
            vector currentPos = llGetPos();
            vector newPos = llGetPos() - <.5, 0, .5>; //for y-axis door switch x and y values
            rotation new_rot = llGetRot() * x_r10; 
            llSetRot(new_rot);
            llSetPos(newPos);
            }
            else {
                if (n > (2*DOORCOUNT+WAITTIME)) {
                    llSetTimerEvent(0);
                    n = 0;
                }
            }
        }
          
    }
    
    listen(integer channel, string name, key id, string message) {
        // when told "off"...
        if (message == "off") {
            llListenControl(Handle, FALSE);
        }
        else {
            if (message == "black" || message == "blackwalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0, 0, 0>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "grid" || message == "gridwalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "aebd4b83-6aea-b0ec-734c-f2c5e16c661a", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "glass" || message == "glasswalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5b2eb7d3-2e83-7a3e-d944-8baa3f971fec", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "wood" || message == "woodwalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "89556747-24cb-43ed-920b-47caed15465f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "dirt" || message == "dirtwalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "0bc58228-74a0-7e83-89bc-5c23464bcec5", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "grass" || message == "grasswalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "63338ede-0037-c4fd-855b-015d77112fc8", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "white" || message == "whitewalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "rock" || message == "rockwalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "53a2f406-4895-1d13-d541-d2e3b86bc19c", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "mountain" || message == "mountainwalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "303cd381-8560-7579-23f1-f0a880799740", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "video" || message == "videowalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "6e0f05ad-1809-4edc-df29-fae3d2a6c9b8", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "light" || message == "lightwalls")
            llSetPrimitiveParams([
            PRIM_MATERIAL, PRIM_MATERIAL_LIGHT]);
            if (message == "dark" || message == "darkwalls")
            llSetPrimitiveParams([
            PRIM_MATERIAL, PRIM_MATERIAL_WOOD]);
            if (message == "hide" || message == "hidewalls")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 0.0]);
            if (message == "open" || message == "opendoor"){
                llWhisper(0,"Open the pod bay doors, Hal!");
                llSetTimerEvent(0.1);
            }                    
    }
    }
}
