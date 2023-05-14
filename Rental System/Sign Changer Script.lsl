integer Rented;
string UnitID;
list TexNames;
list TexKeys;


integer ComChannel = -86000;
integer MenuComChannel = -87000;
integer ComHandle;
integer MenuComHandle;
string EMPTY = "";

integer GetLoaded(){
    integer NumTextures = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer i;
    for(i=0;i<NumTextures;i++){
        TexNames = TexNames + llGetInventoryName(INVENTORY_TEXTURE, i);
        TexKeys = TexKeys + llGetInventoryKey(llList2String(TexNames, -1));
        integer NumKeys = (llGetListLength(TexKeys)-1);
        if(NumKeys==i){
            //llOwnerSay("Loaded Texture: "+llList2String(TexNames, -1));
        }
    }
    integer FinalListLength = llGetListLength(TexNames);
    if(FinalListLength==NumTextures){
        return TRUE;
    }else{
        return FALSE;
    }
}

SetState(string NewState){
    string TextureName;
    if(NewState=="Rented"){
        TextureName = "Unit"+UnitID+"Ocu";
        llSetTexture(TextureName, 2);
    }else if(NewState=="NotRented"){
        TextureName = "Unit"+UnitID+"Avail";
        llSetTexture(TextureName, 2);
    }
}

default{
    state_entry(){
        integer Loaded = GetLoaded();
        if(Loaded){
            UnitID = llGetObjectDesc();
            if(UnitID!="" && llStringLength(UnitID)<=3){
                MenuComHandle = llListen(MenuComChannel, EMPTY, EMPTY, EMPTY);
                llDialog(llGetOwner(), UnitID+"\n\n\tIs this the correct Unit ID for this Sign?", ["Yes", "No"], MenuComChannel);
            }else{
                llOwnerSay("Unable to Configure, Please Enter UnitID into Desc, Max 3 Chars\n Auto Rebooting in 5 minutes...");
                llSetTimerEvent(300.0);
            }
        }else{
            llOwnerSay("We Need the Textures for the units.\n Auto Rebooting in 5 minutes...");
            llSetTimerEvent(300.0);
        }
    }
    
    listen(integer channel, string name, key id, string msg){
        if(channel==MenuComChannel){
            if(id==llGetOwner()){
                if(llToLower(msg)=="yes"){
                    if(ComHandle>0){
                        return;
                    }
                    llOwnerSay("Opening Com Channel("+(string)ComChannel+")...");
                    ComHandle = llListen(ComChannel, EMPTY, EMPTY, EMPTY);
                    if(ComHandle>0){
                        llOwnerSay("Com Channel Open!");
                    }
                }else if(llToLower(msg)=="no"){
                    llOwnerSay("Please set correct Unit ID in Description Field!\nResetting in 5 minutes...");
                    llSetTimerEvent(300.0);
                }
            }else{
                
            }
        }else if(channel==ComChannel){
            //llOwnerSay("msg: "+msg);
            list InputData = llParseString2List(msg, ["||"], []);
            string UnitName = llList2String(InputData, 1);
            string Rented = llList2String(InputData, 6);
            if(UnitName==UnitID){
                if(Rented=="TRUE"){
                    SetState("Rented");
                }else if(Rented=="FALSE"){
                    SetState("NotRented");
                }
            }
            
        }
    }
    
    timer(){
        llSetTimerEvent(0.0);
        llOwnerSay("Resetting...");
        llResetScript();
    }
}