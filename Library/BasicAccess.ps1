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

# This function will run if and only if the configuration file
# netconfig.ps1 does not exist in the same directory. It will collect
# essential network information, and store it as a config file.
# It will make it possible to run the diagnostics without any network connection
function CreateConfigFile {
    "# This is the config flie for nettest.ps1" | Out-File -FilePath .\Library\netconfig.ps1
    # Create a window object to display information to the user.
    "`$global:BasicTestGlobals = [PSCustomObject]@{" | Out-File -FilePath .\Library\netconfig.ps1
    
        "    localhost = `"127.0.0.1`"" | Out-File -FilePath .\Library\netconfig.ps1 -Append
        $mytemp1 = ipconfig
        $mytemp2 = Write-Output $mytemp1 | grep "IPv4"
        $mytemp3 = $mytemp2.split(":")
        "    myhost = `"" + $mytemp3[1].trim() + "`"" | Out-File -FilePath .\Library\netconfig.ps1 -Append
        $mytemp2 = Write-Output $mytemp1 | grep "Gateway"
        $mytemp3 = $mytemp2.split(":")
        "    myrouter = `"" + $mytemp3[1].trim() + "`"" | Out-File -FilePath .\Library\netconfig.ps1 -Append
        $mytemp1 = tracert www.riksdagen.se
        $mytemp2 = $mytemp1.split("]")
        $mytemp3 = $mytemp2[7]
        $mytemp1 = $mytemp3.split("[")
        "    myISP = `"" + $mytemp1[1] +"`"" | Out-File -FilePath .\Library\netconfig.ps1 -Append
        "    # The following two lines should be edited, to reflect your ISP's DNS server IP's" | Out-File -FilePath netconfig.ps1 -Append
        "    ISPDNS1 = `"89.160.20.18`"" | Out-File -FilePath .\Library\netconfig.ps1 -Append
        "    ISPDNS2 = `"89.160.20.22`"" | Out-File -FilePath .\Library\netconfig.ps1 -Append
        "`}" | Out-File -FilePath .\Library\netconfig.ps1 -Append
}

# The function doTest test if an address (the address parameter) on the Internet is accessible,
# and if not shows an error message contained int the parameter msg in
# the window object wobj
# If the test fails, the message is shown in a popup window and the script is then terminated
function doTest {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $addr
        )

    $pingtest = Test-Connection -Quiet -Count 2 -ComputerName $addr
    return $pingtest
}

Function doBasicTests {
    # Test if this function has been run before
    if(Test-Path -Path .\library\netconfig.ps1 -PathType Leaf){
        # The function has been run before, and the configuration saved
        . .\library\netconfig.ps1   # Use . sourcing to include the config file
    }else{
        # The function has not been run before, create and save the configuration
        createConfigFile    # First create the config file
        . .\library\netconfig.ps1   # And then load it into this script
    }
    $retval = ""
    # Test 1 of lokal computer, localhost
    $my_temp = doTest($global:BasicTestGlobals.localhost)
    if ( ("" -eq $retval) -and ($false -eq $my_temp) ) {
        $retval = "Your own computer does not respond! Check the TCP/IP device drivers."
    }

    # Testing the closest router, usually a router in the owners appartment
    $my_temp = doTest($global:BasicTestGlobals.myrouter)
    if( ("" -eq $retval) -and ($false -eq $my_temp) ) {
        $retval =  "Your router does not respond. Check your cables and the router."
    }

    # Testing the connection to your ISP's router
    $my_temp = doTest($global:BasicTestGlobals.myISP )
    if(("" -eq $retval) -and ($false -eq $my_temp) ) {
        $retval =  "Your ISP's router don't respond. You have to contact your ISP!"
    }

    # Testing if you can reach your ISP's DNS servers
    # Cannot use doTest, since it's acceptable if one of two
    # DNS servers is unavailable
    $dns1 = Test-Connection -Quiet -ComputerName $global:BasicTestGlobals.ispdns1
    $dns2 = Test-Connection -Quiet -ComputerName $global:BasicTestGlobals.ispdns2

    if( -not ( $dns1 -or $dns2 ) -and  ("" -eq $retval) ) {
        $retval =  "Your ISP's DNS servers are unavailable. You can only use numeric IP addresses for now."
    }

    # Test 2 on DNS, lookup an address.
    $temp1 = nslookup riksdagen.se
    $temp2 = $temp1.split([Environment]::NewLine)
    $temp3 = $temp2[5].trim()
    if( ("" -eq $retval) -and ("193.11.1.15" -ne $temp3) ) {
        $retval =  "Attempted to lookup an address but it failed. Your ISP's DNS sytem is not working!"
    }

    # From here the most important services can be assumed to work. 
    $retval =  "All tests works as expected, and responces are allso as expected. You apper to have basic contact with Intenet."

    return $retval
}
