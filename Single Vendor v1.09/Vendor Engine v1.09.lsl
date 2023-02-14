    // Hard-Coded Variables
string cName = ".config"; // Name of Configuration NoteCard
integer BufferFace = 3; // Face to Preload the Next Texture Given the Last Direction used. LOL "BUFFER FACE!!!"
integer DisplayFace = 1; // Face to Display Product
integer DisplayPrimID = 2; // Link number of Prim used to Display and Buffer Textures
integer DHandleChannel = -18006; // Dialog Handle Channel
float DHandleTimeOut = 60.0;
    // Color Vectors
list colorsVectors = [<0.000, 0.122, 0.247>, <0.000, 0.455, 0.851>, <0.498, 0.859, 1.000>, <0.224, 0.800, 0.800>, <0.239, 0.600, 0.439>, <0.180, 0.800, 0.251>, <0.004, 1.000, 0.439>, <1.000, 0.863, 0.000>, <1.000, 0.522, 0.106>, <1.000, 0.255, 0.212>, <0.522, 0.078, 0.294>, <0.941, 0.071, 0.745>, <0.694, 0.051, 0.788>, <1.000, 1.000, 1.000>, <0.867, 0.867, 0.867>, <0.667, 0.667, 0.667>, <0.000, 0.000, 0.000>];
    // List of Names for Colors
list colors = ["NAVY", "BLUE", "AQUA", "TEAL", "OLIVE", "GREEN", "LIME", "YELLOW", "ORANGE", "RED", "MAROON", "FUCHSIA", "PURPLE", "WHITE", "SILVER", "GRAY", "BLACK"];


    // Empty Variales to be filled by script
key user; // UUID of Customer Avatar
string mode = "";
list prodBoxes; // List that will contain Product Box Names
list prodNC; // List that will contain Product Notecard Names
list prodImages; // List that will contain Product Images for Display on main Board.
list prodPrices; // List that will contain Product Prices of Configured to read prices from box description.
integer NumProds; // Hold Total NUmber of Products
integer prodIndex; // Product Index Storage Variable (Changes with Current viewed Product)
string GiftRecipientID; // Hold Key of User object will be gifted too.
integer cLine; // Holds Configuration Line Index for Loading Config Loop
key cQueryID; // Holds Current Configuration File Line during Loading Loop
string NavDirection = "up"; // Will Hold Direction of users surfing through vendor, (up vs down)
integer SlideCount = 0; // Hold Product ID If SlideShow Mode is turned on.
integer MoneyPerm; // Holds Script Money Permissions Mask
integer price; // Hold Price for Final Money Event Call

// Share Holders Configuration Variables
integer ProfitSharing = FALSE;
list ShareHolders = [];
float SharePercentage = 0.0;
integer NumShareHolders = 0;
list ShareHoldersCut = [];
integer TotalShareHolderPercent = 0;

    // Handles
integer DListener; // Main Dialog Listener Handle

    // Initially Coded but flexible Switches
integer SinglePrice = TRUE; // True if All Items use One Uniform Price
integer SPrice; // Holds Price obtained from Config file (If previous swich is TRUE)
integer PriceInDesc = FALSE; // True if price can be found in description of each box in inventory

integer HoverText = TRUE; // Enable HoverText By Default
integer TextFromNames = FALSE; // Should Hover Text be based on Currently viewed product.
string HTextString = "Vendor Hover Text"; // Default Vendor Hover Text
vector HTextColor; // Default Vendor Hover Text Color Vector
string HTextColorString; // Hold Name of Currently Selected Hover Text Color
string HTextPriceLabel; // Hover Text Price Label Holder

integer LoopProducts = TRUE; // True if we want to cycle product list upon reaching the end.
string InfoCard = ""; // Name of InfoCard NC
string VendorHelpCard = ""; // Name of Vendor Help NC

string ResetReason = "Refresh";
float SlideTimer = 10.0;
float ResetTimer = 600.0;
integer SlideShow = TRUE;
integer CheckConfig(string NCtoCheck){
    integer ConfigFileCheck = llGetInventoryType(NCtoCheck);
    if(ConfigFileCheck == INVENTORY_NOTECARD){ // File Exists and is a NoteCard
        return TRUE;
    }else{ // File Exists but is of different Type
        return FALSE;
    }
}

LoadConfig(string data){
    if(data!=""){ // If Line is not Empty
        //  if the line does not begin with a comment
        if(llSubStringIndex(data, "#") != 0)
        {
        //  find first equal sign
            integer i = llSubStringIndex(data, "=");
 
        //  if line contains equal sign
            if(i != -1){
                //  get name of name/value pair
                string name = llGetSubString(data, 0, i - 1);
 
                //  get value of name/value pair
                string value = llGetSubString(data, i + 1, -1);
 
                //  trim name
                list temp = llParseString2List(name, [" "], []);
                name = llDumpList2String(temp, " ");
 
                //  make name lowercase
                name = llToLower(name);
 
                //  trim value
                temp = llParseString2List(value, [" "], []);
                value = llDumpList2String(temp, " ");
 
                //  Check Key/Value Pairs and Set Switches and Lists
                if(name == "luna"){ // Found Luna Directive
                    if(value=="1251"){ // Check Value and Continue
                        integer luna = TRUE; // Luna Directive Marked TRUE;
                    }else{ // Incorrect Value Break Vendor and wait for inventory change
                        llOwnerSay("Configuration file Error! Please reload from Example File contained in vendor. Consult Documentation.");
                        state broken;
                    }
                }else if(name == "singleprice" && value!=""){
                    value = llToLower(value);
                    if(value=="true"){
                        SinglePrice = TRUE;
                        llOwnerSay("Single Price Configuration...");
                    }else{
                        SinglePrice = FALSE;
                    }
                }else if(name == "price" && value!=""){
                    if(SinglePrice){
                        SPrice = (integer)value;
                        llOwnerSay("Single Price: "+value);
                    }
                }else if(name=="hovertext"){
                    value = llToLower(value);
                    if(value=="true"){
                        HoverText = TRUE;
                        llOwnerSay("Hover Text: Enabled");
                    }else{
                        HoverText = FALSE;
                        llOwnerSay("Hover Text: Disabled");
                    }
                }else if(name=="hovertextstring"){
                    if(value==llToLower(value)){
                        TextFromNames = TRUE;
                        llOwnerSay("Dynamic HoverText Set...");
                    }else{
                        TextFromNames = FALSE;
                        HTextString = value;
                        llOwnerSay("Staic HoverText: "+value);
                    }
                }else if(name=="slideshow"){
                    value = llToLower(value);
                    if(value=="true"){
                        SlideShow = TRUE;
                        llOwnerSay("SlideShow Mode: Enabled");
                    }else{
                        SlideShow = FALSE;
                        llOwnerSay("SlideShow Mode: Disabled");
                    }
                }else if(name=="hovertextcolor"){
                    if(HoverText){
                        value = llToUpper(value);
                        integer cIndex;
                        integer lLength = llGetListLength(colors);
                        for(cIndex=0;cIndex<lLength;cIndex++){
                            if(value==llToUpper(llList2String(colors, cIndex))){
                                HTextColor = llList2Vector(colorsVectors, cIndex);
                                HTextColorString = value;
                            }
                        }
                        llOwnerSay("Hover Text Color: "+HTextColorString);
                    }
                }else if(name=="hoverpricelabel"){
                    HTextPriceLabel = value;
                    llOwnerSay("Price Label set to: "+HTextPriceLabel);
                }else if(name=="loopselection"){
                    value = llToLower(value);
                    if(value=="true"){
                        LoopProducts = TRUE;
                        llOwnerSay("Vendor set to Loop Product Selection...");
                    }else{
                        LoopProducts = FALSE;
                        llOwnerSay("Vendor set to NOT Loop Product Selection...");
                    }
                }else if(name=="infocard"){
                    if(value!=""){
                        integer FF = llGetInventoryType(value);
                        integer InfoCardPerm = llGetInventoryPermMask(value, MASK_NEXT);
                        if(FF==INVENTORY_NOTECARD){
                            if(!InfoCardPerm & PERM_COPY){
                                llOwnerSay("InfoCard not set with COPY Permissions! You will lose it on first request!");
                            }
                            InfoCard = value;
                            llOwnerSay("Info Card Set to: "+InfoCard);
                        }else{
                            llOwnerSay("No Info Card Found! Please add a General Info card and/or check .config file");
                            state broken;
                        }
                    }else{ // Not Info Card Specified, Break Script and Wait for .config Update
                        llOwnerSay("Please specify an Info Card in the .config file!");
                        state broken;
                    }
                }else if(name=="helpcard"){
                    if(value!=""){
                        integer FF = llGetInventoryType(value);
                        integer HelpCardPerm = llGetInventoryPermMask(value, MASK_NEXT);
                        if(FF==INVENTORY_NOTECARD){
                            if(!HelpCardPerm & PERM_COPY){
                                llOwnerSay("HelpCard not set with COPY Permissions! You will lose it on first request!");
                            }
                            VendorHelpCard = value;
                            llOwnerSay("Info Card Set to: "+VendorHelpCard);
                        }else{
                            llOwnerSay("No Info Card Found! Please add a General Info card and/or check .config file");
                            state broken;
                        }
                    }else{ // Not Info Card Specified, Break Script and Wait for .config Update
                        llOwnerSay("Please specify an Info Card in the .config file!");
                        state broken;
                    }
                }else if(name=="slidetimer"){
                    SlideTimer = (integer)value;
                    llOwnerSay("Slide Timer: "+value+" seconds");
                }else if(name=="profitsharing"){
                    if(value=="TRUE"){
                        llOwnerSay("Profit Sharing Enabled");
                        ProfitSharing = TRUE;
                    }else if(value=="FALSE"){
                        llOwnerSay("Profit Sharing Disabled");
                        ProfitSharing = FALSE;
                    }else{
                        llOwnerSay("Invalid Value for ProfitSharing Config Directive!\nProfit Sharing Disabled!");
                        ProfitSharing = FALSE;
                    }
                }else if(name=="shareholder" && ProfitSharing && value!=""){
                    integer ListLength = llGetListLength(ShareHolders); // Get Length of ShareHolder List to Compare with End of Function for Success Test
                    integer SpaceIndex = llSubStringIndex(value, " "); // Find Index of Space
                    integer IOPipeIndex = llSubStringIndex(value, "||"); // Find Index of IO Pipe
                    string FName = llGetSubString(value, 0, SpaceIndex-1); // Extract First Name
                    string LName = llGetSubString(value, SpaceIndex+1, IOPipeIndex-1); // Extract Last Name
                    string HisCut = llGetSubString(value, IOPipeIndex+2, -1); // Determine Share Holders Cut
                    ShareHoldersCut = ShareHoldersCut + [HisCut]; // Save Cut to List
                    ShareHolders = ShareHolders + [osAvatarName2Key(FName, LName)]; // Save ShareHolder UUID to List
                    if(llGetListLength(ShareHolders)>ListLength){ 
                        llOwnerSay("\nShare Holder '"+FName+" "+LName+"' Added!\nThier UUID: "+llList2String(ShareHolders, NumShareHolders)+"\nShare Holder Cut: "+llList2String(ShareHoldersCut, llListFindList(ShareHoldersCut, [HisCut]))+"%");
                        NumShareHolders++;
                        TotalShareHolderPercent = TotalShareHolderPercent + (integer)HisCut;
                        if(TotalShareHolderPercent>100){
                            ProfitSharing = FALSE;
                            llOwnerSay("ERROR! Total ShareHolder Percentage is Greater than 100%!\nProfit Sharing Disabled!");
                        }
                    }
                }else if(name=="shareholder" && !ProfitSharing){
                    
                }else{
                    llOwnerSay("Unknown configuration value: " + name + " on line " + (string)cLine);
                }
        }else{ //  line does not contain equal sign
                llOwnerSay("Configuration could not be read on line " + (string)cLine);
            }
        }
    }
}

CheckPerms(string Name, integer InvType){
    integer permCode = llGetInventoryPermMask(Name, MASK_NEXT);
    if(InvType==INVENTORY_OBJECT){
        if(~permCode & PERM_COPY){
            llOwnerSay("Item: "+Name+" is not marked as copy, your object will be lost from vendor inventory on purchase.\n Please Mark as Copy to avoid this issue.");
        }
        if(permCode & PERM_TRANSFER){
           llOwnerSay("Item: "+Name+" is marked as TRANSFER, Customers will be able to resell this product.");
        }
    }else if(InvType==INVENTORY_NOTECARD){
        if(~permCode & PERM_COPY){
            llOwnerSay("Item: "+Name+" is not marked as copy, your object will be lost from vendor inventory on purchase.\n Please Mark as Copy to avoid this issue.");
        }
        if(permCode & PERM_TRANSFER){
           llOwnerSay("Item: "+Name+" is marked as TRANSFER, Customers will be able to resell this product.");
        }
    }
}

ShareProfits(integer Income){
    integer i;
    for(i=0;i<=llGetListLength(ShareHolders)-1;i++){ // For Each Share Holder in the List
        string ShareHolderID = llList2String(ShareHolders, i);
        float HisCut = (float)Income * (llList2Float(ShareHoldersCut, i) / 100);
        integer PayHim = (integer)HisCut;
        string Name = osKey2Name((key)ShareHolderID);
        llGiveMoney(ShareHolderID, PayHim);
    }
}

LoadInventory(){ // Load Invectory into prodBoxes & prodImages Lists
    integer i;
    NumProds = llGetInventoryNumber(INVENTORY_OBJECT);
    if(NumProds<=0){
        llOwnerSay("No Products Found! Please place your products inside the vendors 'Content' Tab");
        state broken;
    }else{
        llOwnerSay((string)NumProds+" Found!");
    }
    for(i=0;i<=NumProds-1;i++){
            //Get Product Box By Name and Checks it's Permissions
        string objName = llGetInventoryName(INVENTORY_OBJECT, i);
        CheckPerms(objName, INVENTORY_OBJECT);
        prodBoxes += objName;

            //Get Product Texture by Name and Check It's Permissions
        string TextureName = llGetInventoryName(INVENTORY_TEXTURE, i);
        CheckPerms(TextureName, INVENTORY_TEXTURE);
        prodImages += llGetInventoryKey(llGetInventoryName(INVENTORY_TEXTURE, i));

            // Get Product Notecards by Name and Check Their Permissions
        string NoteName = llGetInventoryName(INVENTORY_NOTECARD, i);
        if(NoteName==".config" || NoteName==InfoCard || NoteName == VendorHelpCard){
            i++;
            NoteName = llGetInventoryName(INVENTORY_NOTECARD, i);
            if(NoteName == ".config" || NoteName == InfoCard || NoteName == VendorHelpCard){
                i++;
                NoteName = llGetInventoryName(INVENTORY_NOTECARD, i);
                if(NoteName == ".config" || NoteName == InfoCard || NoteName == VendorHelpCard){
                    i++;
                    NoteName = llGetInventoryName(INVENTORY_NOTECARD, i);
                    if(NoteName == ".config" || NoteName == InfoCard || NoteName == VendorHelpCard){
                        i=i-3;
                        llOwnerSay("Unable to Find Matching Notecard to Found Product: "+llList2String(prodBoxes, i)+"\nPlease consult documentation...");
                        state broken;
                    }else{
                        CheckPerms(NoteName, INVENTORY_NOTECARD);
                        prodNC += llGetInventoryName(INVENTORY_NOTECARD, i);
                        i = i-3;
                    }
                }else{
                    CheckPerms(NoteName, INVENTORY_NOTECARD);
                    prodNC += llGetInventoryName(INVENTORY_NOTECARD, i);
                    i = i-2;
                }
            }else{
                CheckPerms(NoteName, INVENTORY_NOTECARD);
                prodNC += llGetInventoryName(INVENTORY_NOTECARD, i);
                i--;
            }
        }else{
            CheckPerms(NoteName, INVENTORY_NOTECARD);
            prodNC += llGetInventoryName(INVENTORY_NOTECARD, i);
        }

            // Set All Prices in List to 9999
        prodPrices += 9999;
        if(llList2String(prodBoxes, i)!="" && llList2String(prodImages, i)!=""){
            llOwnerSay("Found Item: "+llList2String(prodBoxes, i));
            llOwnerSay("Found Texture: "+llList2String(prodImages, i));
            llOwnerSay("Found NoteCard: "+llList2String(prodNC, i));
        }else{
            llOwnerSay("ERROR: Could not find Matching Texture for Product: "+llList2String(prodBoxes, i));
        }
    }
    llOwnerSay(NumProds+" Different Products Successfully Loaded!");
    Init();
}

Init(){
    if(!SinglePrice){
        llOwnerSay("Starting Vendor...\nVendor is in Custom Price Mode. See Documentation for help setting prices in this mode.\nAll Prices set to P$ 9999");
    }else{
        llOwnerSay("Starting Vendor in Single Price Mode...");
    }
    if(HoverText){
        if(TextFromNames){
            if(SinglePrice){
                llSetText(llList2String(prodBoxes, prodIndex)+"\n"+HTextPriceLabel+": P$ "+SPrice, HTextColor, 1.0);
            }else{
                llSetText(llList2String(prodBoxes, prodIndex)+"\n"+HTextPriceLabel+": P$ "+llList2Integer(prodPrices, prodIndex), HTextColor, 1.0);
            }
        }else{
            llSetText(HTextString, HTextColor, 1.0);
        }
    }else{
        llSetText("", HTextColor, 1.0);
    }
    state running;
}

DisplayProduct(integer ProdID, string Direction){
    if(Direction=="up"){
        if(TextFromNames){
            if(HoverText){
                if(SinglePrice){
                    llSetText(llList2String(prodBoxes, ProdID)+"\n"+HTextPriceLabel+": P$ "+SPrice, HTextColor, 1.0);
                }else{
                    llSetText(llList2String(prodBoxes, ProdID)+"\n"+HTextPriceLabel+": P$ "+llList2Integer(prodPrices, ProdID), HTextColor, 1.0);
                }
            }
        }
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, DisplayFace, llList2String(prodImages, prodIndex), <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0]);
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, BufferFace, llList2String(prodImages, prodIndex+1), <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0]);
    }else if(Direction=="down"){
        if(TextFromNames){
            if(HoverText){
                if(SinglePrice){
                    llSetText(llList2String(prodBoxes, ProdID)+"\n"+HTextPriceLabel+": P$ "+SPrice, HTextColor, 1.0);
                }else{
                    llSetText(llList2String(prodBoxes, ProdID)+"\n"+HTextPriceLabel+": P$ "+llList2Integer(prodPrices, ProdID), HTextColor, 1.0);
                }
            }
        }
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, DisplayFace, llList2String(prodImages, prodIndex), <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0]);
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, BufferFace, llList2String(prodImages, prodIndex-1), <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0]);
    }
}

default{
    on_rez(integer start_param){
        llResetScript();
    }
    
    state_entry(){
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, DisplayFace, TEXTURE_BLANK, <1.0, 1.0, 1.0>, ZERO_VECTOR,0.0]);
        llSetText("",<1.0,1.0,1.0>,1.0);
        llOwnerSay("Searching for Configuration File...");
            // Check for Config NoteCard
        integer ConfigFound = CheckConfig(cName);
        if(ConfigFound==TRUE){ // Configuration Notecard Was Found
            llOwnerSay("Configuration File Found!"); // Tell User File was found and allow script to proceed
        }else{ // Config File was not found, Notify User and Switch to Broken State.
            llOwnerSay("Configuration File NOT Found or is Incorrect FileType!\nPlease copy the contents of NoteCard EXAMPLE.config to a Notecard Named .config\nSee Documentation for further details.");
            state broken; // Switch to Broken State and wait for inventory change.
        }
        llOwnerSay("Configuring...");
        cQueryID = llGetNotecardLine(cName, cLine);
    }
    dataserver(key query_id, string data){       // Config Notecard Read Function Needs to be Finished
        if (query_id == cQueryID){
            if (data != EOF){ 
                LoadConfig(data); // Process Current Line
                ++cLine; // Incrment Line Index
                cQueryID = llGetNotecardLine(cName, cLine); // Attempt to Read Next Config Line (Re-Calls DataServer Event)
            }else{ // IF EOF (End of Config loop, and on Blank File)
                llOwnerSay("Please accept Debit Permissions...");
                llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
            }
        }
    }
    
    run_time_permissions(integer perm)
    {
        MoneyPerm = perm;
        if(MoneyPerm & PERMISSION_DEBIT){
            llOwnerSay("Debit Permissions OK");
            llSetPayPrice(PAY_HIDE, [PAY_HIDE ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
            llOwnerSay("Configuration Loaded!\nLoading Inventory...");
            LoadInventory();
        }
    }
}

state broken{
    state_entry(){
        llOwnerSay("Vendor Offline");
    }
    
    changed(integer change){
        if(change && change == CHANGED_INVENTORY){
            llOwnerSay("Inventory Modification Detected, Resetting...");
            llResetScript();
        }
    }
}

state running{
    state_entry(){
        if(SinglePrice){
            llOwnerSay("Vendor Online!");
            if(SlideShow){
                ResetReason = "NextSlide";
                llSetTimerEvent(SlideTimer);
            }
        }else{
            llOwnerSay("Vendor Online! Please Remember to Set Product Prices!\n Consult Documentation for Help.");
        }
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, DisplayFace, llList2String(prodImages, prodIndex), <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0]);
        llSetLinkPrimitiveParamsFast(DisplayPrimID, [PRIM_TEXTURE, BufferFace, llList2String(prodImages, prodIndex+1), <1.0, 1.0, 0.0>, ZERO_VECTOR,0.0]);
    }
    
    link_message(integer sender_num, integer num, string message, key id)
    {
        // Admin Dialog
        if(message=="admin" && id==llGetOwner() && !SinglePrice){
            llSetTimerEvent(0);
            DListener = llListen(DHandleChannel, "", id, "");
            llDialog(id, "What would you like to do?", ["Change Price", "Cancel"], DHandleChannel);
            ResetReason = "Dialog";
            llSetTimerEvent(DHandleTimeOut);
            mode = "admin";
        }else if(message=="admin"){
            if(llList2String(prodNC, prodIndex)==""){
                llSay(0, "There is not NoteCard Associated with this product to give you.");
                return;
            }
            llGiveInventory(id, llList2String(prodNC, prodIndex));
        }
        if(message=="next"){
            ResetReason = "NextSlide";
            llSetTimerEvent(60);
            if(prodIndex==0){
                prodIndex++;
                NavDirection = "up";
                DisplayProduct(prodIndex, NavDirection);
            }else if(prodIndex==NumProds-1){
                if(LoopProducts){
                    prodIndex = 0;
                    NavDirection = "up";
                    DisplayProduct(prodIndex, NavDirection);
                }else{
                    llSay(0, "End of product list reached!");
                }
            }else if(prodIndex<NumProds-1){
                prodIndex++;
                NavDirection = "up";
                DisplayProduct(prodIndex, NavDirection);
            }
        }else if(message=="prev"){
            ResetReason = "NextSlide";
            llSetTimerEvent(60);
            if(prodIndex==0){
                if(LoopProducts){
                    prodIndex = NumProds-1;
                    NavDirection = "down";
                    DisplayProduct(prodIndex, NavDirection);
                }else{
                    llSay(0, "End of product list reached!");
                }
            }else if(prodIndex==NumProds-1){
                prodIndex--;
                NavDirection = "down";
                DisplayProduct(prodIndex, NavDirection);
            }else if(prodIndex<NumProds-1){
                prodIndex--;
                NavDirection = "down";
                DisplayProduct(prodIndex, NavDirection);
            }
        }else if(message=="help"){
            if(!llGetInventoryType(VendorHelpCard) || VendorHelpCard==""){
                llSay(0, "No Vendor Help Card to give you.");
                return;
            }
            llGiveInventory(id, VendorHelpCard);
        }else if(message=="info"){
            if(!llGetInventoryType(InfoCard) || InfoCard==""){
                llSay(0, "No InfoCard to Give you.");
                return;
            }
            llGiveInventory(id, InfoCard);
        }else if(message=="gift"){
            DListener = llListen(DHandleChannel, "", id, "");
            if(!DListener){
                llSay(0, "Error!\n Unable to open dialog, please contact vendor support!");
                state broken;
            }else{
                llTextBox(id, "Please enter the first and last name of the person you wish you buy this item for.\nYou have 60 seconds...", DHandleChannel);
                llSetTimerEvent(DHandleTimeOut);
            }
        }else if(message=="buy"){
            ResetReason = "OrderRefresh";
            llSetTimerEvent(20);
            user = id;
            if(MoneyPerm & PERMISSION_DEBIT){
                if(HoverText){
                    llSetText("Preparing Vendor for purcahse...", HTextColor, 1.0);
                }
                    if(SinglePrice){
                        llSetPayPrice(PAY_HIDE, [(integer)SPrice, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                    }else{
                        llSetPayPrice(PAY_HIDE, [llList2Integer(prodPrices, prodIndex), PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                    }
                if(HoverText){
                    llSetText("Please pay vendor to buy this item...", HTextColor, 1.0);
                }
                llSay(0, "Please pay vendor to buy this item...\nYou have 20 seconds to pay the vendor...");
            }
        }
    }
    
    listen(integer chan, string name, key id, string msg){
        llOwnerSay(name);
        if(chan==DHandleChannel){
            if(mode=="admin"){
                if(msg!=""){
                    if(msg=="Change Price"){
                        llTextBox(id, "Please enter new price...\n\nExample: 199", DHandleChannel);
                    }else if(msg=="Cancel"){
                        llOwnerSay("Admin Mode Canceled");
                        if(SlideShow){
                            llSetTimerEvent(SlideTimer);
                        }
                    }else if(mode=="admin" && msg!=""){
                        llOwnerSay("Setting Price to "+msg);
                        list newlist = [(integer)msg];
                        list finallist = llListInsertList(prodPrices, newlist, prodIndex);
                        prodPrices = finallist;
                        llOwnerSay("Leaving Admin Mode...");
                        mode = "";
                        DisplayProduct(prodIndex, NavDirection);
                        if(SlideShow){
                            llSetTimerEvent(SlideTimer);
                        }
                    }
                }
            }else if(msg!=""){
                if(GiftRecipientID!="" && msg=="Yes"){
                    // Setup Money Transaction and Notify User
                    ResetReason = "OrderRefresh";
                    llSetTimerEvent(20);
                    user = (key)GiftRecipientID;
                    if(MoneyPerm & PERMISSION_DEBIT){
                        if(HoverText){
                            llSetText("Preparing Vendor for purcahse...", HTextColor, 1.0);
                        }
                        llSay(0, "Preparing Vendor for pruchase...");
                        if(SinglePrice){
                            llSetPayPrice(PAY_HIDE, [(integer)SPrice, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                        }else{
                            llSetPayPrice(PAY_HIDE, [llList2Integer(prodPrices, prodIndex), PAY_HIDE, PAY_HIDE, PAY_HIDE]);
                        }
                        if(HoverText){
                            llSetText("Please pay vendor to buy this item...", HTextColor, 1.0);
                        }
                        llSay(0, "Please pay vendor to buy this item...\nYou have 20 seconds to pay the vendor...");
                    }
                }else if(msg=="No"){
                    GiftRecipientID = NULL_KEY;
                    llSay(0, "Gift Process Cleared\nRestarting SlideShow...");
                    llListenRemove(DListener);
                    ResetReason = "OrderRefresh";
                    llSetTimerEvent(5.0);
                }else if(msg=="Forget It"){
                    GiftRecipientID = NULL_KEY;
                    llSay(0, "Gift Process Cleared\nRestarting SlideShow...");
                    llListenRemove(DListener);
                    ResetReason = "OrderRefresh";
                    llSetTimerEvent(5.0);
                }else{
                    integer spaceIndex = llSubStringIndex(msg, " ");
                    string  firstName  = llGetSubString(name, 0, spaceIndex - 1);
                    string  lastName  = llGetSubString(name, spaceIndex + 1, -1);
                    GiftRecipientID = osAvatarName2Key(firstName, lastName);
                    if(GiftRecipientID==""){
                        llSay(0, "ERROR! Invalid UUID. Please consult documentation");
                    }else{
                        llSay(0, "Please Note your gift recipient must be on this sim!\n\nYou are buying for "+firstName+" "+lastName);
                        llDialog(id, "Please Note your gift recipient must be on this sim!\n\nYou are buying for "+firstName+" "+lastName+".\nIs this correct?", ["Yes", "No", "Forget It"], DHandleChannel);
                    }
                }
            }
        }
    }
    
    timer(){
        if(ResetReason=="Dialog"){
            llSay(0, "Dialog Menu Timed-Out");
            user = NULL_KEY; 
            llListenRemove(DListener);
            ResetReason = "Refresh";
            llSetTimerEvent(ResetTimer);
        }else if(ResetReason=="Refresh"){
            user = NULL_KEY;
            llListenRemove(DListener);
            prodIndex = 0;
            DisplayProduct(prodIndex, NavDirection);
        }else if(ResetReason=="NextSlide"){
            if(SlideShow){
                if(SlideCount<ResetTimer){
                    llSetTimerEvent(SlideTimer);
                    SlideCount = SlideCount + 10;
                    if(prodIndex<NumProds-1){
                        prodIndex++;
                        DisplayProduct(prodIndex, NavDirection);
                    }else{
                        prodIndex = 0;
                        DisplayProduct(prodIndex, NavDirection);
                    }
                }else{
                    SlideCount = 0;
                    ResetReason = "Refresh";
                }
            }else{
                
            }
            llListenRemove(DListener);
        }else if(ResetReason=="OrderRefresh"){
            llSetPayPrice(PAY_HIDE, [PAY_HIDE ,PAY_HIDE, PAY_HIDE, PAY_HIDE]);
            user = NULL_KEY;
            GiftRecipientID = "";
            llListenRemove(DListener);
            ResetReason = "NextSlide";
            llSetTimerEvent(0);
            llSetTimerEvent(SlideTimer);
            prodIndex = 0;
            DisplayProduct(prodIndex, NavDirection);
        }
    }
    
    money(key id, integer amount){
        if(SinglePrice){
            price = (integer)SPrice;
        }else{
            price = llList2Integer(prodPrices, prodIndex);
        }
        if(id!=user){
            llSay(0, "Please, Only the person who clicked 'Buy' May pay for the item.\n If you wish please use 'Buy as Gift' Button");
            llSetTimerEvent(ResetTimer);
            DisplayProduct(prodIndex, NavDirection);
        }else{
            if(amount<price){
                llSay(0, "You did not pay enough, Refunding...\nYou have 60 seconds to pay the correct amount before the vendor resets.");
                llGiveMoney(user, amount);
                ResetReason = "OrderRefresh";
                llSetTimerEvent(0);
                llSetTimerEvent(60);
            }else if(amount>price){
                llSay(0, "You paid too much, Refunding Difference...");
                integer amtDiff = amount-price;
                llGiveMoney(user, amtDiff);
                llGiveInventory(user, llList2String(prodBoxes, prodIndex));
                ResetReason = "OrderRefresh";
                llSay(0, "Order Successful! Please accept your new item...");
                llSetTimerEvent(0);
                llSetTimerEvent(15);
            }else if(amount==price){
                llSay(0, "Thank You, Please accept your new item...");
                llGiveInventory(user, llList2String(prodBoxes, prodIndex));
                ResetReason = "OrderRefresh";
                if(ProfitSharing){
                    ShareProfits(amount);
                }
                llSetTimerEvent(0);
                llSetTimerEvent(15);
            }
        }
    }
}