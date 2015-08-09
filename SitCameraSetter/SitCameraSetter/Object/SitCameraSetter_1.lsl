// :CATEGORY:Camera
// :NAME:SitCameraSetter
// :AUTHOR:Heb Dexler
// :CREATED:2010-08-14 04:30:45.143
// :EDITED:2013-09-18 15:39:03
// :ID:774
// :NUM:1062
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// When you sit on an object your camera is set to a default view. If you want to change this and look elsewhere, zoomed in close in or even a couple of sims away, you can use this to do it.// // You just sit on the prim with this script in it and move your camera into position. One click and its done.// // You can leave the script in place or use the cam offsets from your chat window in your own.// 
// All sorts of uses from telescopes to microscopes. 
// Hope you have fun with it!
// :CODE:
//~^~^~^~^~^~^~^ SitCameraSetter v3 by Heb Dexler, SL August 2010 ~^~^~^~^~^~^~^~
// Setup camera offsets for seated avatars using your current camera position.
// Script licence IfYouWinTheLottoGiveUsAfewQuidWare. Please keep open source.

//1. Put this in a prim and sit. (Sets a default sit target if there isnt one already)
//2. Move your camera to a viewpoint you like
//3. Press the button or chat '/517 setcam'
//4. Press 'ESC' key once or twice to reset your camera If you dont see it on first sit.

// Has worked viewing 2 sims away. Give it a try! 
//~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~^~

// listen chanel- change this if you like
integer dialogChannel = 517;
integer menuTimeOut   = 300;

// dialog vars - leave this
integer setup = FALSE;
integer listenId;
key sitterId;

// position vars
rotation startRot;
vector  startPos;
vector eyeOffPos;
vector camOffPos;

// set the camera offsets
setCamOffsets(){
    llSetCameraEyeOffset(eyeOffPos);
    llSetCameraAtOffset(camOffPos);
    if (!setup){
        llOwnerSay("Please sit to set a camera position.");
    }
}

// Default state - set cam offsets or run setup
default{
    on_rez(integer r){
        setCamOffsets();
    }
    state_entry(){
        setCamOffsets();
    }

    run_time_permissions(integer perm){
        if(perm & PERMISSION_TRACK_CAMERA){
           state camsetup;
        }
    }

    changed(integer change){
        //convoluted way of getting sitter==owner test without an llAvatarOnSitTarget
        integer numAv = llGetNumberOfPrims()-llGetObjectPrimCount(llGetKey());
        
        // set a default sittarget if none
        if(numAv > 0 && llAvatarOnSitTarget() == NULL_KEY){  
           llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);    
           llOwnerSay("There was no sittarget. A default has been set");
        }
        
        if (change & CHANGED_LINK){  
            if (numAv == 1){
                integer lnkNumAv = llGetObjectPrimCount(llGetKey())+1;
                sitterId = llGetLinkKey(lnkNumAv); 
                // check sitter is owner and change state
                if(sitterId == llGetOwner() && !setup){
                    integer perm = llGetPermissions();
                    // missfeature use 'if' to change state not 'if else'
                    if (perm & PERMISSION_TRACK_CAMERA){
                        state camsetup;
                    }  
                    if (!(perm & PERMISSION_TRACK_CAMERA)) {
                        llRequestPermissions(llGetOwner(), PERMISSION_TRACK_CAMERA);
                    }   
                }  
            }
        }
    }
    
}

// Change state - run camera setup dialog to get offsets
state camsetup{

    state_entry(){
        
        // get current prim pos
        startPos = llGetPos();
        startRot = llGetRot();
        
        listenId = llListen(dialogChannel, "",sitterId, "");
        
        string msg = "\n\nPosition your camera then press 'setcam'";
               msg += "\n\n(in mouselook chat: /517 setcam)";
        llDialog(sitterId, msg,["setcam"],dialogChannel);
        
        llSetTimerEvent(menuTimeOut);
    }


    listen(integer _channel, string _name, key _id, string _message) {

       // handle dialog replies and calc offsets
       if(_message == "setcam"){
           
             // this does the work
             eyeOffPos = (llGetCameraPos()-startPos)/startRot;
             camOffPos = (llGetCameraPos()-startPos)/startRot + llRot2Fwd(llGetCameraRot()/llGetRot());
                     
             string msgOut =" Camera position setup!\n\t\t\t  (ESC key twice on sit if necessary)";
             msgOut +="\n Leave the script in place or use the following code in your own:";
             msgOut +="\n//SitCamSetter \ndefault{\n\t state_entry(){";
             msgOut +="\n\t\t llSetCameraEyeOffset(" + (string)eyeOffPos + ");";
             msgOut +="\n\t\t llSetCameraAtOffset(" + (string)camOffPos + ");\n\t}\n}//end";

             llOwnerSay(msgOut);

              //remove listens and change state
              llListenRemove(listenId);
              llSetTimerEvent(0);
              setup = TRUE;
              llSetClickAction(1);
              llUnSit(sitterId);
              state default;
            }
        }
        
    // timeout on the menu
    timer(){
        llOwnerSay("Menu timeout..");
        llListenRemove(listenId);
        llSetTimerEvent(0);
        setup = FALSE;
        state default;
    }
}//end
