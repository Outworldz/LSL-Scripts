// :CATEGORY:Particles
// :NAME:Square_Particle_Garden
// :AUTHOR:Optikal
// :CREATED:2011-06-13 12:08:08.483
// :EDITED:2013-09-18 15:39:05
// :ID:830
// :NUM:1158
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Square_Particle_Garden
// :CODE:
// 3-2-2012 - removed non breaking spaces - FKB

//// "Fire" PARTICLE TEMPLATE v1 - by Jopsy Pendragon - 4/8/2008
//// You are free to use this script as you please, so long as you include this line:
//** The original 'free' version of this script came from THE PARTICLE LABORATORY. **//

// SETUP:  Drop one optional particle texture and this script into a prim.
// Particles should start automatically. (Reset) the script if you insert a
// particle texture later on.  Add one or more CONTROLLER TEMPLATES to any
// prims in the linked object to control when particles turn ON and OFF.

// Customize the particle_parameter values below to create your unique
// particle effect and click SAVE.  Values are explained along with their
// min/max and default values further down in this script.

// converted for pattern spread by Joris Tolsen
// -----------------------------------
// parameters ------------------------
// -- square mode --
float row_space = 0.5;
float plant_space = 0.5;        // used by circle and random too
float plant_offset = 0.0;
integer rows = 8;
integer plants = 8;
// -- random mode --
integer rand_plants = 30;
float rand_width = 15.0;
float rand_depth = 12.0;
// -------------------
float   scale = 0.5;
integer Handle;
integer Channel = 1;
integer active = 1;
integer pattern = 0;          // 0 = square, 1 = random, 2 = circle
list    plant_list = [];
// ----------------------------------
list particle_parameters=[]; // stores your custom particle effect, defined below.
list target_parameters=[]; // remembers targets found using TARGET TEMPLATE scripts.
maak_part(float distance,float angle,string texture){
    particle_parameters = [  // start of particle settings
        // Texture Parameters:
        PSYS_SRC_TEXTURE,   texture,    //llGetInventoryName(INVENTORY_TEXTURE, 0),
        PSYS_PART_START_SCALE, <scale ,scale, FALSE>,
        PSYS_PART_END_SCALE, <scale ,scale, FALSE>,
        PSYS_PART_START_COLOR, < 1,1,1>,
        PSYS_PART_END_COLOR, < 1,1,1>,
        PSYS_PART_START_ALPHA, (float)1,
        PSYS_PART_END_ALPHA, (float)1,
        // Production Parameters:
        PSYS_SRC_BURST_PART_COUNT, 2,
        PSYS_SRC_BURST_RATE, (float) 0.01,
        PSYS_PART_MAX_AGE, (float)30.0,
        PSYS_SRC_MAX_AGE,(float) 0.0,
        // Placement Parameters:
        PSYS_SRC_PATTERN, (integer)4, // 1=DROP, 2=EXPLODE, 4=ANGLE, 8=ANGLE_CONE,
        // Placement Parameters (for any non-DROP pattern):
        PSYS_SRC_BURST_SPEED_MIN, (float)0,
        PSYS_SRC_BURST_SPEED_MAX, (float)0,
        PSYS_SRC_BURST_RADIUS, distance,
        // Placement Parameters (only for ANGLE & CONE patterns):
        PSYS_SRC_ANGLE_BEGIN, angle,
        PSYS_SRC_ANGLE_END, angle,
        // PSYS_SRC_OMEGA, <0,0,0>,
        // After-Effect & Influence Parameters:
        //   PSYS_SRC_ACCEL, <0.0,0.0,0.01>,
        // PSYS_SRC_TARGET_KEY,      llGetLinkKey(llGetLinkNum() + 1),
        PSYS_PART_FLAGS, (integer)( 0         // Texture Options:
            //   | PSYS_PART_INTERP_COLOR_MASK
            //   | PSYS_PART_INTERP_SCALE_MASK
            //   | PSYS_PART_EMISSIVE_MASK
            //   | PSYS_PART_FOLLOW_VELOCITY_MASK
            // After-effect & Influence Options:
            //   | PSYS_PART_WIND_MASK
            //   | PSYS_PART_BOUNCE_MASK
            // | PSYS_PART_FOLLOW_SRC_MASK
            // | PSYS_PART_TARGET_POS_MASK
            // | PSYS_PART_TARGET_LINEAR_MASK
            )
                //end of particle settings
                ];
    llParticleSystem( particle_parameters );
}
// ---------------------------------
// calculate where the plants go
// ---------------------------------
planten(){
    if (pattern==0){
        planten_square();
    }
    else if (pattern==1){
        planten_list();
    }
}
planten_square(){
    integer plants_row=0;       // will be set by script !!!
    integer plants_row_odd=0;   // will be set by script !!
    integer number = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer textcnt=0;
    vector begin_pos;
    vector thrower_pos;
    integer rc;     // row counter
    integer pc;     // plant counter
    float rl=0.0;   // row length
    float fl=0.0;   // field length
    begin_pos=llGetPos();
    thrower_pos=llGetPos();
    plants_row=plants/2;
    if (plants - plants_row - plants_row > 0){
        plants_row_odd=1;
    }
    if (rows > 1){
        fl = rows*row_space-row_space;
        begin_pos.x-=fl/2.0;
    }
    if (plants_row > 1){
        rl=plants_row*plant_space-plant_space;
    }
    if (!plants_row_odd){
        begin_pos.y+=plant_space/2.0;       // even number of rows  .. take offset
    }
    begin_pos.x+=plant_offset;
    for(rc=0; rc< rows ; rc++){
        float rx=begin_pos.x+rc*row_space;
        for (pc=0; pc<plants_row+plants_row_odd;pc++){
            float py=begin_pos.y+pc*plant_space;
            float dst;
            float ang;
            float ro=rx-thrower_pos.x;
            float po=py-thrower_pos.y;
            dst = llSqrt(ro*ro+po*po);
            ang = llAtan2(po,ro);
            maak_part(dst,ang,llGetInventoryName(INVENTORY_TEXTURE,textcnt));
            if (++textcnt >= number) textcnt=0;
            llSleep(0.05);
        }
    }
    llParticleSystem([]);
}
planten_list(){
    integer planten = llGetListLength(plant_list);       // will be set by script !!!
    
    vector thrower_pos;
    vector begin_pos;
    integer pc;     // plant counter
    thrower_pos=llGetPos();
    begin_pos=thrower_pos;
    begin_pos.x+=plant_offset;
    for (pc=0; pc< planten ; pc++){
        vector pp;
        pp=llList2Vector(plant_list,pc);
        float px=begin_pos.x+pp.x;
        float py=begin_pos.y+pp.y;
        float dst;
        float ang;
        float ro=px-thrower_pos.x;
        float po=py-thrower_pos.y;
        dst = llSqrt(ro*ro+po*po);
        ang = llAtan2(po,ro);
        maak_part(dst,ang,llGetInventoryName(INVENTORY_TEXTURE,(integer)llFloor(pp.z)));
        llSleep(0.05);
    }
    llParticleSystem([]);
}
maak_list(){
    plant_list=[];
    integer pc;     // plant counter
    integer number = llGetInventoryNumber(INVENTORY_TEXTURE);
    float hpd=plant_space/2.0;
    float dpt=(rand_depth-plant_space)/2.0;
    for (pc=0; pc<rand_plants;pc++) {
        integer fout=0;
        vector pp;
        do{
            fout=0;
            pp=<llFrand(rand_width)-(rand_width/2),llFrand(dpt)+hpd,llFrand(number)>;
            // check distance
            integer len = llGetListLength(plant_list);
            if (len > 0){
                integer tel;
                for (tel=0;!fout && tel < len ;tel++){
                    vector lp=llList2Vector(plant_list,tel);
                    if (llVecDist(lp,pp)<plant_space){
                        fout=1;
                    }
                }
            }
        }
        while (fout);
        plant_list += [pp];
    }
}
// -------------------------------------
// check if and which command is in str
// -------------------------------------
string checkMatch( string str, list prefixes  ){
    integer numElements = llGetListLength( prefixes );
    integer i;
    integer lastChar;
    string curPrefix;
    string curStr = llToLower( str );
    for( i=0; i<numElements; i++ ){
        curPrefix = llList2String(prefixes, i);
        lastChar = llStringLength( curPrefix );
        lastChar -= 1;
        if ( llGetSubString(curStr, 0, lastChar) == curPrefix )
            return curPrefix;
    }
    return "";
}
help(){
    llOwnerSay("command format /"+(string)Channel+" command value");
    llOwnerSay("commands recognized :");
    llOwnerSay("uit off stop        : switch the particles off");
    llOwnerSay("aan on start        : switch the particles on");
    llOwnerSay("regels rows         : number of rows to plant");
    llOwnerSay("plants planten      : number of plants per row/random patern");
    llOwnerSay("offset plaats       : shift the rows away from the center");
    llOwnerSay("plantspace          : space between plants");
    llOwnerSay("rowspace            : space between rows");
    llOwnerSay("show toon           : make spreader visible");
    llOwnerSay("hide verstop        : hide the spreader");
    llOwnerSay("square              : square plants in rows");
    llOwnerSay("random              : generate random pattern");
    llOwnerSay("width               : width of the random pattern");
    llOwnerSay("depth               : dept of the random pattern");
    llOwnerSay("scale               : scale factor of the particle");
}
init(){
    llSetTimerEvent(12.5);
    planten();
    Handle = llListen(Channel, "", llGetOwner(), "");
    active=1;
    if (pattern == 1) maak_list();
}

default{

    state_entry(){
        llOwnerSay("Commands == /"+(string)Channel+" help ");
        init();
    }

    on_rez(integer count){
        llResetScript();
    }

    timer(){
        planten();
    }

    touch_start(integer count){
        if (active){
            llSetTimerEvent(0.0);
            active=0;
        }
        else{
            init();
        }
    }

    listen(integer channel,string name,key id,string message) {
        string match;
        integer divide=llSubStringIndex(message," ");
        string gSubCommand = llToLower(llGetSubString(message, divide + 1, 40)); // grab the rest of the input string.
        match = checkMatch( message, ["offset", "plaats"] );
        if( match != "" ) {
            plant_offset=(float)gSubCommand;
        } else {
                match = checkMatch( message, ["uit", "off", "stop"] );
            if( match != "" ) {
                llSetTimerEvent(0.0);
                active=0;
            } else {
                    match = checkMatch( message, ["aan", "on", "start"] );
                if( match != "" ) {
                    init();
                } else {
                        match = checkMatch( message, ["plantspace", "plantafstand"] );
                    if( match != "" ) {
                        plant_space=(float)gSubCommand;
                    } else {
                            match = checkMatch( message, ["rowspace", "rijafstand"] );
                        if( match != "" ) {
                            row_space=(integer)gSubCommand;
                        } else {
                                match = checkMatch( message, ["rows", "regels"] );
                            if( match != "" ) {
                                integer rw=0;
                                rw=(integer)gSubCommand;
                                if (rw > 0) rows = rw;
                            } else {
                                    match = checkMatch( message, ["plants", "planten"] );
                                if( match != "" ) {
                                    integer pl=0;
                                    pl=(integer)gSubCommand;
                                    if (pl > 0) {
                                        if (pattern == 1) {
                                            rand_plants=pl;
                                            maak_list();
                                        } else {
                                                plants=pl;
                                        }
                                    }
                                } else {
                                        match = checkMatch( message, ["show", "toon"] );
                                    if( match != "" ) {
                                        llSetAlpha(1.0,ALL_SIDES);
                                    } else {
                                            match = checkMatch( message, ["hide", "verstop"] );
                                        if( match != "" ) {
                                            llSetAlpha(0.0,ALL_SIDES);
                                        } else {
                                                match = checkMatch( message, ["width"] );
                                            if( match != "" ) {
                                                rand_width=(float)gSubCommand;
                                            } else {
                                                    match = checkMatch( message, ["depth"] );
                                                if( match != "" ) {
                                                    rand_depth=(float)gSubCommand;
                                                } else {
                                                        match = checkMatch( message, ["square"] );
                                                    if( match != "" ) {
                                                        pattern=0;
                                                    } else {
                                                            match = checkMatch( message, ["random"] );
                                                        if( match != "" ) {
                                                            pattern=1;
                                                            maak_list();
                                                        } else {
                                                                match = checkMatch( message, ["scale"] );
                                                            if( match != "" ) {
                                                                scale = (float)gSubCommand;
                                                            } else {
                                                                    help();
                                                            }}}}}}}}}}}}}}
                                                        }
                                                    }
