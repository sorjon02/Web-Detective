

# Create a global structure to make it easier to pass values between
# functions in this module
$Global:ISPGuiGlobals = [PSCustomObject]@{
    DbPath = ""
    DNSList = ""
}

Function SetPath {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $DbPath
    )
    $Global:ISPGuiGlobals.DbPath = $DbPath
}

# Import the functionality provided by .\Library\ISPQuery.ps1
. .\Library\ISPQery.ps1

Function GetCurrentDirLevel {
    return ".\database\Europe\Sweden\Västerbotten\Umeå"
}

Function CreatePopupWindow {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    # Create a new form for a popup query about the users ISP
    $form = New-Object System.Windows.Forms.Form
    $form.Width = 280;
    $form.Height = 200;
    $form.Text = "Web Detective"
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;

    ##############Define the text label
    $textLabel1 = New-Object System.Windows.Forms.Label
    $textLabel1.Left = 25;
    $textLabel1.Top = 15;
    $textLabel1.AutoSize =$true
    $textLabel1.Text = "Please select your Internet Service Provider"
    $form.Controls.Add($textLabel1);

    #### Create the ComboBox and populate it
    $my_ComboBox = New-Object System.Windows.Forms.ComboBox
    $my_ComboBox.Location = New-Object System.Drawing.Point( 25, 40 )
    $my_ComboBox.Width = 220
    $my_ComboBox.Add_DropDownClosed([System.EventHandler]{
        $myTemp = $my_ComboBox.SelectedItem.ToString()
        SetCity($Global:ISPGuiGlobals.DbPath)
        $myTemp2 = CreateDNSList($myTemp)
        $Global:ISPGuiGlobals.DNSList = $myTemp2
        $form.Close()
    })
    $form.Controls.Add($my_ComboBox)
    $DbPointer = GetCurrentDirLevel
    $List = CreateISPList($DbPointer)
    $my_array = $List -Split ","
    for($i = 0; $i -lt $my_array.length; $i++){
        $my_ComboBox.Items.Add($my_array[$i])
    }

    # Show the form
    $ret = $form.ShowDialog()

    $MyRetvalue = $Global:ISPGuiGlobals.DNSList
    return $MyRetvalue
}
