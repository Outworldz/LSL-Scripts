// :CATEGORY:Cache
// :NAME:View_Your_Second_Life_Cache
// :AUTHOR:Ferd Frederix
// :CREATED:2010-11-04 13:44:29.640
// :EDITED:2013-09-18 15:39:09
// :ID:955
// :NUM:1376
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The VB Script - runs from the command prompt
// :CODE:

' run this with the following command in windows boxes:
' cscript show.vbs
' browse to the cache texture folder for
' Vista : C:\Users\YOURNAME\AppData\Local\SecondLife\texturecache
' XP:  C:\Documents and Settings\fred\Local Settings\Application Data\SecondLife\texturecache

' open the resulting file FileList0.htm with a web browser to view your cache and the UUID 
' each folder will be made into a separate web page with a Next button to view them

option Explicit ' all vars must be declared 
Dim fso, folder, files, NewsFile,sFolder, subfolder,subfiles, path, counter,sCount,folderIdx,fName,NewFile,subfolderIdx,spos,epos,Name

sFolder = BrowseFolder( "C:\", True )

Set fso = CreateObject("Scripting.FileSystemObject")    

counter = 0
Set folder = fso.GetFolder(sFolder)
Set files = folder.SubFolders
For each folderIdx In files
  path = sFolder & "\" & folderIdx.Name
  fName = "FileList" & counter & ".htm"
  
  Set NewFile = fso.CreateTextFile(fName, True)
  
  Set subfolder = fso.GetFolder(path)
  Set subfiles = subfolder.Files
  For each subfolderIdx in subfiles
    name = subfolderIdx.Name
    name= Replace(name,".texture","")
    NewFile.WriteLine("<img src='http://secondlife.com/app/image/" + name + "/2'><br><p> "  & name & " </p>" )
  Next
  counter = counter + 1
  NewFile.WriteLine("<p><a href='FileList" & counter & ".htm'>Next Page</a></p>")
  NewFile.Close
Next
Wscript.Echo "Open 'FileList0.htm' in a web browser to view your cache"
  
Function BrowseFolder( myStartLocation, blnSimpleDialog )
' This function generates a Browse Folder dialog
    Const MY_COMPUTER   = &H11&
    Const WINDOW_HANDLE = 0 ' Must ALWAYS be 0

    Dim numOptions, objFolder, objFolderItem
    Dim objPath, objShell, strPath, strPrompt

    ' Set the options for the dialog window
    strPrompt = "Select a folder:"
    If blnSimpleDialog = True Then
        numOptions = 0      ' Simple dialog
    Else
        numOptions = &H10&  ' Additional text field to type folder path
    End If
    
    ' Create a Windows Shell object
    Set objShell = CreateObject( "Shell.Application" )

    ' If specified, convert "My Computer" to a valid
    ' path for the Windows Shell's BrowseFolder method
    If UCase( myStartLocation ) = "MY COMPUTER" Then
        Set objFolder = objShell.Namespace( MY_COMPUTER )
        Set objFolderItem = objFolder.Self
        strPath = objFolderItem.Path
    Else
        strPath = myStartLocation
    End If

    Set objFolder = objShell.BrowseForFolder( WINDOW_HANDLE, strPrompt, _
                                              numOptions, strPath )

    ' Quit if no folder was selected
    If objFolder Is Nothing Then
        BrowseFolder = ""
        Exit Function
    End If

    ' Retrieve the path of the selected folder
    Set objFolderItem = objFolder.Self
    objPath = objFolderItem.Path

    ' Return the path of the selected folder
    BrowseFolder = objPath
End Function

