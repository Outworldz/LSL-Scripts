// :CATEGORY:Jewelry
// :NAME:Necklace_Generator
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:552
// :NUM:753
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//     DO NOT TRY THIS AT HOME! A sandbox is so much better!// //     First, you need this script: Necklace Generator// //     Generate a prim, any prim and put this script in it.// 
//     Second you need a bead, a simple white sphere all shiny and full bright size 0.2 x 0.2 x 0.2 works great for a 30 pearl necklace. Name it "test bead" and put it in the same prim as the script. Then touch the prim and you will see a necklace magically appear in front of you.
// 
//     Use edit to select all the prims (this is why you need a sandbox, so you dont accidentally also select unwanted prims) and then link them. (or delete them, play with the parameters some more and try again).
// 
// Ariane Brodie's homemade fine jewelry in Second Life 	
// 
// Then it is just a matter of resizing (this makes really big necklaces), attaching to your chest, and positioning and rotating it to fit around your neck.
// 
// Note that the first few lines are parameters you can play with (setting a to 1 and b to 0 makes a nice round bracelet). You can make the necklace as fine as you want with as many prims as you want. Most of the necklaces in game are about 60 prims. The bigger the numbead count, the smaller the test bead size should be.
// 
// After making a pearl necklace, try throwing down a torus size .2 x .2 x .2,
// twist -360 to 360 hole size 0.05, 0.50 advanced cut .88 to .9
// 
// Put this Link Script in the prim before loading it in the necklace generator
// Set the numbeads to 50, and viola!
// 
// If you put the link script in, then linked all the chain links together then edit, replace the link script with this chain script.
// 
// Now you can make your chain turn gold, silver, glow or not with some simple commands.
// 
// Bonus Project: You can also use the necklace generator to create a prim skirt
// :CODE:
//fine jewelry necklace generator
float a = 0.6; //elipse parameter between 0 (line) and 1 (perfect circle)
float b = 0.3; //bending parameter 0 = flat
string bead = "test bead"; //object to use
integer numbeads = 30; //how many beads should the necklace have
vector offsetrot = <0,0,0>; //rotation of test bead

make()
{
    integer n;
    float t; //parameter
    float d; //derivitive angle
    vector p; //position
    vector re; //rotation in euler
    rotation rot; //re in rot format
    for(n = 1;n <= numbeads;n++) {
        t = TWO_PI * ((float)n/(float)numbeads);
        llOwnerSay((string)n);
        p.x = llCos(t);
        p.y = a * llSin(t);
        p.z = b * llCos(t)*llCos(t) + 1;
        p = p + llGetPos();
        re.x = -1 * llSin(t) + DEG_TO_RAD * offsetrot.x;
        re.y = llCos(t) + DEG_TO_RAD * offsetrot.y;
        re.z = t + DEG_TO_RAD * offsetrot.z;
        rot = llEuler2Rot(re);
        llRezObject(bead, p, ZERO_VECTOR, rot, 0);
    }
}
        

default
{
    state_entry()
    {
        llSay(0, "Touch to generate a Necklace");
    }

    touch_start(integer total_number)
    {
        make();
    }
}
