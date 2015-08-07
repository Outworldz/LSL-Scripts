// :CATEGORY:Email
// :NAME:Simple_Email_Parser
// :AUTHOR:Plowboy Lifestyle
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:760
// :NUM:1047
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
default {
    state_entry() {
        llEmail((string)llGetKey() + "@lsl.secondlife.com", "Test!", "This (is) a test message.\n This is test message line two."); // Send email to self.
        llSetTimerEvent(2.5); // Poll for emails. (Yes, that is a retarded way on an event-based system!)
    }
    
    timer() {
        llGetNextEmail("", ""); // Check for email with any sender address and subject.
    }
    
    email(string time, string address, string subj, string message, integer num_left) {
        string object_name;
        string region_name;
        float region_corner_x;
        float region_corner_y;
        vector local_position;
        string message_body;
        
        // Parse email to list
        list email_parts = llParseString2List(message,[],["\n"," (",")",", ","Object-Name: ","Region: "]);
        list format_parts = ["Object-Name: ","x","\n","Region: ","x"," (","X",", ","X",")","\n","Local-Position:"," (","X",", ","X",", ","X",")","\n","\n"];
        // Determine if email is properly formatted.
        integer error = FALSE;
        if (llGetListLength(email_parts)>20) {
            integer n;
            for (n=0;n<21;n++) {
                string f = llList2String(format_parts,n);
                string e = llList2String(email_parts,n);
                if ((f!="x")&&(f!="X")) {
                    if (f!=e) error = TRUE;
                }
            }
        }
        else {
            error = TRUE;
        }
                   
        if (error) {
            object_name = "unknown";
            region_name = "unknown";
            region_corner_x = -1.0;
            region_corner_y = -1.0;
            local_position = ZERO_VECTOR; 
            message_body = message;
        }
        else {
            object_name = llList2String(email_parts,1);
            region_name = llList2String(email_parts,4);
            region_corner_x = (float)llList2String(email_parts,6);
            region_corner_y = (float)llList2String(email_parts,8);
            local_position = <(float)llList2String(email_parts,13),
                                (float)llList2String(email_parts,15),
                                (float)llList2String(email_parts,17)>;
            message_body = llDumpList2String(llDeleteSubList(email_parts, 0, 20),"");
        }
        
        llSay(0, "You got mail! " + (string)num_left + " more mails.");
        llSay(0, "Unix Time: " + (string)time);
        llSay(0, "Address: " + (string)address);
        llSay(0, "Subject: " + (string)subj);
        llSay(0, "Object_Name: "+(string)object_name);
        llSay(0, "Region_Name: "+(string)region_name);
        llSay(0, "Region_Corner_x: "+(string)region_corner_x);
        llSay(0, "Region_Corner_y: "+(string)region_corner_y);
        llSay(0, "Local_Position: "+(string)local_position);
        llSay(0, "Message_Body: "+(string)message_body);
    }
}
