// :CATEGORY:Color
// :NAME:Colors_Grader
// :AUTHOR:MeLight Korvin
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:198
// :NUM:271
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Colors Grader.lsl
// :CODE:

//Das MeLight Korvin's work
//Use freely and mod and whatever but don't be a schmuck and sell it as is
//How to use:
//1. Put this script in an object of at least 2 prims (the more the better, the grading will be smoother)
//2. now you have to command it to grade between any two RGB's, RGB's entered as integers (0-255 scale) lets say u wanna grade from red to blue
//the command will look like this: /12 grade 255 0 0 0 0 255
//first 3 values first RGB, and the ending 3 are of the second RGB (duh)
//if you having problemos lemmie know

list colCom;
default
{
    state_entry()
    {
        llListen(12, "", "", "");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(id != llGetOwner()) return; //remove the first '//' to make it work for owner only
        
        colCom = llParseString2List(message, [" "], []);
        if(llList2String(colCom,0) == "grade")
        {
            vector startCol = <llList2Float(colCom,1)/255, llList2Float(colCom,2)/255, llList2Float(colCom,3)/255>;
            vector endCol = <llList2Float(colCom,4)/255, llList2Float(colCom,5)/255, llList2Float(colCom,6)/255>;
            vector grades = <(endCol.x - startCol.x)/llGetNumberOfPrims(), (endCol.y - startCol.y)/llGetNumberOfPrims(), (endCol.z - startCol.z)/llGetNumberOfPrims()>;
            
            integer x;
            for(x = 1; x < llGetNumberOfPrims()+ 1; x++)
            {
                startCol += grades;
                llSetLinkColor(x, startCol, ALL_SIDES);
            }
        }
    }
}
// END //
