 /////////////// CONSTANTS ///////////////////
 // XyText Message Map.
 integer DISPLAY_STRING      = 281000;
 integer DISPLAY_EXTENDED    = 281001;
 integer REMAP_INDICES       = 281002;
 integer RESET_INDICES       = 281003;
 integer SET_CELL_INFO       = 281004;
 
 // This is an extended character escape sequence.
 string  ESCAPE_SEQUENCE = "\\e";
 
 // This is used to get an index for the extended character.
 string  EXTENDED_INDEX  = "123456789abcdef";
 
 // Face numbers.
 integer LEFT_FACE       = 4;
 integer MIDDLE_FACE     = 0;
 integer RIGHT_FACE      = 2;
 
 // This is a list of textures for all 2-character combinations.
 list CHARACTER_GRID  = [
        "e1adcf74-b678-46f5-ab85-a3b03d221e7e",
        "0f72d0a2-928a-435a-90a6-0c6fc3f6bfe5",
        "c45d9b9e-2c7c-4704-9f0f-06e3fda13732",
        "150c4bfe-f38d-472f-b0c4-51f0f16080ad",
        "62be6f91-e631-494f-a78c-9512ab0778e0",
        "330428c9-eb69-4e27-8104-964930a8032f",
        "3d4f54dd-4bc1-497f-9099-a4763f8ed4ab",
        "2695c77f-207c-49d6-89fa-8ebbaaa1599a",
        "6cb2ee7c-afec-4792-8c5f-07957ea0e520",
        "1a255b88-bbdc-4a21-af32-6c126c7d50fd",
        "86692870-a2de-411e-bc78-68938237e0ef",
        "f7aa79e8-4e9b-4547-8076-b143f4f9d4bb",
        "9b8d9e38-4a35-43f1-8301-d83734ed4d36",
        "94855b9d-3f5b-4827-986e-8d10fdce0f1a",
        "18a7cd1c-7676-4dfb-a28e-a6b25afa9446",
        "4e44033f-e631-4836-93c8-cd6d5b0c86cd",
        "7c1d0854-6bc7-4e1e-b612-6fb0c573224a",
        "0c7a5f72-6635-4edd-9004-6293b00d19d5",
        "e68c90d3-1ba9-4bc1-84e6-d7a807ac1b5f",
        "a094d717-3e81-42d4-be30-6ef612cf21ba",
        "6d496c5b-d69b-4f30-b896-7e0fc11ba09b",
        "fcefb20d-b260-434c-8b66-2ae57ba84682",
        "e95cb97d-d73d-4baf-a5d7-27dc906a95cd",
        "1cba70f9-7e2b-4dcf-aeea-89f2157488f6",
        "4ee7726b-410a-406c-bbda-1bc8464ff884",
        "5c47176e-7d66-4e43-bf58-d513b6ad5859",
        "f2a7efea-63c9-4738-b51a-501d41feac08",
        "3b6fa4d0-35b4-4be5-96eb-6a08eb712b2c",
        "ed1472b4-00c5-420d-81d6-bf417ade3ac9",
        "250671b1-afd1-4b37-9abb-ac6eb8d38929",
        "061974d5-2cc4-4974-8297-6a296087059b",
        "6d9522dc-11dc-49aa-994a-d1d2e3eb9117",
        "d7adc248-6c78-4faf-bcd4-628f42223ef1",
        "d728fdc7-648b-47c8-9121-b094d5d4429a",
        "a9fa907c-70f3-4a15-b57c-f55b907861c6",
        "875b9c0e-ccf6-4bf6-87bb-05d916441dd5",
        "357a341d-afed-4584-b5bd-45a931c1bae7",
        "20c0394e-2930-4cf1-9fda-20d7d5cbb9c1",
        "bf7ec147-6460-46bf-af4d-ea890eac583d",
        "eee00eff-a5e5-4338-bda9-ffbf5658752a",
        "a18b6a59-34f8-428f-bcb4-678416b6c378",
        "f5833f71-25b0-4be5-a9c8-7550faca1b30",
        "890456ad-103a-495a-9ec7-cdd9da71028f",
        "721563ff-7019-4445-a183-6dc08f6e363a",
        "aa67b329-cd4e-4c04-8bec-9e477dab2f56",
        "3ab607b1-c2b7-4e08-83cf-3bb6204d8de9",
        "da071c8e-e187-4c73-9647-352a4b772c40",
        "45bf87a8-8102-41ec-a7d5-0ad5150dd764",
        "aab84719-d8b3-4f89-bd2c-0fce1d049d25",
        "24cf75a8-768d-4b9c-8588-9acfbeeb85c9",
        "bd7b187f-83d7-4e30-a126-69ef13ebd5a7",
        "e0951d46-30f7-4bc6-a66f-6a9bb492bdb4",
        "d4e44008-ba97-49cc-9ad7-2c71d834493b",
        "6437b969-5807-49b2-b6ef-cbcfefd44864",
        "df3b5a0b-65d4-42a9-a408-92e770ad2e7a",
        "a35b4b7e-dbc4-4cc1-bb0c-73331f268a9b",
        "1fb8ca6c-eb6e-46fc-a294-283d6ed3c102",
        "b0afff79-48fd-4b6d-8a73-1a628dc07556",
        "8377fc50-c138-428b-910d-69f5373ba935",
        "d7a1085f-b181-468b-9804-ab0ac127dcb6",
        "43736d8b-8ebb-48c8-aca8-5c2dc13a38b0",
        "1b5588c9-87a5-4a13-9270-e38e8c7a3117",
        "7465a761-4aa2-4654-b4f9-577cb211bfc2",
        "6eac5302-40dc-40bf-9ad6-8bda00e34814",
        "410c41fc-eece-43ef-8efb-cf069a06fd25",
        "28bb8a52-3062-435d-81dd-052b8cdb88f9"
           ];
 
 ///////////// END CONSTANTS ////////////////
 
 ///////////// GLOBAL VARIABLES ///////////////
 // All displayable characters.  Default to ASCII order.
 string gCharIndex;
 // This is the channel to listen on while acting
 // as a cell in a larger display.
 integer gCellChannel      = -1;
 // This is the starting character position in the cell channel message
 // to render.
 integer gCellCharPosition = 0;
 /////////// END GLOBAL VARIABLES ////////////
 
 ResetCharIndex() {
     gCharIndex  = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`";
     // \" <-- Fixes LSL syntax highlighting bug.
     gCharIndex += "abcdefghijklmnopqrstuvwxyz{|}~";
     gCharIndex += "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n";
 }
 
 vector GetGridPos(integer index1, integer index2) {
     // There are two ways to use the lookup table...
     integer Col;
     integer Row;
     if (index1 >= index2) {
         // In this case, the row is the index of the first character:
         Row = index1;
         // And the col is the index of the second character (x2)
         Col = index2 * 2;
     }
     else { // Index1 < Index2
         // In this case, the row is the index of the second character:
         Row = index2;
         // And the col is the index of the first character, x2, offset by 1.
         Col = index1 * 2 + 1;
     }
     return < Col, Row, 0>;
 }
 
 string GetGridTexture(vector grid_pos) {
     // Calculate the texture in the grid to use.
     integer GridCol = llRound(grid_pos.x) / 20;
     integer GridRow = llRound(grid_pos.y) / 10;
 
     // Lookup the texture.
     key Texture = llList2Key(CHARACTER_GRID, GridRow * (GridRow + 1) / 2 + GridCol);
     return Texture;
 }
 
 vector GetGridOffset(vector grid_pos) {
     // Zoom in on the texture showing our character pair.
     integer Col = llRound(grid_pos.x) % 20;
     integer Row = llRound(grid_pos.y) % 10;
 
     // Return the offset in the texture.
     return <-0.45 + 0.05 * Col, 0.45 - 0.1 * Row, 0.0>;
 }
 
 ShowChars(vector grid_pos1, vector grid_pos2, vector grid_pos3) {
     // Set the primitive textures directly.
     llSetPrimitiveParams( [
         PRIM_TEXTURE, LEFT_FACE,   GetGridTexture(grid_pos1), <0.1, 0.1, 0>, GetGridOffset(grid_pos1), PI_BY_TWO,
         PRIM_TEXTURE, MIDDLE_FACE, GetGridTexture(grid_pos2), <0.1, 0.1, 0>, GetGridOffset(grid_pos2), 0.0,
         PRIM_TEXTURE, RIGHT_FACE,  GetGridTexture(grid_pos3), <0.1, 0.1, 0>, GetGridOffset(grid_pos3), -PI_BY_TWO
         ]);
 }
 
 RenderString(string str) {
     // Get the grid positions for each pair of characters.
     vector GridPos1 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 0, 0)),
                                   llSubStringIndex(gCharIndex, llGetSubString(str, 1, 1)) );
     vector GridPos2 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 2, 2)),
                                   llSubStringIndex(gCharIndex, llGetSubString(str, 3, 3)) );
     vector GridPos3 = GetGridPos( llSubStringIndex(gCharIndex, llGetSubString(str, 4, 4)),
                                   llSubStringIndex(gCharIndex, llGetSubString(str, 5, 5)) );
 
     // Use these grid positions to display the correct textures/offsets.
     ShowChars(GridPos1, GridPos2, GridPos3);
 }
 
 RenderExtended(string str) {
     // Look for escape sequences.
     list Parsed       = llParseString2List(str, [], [ESCAPE_SEQUENCE]);
     integer ParsedLen = llGetListLength(Parsed);
 
     // Create a list of index values to work with.
     list Indices;
     // We start with room for 6 indices.
     integer IndicesLeft = 6;
 
     integer i;
     string Token;
     integer Clipped;
     integer LastWasEscapeSequence = FALSE;
     // Work from left to right.
     for (i = 0; i < ParsedLen && IndicesLeft > 0; i++) {
         Token = llList2String(Parsed, i);
 
         // If this is an escape sequence, just set the flag and move on.
         if (Token == ESCAPE_SEQUENCE) {
             LastWasEscapeSequence = TRUE;
         }
         else { // Token != ESCAPE_SEQUENCE
             // Otherwise this is a normal token.  Check its length.
             Clipped = FALSE;
             integer TokenLength = llStringLength(Token);
             // Clip if necessary.
             if (TokenLength > IndicesLeft) {
                 Token = llGetSubString(Token, 0, IndicesLeft - 1);
                 TokenLength = llStringLength(Token);
                 IndicesLeft = 0;
                 Clipped = TRUE;
             }
             else
                 IndicesLeft -= TokenLength;
 
             // Was the previous token an escape sequence?
             if (LastWasEscapeSequence) {
                 // Yes, the first character is an escape character, the rest are normal.
 
                 // This is the extended character.
                 Indices += [llSubStringIndex(EXTENDED_INDEX, llGetSubString(Token, 0, 0)) + 95];
 
                 // These are the normal characters.
                 integer j;
                 for (j = 1; j < TokenLength; j++)
                     Indices += [llSubStringIndex(gCharIndex, llGetSubString(Token, j, j))];
             }
             else { // Normal string.
                 // Just add the characters normally.
                 integer j;
                 for (j = 0; j < TokenLength; j++)
                     Indices += [llSubStringIndex(gCharIndex, llGetSubString(Token, j, j))];
             }
 
             // Unset this flag, since this was not an escape sequence.
             LastWasEscapeSequence = FALSE;
         }
     }
 
     // Use the indices to create grid positions.
     vector GridPos1 = GetGridPos( llList2Integer(Indices, 0), llList2Integer(Indices, 1) );
     vector GridPos2 = GetGridPos( llList2Integer(Indices, 2), llList2Integer(Indices, 3) );
     vector GridPos3 = GetGridPos( llList2Integer(Indices, 4), llList2Integer(Indices, 5) );
 
     // Use these grid positions to display the correct textures/offsets.
     ShowChars(GridPos1, GridPos2, GridPos3);
 }
 
 integer ConvertIndex(integer index) {
     // This converts from an ASCII based index to our indexing scheme.
     if (index >= 32) // ' ' or higher
         index -= 32;
     else { // index < 32
         // Quick bounds check.
         if (index > 15)
             index = 15;
 
         index += 94; // extended characters
     }
 
     return index;
 }
 
 default {
     state_entry() {
         // Initialize the character index.
         ResetCharIndex();
 
         //llSay(0, "Free Memory: " + (string) llGetFreeMemory());
     }
 
     link_message(integer sender, integer channel, string data, key id) {
         if (channel == DISPLAY_STRING) {
             RenderString(data);
             return;
         }
         if (channel == DISPLAY_EXTENDED) {
             RenderExtended(data);
             return;
         }
         if (channel == gCellChannel) {
             // Extract the characters we are interested in, and use those to render.
             RenderString( llGetSubString(data, gCellCharPosition, gCellCharPosition + 5) );
             return;
         }
         if (channel == REMAP_INDICES) {
             // Parse the message, splitting it up into index values.
             list Parsed = llCSV2List(data);
             integer i;
             // Go through the list and swap each pair of indices.
             for (i = 0; i < llGetListLength(Parsed); i += 2) {
                 integer Index1 = ConvertIndex( llList2Integer(Parsed, i) );
                 integer Index2 = ConvertIndex( llList2Integer(Parsed, i + 1) );
 
                 // Swap these index values.
                 string Value1 = llGetSubString(gCharIndex, Index1, Index1);
                 string Value2 = llGetSubString(gCharIndex, Index2, Index2);
 
                 gCharIndex = llDeleteSubString(gCharIndex, Index1, Index1);
                 gCharIndex = llInsertString(gCharIndex, Index1, Value2);
 
                 gCharIndex = llDeleteSubString(gCharIndex, Index2, Index2);
                 gCharIndex = llInsertString(gCharIndex, Index2, Value1);
             }
             return;
         }
         if (channel == RESET_INDICES) {
             // Restore the character index back to default settings.
             ResetCharIndex();
             return;
         }
         if (channel == SET_CELL_INFO) {
             // Change the channel we listen to for cell commands, and the
             // starting character position to extract from.
             list Parsed = llCSV2List(data);
             gCellChannel        = (integer) llList2String(Parsed, 0);;
             gCellCharPosition   = (integer) llList2String(Parsed, 1);
             return;
         }
     }
 }