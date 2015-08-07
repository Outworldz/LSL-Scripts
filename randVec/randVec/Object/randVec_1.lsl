// :CATEGORY:Vectors
// :NAME:randVec
// :AUTHOR:Vince Bosen
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:683
// :NUM:926
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Note that this is a function and will not work standalone. 
// :CODE:
vector randVec(float highBound){
    integer xSign=llRound(llFrand(1));
    integer ySign=llRound(llFrand(1));
    integer zSign=llRound(llFrand(1));
    float x = llFrand(highBound);
    float y = llFrand(highBound);
    float z = llFrand(highBound);
    if(xSign)x=-x;
    if(ySign)y=-y;
    if(zSign)z=-z;
    return <x,y,z>;
}
