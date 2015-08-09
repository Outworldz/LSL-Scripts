// :CATEGORY:Building
// :NAME:Clone_Prim
// :AUTHOR:Clarknova Helvetic
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:183
// :NUM:254
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Clone_Prim
// :CODE:
///////////////////////////////////////////////////////////////////
//
//                   CLONE PRIMITIVE  v 2.31
//
//
//   This script chats out lines of text that can be pasted back 
//   into a blank script to clone the original prim.
//
//   It also produces codeblocks optimized for automated transforms.
//
//    
 ////////////////////////////////////////////////////////////////////
//
//                    HOW TO USE
//
//
//   Drag 'n Drop this script into the prim you want to copy.   
//
//   It will output a complete script for replicating the object
//   in Owner-Only chat.  Then it will delete itself.
//  
//   Copy and paste the chatted script into a *completly blank*
//   new script
//
//   Then use the  Search/Replace function under the Edit menu 
//   to replace the "[HH:MM]  :" line prefixes with a blank.
//
//   Just hit the 'Replace All' button.
//
//   It can take 2 minutes or more to print out, so you may have to 
//   do this a few times.
//
//
//   The Primitve Paramaters will be chatted out in the oder that 
//   they're featured on the offical Wiki:
//
//   http://wiki.secondlife.com/wiki/LlGetPrimitiveParams   
//
 ///////////////////////////////////////////////////////////////////
//
//                       WHY?
//
//   Chances are you're not going to need an end-to-end
//   script to dupe your prim. Shift-drag copy is a lot easier.
//
//   But if you're reading this you probably want some of the code,
//   so carve out what you need from the output.
//
//   The output code is also commented where appropriate. If you want 
//   To know more about what's going on, read the comments here and 
//   check out the wiki.  The wiki's good.
//
//   Many advanced items on the grid transform from one object to 
//   another.  Builders have used scrips like this to generate the 
//   code that goes into those products.
//
//   Consider the use of both of llSetPrimitiveParams([]) and 
//   llSetLinkPrimitiveParams([]).  A multi-prim prim object can be 
//   metamorphed with a single scipt.
//
//   In my experience you can pack five complete primitive trans-
//   formations into one script before you run out of bytes.
//
 ///////////////////////////////////////////////////////////////////
//
//              Released nder the terms of the 
//              GNU General Public Liscence v3
//
//  This source code is free to use / modify / resell 
//  with the following restrictions:
//
//  If you include any portion of -this- script in a product you 
//  distribute you must make the script fully mod/copy/trans for 
//  the next user/owner.  You must also liscence it under the GPL 
//  and give attribution to the contributors.
//
//  This does not extend to the code this script generates.  That
//  is yours to liscense as you see fit.
//
//             No warantee expressed or implied.
//   
//  For more info see http://www.gnu.org/copyleft/gpl.html
//
 ///////////////////////////////////////////////////////////////////
//
//      Written by          
//      Clarknova Helvetic [2008.01.04]
//      w/ thanks to Bopete Yossarian
//
////////////////////////////////////////////////////////////////////
 
 
///  Global Functions & Vars to make life easier
 
 
float   pause   =   .1  ; //// Change this to change the delay between each printed line.
                          //// The laggier the server the more delay you'll need to 
                          //// prevent line mix-up.
 
 
// Object-Specific parameters 2 string
string osp(integer p) {return llDumpList2String(llGetPrimitiveParams([p]),","); }
 
// Face-Specific parameters 2 string
string fsp(integer p, integer f) { return llDumpList2String(llGetPrimitiveParams([p,f]),","); }
 
// Parameter prefixed and formatted for output
string param(string p , integer q) { return p + "," + osp(q); }
 
// General owner chat w\ Sleep function to stop chat lag from  screwing up the line order
say(string c) { llSleep(pause); llOwnerSay(c); } 
 
// Printing out next element to add to the parameter list
sayn(string c) { say("\t" + c + " , "); }
 
// Printing out the last element to add to the parameter list
saynd(string c) { say("\t" + c + "\n\n\t];"); }
 
// Print out the code to apply the parameters to the object
define() {  say("\tllSetPrimitiveParams(params);\n\tparams = [];"); }
 
// Handle to insert comments
comment(string c) { say("\n\t// " + c ); }
 
 
 
/// On with the show...
 
 
 
default
{
    state_entry()
    {


        say("COPY/PASTE THE CODE BELOW INTO A *BLANK* SCRIPT TO CLONE THIS PRIM: \n\n");  // Announce what we're doing

        // We're going to change the object's name to a null string to make the output easier to read.
        string object_name = llGetObjectName(); // Store the object's name so we can set it back when done
        llSetObjectName("");

        // Guess we should transfer the description too
        string object_desc = llGetObjectDesc();

        //  Print the script header up to state_entry
        say("\ndefault\n{\n\tstate_entry()\n\t{\n\tlist params;\n\t\n\n\t// If you are cutting code out to paste into custon functions\n\t// Define \"params\" as a global list and start cutting below this line.\n\n\tparams =");




        // Add some comments to the script

        // [12:56]  Tali Rosca: It uses the C-style thing about an assignment also being an expression with a value.
        // [12:56]  Tali Rosca: Why it actually saves memory still baffles my mind, though.

        // list of the the first: paramater constants as strings, then thier integer value.
        list Param_Names = ["PRIM_TYPE",PRIM_TYPE,"PRIM_MATERIAL",PRIM_MATERIAL,"PRIM_PHYSICS",PRIM_PHYSICS,"PRIM_TEMP_ON_REZ",PRIM_TEMP_ON_REZ,"PRIM_PHANTOM",PRIM_PHANTOM,"PRIM_POSITION",PRIM_POSITION,"PRIM_ROTATION",PRIM_ROTATION,"PRIM_SIZE",PRIM_SIZE];


        // ASIDE:
        // Prim params are of two types: Object-Specific and Face-Specific.
        //
        // I'd Like to group them together according to type, but LsL doesn't
        // nor does wiki.secondlife, and I am sworn to complete my destiny...
        //
        // This is probably for historical reasons (the param order, not my
        // ultimate destiny).


        integer i; // You're going to see a lot of use, integer i!
        integer length; // So are you, integer length!

        length = (llGetListLength(Param_Names)); // I'm way lazy.  Let's make LsL do basic math for us.

        for ( i = 0 ; i < length ; i = i +2) // This is may answer to list strides.  Take that!
        {
            if (i > length -3 ) // If we're at the last stride
            {
                saynd(param(llList2String(Param_Names,length -2), llList2Integer(Param_Names,length -1))) ; // Fecth the constants out of Param_Names.
                i = length;
            }
            else if (i == 0) // PRIM_TYPE is a special case.  But then what isn't?
            {
                //  Checking if it's a sculptie in a rather extravagant way,
                //  but I also want to check my work.

                integer j = llList2Integer(Param_Names,i+1); // What's the param we're checking?
                list r = llGetPrimitiveParams([j]); // What are its values?
                integer t = llList2Integer(r,0); // What's the first value?

                if (t == 7) // if it's a sculptie
                {
                    sayn("[\n\tPRIM_TYPE,"+ (string)t + ",\""+ llList2String(r,1) + "\"," + llList2String(r,2) );

                }
                else sayn("[ \n \n \t" + param(llList2String(Param_Names,i), j));
            }
            else if (i < length -3 && i != length -6 ) sayn(param( llList2String(Param_Names,i), llList2Integer(Param_Names,i+1)) ) ;
            else if (i < length -3 && i == length -6 )
            {
                say("\t// It's probably not a god idea to have your new prim jump to the old one\n\t// " + param( llList2String(Param_Names,i), llList2Integer(Param_Names,i+1)) + " ] + (params = []) +");

            }
        }

        Param_Names = []; // Free up some memory

        // I reallllly want our script to set all of the paramaters at once, with one llSetPrimitiveParams()
        // call at the end of the script but we can't because of bugs in LsL.
        //
        // See  https://jira.secondlife.com/browse/SVC-38  for more info.  Please vote to fix it.\n\t

        say("");

        comment("Set all of the above paramaters as a group.");
        define();

        say("");
        comment("We are breaking the llSetPtimitiveParam([]) calls into blocks, because some params are incompatible with others \n\t// during the same call. This is an LsL bug.  See https://jira.secondlife.com/browse/SVC-38 for more info.\n\t// Please vote to fix it. \n");


        //// Okay, now for the hard stuff: 4 out of 5 of the Face-Specific params, starting with the hardest:
        //// PRIM_TEXTURE.  Why is PRIM_TEXTURE a pain?  Because llSetPrimitiveParams wants it in qoutes, but
        //// llGetPrimitiveParams doesn't give it to us in quotes.  It's a pickle.
        ////
        //// The Face-Specific params each need thier own For loop because the number of faces is variable
        //// from prim to prim.  A simple sphere only has one.  A tube can have up to 9.


        integer sides = llGetNumberOfSides();  // So here we find out how many faces we've got

        comment("This prim has " + (string)sides + " faces.\n"); // Don't care enough to correct for the singular :)


        ///  PRIM_TEXTURE ///

        say( "\tparams = \n\t[ \n \n ");
        for (i = 0 ; i < sides ; ++i)
        {

            list r =llGetPrimitiveParams([PRIM_TEXTURE,i]);
            string s =
                "\""  + llList2String(r,0) + "\"" // First element is the texture key.
                    + ","
                + llList2String(r,1)
                + ","
                + llList2String(r,2)
                + ","
                + llList2String(r,3) ;

            if (i < sides -1)  s = s + " , " ;
            else if (i == sides -1)  s = s + "\n\n\t];";

            say("\tPRIM_TEXTURE," + (string)i + "," + s );


            // Local variables aren't cleared when we leave thier scope.  Can you believe that crap?
            r = []; s = "";

        }



        define();

        comment("Note that you -cannot- define textures and colors in the same call!\n\t// If you're cutting out these params for your custom code watch out for this.\n");


        ///  PRIM_COLOR ///
        say( "\tparams = \n\t[ \n \n ");
        for (i = 0 ; i < sides ; ++i)
        {

            if (i < sides -1 ) sayn("PRIM_COLOR," + (string)i + "," + fsp(PRIM_COLOR,i));
            if (i == sides -1 ) saynd("PRIM_COLOR," + (string)i + "," + fsp(PRIM_COLOR,i));
        }
        define();


        ///  PRIM_BUMP_SHINY ///
        say( "\tparams = \n\t[ \n \n ");
        for (i = 0 ; i < sides ; ++i)
        {
            if (i < sides -1 ) sayn("PRIM_BUMP_SHINY," + (string)i + "," + fsp(PRIM_BUMP_SHINY,i) );
            if (i == sides -1 ) saynd("PRIM_BUMP_SHINY," + (string)i + "," + fsp(PRIM_BUMP_SHINY,i));

        }
        define();

        ///  PRIM_FULLBRIGHT ///


        say( "\tparams = \n\t[ \n \n ");
        for (i = 0 ; i < sides ; ++i)
        {
            sayn("PRIM_FULLBRIGHT," + (string)i + "," + fsp(PRIM_FULLBRIGHT,i));

        }


        ////   Now back to an Object-Specific paramaters : Flexible & Shadows
        ////   Remember that I'm going in this screwy order so that our
        ////   Code matches the table on http://wiki.secondlife.com/wiki/LlSetPrimitiveParams


        sayn(param( "PRIM_FLEXIBLE",21));
        sayn("// " + param( "PRIM_CAST_SHADOWS",24));





        //// Now for one more Face-Specific paramater

        ///  PRIM_TEXGEN ///

        // Planar mapping is for correcting the what circular surfaces do to textures
        // The default value for all faces is 0 ( distored )
        // So we will only uncomment lines that carry a value of 1 ( corrected )

        //  And we make a note of that in the output script here
        comment("Planar mapping (PRIM_TEXGEN) is for correcting the what circular surfaces do to textures.\n\t// Most builds don't use it, so it's commented out to save bytes in auto-transform code.\n\t// The default value is 1 (distorted).\n\t// if you are metamorphing an object that already had planar mapping (rare)\n\t// uncomment those 0 lines.\n\t// This may not seem like much savings\n\t//  but if your script is trying to metamorph between as many as five objects\n\t// those few bytes saved might come in handy at the end.\n\n\t// If your textures are coming out with the offsets all wrong, try uncommenting them.");
        for (i = 0 ; i < sides ; ++i)
        {
            list r = llGetPrimitiveParams([PRIM_TEXGEN,i]);
            if (llList2Integer(r,-1) == 0) say("\t// PRIM_TEXGEN," + (string)i + "," + llDumpList2String(r," , ") + " , ");
            if (llList2Integer(r,-1) == 1) say("\tPRIM_TEXGEN," + (string)i + "," + llDumpList2String(r," , ") + " , ");
        }

        /// The last paramater is Object-Specific


        saynd("PRIM_POINT_LIGHT," + osp(PRIM_POINT_LIGHT) );

        say("\tllSetPrimitiveParams(params);\tparams = [];");  //  Print the final function call, braces & some blank lines

        say("\n\n\t// If you were cut/pasting this code into a custom transform function\n\t// end your cut above this comment.\n\t// Otherwise ignore this.\n\n\tllSetObjectName(\"" + object_name + "\");\n");  // Make the target's name match this one
        say("\n\tllSetObjectDesc(\"" + object_name + "\");\n");  // Make the target's desc match this one

        comment("This next line deletes the script.  Comment it out if you want the script to persist");

        say("\n\tllRemoveInventory(llGetScriptName());\n\t}\n}\n\n\n");  // Remove the cloning script when done


        llSetObjectName(object_name); // Change our object's name back.

        say("Don't forget to remove the \"[HH:MM]  :\" timestamp at the beginning of each line.  Use Find/Replace  :)"); // Remind us to remove prefixes.)
        llRemoveInventory(llGetScriptName());  // Delete this script.
    }
}
