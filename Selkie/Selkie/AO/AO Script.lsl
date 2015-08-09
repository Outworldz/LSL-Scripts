// :CATEGORY:AO
// :NAME:Selkie
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1007
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Dual AO
// :CODE:

// Low Lag AO by Casper Warden // Completely license free
// Mods by Ferd Frederix for use with dual identity Selkie avatars

// 8-11-2013 Rev 0.2

// ABOUT THIS SCRIPT 
// -----------------
//
// This is an animation overrider optimised for use on pensim.  We don't use
// complicated list parsing, and we don't have a timer firing every 0.5 seconds
// like other AO's.
// 
// All configuration is done in the notecard "AOConfigHuman and AoCOnfigAnimal".
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

list aWalking;
list aRunning;
list aCrouchWalking; 
list aFlying;
list aJumping;
list aHoveringDown;
list aHoveringUp;
list aCrouching;
list aFlyDown;
list aStanding;
list aHovering;
list aSitting;
list aSoftLanding;
list aPreJumping;
list aFalling;
list aLanding;
list aStandingUp;
list aFlyingSlow;
list aSittingonGround;
list aFloating; 
list aSwimmingForward;
list aSwimmingUp;
list aSwimmingDown;

list hWalking;
list hRunning;
list hCrouchWalking; 
list hFlying;
list hJumping;
list hHoveringDown;
list hHoveringUp;
list hCrouching;
list hFlyDown;
list hStanding;
list hHovering;
list hSitting;
list hSoftLanding;
list hPreJumping;
list hFalling;
list hLanding;
list hStandingUp;
list hFlyingSlow;
list hSittingonGround;
list hFloating; 
list hSwimmingForward;
list hSwimmingUp;
list hSwimmingDown;




integer aoon=TRUE;
string onOff = "AO On";
integer siton=TRUE;
integer sittinganywhere=FALSE;
integer automaticSwitch = TRUE;

key gQueryID;
integer gLine=0;
string currentmode;
string lastactive="";
string lastactiveanim="";

integer listener;
integer ownerChannel;  // for selki control 

integer animalHuman;   // TRUE for animal, FALSE for Human


Human()
{
    if (animalHuman)
    {
        llOwnerSay("Human");
        llSetTexture("Nara", ALL_SIDES);
        Walking=hWalking;
        Running=hRunning;
        CrouchWalking=hCrouchWalking;
        Flying=hFlying;
        Jumping=hJumping;
        HoveringDown=hHoveringDown;
        HoveringUp=hHoveringUp;
        Crouching=hCrouching;
        FlyDown=hFlyDown;
        Standing=hStanding;
        Hovering=hHovering;
        Sitting=hSitting;
        SoftLanding=hSoftLanding;
        PreJumping=hPreJumping;
        Falling=hFalling;
        Landing=hLanding;
        StandingUp=hStandingUp;
        FlyingSlow=hFlyingSlow;
        SittingonGround=hSittingonGround;
        Floating=hFloating;
        SwimmingForward=hSwimmingForward;
        SwimmingUp=hSwimmingUp;
        SwimmingDown=hSwimmingDown;
        animalHuman = FALSE;
        
        llWhisper(ownerChannel,"Human");
    }
 
}

Animal()
{
    if (! animalHuman )
    {
        llSetTexture("seal thumbnail", ALL_SIDES);
        
        Walking=aWalking;
        Running=aRunning;
        CrouchWalking=aCrouchWalking;
        Flying=aFlying;
        Jumping=aJumping;
        HoveringDown=aHoveringDown;
        HoveringUp=aHoveringUp;
        Crouching=aCrouching;
        FlyDown=aFlyDown;
        Standing=aStanding;
        Hovering=aHovering;
        Sitting=aSitting;
        SoftLanding=aSoftLanding;
        PreJumping=aPreJumping;
        Falling=aFalling;
        Landing=aLanding;
        StandingUp=aStandingUp;
        FlyingSlow=aFlyingSlow;
        SittingonGround=aSittingonGround;
        Floating=aFloating;
        SwimmingForward=aSwimmingForward;
        SwimmingUp=aSwimmingUp;
        SwimmingDown=aSwimmingDown; 
        animalHuman = TRUE;
        llWhisper(ownerChannel,"Animal");
    }
}


makeMenu()
{
    if (listener)
        llListenRemove(listener);
        
    listener = llListen(menuChannel, "", llGetOwner(), "");
    llDialog(llGetOwner(),"What do you want to do?",["Human","Animal","Auto",onOff , "Toggle Sit","Sit Anywhere","Reset"],menuChannel);   
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
          
          if (z < 20 &&  automaticSwitch)
          {
                Animal(); 
          }
          else if (z >= 20 && automaticSwitch)
          {
                Human();
          }
            
          if (z < 20 && check == "Flying" &&  automaticSwitch) 
          {
                getAnim = llList2String(SwimmingForward,0);    
          }
  
  
  
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



integer menuChannel;

default
{

    state_entry()
    {
        ownerChannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
        menuChannel = llCeil(llFrand(10000) + 10000);
        llSetText("",<1.0,1.0,1.0>,1.0);

        llOwnerSay("Reading notecard for Animals.");
        if (llGetInventoryType("AOConfigAnimal")==INVENTORY_NONE) {
            llOwnerSay("Can't start AO: Notecard 'AOConfigAnimal' is missing");
        } else {
            gQueryID = llGetNotecardLine("AOConfigAnimal",0);
        }
    }
   
    touch_start(integer j)
    {
        llResetScript();    
    }
    
     dataserver(key query_id, string data) {
        if (query_id == gQueryID) {
            if (data != EOF) {    // not at the end of the notecard
                gLine++;
                gQueryID = llGetNotecardLine("AOConfigAnimal", gLine);    // request next line
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
                                 aWalking+=[data];
                             } else if (currentmode=="[running]") {
                                 aRunning+=[data];
                             }    else if (currentmode=="[crouchwalking]") {
                                 aCrouchWalking+=[data];
                             }    else if (currentmode=="[flying]") {
                                 aFlying+=[data];
                             }    else if (currentmode=="[jumping]") {
                                 aJumping+=[data];
                             }    else if (currentmode=="[hovering up]") {
                                 aHoveringUp+=[data];
                             }    else if (currentmode=="[crouching]") {
                                 aCrouching+=[data];
                             }    else if (currentmode=="[fly down]") {
                                 aFlyDown+=[data];
                             }    else if (currentmode=="[standing]") {
                                 aStanding+=[data];
                             }    else if (currentmode=="[hovering down]") {
                                 aHoveringDown+=[data];
                             }    else if (currentmode=="[hovering]") {
                                 aHovering+=[data];
                             }    else if (currentmode=="[sitting]") {
                                 aSitting+=[data];
                             }    else if (currentmode=="[prejumping]") {
                                 aPreJumping+=[data];
                             }    else if (currentmode=="[falling]") {
                                 aFalling+=[data];
                             }    else if (currentmode=="[landing]") {
                                 aLanding+=[data];
                             }    else if (currentmode=="[soft landing]") {
                                 aSoftLanding+=[data];
                             }    else if (currentmode=="[standing up]") {
                                 aStandingUp+=[data];
                             }    else if (currentmode=="[flyingslow]") {
                                 aFlyingSlow+=[data];
                             }    else if (currentmode=="[sitting on ground]") {
                                 aSittingonGround+=[data];
                             }    else if (currentmode=="[floating]") {
                                 aFloating+=[data];
                             }    else if (currentmode=="[swimming forward]") {
                                 aSwimmingForward+=[data];
                             }    else if (currentmode=="[swimming up]") {
                                 aSwimmingUp+=[data];
                             }    else if (currentmode=="[swimming down]") {
                                 aSwimmingDown+=[data];
                             }  else {
                               // llOwnerSay("Unknown mode: "+currentmode);   
                            }
                            
                        } 
                    }
                }
                
            } else {
                state ReadHuman;   
            }
        }
    }
}



state ReadHuman
{
    state_entry()
    {
         if (llGetInventoryType("AOConfigHuman")==INVENTORY_NONE) {
            llOwnerSay("Can't start AO: Notecard 'AOConfigHuman' is missing");
        } else {
            gLine = 0;
            llOwnerSay("Reading notecard for puny Humans.");
            gQueryID = llGetNotecardLine("AOConfigHuman",0);
        }

    }

    
    dataserver(key query_id, string data) {
        if (query_id == gQueryID) {
            if (data != EOF) {    // not at the end of the notecard
                gLine++;
                gQueryID = llGetNotecardLine("AOConfigHuman", gLine);    // request next line
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
                                 hWalking+=[data];
                             } else if (currentmode=="[running]") {
                                 hRunning+=[data];
                             }    else if (currentmode=="[crouchwalking]") {
                                 hCrouchWalking+=[data];
                             }    else if (currentmode=="[flying]") {
                                 hFlying+=[data];
                             }    else if (currentmode=="[jumping]") {
                                 hJumping+=[data];
                             }    else if (currentmode=="[hovering up]") {
                                 hHoveringUp+=[data];
                             }    else if (currentmode=="[crouching]") {
                                 hCrouching+=[data];
                             }    else if (currentmode=="[fly down]") {
                                 hFlyDown+=[data];
                             }    else if (currentmode=="[standing]") {
                                 hStanding+=[data];
                             }    else if (currentmode=="[hovering down]") {
                                 hHoveringDown+=[data];
                             }    else if (currentmode=="[hovering]") {
                                 hHovering+=[data];
                             }    else if (currentmode=="[sitting]") {
                                 hSitting+=[data];
                             }    else if (currentmode=="[prejumping]") {
                                 hPreJumping+=[data];
                             }    else if (currentmode=="[falling]") {
                                 hFalling+=[data];
                             }    else if (currentmode=="[landing]") {
                                 hLanding+=[data];
                             }    else if (currentmode=="[soft landing]") {
                                 hSoftLanding+=[data];
                             }    else if (currentmode=="[standing up]") {
                                 hStandingUp+=[data];
                             }    else if (currentmode=="[flyingslow]") {
                                 hFlyingSlow+=[data];
                             }    else if (currentmode=="[sitting on ground]") {
                                 hSittingonGround+=[data];
                             }    else if (currentmode=="[floating]") {
                                 hFloating+=[data];
                             }    else if (currentmode=="[swimming forward]") {
                                 hSwimmingForward+=[data];
                             }    else if (currentmode=="[swimming up]") {
                                 hSwimmingUp+=[data];
                             }    else if (currentmode=="[swimming down]") {
                                 hSwimmingDown+=[data];
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
        makeMenu();

        StopAllAnims();  

        doAOCheck();
        ownerChannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
        
        llSetTimerEvent(0);
    }   

    changed(integer j) {
        if (j & CHANGED_ANIMATION) {
            if (aoon==TRUE)
            {
                doAOCheck();    
            }   
        } else if (j & CHANGED_INVENTORY) {
            llResetScript();
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
        }
    }
    
    touch_start(integer j)
    {
        //Throw a menu
        makeMenu(); 
    }
    
    listen(integer channel, string name, key id, string message)
    {
        if (message=="Reset") {
            llResetScript(); 
        } else if (message == "AO On") {
            onOff = "AO Off";
            aoon = FALSE;
            StopAllAnims();
            llOwnerSay("AO Off");
            makeMenu();
        } else if (message == "AO Off") {
            onOff = "AO On";
            aoon = TRUE;
            llOwnerSay("AO On");
            makeMenu();
        } else if (message == "Human" ) {
            automaticSwitch = FALSE;
            Human();
            makeMenu();
            doAOCheck();
        } else if (message == "Animal") {
            automaticSwitch = FALSE;
            Animal();
            makeMenu();
            doAOCheck();
        } else if (message == "Auto") {
            automaticSwitch = TRUE;
            makeMenu();
            doAOCheck();
                    
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
            makeMenu();
             
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
            
            makeMenu();
            
        }
    }

 
}
