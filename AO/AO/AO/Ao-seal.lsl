// Low Lag AO by Casper Warden // Completely license free

// This script was created on K-Grid and is free to use or modify

// ABOUT THIS SCRIPT
// -----------------
//
// This is an animation overrider optimised for use on K-Grid.  We don't use
// complicated list parsing, and we don't have a timer firing every 0.5 seconds
// like other AO's.
// 
// All configuration is done in the notecard "AOConfig".
// Use a format of
//
// [AnimationState (e.g Walking)]
// Animation one 
// Animation two
// Animation three
// 
// [AnimationState] ... etc etc
//
// The animations will be selected randomly. You can have more than one animation
// per state.

// DO NOT MODIFY THIS SCRIPT UNLESS YOU KNOW WHAT YOU'RE DOING
// THE ONLY CONFIG YOU NEED IS IN THE 'AOConfig' NOTECARD

// LSLEDitor specific
integer CHANGED_ANIMATION = 1;


//Since list functions are unreliable we're going to use a different list for each anim type
  
list Walking;
list Running;
list CrouchWalking; 
list Flying;
list Jumping;
list HoveringDown;
list HoveringUp;
list Crouching;
list FlyDown;
list Standing;
list Hovering;
list Sitting;
list SoftLanding;
list PreJumping;
list Falling;
list Landing;
list StandingUp;
list FlyingSlow;
list SittingonGround;
list Floating;
list SwimmingForward;
list SwimmingUp;
list SwimmingDown;

integer aoon=TRUE;
integer radaron=TRUE;
integer siton=TRUE;
integer sittinganywhere=FALSE;



key gQueryID;
integer gLine=0;
string currentmode;
string lastactive="";
string lastactiveanim="";


DoHuman()
{
    llMessageLinked(LINK_SET,0,"particle","");    // tell the particles to run
    llSetTexture("transparent", ALL_SIDES);
 
}

DoAnimal()
{
   llMessageLinked(LINK_SET,0,"particle","");
   llSetTexture("38b86f85-2575-52a9-a531-23108d8da837", ALL_SIDES);   
}


string GetAnimationFromState(string s) {
    integer cancel=FALSE;
    if (sittinganywhere==TRUE)
    {
            s="Sitting on Ground";
    }
    
    list animselect;    
    if (s=="Walking") {
        animselect = Walking;
    } else if (s=="Running") {
        animselect = Running;
    } else if (s=="CrouchWalking") {
        animselect = CrouchWalking;
    } else if (s=="Flying") {
        animselect = Flying;
    } else if (s=="Jumping") {
        animselect = Jumping;
    } else if (s=="Hovering Up") {
        animselect = HoveringUp;
    } else if (s=="Crouching") {
        animselect = Crouching;
    } else if (s=="FlyDown") {
        animselect = FlyDown;
    } else if (s=="Standing") {
       // llOwnerSay("STANDING");
       // llOwnerSay(llList2CSV(Standing));
        animselect = Standing;
    } else if (s=="Hovering Down") {
        animselect = HoveringDown;
    } else if (s=="Hovering") {
        animselect = Hovering;
    } else if (s=="Sitting") {
        if (siton==TRUE)
        {
            animselect = Sitting;
        }
        else
        { 
            cancel=TRUE;
        }
    } else if (s=="PreJumping") {
        animselect = PreJumping;
    } else if (s=="Falling") {
        animselect = Falling;
    } else if (s=="Soft Landing") {
        animselect = SoftLanding;
    } else if (s=="Landing") {
        animselect = Landing;
    } else if (s=="Standing Up") {
        animselect = StandingUp;
    } else if (s=="Flying Slow") {
        animselect = FlyingSlow;
    } else if (s=="Sitting on Ground") {
        if (sittinganywhere==TRUE)
        {
            if (SittingonGround==[])
            {
                animselect=["sit_ground"];    
            }
            else
            {
                animselect = SittingonGround;
            }   
        }
        else
        {
         animselect = SittingonGround;    
        }
    } else if (s=="Floating") {
        animselect = Floating;
    } else if (s=="Swimming Forward") {
        animselect = SwimmingForward;
    } else if (s=="Swimming Up") {
        animselect = SwimmingUp;
    } else if (s=="Swimming Down") {
        animselect = SwimmingDown;
    } else {
        //llOwnerSay("Unknown state: "+s);
        return "";    
    }
    if (cancel==TRUE)
    {
        return lastactiveanim;  

    } else {    
        animselect=llListRandomize(animselect, 1);
        return llList2String(animselect,0);
    }
    
}
StopAllAnims(){

integer x;
list h=llGetAnimationList(llGetOwner());
for (x=0; x<llGetListLength(h); x++)
{
    llStopAnimation(llList2String(h,x));   
    
}
        
    
}
doAOCheck() {
    //llOwnerSay("Doing check");
  string check=llGetAnimation(llGetOwner());
  
  
  
 
  if (check!=lastactive) {    
     lastactive=check;
     if (check!="") {
         string getAnim=GetAnimationFromState(check);
         
         
          vector apos = llGetPos();
          float z = apos.z;
          if (z < 20 && check == "Flying")
                getAnim = llList2String(SwimmingForward,0);
        
  
  
  
         //llOwnerSay(getAnim);
         if (lastactiveanim!=getAnim) {
            if (lastactiveanim!="") {
                llStopAnimation(lastactiveanim);
            }
            lastactiveanim=getAnim;  
            llStartAnimation(lastactiveanim);  
            float vz;
            vector pos;
            float diff=1.0;
            integer count=0;
            if (check=="Jumping") {

        
                @to;
                    pos=llGetPos();    
                    vz=pos.z;
                    llSleep(0.2);
                    pos=llGetPos();
                    diff=pos.z - vz;

                if (diff>0.1 || diff < -0.1) {
                    jump to;   
                } else {
                    count++;  
                    if (count<3) {
                        jump to;
                    }  
                }
                

                doAOCheck();
            }
         }   
    }
  }
}
default
{

    state_entry()
    {
        llSetText("",<1.0,1.0,1.0>,1.0);
        llSetTimerEvent(30.0);
        llOwnerSay("Reading notecard (will retry in 30 seconds).");
        if (llGetInventoryType("AOConfig")==INVENTORY_NONE) {
            llOwnerSay("Can't start AO: Notecard 'AOConfig' is missing");
        } else {
            gQueryID = llGetNotecardLine("AOConfig",0);
        }
    }
    timer() 
    {
        llResetScript();    
    } 
    touch_start(integer j)
    {
        llResetScript();    
    }
     dataserver(key query_id, string data) {
        if (query_id == gQueryID) {
            if (data != EOF) {    // not at the end of the notecard
                gLine++;
                gQueryID = llGetNotecardLine("AOConfig", gLine);    // request next line
                data=llStringTrim(data,STRING_TRIM);
                if (data!="") {
                    
                    if (llGetSubString(data,0,0)=="[") {
                        currentmode=llToLower(data); 
                    } else {
                        if (llGetInventoryType(data)==INVENTORY_NONE) {
                                llOwnerSay("NOT ADDED: "+data+" - Not found in inventory");
                            } else {
                        //Decipher which mode we're in
                        
                        
                         if (currentmode=="[walking]") {
                             Walking+=[data];
                         } else if (currentmode=="[running]") {
                             Running+=[data];
                         }    else if (currentmode=="[crouchwalking]") {
                             CrouchWalking+=[data];
                         }    else if (currentmode=="[flying]") {
                             Flying+=[data];
                         }    else if (currentmode=="[jumping]") {
                             Jumping+=[data];
                         }    else if (currentmode=="[hovering up]") {
                             HoveringUp+=[data];
                         }    else if (currentmode=="[crouching]") {
                             Crouching+=[data];
                         }    else if (currentmode=="[fly down]") {
                             FlyDown+=[data];
                         }    else if (currentmode=="[standing]") {
                             Standing+=[data];
                         }    else if (currentmode=="[hovering down]") {
                             HoveringDown+=[data];
                         }    else if (currentmode=="[hovering]") {
                             Hovering+=[data];
                         }    else if (currentmode=="[sitting]") {
                             Sitting+=[data];
                         }    else if (currentmode=="[prejumping]") {
                             PreJumping+=[data];
                         }    else if (currentmode=="[falling]") {
                             Falling+=[data];
                         }    else if (currentmode=="[landing]") {
                             Landing+=[data];
                         }    else if (currentmode=="[soft landing]") {
                             SoftLanding+=[data];
                         }    else if (currentmode=="[standing up]") {
                             StandingUp+=[data];
                         }    else if (currentmode=="[flyingslow]") {
                             FlyingSlow+=[data];
                         }    else if (currentmode=="[sitting on ground]") {
                             SittingonGround+=[data];
                         }    else if (currentmode=="[floating]") {
                             Floating+=[data];
                         }    else if (currentmode=="[swimming forward]") {
                             SwimmingForward+=[data];
                         }    else if (currentmode=="[swimming up]") {
                             SwimmingUp+=[data];
                         }    else if (currentmode=="[swimming down]") {
                             SwimmingDown+=[data];
                         }  else {
                           // llOwnerSay("Unknown mode: "+currentmode);   
                        }
                        
                    } 
                    }
                }
                
            } else {
                state Perms;   
            }
        }
    }

    
}
state Perms
{

    state_entry() {
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
    
    }
    run_time_permissions(integer h) {
        if (!(h & PERMISSION_TRIGGER_ANIMATION)) {
                llOwnerSay("Can't function without permissions. Touch to reset.");
        } else {
                state On;    
        }
    }
    touch_start(integer j) {
        llResetScript();    
    }
        
}
state On
{
    
    state_entry() {
        llOwnerSay("AO is now active"); 
        StopAllAnims();  
        //llMinEventDelay(0.5);

        doAOCheck();
        llListen(-9000, "", llGetOwner(), "");
        llSetTimerEvent(0);
    }   

    changed(integer j) {
        if (j & CHANGED_REGION) {
            llResetScript();    
        } else if (j & CHANGED_ANIMATION) {
            if (aoon==TRUE)
            {
                doAOCheck();    
            }   
        }
    }
    attach(key j) {
        llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
        
    }
    
    run_time_permissions(integer h) {
        if (!(h & PERMISSION_TRIGGER_ANIMATION)) {
                llOwnerSay("Can't function without permissions. Touch to reset.");
        } else {
            doAOCheck();
            llListen(-9000, "", llGetOwner(), "");
        }
    }
    
    touch_start(integer j)
    {
        //Throw a menu
        llDialog(llDetectedKey(0),"What do you want to do?",["Human","-","Animal","Toggle Sit","Sit Anywhere","Reset"],-9000);    
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message=="Reset") {
            llResetScript();    
        } else if (message == "Human"){
            DoHuman();
        }   else if (message == "Animal"){
            DoAnimal();
        } else if (message=="Toggle Sit") {
           if (siton==TRUE)
           {
                siton=FALSE;
                llOwnerSay("Sit off");
                if (aoon){
                    lastactive="";
                    doAOCheck();
                }   
            } else {
                
                siton=TRUE;
                llOwnerSay("Sit On");    
                if (aoon){
                    lastactive="";
                    doAOCheck();    
                }
                
            }
             
        } else if (message=="Sit Anywhere") {
            
            if (sittinganywhere==TRUE){
                
                sittinganywhere=FALSE;     
                if (aoon) {
                lastactive="";                    
                    doAOCheck();    
                }
                else
                {
                    StopAllAnims();    
                }
            }
            else
            {
                
                sittinganywhere=TRUE; 
                lastactive="";   
                doAOCheck();
            }
            
        }
    }

 
}