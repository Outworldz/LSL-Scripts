// :CATEGORY:Prim
// :NAME:Super_Prim_Animator_Motion_Compiler
// :AUTHOR:Allen Firethorn
// :CREATED:2012-11-14 08:41:27.760
// :EDITED:2013-09-18 15:39:05
// :ID:848
// :NUM:1178
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script requires the Super Prim Animator http://www.outworldz.com/cgi/freescripts.plx?ID=1519 by Fred Beckhusen (Ferd Frederix).  Just set up your animations as per the animator's instructions, Save it to a notecard put this script and the notecard into any prim and when you touch the prim it will print a new script into local chat. Copy everything between and including the lines /*---------- and ----------*/  anything that is not part of the script is automatically converted to comments.  When the script is run it will cycle through all the animations and print a llSetMemoryLimit() command to local chat.  Replace everything in the default state_entry function with that command and your script is ready to run.  with a very optimized memory limit.
// :CODE:
key notecardQueryId;

// Set this to an empty string if you don't want to use the fast forms
string fast="Fast";
 
// first notecard line is line 0
integer notecardLine;
list notecardLines;
list animations;

//print out a line of code with the timestamp and object name commented out
SayCode(string code){
    llOwnerSay("\n*/\n"+code+"\n/*");
}
default
{
    state_entry(){
        notecardLine = 0;
        notecardLines=[];
        animations = [];
    }
    touch_start(integer num)
    {
        llOwnerSay("Reading notecard. Please wait....");
        notecardQueryId = llGetNotecardLine("Movement", notecardLine);
    }
 
    dataserver(key query_id, string data)
    {
        if (query_id == notecardQueryId)
        {
            if (data == EOF){
                string code;
                integer i;
                for (i = 0; i < llGetListLength(animations); i++){
                    string animationName = llList2String(animations,i);
                    llOwnerSay(animationName);
                }
                llOwnerSay("Done reading notecard, read " + (string)(notecardLine + 1) + " notecard lines.");
                llOwnerSay("copy below this line and paste it into a new script\n/*----------");
                SayCode("integer playbackchannel = 1;");
                SayCode("rotation calcChildRot(rotation rdeltaRot){\n"+
                "\tif (llGetAttached())\n"+
                "\t\treturn rdeltaRot/llGetLocalRot();\n"+
                "\telse\n"+
                "\t\treturn rdeltaRot/llGetRootRotation();\n"+
                "}");
                
                // Go through the data until we find "start" to get the original scale
                for(i = 0; i < llGetListLength(notecardLines); i++){
                    list primList = llParseString2List(llList2String(notecardLines,i),["|"],[]);
                    if(llToLower(llList2String(primList,1)) == "start"){
                        SayCode("vector originalScale = " + llList2String(primList,2)+";");
                        llSleep(0.5);
                    }
                }
                // Go through each animation and create a function for each one
                for(i = 0; i < llGetListLength(animations); i ++){
                    integer j;
                    string animationName = llList2String(animations, i);
                    code= animationName+"(){\n"+
                        "\tvector currentSize = llGetScale();\n"+
                        "\tfloat scaleby = currentSize.x/originalScale.x;\n";
                    SayCode(code);
                    llSleep(0.5);
                    //Read through the list and print out the instructions for this animation
                    for(j=0; j< llGetListLength(notecardLines);j++){
                        string line = llList2String(notecardLines,j);
                        list data = llParseString2List(line,["|"],[]);
                        integer primNum = llList2Integer(data,2);
                        // Fixme negative numbers are supposed to be read as a delay
                        if(llList2String(data,1) == animationName){
                            if(primNum >1){
                                code = "\tllSetLinkPrimitiveParams"+fast+"("+llList2String(data,2)+
                                    ", [PRIM_POSITION, "+llList2String(data,3)+"*scaleby, "+
                                    "PRIM_ROTATION,calcChildRot("+llList2String(data,4)+"), "+
                                    "PRIM_SIZE, "+llList2String(data,5)+"*scaleby]);";
                                SayCode(code);
                                llSleep(0.5);
                            } else {

                                SayCode("\tllSleep("+(string)(primNum*-1)+");");
                                llSleep(0.5);
                            }
                        }
                    }
                    code="}";
                    SayCode(code);
                    llSleep(0.5);
                }
                
                code="default{\n"+
                "\tstate_entry(){\n"+
                "\t\t//Paste the SetMemoryLimit() line this script prints out here\n";
                for(i=0; i<llGetListLength(animations);i++){
                    code+="\t\t"+llList2String(animations,i)+"();\n"+
                    "\t\tllSleep(0.1);\n";
                }
                code += "\t\tinteger mem = llGetUsedMemory();\n"+
                "\t\tmem=llFloor((float)mem/(float)1024)+1;\n"+
                "\t\tmem=mem*1024;\n"+
                "\t\tllOwnerSay(\"llSetMemoryLimit(\"+string(mem) + \");\");\n"+
                "\t}\n";
                SayCode(code);
                llSleep(0.5);
                code = "link_message(integer sender_num, integer num, string message, key id){\n"+
                "\t\tif(num == playbackchannel){\n";
                for(i=0; i<llGetListLength(animations);i++){
                    code+="\t\t\tif(message == \""+llList2String(animations,i)+"\"){\n"+
                    "\t\t\t\t"+llList2String(animations,i)+"();\n"+
                    "\t\t\t}\n";
                }
                code += "\t\t}\n"+
                "\t}\n";
                SayCode(code);
                llSleep(0.5);
                SayCode("}");
                llSleep(0.5);
                llOwnerSay("\n----------*/\n");
            }
            else
            {
                // Split the line up so we can strip off the timestamp and object name
                list dList = llParseString2List(data,[":"],[]);
                string anidata = llList2String(dList,2);
                notecardLines+=anidata;

                // Store the name of the animation if it is not already stored
                list primList = llParseString2List(anidata,["|"],[]);
                integer i = llListFindList(animations, [llList2String(primList,1)]);
                string animationName = llList2String(primList,1);
                if(i<0 && animationName != llToLower("start")){
                    animations+= animationName;
                }
 
                ++notecardLine;
                notecardQueryId = llGetNotecardLine("Movement", notecardLine);
            }
        }
    }
}
