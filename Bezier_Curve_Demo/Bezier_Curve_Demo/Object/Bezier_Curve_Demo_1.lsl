// :CATEGORY:Building
// :NAME:Bezier_Curve_Demo
// :AUTHOR:Lionel Forager
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:88
// :NUM:117
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This set of scripts will draw a bezier curve segment controlled by 3 control points.// // It tries to be the foundation of a more general graph server in SL.// // The idea and first version of the bezier curve demo script, was given to me by CatherineOmega. She had a working script that rezzed small spheres in each point position.// Then i added some modifications and the possibility of drawing segments made up of cylinders to rezz a line instead of just points.
// 
// The complete bezier server consists of several parts:
// 
//     * Server:An object that controls and creates the graph. We call this
//     * Control Points p1,p2,p3: control points that controls the begining, direction and end of the bezier segments.
//     * Point Mark: the object (may be a sphere or other) contained in the server that is rezzed in each created point mark position.
//     * Segment: the object (a cylinder) contained in the server that is rezzed when a line segments are required instead of point marks.
// 
// 
// A description of each part will be given.
// 
// 
// Server object
// 
// Description
// 
// The server object is the one which calculates the point coordinates interpolated using a bezier curve.
// It rezzes the segments or point marks.
// It shows the positions of the three control points in its display text.
// Commands to it are given in the channel 1.
// It receives the positions in that channel from the control points, and when it has all three, draws the curve.
// When a new position is received from a control point, it clears the previously rezzed objects and draws new ones.
// The server knows which control point has moved by the name of the object that has said the command it receives.
// 
// Commands - How to use
// 
// Once you have rezzed the bezier server, you can say commands to it through channel #1 to control its behaviour.
// Commands are:
// 
//     * "/1 markers on": activate the drawing of markers. This is the default option.
//     * "/1 markers off": deactivate them.
//     * "/1 lines on": activate the drawing of a line made of segments.
//     * "/1 lines off": deactivate the drawing of segments. This is the default option.
//     * "/1 segments n": set the number of segments that should be drawn to n.
//     * "/1 start": this command forces the drawing of the curve.
//     * "/1 mu float": draws a point corresponding to the given value of mu parameter.
// 
// 
// How to create de server
// 
// To create the bezier demo server object, create a prim that you like and put the following script in its inventory.
// Then you should create the segment and point mark objects (see descriptions below) and put them in the inventory of the server object too (see bellow).
// :CODE:
// Bezier Curve Demo 1.0.1
// Catherine Omega Heavy Industries
// Modified by Lionel Forager 29-12-2006: Added segment drawing between points. Corrected minor bugs.

key gOwner; // object owner

float diam=0.05; //diameter of line segments.

list gPoints; // list of vectors to feed to bezier3
string gObject="Point Mark"; // name of object to rez as the mark in each point
string gSegment="Segment"; // name of object to rez as the mark in each point

integer gNumSegments = 10; // number of segments to rez
integer gMarks= TRUE; //Draw marks in the point positions.
integer gLines= FALSE; //Don't draw segments between points.

float gMu;
vector gPos1;
vector gPos2;
vector gPos3;

//codes a line number and a segment in a unique ID integer
integer codeID(integer line, integer segment)
{
    //Code de id: line# in 16 most significant bits, segment# in 16 less significant bits
    return ( (line << 16) + segment);
}
//Rezz a segment between 2 given points and assigning it to a line # and a segment #
drawLineSegment(vector p1,vector p2,integer line,integer seg)
{
    //Calc the position of the center of the segment
    vector center= (p1+p2)/2.;
    vector localZ= p2 - p1;
    //Get distance between points
    float distance= llVecMag(localZ);
    //Normalize the vector
    localZ= localZ / distance;

    vector xAxis;
    //Let's choose as x local axis the direction of a vector normal to localZ and
    //contained in the plain given by localZ and global X or global Y, the one that is less parallel to localZ
    if ( localZ.x < localZ.y ) xAxis= <1.,0.,0.>;
    else xAxis= <0.,1.,0.>;
    //localX is the one contain in the plane given by localZ and xAxis that is normal to localZ.
    //that's it localX= xAxis - localZ*xaxis*localZ. We should normalize the vector to get a unitary one.
    vector localX= xAxis - (localZ * xAxis) * localZ;
    localX= llVecNorm(localX);
    //Now get the rotation to put axis Z oriented pointing to the direction between the two given points.
    rotation rot= llAxes2Rot(localX,localZ % localX, localZ);    
    //Crear el objeto en la posici?n del server.
    llRezObject(gSegment,center,ZERO_VECTOR,rot,codeID(line,seg));
    llSay(line,"segInit "+(string)seg+","+(string)diam+"," + (string)distance);

}
//Three control point Bezier interpolation
//mu ranges from 0 to 1, start to end of the curve
vector bezier3(vector p1, vector p2, vector p3, float mu)
{
   float mum1;
   float mum12;

   float mu2;
   vector p;

   mu2 = mu * mu;
   mum1 = 1 - mu;
   mum12 = mum1 * mum1;
   
   // p= (1-mu)^2 p1 + 2*mu*(1-mu)*p2 + mu^2 * p3
   p.x = p1.x * mum12 + 2. * p2.x * mum1 * mu + p3.x * mu2;
   p.y = p1.y * mum12 + 2. * p2.y * mum1 * mu + p3.y * mu2;
   p.z = p1.z * mum12 + 2. * p2.z * mum1 * mu + p3.z * mu2;

   return(p);
}

start(integer segments)
{
     if (gPos1 != ZERO_VECTOR && gPos2 != ZERO_VECTOR && gPos3 != ZERO_VECTOR)
    {
        gNumSegments = segments;
        float increment = 1.0 / gNumSegments;
        
        float current_mu;
        
        integer i;
        vector oldPos= gPos1;
        vector pos;

        //Render the mark at the position of the first point
        if( gMarks ) llRezObject(gObject,gPos1,ZERO_VECTOR,ZERO_ROTATION,0);

        for (i = 1; i <= gNumSegments; i++)
        {
            current_mu= i * increment;
            pos = bezier3(gPos1,gPos2,gPos3,current_mu);
            if(gMarks) llRezObject(gObject,pos,ZERO_VECTOR,ZERO_ROTATION,0);
            if( gLines ) drawLineSegment(oldPos,pos,1,i);
            oldPos= pos;
        }
    }
}

updateText()
{
    vector color = <1,0,0>;
    if (gPos1 != ZERO_VECTOR && gPos2 != ZERO_VECTOR && gPos3 != ZERO_VECTOR)
    {
        color = <0,1,0>;
    }
    
    string output = (string)gPos1 + "\n" + (string)gPos2  + "\n" + (string)gPos3;
    llSetText(output, color, 1.0);
}

// get gCommand and gSubCommand (now improved to handle null gSubCommands.)
string gCommand;
string gSubCommand;

string gCommandLower;
string gSubCommandLower;

parseCommands(string input, string divider)
{
    integer command_divide = llSubStringIndex(input,divider);
    if (command_divide == -1)
    {
        gCommand = llGetSubString(input, 0, command_divide);
        gSubCommand = "";
    }
    else
    {
        gCommand = llGetSubString(input, 0, command_divide - 1);
        gSubCommand = llGetSubString(input, command_divide + 1, llStringLength(input));
    }
    
    gCommandLower = llToLower(gCommand);
    gSubCommandLower = llToLower(gSubCommand);
}

default
{
    state_entry()
    {
        gOwner = llGetOwner();
        //gObject = llGetInventoryName(INVENTORY_OBJECT,0);
        
        updateText();
        
        llListen(1,"","","");
        llSay(0,"Online.");
    }
    
    listen(integer channel, string name, key id, string m)
    {
        if (llGetOwnerKey(id) == gOwner)
        {
            if (id == gOwner)
            {
                parseCommands(m," ");
                
                if (gCommandLower == "mu")
                {
                    vector pos = bezier3(gPos1,gPos2,gPos3,(float)gSubCommand);
                    llRezObject(gObject,pos,ZERO_VECTOR,ZERO_ROTATION,0);
                }
                
                else if (gCommandLower == "start")
                {
                    start((integer)gSubCommand);
                    
                    llSay(0,"Done.");
                }
                
                else if (gCommandLower == "segments")
                {
                    gNumSegments = (integer)gSubCommand;
                }
                else if (gCommandLower == "markers")
                {
                    if( gSubCommand != "off" ) {
                        gMarks= TRUE;
                        llSay(0,"Markers on");
                    }
                    else {
                        gMarks=FALSE;
                        llSay(0,"Markers off");
                    }

                }
                else if (gCommandLower == "lines")
                {
                    if( gSubCommand != "off" ) {
                        gLines= TRUE;
                        llSay(0,"Lines on");
                    }
                    else {
                        gLines=FALSE;
                        llSay(0,"Lines on");
                    }
                }
            }
            
            else
            {
                // make sure it's actually a vector
                if ((vector)m != ZERO_VECTOR)
                {
                    if (llToLower(name) == "p1")
                    {
                        gPos1 = (vector)m;
                        llSay(1,"clear");
                        updateText();
                        start(gNumSegments);
                    }
                    
                    else if (llToLower(name) == "p2")
                    {
                        gPos2 = (vector)m;
                        llSay(1,"clear");
                        updateText();
                        start(gNumSegments);                        
                    }
                    
                    else if (llToLower(name) == "p3")
                    {
                        gPos3 = (vector)m;
                        llSay(1,"clear");
                        updateText();
                        start(gNumSegments);
                    }
                }
            }
        }
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
