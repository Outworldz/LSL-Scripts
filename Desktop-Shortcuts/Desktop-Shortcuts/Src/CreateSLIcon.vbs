// :CATEGORY:Shortcut
// :NAME:Desktop-Shortcuts
// :AUTHOR:Ferd Frederix
// :KEYWORDS:Shortcut
// :CREATED:2014-02-20 14:20:12
// :EDITED:2014-02-20
// :ID:1026
// :NUM:1596
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Desktop Shortcut creator script to a landmark in world.
// :CODE:

'  VBScript for windows boxes, "wscript CreateSLIcon" to run it, or double click it.

' Desktop Shortcut creator script
' author: Fred Beckhusen
' puts Icon to Windows desktops pointing to a Location
' declare a few places to save things in
Dim  Shortcut, DesktopPath, Region, Name

Region = "Phaze Demesnes/128/129/22"  ' where they are to go
Name = "Visit Phaze"    ' the name of the shortcut

' Need to access special folders such as desktop....
Set WSHShell = WScript.CreateObject("WScript.Shell")
' get a path to the current desktop
DesktopPath = WSHShell.SpecialFolders("Desktop")
' Create a shortcut object for us to fill in the properties.  It is not saved yet
Set Shortcut = WSHShell.CreateShortcut(DesktopPath & "/" & Name & ".lnk")
' Get an Icon from Shell32.dll
Shortcut.IconLocation = "SHELL32.dll, 34" ' the 34th icon in this is representative of a viewer
Shortcut.Targetpath = "secondlife://" & Region

' Save it
Shortcut.Save
