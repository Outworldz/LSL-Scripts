// :CATEGORY:Walls
// :NAME:Changing_walls_via_command
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:165
// :NUM:233
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Just drop a script into each floor, wall or ceiling prim, and type commands on the /10 channel. You can read the scripts to see what the commands are, note you can handle the floor walls and roof separately or together. It is easy to add your own commands and textures if you want.// // Commands: Use "/10 command" to send// black, grid, glass, wood, dirt, grass, white, rock, mountain, hide// to affect just floor add "floor" to the end with no spaces, i.e. blackfloor, gridfloor...// to affect just walls add "walls" to the end
// to affect just roof add "roof" to the end
// :CODE:
(bonus command "phantom" will cause anyone on the roof to fall into the house, "solid" reverses it.)


integer Handle;

default {
    state_entry() {
        Handle = llListen(5, "", NULL_KEY, ""); // start listening

    }

    touch_start(integer total_number) {
        // when touched...
        llListenControl(Handle, TRUE); // ...enable listen
    }
    
    listen(integer channel, string name, key id, string message) {
        // when told "off"...
        if (message == "off") {
            llListenControl(Handle, FALSE);
        }
        else {
            if (message == "black" || message == "blackroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0, 0, 0>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "grid" || message == "gridroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "aebd4b83-6aea-b0ec-734c-f2c5e16c661a", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "glass" || message == "glassroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5b2eb7d3-2e83-7a3e-d944-8baa3f971fec", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "wood" || message == "woodroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "89556747-24cb-43ed-920b-47caed15465f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "dirt" || message == "dirtroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "0bc58228-74a0-7e83-89bc-5c23464bcec5", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "grass" || message == "grassroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "63338ede-0037-c4fd-855b-015d77112fc8", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "white" || message == "whiteroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "5748decc-f629-461c-9a36-a35a221fe21f", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "rock" || message == "rockroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "53a2f406-4895-1d13-d541-d2e3b86bc19c", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "mountain" || message == "mountainroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 1.0, 
            PRIM_TEXTURE, ALL_SIDES, "303cd381-8560-7579-23f1-f0a880799740", <1,1,0>, <0.0,0.0,0>, 0.0]);
            if (message == "light" || message == "lightroof")
            llSetPrimitiveParams([
            PRIM_MATERIAL, PRIM_MATERIAL_LIGHT]);
            if (message == "dark" || message == "darkroof")
            llSetPrimitiveParams([
            PRIM_MATERIAL, PRIM_MATERIAL_WOOD]);
            if (message == "phantom" || message == "phantomroof")
            llSetPrimitiveParams([
            PRIM_PHANTOM, TRUE]);
            if (message == "solid" || message == "solidroof")
            llSetPrimitiveParams([
            PRIM_PHANTOM, FALSE]);
            if (message == "hide" || message == "hideroof")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <255, 255, 255>, 0.0]);
                    
    }
    }
}
