integer TotalTouched = 0;
default
{
    state_entry()
    {
        
    }
    
    touch(integer num){
       TotalTouched = TotalTouched + num;
       if(TotalTouched>1){
           return;
        }
       llMessageLinked(LINK_ROOT, 0, "TOGVIS", "");
    }
    
    touch_end(integer num){
        TotalTouched = 0;
    }
}