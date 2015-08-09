// :CATEGORY:Pet
// :NAME:Blue_Bovine_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:105
// :NUM:140
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// ALife by Strick Unknown; simplified Polyworld
list tape;
integer tn;
integer tp;
string prog;
integer pc;
integer chan;
integer minx;
integer maxx;
integer miny;
integer maxy;
vector f1; // closest friend
vector f2;
vector f3;
vector A; // accumulator for interp
object_move_to(vector position) {
    vector last;
    do {
        last = llGetPos();
        llSetPos(position);
    } while ((llVecDist(llGetPos(),position) > 0.001) && (llGetPos() != last));
}
critter_move_offset( vector off )
{
    if (llVecMag(off)>1.0) { off= llVecNorm(off);} // move at most 1 meter
    if (llVecMag(off)>0.1) {
        llSay(0, "off= " + (string)off );
        // turn in direction of motion
        vector reference; // = llRot2Left( llGetRot() );
        reference= <0, PI/2, 0>;
        llSay(0, "reference= " + (string)reference );
        rotation between;// = llRotBetween( llVecNorm(off), reference );
        between= llRotBetween( reference, llVecNorm(off) );
        llSay(0, "between= " + (string)between );
        llSetRot( llEuler2Rot(<0,PI/2,0>) * between );

        //llSetRot( llEuler2Rot(llRot2Up(llEuler2Rot(llVecNorm(off)))) );
        //llSetRot( (llEuler2Rot(<0,0,PI/2>) * between) * llEuler2Rot(<0,-PI/2,0>) );

    }
    vector p= llGetPos() + off;
    if (minx<=p.x && p.x<maxx && miny<=p.y && p.y<maxy) {
        float z = llGround(< 0.0, 0.0, 0.0 >);
        llSay(0, "Moving to " + (string)p );
        object_move_to( < p.x, p.y, z+2.0 > );
    } else {
        llSay(0, "Cant move offset " + (string)off );
    }
}

vector Tget(integer i) {
    return llList2Vector(tape, i);
}
Tput(integer i, vector v) {
    tape= llListReplaceList( tape, [v], i, i );
}
run_prog()
{
    // initialize tape with input values
    vector rand= < llFrand(2.0)+-1.0, llFrand(2.0)+-1.0, 0 >;
    tape = [ f1, f2, f3, rand, <0.,0.,0.>, <1.,0.,0.>, <0.,1.,0.>, <0.,0.,1.> ];
    tn = llGetListLength(tape);
    tp= 0;
    A= < 0., 0., 0. >;

    // interpret program prog
    integer n= llStringLength(prog);
    for ( pc= 0; pc < n; pc++ ) {
        string c= llGetSubString( prog, pc, pc );
        //llSay(0, "Program step " + (string)pc + " : " + c );
        if (c=="<") { tp--; if (tp<0) { tp= tn+-1;} } // regress ptr
        else if (c==">") { tp++; if (tp>=tn) { tp= 0;} } // advance ptr
        else if (c=="!") { Tput(tp, A); } // store
        else if (c=="^") { A= Tget(tp); } // recall
        else if (c=="+") { A= A + Tget(tp); } // add
        else if (c=="-") { A= -A; } // negate
        else if (c=="*") { A= 2.0 * A; } // double
        else if (c=="/") { A= 0.5 * A; } // half
        else if (c==".") { A= < A * Tget(tp), 0.0, 0.0>; } // dot product
        else if (c=="%") { A= A % Tget(tp); } // cross product
    }
    // Program finished, move by tape[tp]
    vector off= Tget(tp);
    critter_move_offset(off);
}
default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
        llSetTimerEvent(0);
    }

    touch_start(integer total_number)
    {
        state run;
    }
}
state run
{
    state_entry()
    {
        list tmp= llParseString2List( llGetObjectDesc(), [";"], [ ] );
        if ( 6 <= llGetListLength(tmp) ) {
            chan= (integer)llList2String(tmp, 0);
            minx= (integer)llList2String(tmp, 1);
            maxx= (integer)llList2String(tmp, 2);
            miny= (integer)llList2String(tmp, 3);
            maxy= (integer)llList2String(tmp, 4);
            prog= llList2String(tmp, 5);
        } else {
            llSay(0, "Description has not 6 fields, failing");
            state default;
        }
        llSay(0, "Running...");
        llSetTimerEvent(5);


        f1= <999., 999., 999.>;
        f2= f1;
        f3= f1;
        llSensor(llGetObjectName(), NULL_KEY, PASSIVE | SCRIPTED, 96, PI);
    }
    touch_start(integer total_number)
    {
        llSetTimerEvent(0);
        state default;
    }
    timer()
    {
        f1= <999., 999., 999.>;
        f2= f1;
        f3= f1;
        llSensor(llGetObjectName(), NULL_KEY, PASSIVE | SCRIPTED, 96, PI);
    }
    sensor(integer total_number) // total_number is the number of avatars detected.
    {
        llSay(0, (string)total_number + " " + llGetObjectName() + " detected" );
        integer i;
        vector me= llGetPos();
        float dist1= 999.;
        float dist2= 999.;
        float dist3= 999.;
        for (i = 0; i < total_number; i++)
        {
            vector p= llDetectedPos(i)-me;
            llSay(0, "Hello " + llDetectedName(i) + " offset " + (string)p );
            float mydist= llVecMag(p);
            // remember the 3 closest
            if (mydist<dist1) {
                f3=f2; dist3= dist2; f2=f1; dist2= dist1; f1=p; dist1= mydist;
            } else if (mydist<dist2) {
                f3=f2; dist3= dist2; f2=p; dist2= mydist;
            } else if (mydist<dist3) {
                f3= p; dist3= mydist;
            }
        }
        llSay(0, "f1= " + (string)f1 );
        llSay(0, "f2= " + (string)f2 );
        run_prog();
    }

    // if nobody is within 10 meters, say so.
    no_sensor() {
        llSay(0, "Nobody is around.");
        run_prog();
    }
}
