// :SHOW:
// :CATEGORY:Tree 
// :NAME:Advanced Tree Planter
// :AUTHOR:CyberGlo CyberStar
// :KEYWORDS:
// :CREATED:2021-04-26 23:30:44
// :ID:1130
// :NUM:2020
// :REV:3.1
// :WORLD:Opensim
// :DESCRIPTION:
// This device will plant an entire forrest in the 0,0 to 256,256 range (can be changed).  It will plant trees at different heights in accordance with the land height level. 
// :CODE:

// This device will plant an entire forrest in the 0,0 to 256,256 range (can be changed).  It will plant trees at different heights in accordance with the land height level. 
// You've never seen a forrest like this, it's truly beautiful when finished.
// Be sure to understand this script fully.  
// step 1:  put script in cube
// step 2:  put several varieties of FULL COPY Trees in the cube.
// step 3:  click the cube.
// Note:  If I were you I would make all the trees you put in the cube phantom, this makes it much easier on the physics engine of your simulator.

// For LSLEditor testing
//float osGetTerrainHeight(float x, float y) {
//    return 20;
//}

integer gIntX;
integer gIntY;
integer gIntZ;

integer gIntStartX;
integer gIntStartY;
integer gIntEndX;
integer gIntEndY;
rotation gRotRelative = <0.707107, 0.0, 0.0, 0.707107>;

float gFltPlantProbability;
float gFltRandMax;

default
{
    state_entry()
    {
    }    
    
    touch_start(integer param)
    {
        gIntStartX=0;
        gIntStartY=0;
        gIntEndX = 256;
        gIntEndY = 256;
        gFltPlantProbability = .5;
        integer count = llGetInventoryNumber(INVENTORY_OBJECT);
        gFltRandMax = (float)count;
        gIntZ = 0;
        string gStrTreeName;
        for (gIntStartX=2;gIntStartX<gIntEndX;gIntStartX+=4)
        {
            for (gIntStartY=2;gIntStartY<gIntEndY;gIntStartY+=4)
            {
                gIntX =  gIntStartX;
                gIntY =  gIntStartY;
                llSetRegionPos(<gIntX,gIntY,gIntZ>);
                //llOwnerSay((string)gIntX + "   " +(string)gIntY);
                llSetText("X: " + (string)gIntX + " Y: " + (string)gIntY+ " Z: " + (string)gIntZ, <1,1,1>, 1.0);
                integer gIntTreePick = (integer) llFrand(gFltRandMax+1);
                float fltDoIRez = llFrand(1.0);
                if (fltDoIRez < gFltPlantProbability) 
                {
                    gStrTreeName = llGetInventoryName(INVENTORY_OBJECT,gIntTreePick);
                    llSleep(3.0);
                    if (gStrTreeName != "")
                    {
                        vector vecNowPos = llGetPos();
                        float fltLandHeight = osGetTerrainHeight(vecNowPos.x,vecNowPos.y);
                        integer intNewX = (integer)vecNowPos.x;
                        integer intNewY= (integer)vecNowPos.y;
                        integer intNewZ=(integer)fltLandHeight;
                        vecNowPos = <intNewX,intNewY, intNewZ>;
                        llSetRegionPos(vecNowPos);
                           
                        llOwnerSay("I planted: " + gStrTreeName);
                        if (gStrTreeName == "TreeSP")
                        {
                             llRezObject(gStrTreeName, llGetPos() + <0.0,0.0,3.0>, <0.0,0.0,0.0>, <0.0,0.0,0.0,1.0>, 0);
                        }
                        else
                        {
                            llRezObject(gStrTreeName, llGetPos() + <0.0,0.0,8.5>, <0.0,0.0,0.0>, gRotRelative, 0);
                        }
                        llSleep(3.0);
                    }
                }
            }
        }
        llOwnerSay("I have finished planting Trees.");
    }
}