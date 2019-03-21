// :SHOW:
// :CATEGORY:Prim
// :NAME:Prim_Animation_Compiler
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Animation, Puppeteer
// :CREATED:2013-02-25 10:47:09.853
// :EDITED:2015-10-20  14:27:52
// :ID:648
// :REV:1.11
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// This script produces optimized LSL code that can be triggered by link messages.
// For more details on how this script works, see <a href="http://www.outworldz.com/secondlife/posts/prim-compiler/">http://www.outworldz.com/secondlife/posts/prim-compiler/</a>
// :CODE:
// fred@mitsi.com
// 3-7-2012
// Rev 1.1, added a missing } at the end of multiple recordings.
// 20-10-2015 
// Rev 1.11 - SLRes: Patchouli Woollahra (PW)
	// modified SayCode to take devious advantage of new SL-specific commenting behaviors to significantly reduce 
	// editing time required between compile and publish, at minimal cost in compiled script load, readability of script 


// Author: Fred Beckhusen (Ferd Frederix)
// Based on an excellent script by Allen Firethorn
// This is free software, it is not for sale at any price. Yu can use it and sell the object.

// Tunable stuff:
integer OpenSim = FALSE;    // Set to FALSE for Second Life to save memory (EDIT: take advantage of SL-specific optimizations - PW)
string fast="Fast";        // Set this to an empty string if you don't want to use the fast animation
integer debug = FALSE;      // set to TRUE to see stuff inside as it runs

list animations;      // holds a list of all animation names
list receivedData;    // the data from the main program
integer STRIDE = 5;    // size of the data packets in receivedData
integer currentLine;  // the line we are processing

// Link messages
integer CLEAR = -234756;
integer DATA = -234757;
integer COMPILE = -234758;
integer DIE = -234759;

DEBUG(string msg)
{
    if (debug) llOwnerSay("// " + msg);
}

// speak without the name of the prim in the way
SayCode (string story){

//Modification By Patchouli Woollahra, 20 October 2015 
		//Rationale:
			// Recent versions of SL server support block commenting
			// C-style with /* */ tags. By encapsulating timestamps, 
			// object names that are part of each SayCode
			// (plus any unnecessary chat that crops up during export on says)
			// produce script where object names, timestamps, unnecessary chatter
			// are ignored by compiler, also easier to search out and delete if
			// absolute cleanliness in compiled animation script is desired!
			// Until OpenSim version of LSL consistently supports C-style blockcommenting too,
			// this trick is gated off the OpenSim variable and used only if
			//flagged as being compiled on Second Life
	if(OpenSim) {
		//Code running in OpenSim
		llOwnerSay (story);
	} else {
		//code running in SL - SayCode outputs block commenting tags as prepend-postpend to story.
			// Why is block closing tag used first, and block opening tag last?
			// This is an exercise left to the user - 
			// examine a testcompile and iterate through the code manually, you might learn something! >:D
			
		llOwnerSay("<--*/\n "+ story +"\n/*-->"); 
	}
    
    llSleep(0.1);

}

default {

    link_message(integer sender_num,integer num, string msg, key id)    {

        if (num == DIE && msg =="die")  // clear
        {
            llOwnerSay("Compiler has been removed");
            if (! debug) {
                llRemoveInventory(llGetScriptName());
            }
        }

        if (num == CLEAR)  // clear
        {
            animations = [];
            receivedData = [];
            currentLine = 0;
            llOwnerSay("Compiler Ready");
        }
        else if (num == DATA)  // data
        {
            // data formatted like this:
            //  name|primnum|vector Pos|rotation rot|vector size
            // test1|2|<0.026306,-0.150208,0.191069>|<-0.000008,0.956309,-0.292356,0.000000>|<0.074010,0.074010,0.074010>
            list primList = llParseString2List(msg,["|"],[]);
            string name = llList2String(primList,0);

            receivedData += name;
            receivedData += (float) llList2String(primList,1);    // prim Number or ms to sleep
            receivedData += (vector) llList2String(primList,2);     // pos
            receivedData += (rotation) llList2String(primList,3);        // rot
            receivedData += (vector) llList2String(primList,4);     // size

            // Store the name of the animation if it is not already stored
            integer i = llListFindList(animations, [name]);

            if( i < 0 ){
                DEBUG("Adding Animation named " + name);
                animations += name;
            }

            currentLine++;
        }
        else if (num == COMPILE) // finish, compile it
        {

            //DEBUG("Animations:" + llDumpList2String(animations,":"));
            //DEBUG("Length:" + ((string) llGetListLength(animations)));
            //DEBUG("history:" + llDumpList2String(receivedData,":"));
            //DEBUG("Length:" + ((string) llGetListLength(receivedData)));


            string code;
            integer i;

            llOwnerSay("Compiler processing " + (string)currentLine + " prim movements and " + (string) llGetListLength(animations) + " animations");

            llOwnerSay("Copy everything below this line and paste it into a new script\n");

            string oldname = llGetObjectName ();
            llSetObjectName ("Compiler");

            vector scale = llGetScale();
            SayCode("// Prim animation compiler //\n"
                + "// Fred Beckhusen (Ferd Frederix) - http://www.outworldz.com\n"
                + "integer playbackchannel = 1; // The default llMessageLinked number\n"
                + "rotation calcChildRot(rotation rdeltaRot){\n"
                + "\tif (llGetAttached())\n"
                + "\t\treturn rdeltaRot/llGetLocalRot();\n"
                + "\telse\n"
                + "\t\treturn rdeltaRot/llGetRootRotation();\n"
                + "}\n"
                + "vector originalScale = "
                + (string) scale
                + ";"
                );



            // Go through each animation and create a function for each one
            for(i = 0; i < llGetListLength(animations); i++){
                integer j;
                string animationName = llList2String(animations, i);

                //DEBUG("Processing " + animationName);

                SayCode(animationName
                    + "(){\n"
                    + "\tvector currentSize = llGetScale();\n"
                    + "\tfloat scaleby = currentSize.x/originalScale.x;\n"
                    );



                //Read through the list and print out the instructions for this animation
                integer count = llGetListLength(receivedData);
                for(j=0; j < count; j += STRIDE)
                {
                    string name = llList2String(receivedData,j);
                    float primNum = (float) llList2String(receivedData,j+1);

                    //DEBUG("name: " + name + " Prim Num: " + primNum);
                    if( name == animationName){
                        if(primNum > 1){        // not a root prim or sleep
                            SayCode( "\tllSetLinkPrimitiveParams"
                                + fast
                                + "("
                                + (string) ((integer)primNum)
                                + ", [PRIM_POSITION, "
                                + (string) llList2Vector(receivedData,j+2)
                                + "*scaleby, "
                                + "PRIM_ROTATION,calcChildRot("
                                + (string) llList2Rot(receivedData,j+3)
                                + "), "
                                + "PRIM_SIZE, "
                                + (string) llList2Vector(receivedData,j+4)
                                + "*scaleby]);"
                                );
                        } else {
                                SayCode("\tllSleep("
                                    +(string)(primNum*-1) // negative numbers are sleep times
                                +");"
                                );
                        }
                    } // if name
                }  // for j
                SayCode ("\n}");
            } // for animations

            SayCode (
                "\n\n"
                    + "default{\n"
                );
            if (!OpenSim)
                SayCode("\tstate_entry(){\n"
                    +"\t\tllSetMemoryLimit(llGetUsedMemory() + 512);\n"
                + "\t\t}");

            code = "\n\tlink_message(integer sender_num, integer num, string message, key id){\n"+
                "\t\tif(num == playbackchannel){\n";
            for(i=0; i<llGetListLength(animations);i++){
                code+="\t\t\tif(message == \""+llList2String(animations,i)+"\"){\n"+
                    "\t\t\t\t"+llList2String(animations,i)+"();\n"+
                    "\t\t\t}\n";
            }
            code += "\t\t}\n"+
                "\t}\n}";
            SayCode(code);

            SayCode("//  Done!  Copy everything above to a new script, and Search/Replace the time stamp and Compiler: on the left to be blank");
            
			//SL Specific CleanUp Code 
				//remember- on SL, SayCode will end each line with a block comment opening tag - even the last line just before this comment!
				//to avoid throwing errors because of dangling block-comment tag, we manually llOwnersay one last block comment closing tag...
				//Using this in OpenSim? you've traded this issue for the problem of finding and deleting 
				//an object name and timestamp from each exported line - good luck with that one! - Patchouli Woollahra
				
			if (!OpenSim) {
				//if Code is running in Second Life
				llOwnerSay("<--*/"); //AND WE'RE DONE! :D
			}
			llSetObjectName (oldname);

        }
    }


}



