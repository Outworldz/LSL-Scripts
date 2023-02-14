vector test;
rotation rot;
integer hidden = FALSE;
default
{
    state_entry()
    {

    }
    
    link_message(integer sender, integer num, string msg, key id){
        if(msg=="TOGVIS"){
            if(hidden){
//            test.x = 0;
//            test.z = 0;
//            test.y = -0.5 * PI;
//            rot = llEuler2Rot(test);
              rot = llEuler2Rot(<0.000000,-1.570796,0.000000>);
              llSetLocalRot(rot);
            }else if(!hidden){
                llSetLocalRot(ZERO_ROTATION);
            }
            hidden = !hidden;
        }
    }
}