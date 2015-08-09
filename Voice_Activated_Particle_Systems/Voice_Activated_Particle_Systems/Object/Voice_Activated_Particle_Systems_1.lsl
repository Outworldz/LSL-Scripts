// :CATEGORY:Particles
// :NAME:Voice_Activated_Particle_Systems
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:958
// :NUM:1380
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Voice Activated Particle Systems.lsl
// :CODE:

integer ON = FALSE;
//
// Put your choice of channel on the next line - this one uses 0
integer channel = 0;
//
// Change this next line to FALSE if you want anyone to be able to use it
integer owner_only = TRUE;
//
// Change this line to be the command to switch on particles
string TON = "on";
//
// change this line to be the command to switch off particles
string TOFF = "off";

particle_system_on()
{
    //
    // cut and paste your generated particle script here 
    //
}
particle_system_off()
{
    llParticleSystem( [] );
}

update_particles()
{
    if ( ON ) 
    {
        particle_system_on();
    }
    else
    {
        particle_system_off();
    }
}

init()
{
    llListen( channel,"","","" );
    llSetText( "",<0,0,0> ,0);
    //llSetText( ">>>Un comment this line & put your hover text in here if you wish<<<<",<1,1,1>,1);
    ON = FALSE;
    update_particles();
}
    
default
{
    state_entry() 
    {
        init();
    }
    on_rez( integer p )
    {
        llResetScript();
    }
    listen ( integer ch, string nm, key id , string mess )
    {
        if ( owner_only )
        {
            if ( id != llGetOwner() )
            {
                if ( llGetOwnerKey( id ) != llGetOwner() ) 
                {
                    return;
                }
            }
        }
        if ( mess == TON ) 
        {
            ON = TRUE;
            update_particles();
            return;
        }
        if ( mess == TOFF )
        {
            ON = FALSE;
            update_particles();
            return;
        }
    }
}
// END //
