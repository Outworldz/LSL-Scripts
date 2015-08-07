// :CATEGORY:Avatar Detector
// :NAME:Avatar Detector
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:48
// :ID:70
// :NUM:97
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Avatar-Detector with what they are doing
// :CODE:

string text; vector pos; integer many; 
key sub; 
integer info; 
key owner; 
list extra; 

default 
{ 
    on_rez(integer param) 
    { 
        llResetScript(); 
    } 
    
    state_entry() 
    { 
        owner = llGetOwner(); 
        llSetText("Scanning..", <1,0,0>, 1); 
        llSetTimerEvent(1); 
    } 

    timer() 
    { 
        llSensor("", "", AGENT, 20, PI); 
    } 
    
    no_sensor() 
    { 
        llSetText("Nobody Around~", <0,1,0>, 1); 
    } 
    
    sensor(integer num) 
    { 
        text = ""; 
        many = 1; 
        pos = llGetPos(); 
        integer x=0; 
        for(x;x<num;x++) 
        { 
            extra = []; 
            sub = llDetectedKey(x); 
            if(sub != owner) 
            { 
                info = llGetAgentInfo(sub); 
                if(info & AGENT_TYPING) extra += ["Typing"]; 
                if(info & AGENT_AWAY) extra += ["Away"]; 
                if(info & AGENT_BUSY) extra += ["Busy"]; 
                if(info & AGENT_FLYING) extra += ["Flying"]; 
                if(info & AGENT_MOUSELOOK) extra += ["Mouselook"]; 
                if(info & AGENT_ON_OBJECT) 
                { 
                    extra += ["SO"]; 
                } 
        
                else if(info & AGENT_SITTING) 
                { 
                    extra += ["SG"]; 
                } 
        
                if(info & AGENT_SCRIPTED) 
                { 
                    //    extra += ["SAT"]; 
                } 
            
                else if(info & AGENT_ATTACHMENTS) 
                { 
                    extra += ["AT"]; 
                } 
                if(info & AGENT_WALKING) extra += ["Walking"]; 
                if(info & AGENT_CROUCHING) extra += ["Crouching"]; 
                if(info & AGENT_ALWAYS_RUN) extra += ["Running"]; 
                
                text += (string)many + ") " + llDetectedName(x) + " (" + llDumpList2String(extra,",") + 
                ") - " + (string)(llRound(llVecDist(pos, llDetectedPos(x)))) + "mn"; 
                
                many++; 
            } 
        } 
        
        if(many == 1) text = "Nobody Around~"; 
        llSetText(text, <0,0,1>, 1); 
    } 
}     // end 
// CREATOR:

