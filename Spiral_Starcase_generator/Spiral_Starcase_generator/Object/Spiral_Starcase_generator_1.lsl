// :CATEGORY:Stairs
// :NAME:Spiral_Starcase_generator
// :AUTHOR:Meyermagic Salome
// :CREATED:2010-12-27 12:13:52.583
// :EDITED:2013-09-18 15:39:05
// :ID:826
// :NUM:1150
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Generator// // Drop this in the generator prim, along with the step, banister, and baluster. 
// :CODE:
////////////////////////////////
// Spiral Staircase Generator //
// By Meyermagic Salome       //
////////////////////////////////
// Staircase Configuration //
float wh = 2.5;	//Height of one wave (in meters)
float wc = 4.0;	//Full waves in staircase
 
float r_max = 10.0;	//Radius maximum, (0.1 -> 10.0)
float r_min = 7.5;	//Radius minimum, (0.1 -> 10.0)
 
integer landing = 5;	//Number of non-rising stairs at top of staircase (not included in wc)
 
//Step Configuration
float s_h = 0.01;	//Step height, (0.01 -> 0.99)
float s_s = 0.2;	//Vertical stair spacing, (0.01 -> 10.00)
 
float l_max = 1.0;	//Maximum stair length, (0.01 -> 10.00)
float l_min = 0.5;	//Minimum stair length, (0.01 -> 10.00)
 
//Balustrade Configuration
float bal_d = 0.05;	//Baluster diameter, (0.001 -> 1.000)
float bal_h = 0.5;	//Height of baluster / height of banister, (0.01 -> 1.00)
 
float ban_d = 0.05;	//Banister diameter, (0.001 -> 1.000)
float ban_h = 2.0;	//Banister height, (0.01 -> 10.00)
 
// Functions //
string str_repeat(string src, integer count)
{
    if(count > 0)
    {
        string output;
        integer i;
        for(i = 0; i < count; i++)
        {
            output += src;
        }
        return output;
    }
    else
    {
        return "";
    }
}
 
string pad_left(string str, string pad, integer len)//Left-pads string str to length len with character pas
{
    return str_repeat(pad, len - llStringLength(str)) + str;
}
list segment(vector a, vector b)//Returns the parameters for a cylinder connecting points a and b
{//Based on http://lslwiki.net/lslwiki/wakka.php?wakka=LibraryBezierCurveDemo
    vector mid = (a + b) / 2.0;
    vector localZ = b - a;
 
    float len = llVecMag(localZ);
 
    localZ = localZ / len;
 
    vector xAxis;
 
    if(localZ.x < localZ.y)
    {
        xAxis = <1.0, 0.0, 0.0>;
    }
    else
    {
        xAxis= <0.0, 1.0, 0.0>;
    }
 
    vector localX = xAxis - (localZ * xAxis) * localZ;
    localX = llVecNorm(localX);
 
    rotation rot = llAxes2Rot(localX, localZ % localX, localZ);
 
    return [len, mid, rot];
}
 
//Staircase-specific Functions
float wave(integer i)//Return i as portion of full wave (2PI)
{
    return PI * (float)i * s_s / wh;
}
float radius(integer i)//Return the stair radius at step i
{
    return llFabs(((llCos(wave(i)) + 1.0) * ((r_max - r_min) / 2)) + r_min);
}
float len(integer i)//Returns the length of stair at step i
{
    return llFabs(((llCos(wave(i)) + 1.0) * ((l_max - l_min) / 2)) + l_min);
}
float rot(integer i)//Returns the rotation of stair at step i
{
    return llAcos(1 - llPow(len(i), 2.0) / (2 * llPow(radius(i), 2)));
}
 
integer s_encode(integer i)
{
    return (integer)("1" + pad_left((string)llRound(s_h * 100.0), "0", 2) + pad_left((string)llRound(radius(i) * 10.0), "0", 3) + pad_left((string)llRound(len(i) * 100.0), "0", 4));
}
integer p_encode(float h)
{
    return (integer)("1" + pad_left((string)llRound(bal_d * 1000.0), "0", 4) + pad_left((string)llRound(h * 1000.0), "0", 5));
}
integer r_encode(float l)
{
    return (integer)("1" + pad_left((string)llRound(ban_d * 1000.0), "0", 4) + pad_left((string)llRound(l * 1000.0), "0", 5));
}
 
default
{
    touch_start(integer num_detected)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            integer i = 0;
            float t = 0.0;
 
            //Rez main rising steps
            for(i = 0; i < (integer)(wc * wh / s_s); ++i)
            {
                llSetPos(llGetPos() + <0, 0, s_s>);//I'll have it do this every ~10m when I get around to it
 
                float c_rot = rot(i);
                float c_radius = radius(i);
                float n_radius = radius(i + 1);
                vector m_pos = llGetPos();
 
                //Rez step
                llRezObject("Step",
                    m_pos + <llCos(t + c_rot / 2.0) * c_radius / 2.0, llSin(t + c_rot / 2.0) * c_radius / 2.0, 0>,
                    ZERO_VECTOR,
                    llEuler2Rot(<PI_BY_TWO, t + c_rot / 2.0 + 4.7123889, 0>),
                    s_encode(i));
 
                //Get balustrade data
                list b_data = segment(m_pos + <llCos(t) * c_radius, llSin(t) * c_radius, ban_h + (s_h / 2.0)>,
                    m_pos + <llCos(t + c_rot) * n_radius, llSin(t + c_rot) * n_radius, ban_h + (s_h / 2.0) + s_s>);
                if(i == (integer)(wc * wh / s_s) - 1)
                {
                    b_data = segment(m_pos + <llCos(t) * c_radius, llSin(t) * c_radius, ban_h + (s_h / 2.0)>,
                        m_pos + <llCos(t + c_rot) * n_radius, llSin(t + c_rot) * n_radius, ban_h + (s_h / 2.0)>);
                }
                vector b_pos = llList2Vector(b_data, 1);
 
                //Rez banister
                llRezObject("Banister",
                    b_pos,
                    ZERO_VECTOR,
                    llList2Rot(b_data, 2),
                    r_encode(llList2Float(b_data, 0)));
 
                //Rez baluster
                llRezObject("Baluster",
                    <b_pos.x, b_pos.y, m_pos.z + ((b_pos.z - m_pos.z) / 2.0) + (s_h / 2.0)>,
                    ZERO_VECTOR,
                    ZERO_ROTATION,
                    p_encode((b_pos.z - m_pos.z) * bal_h));
 
                //Increment rotation
                t += rot(i);
            }
 
            //Rez non-rising steps
            for(i = (integer)(wc * wh / s_s); i < (integer)(wc * wh / s_s) + landing; ++i)
            {
                float c_rot = rot(i);
                float c_radius = radius(i);
                float n_radius = radius(i + 1);
                vector m_pos = llGetPos();
 
                //Rez step
                llRezObject("Step",
                    m_pos + <llCos(t + c_rot / 2.0) * c_radius / 2.0, llSin(t + c_rot / 2.0) * c_radius / 2.0, 0>,
                    ZERO_VECTOR,
                    llEuler2Rot(<PI_BY_TWO, t + c_rot / 2.0 + 4.7123889, 0>),
                    s_encode(i));
 
                //Get balustrade data
                list b_data = segment(m_pos + <llCos(t) * c_radius, llSin(t) * c_radius, ban_h + (s_h / 2.0)>,
                    m_pos + <llCos(t + c_rot) * n_radius, llSin(t + c_rot) * n_radius, ban_h + (s_h / 2.0)>);
                vector b_pos = llList2Vector(b_data, 1);
 
                //Rez banister
                llRezObject("Banister",
                    b_pos,
                    ZERO_VECTOR,
                    llList2Rot(b_data, 2),
                    r_encode(llList2Float(b_data, 0)));
 
                //Rez baluster
                llRezObject("Baluster",
                    <b_pos.x, b_pos.y, m_pos.z + ((b_pos.z - m_pos.z) / 2.0) + (s_h / 2.0)>,
                    ZERO_VECTOR,
                    ZERO_ROTATION,
                    p_encode((b_pos.z - m_pos.z) * bal_h));
 
                //Increment rotation
                t += rot(i);
            }
        }
    }
}
