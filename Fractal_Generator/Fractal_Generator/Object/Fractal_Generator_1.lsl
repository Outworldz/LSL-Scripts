// :CATEGORY:Building
// :NAME:Fractal_Generator
// :AUTHOR:Seifert Surface
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:336
// :NUM:449
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The following is a set of scripts for generating fractals (strictly speaking, fractal trees). I used variants of this script to build all of the fractals in my (2005) burning life build.
// :CODE:
///////////////////////////////////////////
//////////Fractal Generator 1.0////////////
///////////////////////////////////////////
///////////////////by//////////////////////
///////////////////////////////////////////
/////////////Seifert Surface///////////////
/////////////2G!tGLf 2nLt9cG/////Aug 2005//
///////////////////////////////////////////

//Instructions for use:

//Rez a prim, mess around with it however you want. When you're done, make 3 copies of it.
//Put this script ("Fractal Generator 1.0") in one, which will be the base prim of the
//fractal. Put the script "Fractal Generator 1.0 Child" in another, and "Fractal Generator
//1.0 Rescaler" in the third. Take the "rescaler" prim, make sure it's name is "Object",
//and put it in the contents of the base prim (the one with this script). The scripts will
//build the fractal out of copies of this "rescaler" prim.

//Now we tell the scripts how we want the fractal to be built. Make some number of copies
//of the "child" prims (2 or 3 is a good number), and arrange them near or touching the
//"base" prim. Rotating them is fine, scaling them (down usually) is a good idea, but
//remember whenever you scale it to scale all three dimensions equally (use the grey boxes
//in the "Stretch" tool, not the red, green or blue). Rotating or moving the base prim is
//fine, but don't rescale it at this stage (the scripts rely on the "rescaler" prim to be
//an exact copy of the base prim).

//Now decide how many iterations you want the fractal to contain. 3 is a good number to
//start with. This script calculates beforehand how many prims the final fractal will
//contain, and will not build if it contains more than the "prim_limit" below. You can
//change this number (it is set in the first line of code below) to something bigger, but
//I take no responsibility if you end up crashing a sim! This is *not* a piece of self
//replicating code, but it will rez many prims relatively quickly. You have been warned.

//The formula for the number of prims in the final fractal, starting from b children and
//doing i iterations is:
// i+1                    if b == 1
// (b^(i+1) - 1)/(b - 1)  if b >= 1

//Having decided on the number of iterations you want, simply enter this number into the
//"Description" of the object (in the "General" tab of the extended editing controls).
//Finally, link all the child prims to the base prim, making sure that the base prim is
//the root of the link set. To do this, select the child prims first, add the base prim to
//the selection last (by holding down Shift and clicking on it), and then link (Ctrl-L, or
//selecting "Link" from the "Tools" menu).

//Now say "go" (the script will only listen to its owner), and the fractal will begin
//building (as long as the final fractal wouldn't contain too many prims). A good trick is
//to have the base and child prims (which are now linked) selected in edit mode, so that
//once the fractal is built, you can easily move the generator away. The generator will
//rez copies of the base and the child prims in their exact locations, so it can be
//difficult to select them.

//If you don't like how it turned out, simply edit the positions and scales of the child
//prims (you might want to unlink first and then relink again), and when you're happy, say
//"go" again, and it will generate the new fractal.

//Issues:

//It is impossible to rez a prim that is smaller than 0.01 metres, or larger than 10.0
//metres in any dimension. The script will detect when it tries to do so, and counts how
//many prims fail to rez because of this. It is also impossible to rez a prim further than
//around 10 metres distance from the rezzing object, which is the base prim. Unfortunately
//it doesn't seem to be exactly 10 metres, so I haven't implemented a similar check to see
//how many prims would be too far from the base prim to be rezzed. The code is in there,
//but commented out. Let me know if you work out something reliable. As is, attempting to
//rez a prim too far from the base will silently fail.

//If you modify the code, please keep my name with it, and make sure you don't crash a sim!
//Please do not sell this code, or anything with this code in it. Selling objects created
//with this code is ok. It would be nice if people would let me know what they're making
//with it :)

//   Seifert Surface
//   2G!tGLf 2nLt9cG

///////Start of code///////

integer prim_limit = 255; //wont build anything with more than this number of prims
integer iterations;  //number of levels to go down
integer branching;  //number of elts in each list

list posns;
list rotns;
list scales;

vector base_posn;

integer listen_control;
integer count_replies;      //for making sure that all child prims in the base have replied
integer bad_scales = 0;     //counting how many prims were too small or too big to rez
//integer bad_positions = 0;  //counting how many prims were too far away from the generator to rez
//this seems unreliable - according to the wiki rezzing at a distance of more than 10 meters fails silently,
//but it seems to be able to go a little further (11 meters?). So the distance checking code is here but commented out,
//you can experiment with it if you like. As is, when trying to rez prims too far away, it will just fail silently.

rez_children(vector pos, rotation rot, float scl, integer iters)
{
    integer branch = 0;
    for(branch = 0; branch < branching; branch++)
    {
        //llSay(0, "iter: "+(string)iters+" branch: "+(string)branch);
        vector check_scale = llGetScale()*llList2Float(scales, branch)*scl;
        if(check_scale.x < 0.01 || check_scale.x > 10.0 || check_scale.y < 0.01 || check_scale.y > 10.0 || check_scale.z < 0.01 || check_scale.z > 10.0)
        {
            bad_scales++;
        }
        else
        {
            //start of distance checking code, commented out due to unreliability
            //vector check_pos = pos + scl*(llList2Vector(posns, branch)*rot);
            //
            //if(llVecMag(check_pos) > 10)
            // {
            //     bad_positions++;
            //  }
            //  else        
            //  {        
            //end of dist checking code
                llRezObject("Object", base_posn + pos + scl*(llList2Vector(posns, branch)*rot), //position to rez
                <0,0,0>,   //given vel... ignore
                llList2Rot(rotns, branch)*rot, //rotation to rez
                llRound(1000000.0 * llList2Float(scales, branch)*scl)  //scaling, including workaround passing integer
                );
            // }   //(from dist checking code)
        }

        //llSleep(1.0);  //if you want to slow it down to see what its doing
        if(iters > 1)
        {
        rez_children((pos + scl*llList2Vector(posns, branch)*rot), llList2Rot(rotns, branch)*rot, llList2Float(scales, branch)*scl, iters - 1);
        }              
    }
}    

default
{
    state_entry()
    {
        key owner = llGetOwner();  //will only listen to its owner
        listen_control = llListen(0, "", owner, "");
    }

    on_rez(integer number)
    {
        llResetScript();
    }

    listen(integer channel, string name, key id, string message)
    {
        if(message == "go")  //say "go" to make it start
        {
            llSay(0, "Recording data...");
            state Recording;           
        }
    }   
    
    state_exit()
    {
        llListenRemove(listen_control);
    }   
}

state Recording
{
   state_entry()
   {
        branching = llGetNumberOfPrims() - 1; //dont count the root prim
        if(branching <= 0)
        {
            llSay(0, "Link child prims first!");
            state default;
        }
        //llSay(0, "branching: "+(string)branching);
        //check how many prims there will be... (assuming none too small/big/far away)
        iterations = (integer)llGetObjectDesc();  //put desired number of iterations in the object description
        if(iterations <= 0)
        {
            llSay(0, "Number of iterations (enter it into the object description) must be a positive integer!");
            state default;
        }
        //llSay(0, "iterations: "+(string)iterations);
        integer num_prims;
        if(branching == 1)
        {
           num_prims = iterations + 1;
        }
        else
        {  
        float fi = (float)iterations;
        float fb = (float)branching;
        float temp1 = llPow(fb,(fi + 1)) - 1.0;  //some math here...
        float temp2 = (fb - 1.0);
        num_prims = llRound(temp1/temp2);
        }
        llSay(0, "Final fractal will contain prims: "+(string)num_prims);
        if(num_prims > prim_limit)
        {
            llSay(0, "Too many prims!");
            state default;
        }
       
        count_replies = 0; //going to need all of the child prims to reply

        posns = [];
        rotns = [];
        scales = [];
        integer branch = 0;
        for(branch = 0; branch < branching; branch++)
        {  //reset lists to correct lengths
        posns = llListInsertList(posns, [ZERO_VECTOR], branch);
        rotns = llListInsertList(rotns, [ZERO_ROTATION], branch);
        scales = llListInsertList(scales, [1.0], branch);
        }
       
        llMessageLinked(LINK_ALL_OTHERS, 0, "return", NULL_KEY);  //ask all child prims to report their parameters
   }

   link_message(integer sender_num, integer num, string str, key id)
   {
        count_replies++;
        integer branch = sender_num - 2;
        llSay(0, "Replied, child prim: "+(string)branch);

        list reply = llParseString2List(str, ["|"], []);  //reply is of form <position>|<rotation>|scale
       
        vector temp_pos = (vector)llList2String(reply, 0);
        rotation temp_rot = (rotation)llList2String(reply, 1);
       
        vector temp = llGetScale();    //only measures scaling in x, but doesnt matter which: child prims should
        float tempx = temp.x;          //be scaled in all coords equally for code to work properly
        float temp_scale = (float)llList2String(reply, 2)/tempx;  //stored scale is relative to root prim scale
       
        //llSay(0, (string)temp_pos+(string)temp_rot+(string)temp_sca  le);
       
        posns = llListReplaceList(posns, [temp_pos], branch, branch);
        rotns = llListReplaceList(rotns, [temp_rot], branch, branch);
        scales = llListReplaceList(scales, [temp_scale], branch, branch);

        if(count_replies >= branching)
        {
           //llSay(0, "posns: "+llDumpList2String(posns, "|"));
           //llSay(0, "rotns: "+llDumpList2String(rotns, "|"));
           //llSay(0, "scales: "+llDumpList2String(scales, "|"));
           state Building;
        }
    }
}   

state Building
{
    state_entry()
    {            
        //llSay(0, "Starting...depth: "+(string)iterations)+" branching: "+(string)branching);
        base_posn = llGetPos();
        bad_scales = 0;
        //bad_positions = 0;
            
        llRezObject("Object", base_posn, <0,0,0>, llGetRot(),1); //rez copy of the base  
        rez_children(<0,0,0>, llGetRot(), 1.0, iterations);      //yay recursion!!
        llSay(0, "Done! "+(string)bad_scales+" prims had sizes too large or too small.");
        //llSay(0, "(string)bad_positions+" had positions too far from base prim.");
        state default;
    }
}
