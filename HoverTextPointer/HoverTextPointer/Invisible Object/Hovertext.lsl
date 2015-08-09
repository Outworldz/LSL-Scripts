// :CATEGORY:Hovertext
// :NAME:HoverTextPointer
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-17 18:02:25
// :EDITED:2014-12-17
// :ID:1063
// :NUM:1706
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Puts a arrow below text to point down at something
// :CODE:
default
{
    state_entry()
    {
        string text = llGetObjectDesc();
       llSetText(text + "\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n█\n▼,",<1,1,1>,1.0);
    }

}
