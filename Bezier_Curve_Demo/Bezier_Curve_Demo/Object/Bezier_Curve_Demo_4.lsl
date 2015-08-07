// :CATEGORY:Building
// :NAME:Bezier_Curve_Demo
// :AUTHOR:Lionel Forager
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:88
// :NUM:120
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// // Segment// Description// // The Segments are the prims drawn to make the lines of the bezier curve when you set lines mode on.// The prim should be a cylindre.
// 
// The Segment object should be in the inventory of the bezier server object, as it is rezzed from the script of that object.
// The bezier server object rezzed the cylindre, rotates it to orient it properly in the direction of the line and then gives it a command to initialize its size correctly (as the size of an object cannot be stablished when rezzed and the parameters of a prim can only be altered by itshelf).
// 
// Commands - How to use
// 
// Each segment object listens in the channel corresponding to its line number for clear commands to delete themselves.
// say "/line# clear": deletes all point marks.
// The segment object listen for seginit commands from the bezier server object in its line# channel addressed to its segment number.
// The channel number and segment number are coded in an integer that is passed to the segment when rezzed.
// In this example the line # is always 1.
// The command is:
// "/line# segment#,diam,size" where segment# is the number of the segment to be initilized, diam is the diameter fo the cylindre and size is its lenght.
// How to Create the Segment Object
// 
// Create a cylindre of any size, set a blank texture and choose its color. Save it with name Segment.
// Put the following script in it.
// Then, take the object to your inventory and copy it from there to the inventory of the bezier server object.
// :CODE:
//Author: Lionel Forager (c) 2007
//segmentServer 1.0.1
//This script is designed to work in conjunction with graphics sever 1.0
//It renders the segments in a line, resizing them, changing colors, etc.

//#### internal variables ###

//Line number that the segment belongs to.
//It is used as a line # id and it is the channel # to comunicate with the graphics server
integer lineNum;
integer segmentNum;
list parseCommands(string msg)
{
    msg= llToLower(msg);
    return llParseString2List(msg,[" ",","],[]);
}
default
{
    on_rez(integer param)
    {
        //get the line# and sement# coded in the param
        //line# is in 16 most significant bits
        lineNum= param>>16;
        //segment# is in 16 less significant bits. Clear 16 most significant bits.
        segmentNum= param^(lineNum<<16);

        if( (lineNum == 0)||(segmentNum==0) )
            llWhisper(0,"This object is not designed to be created directly, it works in collaboration with graphics server.");
        else llListen(lineNum,"",NULL_KEY,"");
    }
    
    listen(integer channel, string name, key id, string m)
    {
        //ignore commands not given by the owner.
        if (llGetOwnerKey(id) != llGetOwner()) return;
        list cmds= parseCommands(m);
        m= llList2String(cmds,0);
        if( m == "clear")
        {
            llDie();
        }
        else if (m=="seginit" ) {
            integer seg= llList2Integer(cmds,1);
            //if command is not for current segment, just ignore it.
            if( seg != segmentNum) return;
            float diam= llList2Float(cmds,2);
            float size= llList2Float(cmds,3);
            llSetScale(<diam,diam,size>);
        }
    }
}
