// :CATEGORY:Follower
// :NAME:Keyframe Follower
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:14:04
// :EDITED:2014-12-04
// :ID:1058
// :NUM:1685
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::A avatar folloer thaty works in Opensim 
// :CODE:

// Prim animation compiler //
// Fred Beckhusen (Ferd Frederix) - http://www.outworldz.com
integer playbackchannel = 1; // The default llMessageLinked number
rotation calcChildRot(rotation rdeltaRot){
    if (llGetAttached())
        return rdeltaRot/llGetLocalRot();
    else
        return rdeltaRot/llGetRootRotation();
}
vector originalScale = <0.500000,0.538383,0.122841>;
start(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.087677,-0.114227,0.461792>*scaleby, PRIM_ROTATION,calcChildRot(<-0.609178,0.109585,-0.422058,-0.662390>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <0.037659,0.127304,0.448509>*scaleby, PRIM_ROTATION,calcChildRot(<0.219442,-0.598803,-0.707861,-0.303665>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.248932,-0.022842,0.390663>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.208191,-0.023865,0.593697>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.170807,0.007278,0.770676>*scaleby, PRIM_ROTATION,calcChildRot(<-0.425973,-0.453797,-0.583492,-0.521682>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.269196,0.153488,0.131393>*scaleby, PRIM_ROTATION,calcChildRot(<0.673489,0.739048,0.014592,-0.002662>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.238129,-0.180237,0.123405>*scaleby, PRIM_ROTATION,calcChildRot(<0.673489,0.739048,0.014592,-0.002662>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.058289,0.000885,0.619575>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.685852,-0.073822,0.568771>*scaleby, PRIM_ROTATION,calcChildRot(<0.343354,0.529393,-0.638648,-0.440431>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.266113,0.017426,0.767509>*scaleby, PRIM_ROTATION,calcChildRot(<0.480481,0.544910,-0.484405,-0.487405>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);
    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.087677,-0.114227,0.461792>*scaleby, PRIM_ROTATION,calcChildRot(<-0.609178,0.109585,-0.422058,-0.662390>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <0.037659,0.127304,0.448509>*scaleby, PRIM_ROTATION,calcChildRot(<0.219442,-0.598803,-0.707861,-0.303665>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.218719,0.009628,0.739944>*scaleby, PRIM_ROTATION,calcChildRot(<-0.427263,-0.451559,-0.565432,-0.542058>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.248932,-0.022842,0.390663>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.208191,-0.023865,0.593697>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.170807,0.007278,0.770676>*scaleby, PRIM_ROTATION,calcChildRot(<-0.425973,-0.453797,-0.583492,-0.521682>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.269196,0.153488,0.131393>*scaleby, PRIM_ROTATION,calcChildRot(<0.673489,0.739048,0.014592,-0.002662>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.238129,-0.180237,0.123405>*scaleby, PRIM_ROTATION,calcChildRot(<0.673489,0.739048,0.014592,-0.002662>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.058289,0.000885,0.619575>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.685852,-0.073822,0.568771>*scaleby, PRIM_ROTATION,calcChildRot(<0.343354,0.529393,-0.638648,-0.440431>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.266113,0.017426,0.767509>*scaleby, PRIM_ROTATION,calcChildRot(<0.480481,0.544910,-0.484405,-0.487405>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);

}
up(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.090912,-0.115250,0.488297>*scaleby, PRIM_ROTATION,calcChildRot(<-0.571301,0.203143,-0.511319,-0.609017>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <0.034180,0.124954,0.478188>*scaleby, PRIM_ROTATION,calcChildRot(<0.315962,-0.519760,-0.698578,-0.376838>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.192596,0.005905,0.787628>*scaleby, PRIM_ROTATION,calcChildRot(<-0.439873,-0.449331,-0.557183,-0.542365>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.243927,-0.022400,0.388618>*scaleby, PRIM_ROTATION,calcChildRot(<-0.435345,-0.463711,-0.573662,-0.516100>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.224548,-0.024963,0.594780>*scaleby, PRIM_ROTATION,calcChildRot(<-0.435345,-0.463711,-0.573662,-0.516100>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.134186,0.002350,0.810455>*scaleby, PRIM_ROTATION,calcChildRot(<-0.398263,-0.422593,-0.604600,-0.545216>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.235901,0.155701,0.129883>*scaleby, PRIM_ROTATION,calcChildRot(<-0.674338,-0.735810,-0.052124,-0.033692>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.206360,-0.178177,0.122849>*scaleby, PRIM_ROTATION,calcChildRot(<-0.674338,-0.735810,-0.052124,-0.033692>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.037964,-0.002319,0.648422>*scaleby, PRIM_ROTATION,calcChildRot(<-0.435345,-0.463711,-0.573662,-0.516100>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.697296,-0.071335,0.519936>*scaleby, PRIM_ROTATION,calcChildRot(<0.376533,0.552553,-0.616614,-0.415567>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.229370,0.011810,0.817299>*scaleby, PRIM_ROTATION,calcChildRot(<0.505331,0.569515,-0.455223,-0.461590>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);

}

down(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.051270,-0.119080,0.387947>*scaleby, PRIM_ROTATION,calcChildRot(<-0.616118,-0.249108,-0.061690,-0.744673>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <-0.000458,0.118164,0.342796>*scaleby, PRIM_ROTATION,calcChildRot(<0.126331,0.785096,0.606198,-0.013762>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.276215,0.021240,0.579987>*scaleby, PRIM_ROTATION,calcChildRot(<-0.514895,-0.542889,-0.478441,-0.459618>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.263031,-0.024368,0.400383>*scaleby, PRIM_ROTATION,calcChildRot(<-0.535025,-0.577990,-0.467229,-0.401713>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.158661,-0.019775,0.579208>*scaleby, PRIM_ROTATION,calcChildRot(<-0.535025,-0.577990,-0.467229,-0.401713>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.256317,0.022430,0.623093>*scaleby, PRIM_ROTATION,calcChildRot(<-0.505677,-0.544017,-0.506403,-0.438055>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.403534,0.136917,0.245880>*scaleby, PRIM_ROTATION,calcChildRot(<0.544047,0.619465,-0.410714,-0.389347>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.368469,-0.196304,0.234009>*scaleby, PRIM_ROTATION,calcChildRot(<0.544047,0.619465,-0.410714,-0.389347>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.101135,0.010376,0.516800>*scaleby, PRIM_ROTATION,calcChildRot(<-0.535025,-0.577990,-0.467229,-0.401713>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.617218,-0.078888,0.711449>*scaleby, PRIM_ROTATION,calcChildRot(<0.232527,0.446810,-0.696616,-0.510900>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.345215,0.034195,0.588997>*scaleby, PRIM_ROTATION,calcChildRot(<0.393446,0.457487,-0.567698,-0.560022>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);

}
l(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.097198,-0.075089,0.464996>*scaleby, PRIM_ROTATION,calcChildRot(<-0.610849,0.073793,-0.464468,-0.636935>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <-0.013397,0.130600,0.480568>*scaleby, PRIM_ROTATION,calcChildRot(<0.304596,-0.436717,-0.820620,-0.207561>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.185455,0.106308,0.741096>*scaleby, PRIM_ROTATION,calcChildRot(<-0.313041,-0.560475,-0.664550,-0.382422>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.247375,-0.025650,0.390549>*scaleby, PRIM_ROTATION,calcChildRot(<-0.426620,-0.520168,-0.579640,-0.459825>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.208618,-0.020569,0.593903>*scaleby, PRIM_ROTATION,calcChildRot(<-0.426620,-0.520168,-0.579640,-0.459825>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.145599,0.082733,0.774300>*scaleby, PRIM_ROTATION,calcChildRot(<-0.311901,-0.562018,-0.677148,-0.358223>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.286621,0.145386,0.129936>*scaleby, PRIM_ROTATION,calcChildRot(<-0.627229,-0.778690,-0.014919,-0.001743>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.215210,-0.182129,0.124458>*scaleby, PRIM_ROTATION,calcChildRot(<-0.627229,-0.778690,-0.014919,-0.001743>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.052673,0.036484,0.621750>*scaleby, PRIM_ROTATION,calcChildRot(<-0.426620,-0.520168,-0.579640,-0.459825>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.676422,-0.128326,0.565483>*scaleby, PRIM_ROTATION,calcChildRot(<0.314587,0.549139,-0.664461,-0.397458>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.224701,0.136307,0.766090>*scaleby, PRIM_ROTATION,calcChildRot(<0.327529,0.627953,-0.605156,-0.363574>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);

}
r(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.032379,-0.189697,0.485855>*scaleby, PRIM_ROTATION,calcChildRot(<-0.433656,0.244167,-0.293339,-0.816258>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <0.062897,0.064178,0.445442>*scaleby, PRIM_ROTATION,calcChildRot(<0.143201,-0.617953,-0.674262,-0.378150>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.190155,-0.146484,0.731400>*scaleby, PRIM_ROTATION,calcChildRot(<-0.570039,-0.289957,-0.400416,-0.656238>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.250854,-0.017166,0.390953>*scaleby, PRIM_ROTATION,calcChildRot(<-0.521180,-0.438790,-0.490818,-0.543077>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.208527,-0.029999,0.593254>*scaleby, PRIM_ROTATION,calcChildRot(<-0.521180,-0.438790,-0.490818,-0.543077>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.148804,-0.125046,0.764168>*scaleby, PRIM_ROTATION,calcChildRot(<-0.568740,-0.291403,-0.423669,-0.641968>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.234741,0.162659,0.133804>*scaleby, PRIM_ROTATION,calcChildRot(<0.752611,0.658234,0.013841,-0.010679>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.279419,-0.169403,0.122025>*scaleby, PRIM_ROTATION,calcChildRot(<0.752611,0.658234,0.013841,-0.010679>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.057098,-0.065933,0.614891>*scaleby, PRIM_ROTATION,calcChildRot(<-0.521180,-0.438790,-0.490818,-0.543077>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.685516,0.028671,0.575882>*scaleby, PRIM_ROTATION,calcChildRot(<0.393302,0.487545,-0.584468,-0.515762>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.233948,-0.168625,0.757133>*scaleby, PRIM_ROTATION,calcChildRot(<0.588317,0.399276,-0.304246,-0.633953>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);

}
flame(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

    llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.088196,-0.110626,0.407928>*scaleby, PRIM_ROTATION,calcChildRot(<-0.640473,0.045866,-0.371975,-0.670317>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
    llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <0.033661,0.130173,0.401093>*scaleby, PRIM_ROTATION,calcChildRot(<0.162269,-0.625520,-0.722656,-0.245278>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
    llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.263824,0.017899,0.657967>*scaleby, PRIM_ROTATION,calcChildRot(<-0.469144,-0.502446,-0.526815,-0.499918>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
    llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.256744,-0.023636,0.395195>*scaleby, PRIM_ROTATION,calcChildRot(<-0.501839,-0.539748,-0.508385,-0.445392>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
    llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.181519,-0.021790,0.588120>*scaleby, PRIM_ROTATION,calcChildRot(<-0.501839,-0.539748,-0.508385,-0.445392>), PRIM_SIZE, <0.589556,0.165455,0.193329>*scaleby]);
    llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.221954,0.015411,0.696548>*scaleby, PRIM_ROTATION,calcChildRot(<-0.469526,-0.502998,-0.544790,-0.479314>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
    llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.323700,0.149353,0.141594>*scaleby, PRIM_ROTATION,calcChildRot(<0.667976,0.739942,-0.048001,-0.063163>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.290375,-0.184097,0.131683>*scaleby, PRIM_ROTATION,calcChildRot(<0.667976,0.739942,-0.048001,-0.063163>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
    llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.085114,0.006042,0.567261>*scaleby, PRIM_ROTATION,calcChildRot(<-0.501839,-0.539748,-0.508385,-0.445392>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
    llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.655640,-0.077042,0.646698>*scaleby, PRIM_ROTATION,calcChildRot(<0.286010,0.487603,-0.671454,-0.479157>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
    llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.315155,0.026520,0.676842>*scaleby, PRIM_ROTATION,calcChildRot(<0.436172,0.500618,-0.530054,-0.527426>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);

}

land(){
    vector currentSize = llGetScale();
    float scaleby = currentSize.x/originalScale.x;

llSetLinkPrimitiveParamsFast(2, [PRIM_POSITION, <0.019562,-0.132294,0.489136>*scaleby, PRIM_ROTATION,calcChildRot(<-0.643247,-0.238106,0.029780,-0.727085>), PRIM_SIZE, <0.113302,0.162322,0.173233>*scaleby]);
     llSetLinkPrimitiveParamsFast(3, [PRIM_POSITION, <0.002289,0.111328,0.452057>*scaleby, PRIM_ROTATION,calcChildRot(<0.221676,0.765056,0.604547,-0.008526>), PRIM_SIZE, <0.113450,0.162321,0.173603>*scaleby]);
  llSetLinkPrimitiveParamsFast(4, [PRIM_POSITION, <0.208649,0.010574,0.659607>*scaleby, PRIM_ROTATION,calcChildRot(<-0.549045,-0.600036,-0.418281,-0.404410>), PRIM_SIZE, <0.104103,0.056412,0.182692>*scaleby]);
     llSetLinkPrimitiveParamsFast(5, [PRIM_POSITION, <-0.248932,-0.022842,0.390663>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.355153,0.403545,0.704166>*scaleby]);
     llSetLinkPrimitiveParamsFast(6, [PRIM_POSITION, <-0.195221,-0.024368,0.447243>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.020789,0.025806,0.071206>*scaleby]);
     llSetLinkPrimitiveParamsFast(7, [PRIM_POSITION, <0.184235,0.009933,0.711060>*scaleby, PRIM_ROTATION,calcChildRot(<-0.553267,-0.597050,-0.435805,-0.384059>), PRIM_SIZE, <0.169087,0.180204,0.332219>*scaleby]);
     llSetLinkPrimitiveParamsFast(8, [PRIM_POSITION, <-0.133057,0.166061,0.136291>*scaleby, PRIM_ROTATION,calcChildRot(<-0.478108,-0.512276,-0.532899,-0.474346>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
     llSetLinkPrimitiveParamsFast(9, [PRIM_POSITION, <-0.101868,-0.167648,0.128334>*scaleby, PRIM_ROTATION,calcChildRot(<-0.478108,-0.512276,-0.532899,-0.474346>), PRIM_SIZE, <0.132253,0.167794,0.216373>*scaleby]);
     llSetLinkPrimitiveParamsFast(10, [PRIM_POSITION, <0.058289,0.000885,0.619575>*scaleby, PRIM_ROTATION,calcChildRot(<-0.461346,-0.493366,-0.550428,-0.490692>), PRIM_SIZE, <0.100213,0.183835,0.124935>*scaleby]);
     llSetLinkPrimitiveParamsFast(11, [PRIM_POSITION, <-0.685852,-0.073822,0.568771>*scaleby, PRIM_ROTATION,calcChildRot(<0.343354,0.529393,-0.638648,-0.440431>), PRIM_SIZE, <0.176529,0.009216,0.253571>*scaleby]);
     llSetLinkPrimitiveParamsFast(12, [PRIM_POSITION, <0.266113,0.017426,0.767509>*scaleby, PRIM_ROTATION,calcChildRot(<0.480481,0.544910,-0.484405,-0.487405>), PRIM_SIZE, <0.092038,0.092038,0.092038>*scaleby]);
 
}
default{

    state_entry(){
        llSetMemoryLimit(llGetUsedMemory() + 512);
        land();
    }

    link_message(integer sender_num, integer num, string message, key id){
   
       

        if(message == "up"){
            up();
        }
        else if(message == "down"){
            down();
        }
        else if(message == "l"){
            l();
        }
        else if(message == "r"){
            r();
        }
        else if(message == "flames"){
            flame();
        } 
        else if(message == "land"){
            land();
        }
    }

}
