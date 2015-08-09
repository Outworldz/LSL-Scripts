// :CATEGORY:Notecard Reader
// :NAME:Configuration_Notecard_Reader
// :AUTHOR:Dedric Mauriac
// :CREATED:2011-01-22 12:16:49.847
// :EDITED:2013-09-18 15:38:51
// :ID:201
// :NUM:274
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//     * Create a script//     * Read each line of a note card//     * Skip over comments//     * Skip blank lines//     * Notify the owner of the lines with unknown settings//           o Unknown setting name
//           o Missing delimiter (equal sign) 
//     * Notify the owner of missing configuration note card
//     * Detect when the notecard has been changed
//     * Offer case-insensitive settings
//     * Trim white-space from name/value settings
//     * Initialize with default values
//     * Detect that the name of the configuration file is a notecard
//     * Detect that you have reached the end of the file 
// :CODE:
# this is a file to configure your application
# blank lines are ignored as well as lines
# proceeded with a "#" sign.
Name = Dedric Mauriac
Favorite Color = Blue
