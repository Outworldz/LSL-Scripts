 
float   Timeout     = 3600.;
key     Owner;

default
{
    state_entry() {
        Owner = llGetOwner();
    }
    
    link_message(integer sender, integer num, string str, key id) {
        
        if (str == "PRIMTOUCH") {
            return;
        }
        
        if (num == 0 && str == "POSEB") {
            llSetTimerEvent(Timeout);
            return;
        }

        if (num == 1 && str == "STOP") {
            llSetTimerEvent(0.);
            return;
        }
    }
    
    timer() {
        llMessageLinked(LINK_THIS, -12002, "STOP", (key)"");
        llSetTimerEvent(0.);
    }
    
    changed(integer change) {
        if ((change & CHANGED_OWNER) && llGetOwner() != Owner) {
            Owner = llGetOwner();
            llSetScriptState(llGetScriptName(), FALSE);
        }
    }
}
