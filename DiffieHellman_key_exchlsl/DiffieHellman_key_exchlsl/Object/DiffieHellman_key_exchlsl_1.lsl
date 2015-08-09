// :CATEGORY:Encryption
// :NAME:DiffieHellman_key_exchlsl
// :AUTHOR:John Hurliman 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:237
// :NUM:325
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Diffie-Hellman_key_exch-lsl.lsl
// :CODE:


// Diffie-Hellman Key Exchange
// Proof of concept, v0.0.1
//
// This is initial proof of concept code for a Diffie-Hellman key exchange in
// LSL. It's intended for eventual use in securing an XML-RPC channel to the
// outside world, and is not a secure solution in game as Diffie-Hellman
// provides no authentication mechanism.
//
// USE: Drop this script in a two separate prims, click on one of them to
// initiate the exchange protocol. A new secret value will be generated for
// the initiator each time you click.
//
// NOTES: The llModPow() function limits our secret key (exponent) size to
// 0xFFFF (16 bits). No testing has been done with using negative exponents,
// that could potentially double the size of the secret key space. 16 bit
// encryption is trivial to crack, making this a limited use algorithm
// for specific cases, not a general purpose security layer. p and g were
// picked somewhat at random, and I was having problems using a larger prime
// number. It would be worthwhile to investigate the problem and find the exact
// limits of this algorithm. Also the open_channel value would not exist in an
// XML-RPC implementation, so that value is negligible. Better string parsing
// should be used to prevent bad data (like "INIT123ABC"), and a more compact
// data format should be used to save precious characters in XML-RPC
// transportation.
//
//(c)(cc-by) John Hurliman (jhurliman{at}wsu.edu | [url]http://www.jhurliman.org/[/url])
// [url]http://creativecommons.org/licenses/by/2.5/[/url]

integer x; // Secret exponent
integer p = 38183; // Public (palindromic) Sophie Germain prime
integer g = 53; // Public generator
integer open_channel = 14614510; // Open channel for key exchange example
float x_limit = 65535.0; // Limit for the random 16-bit integer x

default
{
    state_entry()
    {
        // Generate an initial secret exponent
        x = llFloor(llFrand(x_limit)) + 1;

        // Start listening on the key exchange channel
        llListen(open_channel, "", NULL_KEY, "");
        llWhisper(0, "LSL Diffie-Hellman v0.0.1, secret is " + (string)x + ". Listening...");
    }

    touch_start(integer total_number)
    {
        // Generate a new secret exponent for the new session
        x = llFloor(llFrand(x_limit)) + 1;
        llWhisper(0, "New secret is " + (string)x);
        
        integer ya = llModPow(g, x, p);
        
        // Send computed ya to target
        llSay(open_channel, "INIT" + (string)ya);
        llWhisper(0, "Sent INIT" + (string)ya);
    }

    listen(integer channel, string name, key id, string message)
    {
        // Ignore our own messages
        if (id != llGetKey())
        {
            if (llGetSubString(message, 0, 3) == "INIT")
            {
                llWhisper(0, "Got init message: " + message + " from " + (string)id);
                integer ya = (integer)llDeleteSubString(message, 0, 3);
                integer k = llModPow(ya, x, p);
                llWhisper(0, "Computed key " + (string)k);
                
                // Send our response
                integer yb = llModPow(g, x, p);
                llSay(open_channel, "RESP" + (string)yb);
                llWhisper(0, "Sent RESP" + (string)yb);
            }
            
            else if (llGetSubString(message, 0, 3) == "RESP")
            {
                llWhisper(0, "Got response message: " + message + " from " + (string)id);
                integer yb = (integer)llDeleteSubString(message, 0, 3);
                integer k = llModPow(yb, x, p);
                llWhisper(0, "Computed key " + (string)k);
            }
        }
    }
}     // end 
