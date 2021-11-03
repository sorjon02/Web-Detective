#
# Copyright 2021, Sören Jonsson
#
# This file is part of Web Detective.
#
#    Web Detective is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    Web Detective is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with Foobar.  If not, see <https://www.gnu.org/licenses/>.

# Create a data structure containing variables who
# has tobe accessible from all functions in the user
# interface. It is followed by a set of functins who
# has the sole purpose to cange or access the values  
# in this set of information.
$global:UIGlobals = [PSCustomObject]@{
    nextComboBoxXPos = 20
    nextComboBoxYPos = 60
    CurrentDirLevel = 0     # This is an index into listOfDirs
    BasicTests_button = 0
    replyTextBox = 0
    listOfDirs = @(0,1,2,3,4,5,6,7,8,9,10,11)
}

# Import the functions from .\libraries\BasicAccess.ps1
# . .\libraries\BasicAccess.ps1

Function AddTextInfoBox {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $NewLine
    )

    $global:UIGlobals.replyTextBox.Text += $NewLine
    $global:UIGlobals.replyTextBox.Text += [System.Environment]::NewLine
}

# Begining of the methods for access to global info
Function ShowComboBox {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Int] $BoxNr
    )
    $global:UIGlobals.listOfDirs[$BoxNr].show()
}

Function HideComboBox {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Int] $BoxNr
    )
    $global:UIGlobals.listOfDirs[$BoxNr].hide()
}

Function ClearCombobox {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Int] $BoxNr
    )
    $global:UIGlobals.listOfDirs[$BoxNr].Items.clear()
}

Function GetSelectedPath{
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Int] $currentIndex
    )
    $retval = "database"
    for($i=0; $i -le $currentIndex; $i++) {
        $my_temp = $global:UIGlobals.listOfDirs[$i].SelectedItem
        $retval = $retval + "\" + $my_temp
    }
    return $retval
}

# Populate Combobox populates a ComboBox with appropriate names
# of subdirectories. (Europe\Sweden\Västerbotten etc.)
# This allows the user to make a GUI path selection in the database
Function PopulateComboBox {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $Path
    )
    $Level = GetCurrentDirLevel
    $temp1 = Get-ChildItem $Path -Directory
    for( $DirNr=0; $DirNr -lt $temp1.count ; $DirNr++ ) {
        $global:UIGlobals.listOfDirs[$Level].Items.Add( $temp1[$DirNr].Name ) 
    }
}

Function SetupEventHandlers {
    # Set up the event handlers for the ComboBoxes
    # This cannot be done using variables. (Attempt has
    # been made, and failed.) Hard coding the parameter is
    # the only option.
    $global:UIGlobals.listOfDirs[0].Add_DropDownClosed( { EventHandlerComboBoxes(0) })
    $global:UIGlobals.listOfDirs[1].Add_DropDownClosed( { EventHandlerComboBoxes(1) })
    $global:UIGlobals.listOfDirs[2].Add_DropDownClosed( { EventHandlerComboBoxes(2) })
    $global:UIGlobals.listOfDirs[3].Add_DropDownClosed( { EventHandlerComboBoxes(3) })
    $global:UIGlobals.listOfDirs[4].Add_DropDownClosed( { EventHandlerComboBoxes(4) })
    $global:UIGlobals.listOfDirs[5].Add_DropDownClosed( { EventHandlerComboBoxes(5) })
    $global:UIGlobals.listOfDirs[6].Add_DropDownClosed( { EventHandlerComboBoxes(6) })
    $global:UIGlobals.listOfDirs[7].Add_DropDownClosed( { EventHandlerComboBoxes(7) })
    $global:UIGlobals.listOfDirs[8].Add_DropDownClosed( { EventHandlerComboBoxes(8) })
    $global:UIGlobals.listOfDirs[9].Add_DropDownClosed( { EventHandlerComboBoxes(9) })
    $global:UIGlobals.listOfDirs[10].Add_DropDownClosed( { EventHandlerComboBoxes(10) })
    $global:UIGlobals.listOfDirs[11].Add_DropDownClosed( { EventHandlerComboBoxes(11) })
}

# Create directory dropboxes, to allow the user to navigate
# The geographical database to a nerby city for localized testing.
Function CreateDropboxLine {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Object] $ParentForm
    )

    For( $i = 0; 12 -gt $i; $i++) {
        $global:UIGlobals.listOfDirs[$i] = New-Object System.Windows.Forms.ComboBox
        $global:UIGlobals.listOfDirs[$i].location = New-Object System.Drawing.Point( 
            $global:UIGlobals.nextComboBoxXPos, 
            $global:UIGlobals.nextComboBoxYPos
        )

        # Hide all ComboBoxes except the first one (Displaying the names of the continents)
        if(0 -lt $i) {
            $global:UIGlobals.listOfDirs[$i].Hide()
        }
        
        $ParentForm.Controls.Add($global:UIGlobals.listOfDirs[$i])
       
        $global:UIGlobals.nextComboBoxYPos += 25
    }
}

Function SetCurrentDirLevel {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Int] $Level
    )
    $global:UIGlobals.CurrentDirLevel = $Level
}

Function GetCurrentDirLevel {
    $retval =  $global:UIGlobals.CurrentDirLevel
    return $retval
}
# End of the methods for access to global info

# Create a function that creates the main window
function CreateMainWindow {
    $retval = New-Object System.Windows.Forms.Form
    $retval.Text = "Web Detective"
    $retval.Width = 600
    $retval.Height = 400
    $retval.AutoSize = $True

    return $retval
}

# Create a function that creates a label object used to
# give this application it's name.
function CreateAppName {
    $retval = New-Object System.Windows.Forms.Label
    $retval.Text = "Troubleshooting the Internet"
    $my_font = New-Object System.Drawing.Font("Segoe UI Variable", 14, [System.Drawing.Fontstyle]::Bold)
    $retval.Font = $my_font
    $retval.Location = New-Object System.Drawing.Point(200,10)
    $retval.AutoSize = $True

    return $retval
}

# Create a function that creates a label object used to
# give this application it's name.
function CreateSubtitle {
    $retval = New-Object System.Windows.Forms.Label
    $retval.Text = "Troubleshooting the Internet"
    $my_font = New-Object System.Drawing.Font("Segoe UI Variable", 11)
    $retval.Font = $my_font
    $retval.Location = New-Object System.Drawing.Point(200,40)
    $retval.AutoSize = $True

    return $retval
}

# Create a function that creates a label object used to
# give this application it's name.
function CreateInstructions {
    $retval = New-Object System.Windows.Forms.Label
    $retval.Text = "I live in, or near to, this city."
    $retval.Location = New-Object System.Drawing.Point(20, 40)
    $retval.AutoSize = $True

    return $retval
}

# The following function will create an exit button for the application.
Function CreateExitButton {
    $retval = New-Object System.Windows.Forms.Button
    $retval.Location = New-Object System.Drawing.Size(500,380)
    $retval.Size = New-Object System.Drawing.Size(120,23)
    $retval.Text = "Exit"
    $retval.Add_Click({
        . .\Library\BasicAccess.ps1 
        $main_form.add_formClosing({$_.Cancel=$False})
        $Main_form.Close() 
    } )

    return $retval
}

# The following function will create an exit button for the application.
Function CreatetButtonBasicTests {
    $retval = New-Object System.Windows.Forms.Button
    $retval.Location = New-Object System.Drawing.Size(150,340)
    $retval.Size = New-Object System.Drawing.Size(160,23)
    $retval.Text = "Run Basic Tests"
    $retval.Add_Click( { 
        # Inport the functionality created in .\Library\BasicAccess.ps1
        . .\Library\BasicAccess.ps1
        . .\Library\ISPQueryGUI.ps1

        # If the config file don't exist, then create it
        if(-not (Test-Path -Path .\library\netconfig.ps1 -PathType Leaf) ){
            # Open a query window, and ask the user about hes/her ISP
            $my_temp = GetSelectedPath($global:UIGlobals.CurrentDirLevel)
            SetPath($my_temp)
            SetPath($my_temp)
            $my_DNSServers = CreatePopupWindow
            
            # And use the $my_DNSServers list to create the config file
            createConfigFile($my_DNSServers[2] )
        }

        # And now, do the basic Intenet access tests and write out any message
        # in the information text box
        $message = doBasicTests
        AddTextInfoBox($message)
    } )

    # Make the button available in the event handler
    $global:UIGlobals.BasicTests_button = $retval

    $retval.Hide()

    return $retval
}

# This function will list the subdirectories of dir, the
# only input parameter. It will be used to traverse the
# host database. It will add the list of directories to a
# ComboBox object, and return it for use in the GUI
#
# The name TraverseTree reflects that it traverses the subdirectories of
# the Web Detective database, and retirns info about different cities.
#
Function TraverseTree {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $dir
    )

    $retval = Get-ChildItem $dir -Directory
    
    return $retval
}

# IsLeaf determines if a path in the database leads to a leaf directory,
# with no subdirectories. It returns $true or $false
Function IsLeaf {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $Path
    )
    $reply = Get-ChildItem -Path $Path -Directory

    if( 0 -eq $reply.Length) {
        $retval = $True
    } else {
        $retval = $false
    }
    return $retval
}

# Create a common event handler for ComboBoxes
Function EventHandlerComboBoxes {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [Int] $BoxNr
    )

    # Make the current directory level known to the rest of the application
    #$wshell = New-Object -ComObject Wscript.Shell
    #$wshell.Popup("You are now in the ComboBox.Add_DropDownClosed event. Generated from box: " + $BoxNr) 

    # Where in the database directory structure is the ComboBoxes pointing?
    SetCurrentDirLevel($BoxNr + 1) 
    $selectedDir = GetSelectedPath($BoxNr)
    $leaf = IsLeaf($selectedDir)
    for($i = $BoxNr + 1; $i -lt 12; $i++){
        HideComboBox($i)
        ClearCombobox($i)
    }
    if( $false -eq $leaf ) {
        # Not a path to a leaf directory
        PopulateComboBox($selectedDir)
        ShowComboBox($BoxNr + 1)
        $global:UIGlobals.BasicTests_button.Hide()
    } else {
        #$global:UIGlobals.CurrentDirLevel = $BoxNr
        $global:UIGlobals.BasicTests_button.show()
    }
}

Function CreateReplyTextBox {
    $retval = New-Object System.Windows.Forms.TextBox
    $retval.Multiline = $true
    $retval.Location = New-Object System.Drawing.Point(180,100)
    $retval.Size = New-Object System.Drawing.Size(400,220)
    $global:UIGlobals.replyTextBox = $retval

    return $retval
}
Function GenerateForm {

    # Make .NET forms available here
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    # Create a form for the WebDetective application 
    $main_form = CreateMainWindow

    # Create a label showing the purpose of the application
    $Name_label = CreateAppName
    $main_form.Controls.Add($Name_label)

     # Create a label showing the subtitle
     $Subtitle_label = CreateSubtitle
     $main_form.Controls.Add($Subtitle_label)

    # Create the instructions label
    $labelInstructions = CreateInstructions
    $main_form.Controls.Add($labelInstructions)

    # Create an exit button
    $Exit_button = CreateExitButton
    $main_form.Controls.Add($Exit_button)

    # Create the "Run Basic Tets"  button
    $BasicTests_button = CreatetButtonBasicTests
    $main_form.Controls.Add($BasicTests_button)

    # Create the line of ComboBoxes that let the user select hes/her location
    CreateDropboxLine($main_form)
     # Set up the ComboBox event handling
    SetupEventHandlers


    # Populate the Combo Box for the rot directory of the database
    PopulateComboBox(".\database")

    # Create the text box where the application will write
    # all information to the user.
    $infoTextBox = CreateReplyTextBox
    $main_form.Controls.Add($infoTextBox)
   
    $main_form.ShowDialog() | Out-Null

} #End Function

 GenerateForm | Out-Null

