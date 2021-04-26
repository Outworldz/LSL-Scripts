// :CATEGORY:Particles
// :NAME:Pawprints
// :AUTHOR:CyberGlo CyberStar
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
//drop this script in a prim with a texture and wear it on your foot.
// :CODE:

//PawPrints by CyberGlo CyberStar
//drop this script in a prim with a texture and wear it on your foot.
// you can make one for right and left foot if you like.
// texture should be named "Paw"
list gLstSys ;
default
{
    state_entry()
    {     gLstSys = [7, 125, 0, 256, 1, <0.00,0.00,0.00>, 3, <0.00,0.00,0.00>, 5, <0.40,0.20,0.70>, 6, <0.40,0.40,0.70>, 9, 1, 13, 0.50, 8, <0.00,0.00,0.00>, 15, 1, 16, 0.10, 17, 0.10, 20, "", 10, 1.54, 11, 1.55, 21, <0.00,0.00,10.00>, 19, 0, 12, "Paw", 2, llGetKey(), 4, 1];
        llSetTimerEvent(3.0);        
    }
    timer() {  llParticleSystem(gLstSys); }
}