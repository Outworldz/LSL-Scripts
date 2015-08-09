// :CATEGORY:Shortcut
// :NAME:Desktop-Shortcuts
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Shortcut
// :CREATED:2014-02-20 14:20:12
// :EDITED:2014-02-20
// :ID:1026
// :NUM:1594
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Desktop Shortcut creator template script to a landmark in world.
// :CODE:

' Desktop Shortcut creator script
' author: Fred Beckhusen
' puts Icon to Firestorm on Windows desktops pointing to a Given Grid

' declare a few places to save things in
Dim  Shortcut, DesktopPath,  Target, Workingdirectory, Folder, Exe, nBits

' You need to fill this in for the particular viewer defaults
Folder = "Firestorm-OS"   ' I am using Firestorm in This folder
Exe = "Firestorm-Release.exe" ' and the name of the exe file in the above folder
nBits = [% nBits]  ' could be 64 for Singulatity

'  Add any arguments.   I do them one at a time for readibility ( remember the spaces )
' see http://wiki.secondlife.com/wiki/Viewer_parameters
Arguments = " --settings settings_firestorm-release_v4.xml "
Arguments = Argumants & " --channel Firestorm-Release "  ' a unique cache folder name
Arguments = Arguments & " --set InstallLanguage en  "    ''your language for the viewer  to use

' yes all the double quotes are necessary
' uncomment just ONE line, please.

'Arguments = Arguments & " --loginuri ""login.osgrid.org"" "    '' okay,. OsGrid hates the http, no idea whym but this work.
'Arguments = Arguments & " --loginuri ""http://login.inworldz.com:8002/"" "
'Arguments = Arguments & " --loginuri ""http://sim.3dgrid.de:8002/"" "
'Arguments = Arguments & " --loginuri ""https://login.avination.com/"" "
'Arguments = Arguments & " --loginuri ""http://craft-world.org:8002/"" "
Arguments = Arguments & " --loginuri ""http://www.kitely.com:8002/"" "
'Arguments = Arguments & " --loginuri ""http://hypergrid.org:8002/"" "
'Arguments = Arguments & " --loginuri ""https://login.agni.lindenlab.com/cgi-bin/login.cgi"" "


' Need to access special folders such as desktop....
Set WSHShell = WScript.CreateObject("WScript.Shell")

' Use %PROGRAMFILES(x86) for 32 bit viewers
' Use '%PROGRAMFILES%' for 64 bit viewers
if nBits = 64 then
   Workingdirectory  = WSHShell.ExpandEnvironmentStrings("%ProgramFiles%") & "\" & Folder
else
   Workingdirectory  = WSHShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\" & Folder
end if

Target = Workingdirectory & "\" &  Exe

' get a path to the current desktop
DesktopPath = WSHShell.SpecialFolders("Desktop")

' Create a shortcut object for us to fill in the properties.  It is not saved yet
Set Shortcut = WSHShell.CreateShortcut(DesktopPath & "/" & "[% name %]" & ".lnk")

Shortcut.workingdirectory  = Workingdirectory

' Make the Target path  and all arguments
Shortcut.TargetPath = Target
Shortcut.Arguments = Arguments

' There can be a HotKey associated with the shortcut, too
' put the property into the Shortcut object

Shortcut.Hotkey = "[% hotkey %]"

' Get an Icon from Shell32.dll
' put the property into the Shortcut object

Shortcut.IconLocation = "SHELL32.dll, [% icon %]" ' the 34th icon in this is representative of a viewer

Shortcut.Hover = [% hover %]

' Save it
Shortcut.Save
'Catch the error
If Err <> 0 Then
    msgbox "Error saving shortcut " & Err
End If

' the icon will now appear.
