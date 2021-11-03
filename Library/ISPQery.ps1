$Global:ISPGlobals = [PSCustomObject]@{
    DbPath = ""
}

Function SetCity {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $DbPath
    )
    $Global:ISPGlobals.DbPath = $DbPath
}
 
 # This value allows the caller to extract the answer.
 # I.e. find the IP addresses of the users ISPs DNS servers.
Function CreateDNSList {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $ISP
    )

    $my_ISP =  $ISP
    $ISP_list = $Global:ISPGlobals.DbPath + "\ISPs.txt"
    $file =  Get-Content $ISP_list
    foreach($line in $file ) {
        $ISPArray = $line -split ","
    if( $my_ISP -eq $ISPArray[0] ) {
            $retval = ""
        for( $i = 1; $i -lt $ISPArray.Length; $i++) {
                $retval = $retval + "," + $ISPArray[$i]
            }
        }
    }

    return $retval.TrimStart(",")
}

# Create a list of ISPs active in the selected city
Function CreateISPList {
    Param(
        [Parameter(Mandatory=$True, ValueFromPipeline=$True)] [String] $DbPath
    )
       
    # Open the cvs file containing a list of local ISPs
    $ISP_list = $DbPath + "\ISPs.txt"
    $file = Get-Content $ISP_list

    # Create a list of DNS server IP addresses for the selected ISP and city
    foreach( $line in $file ) {
        $ISP = $line.split(',')
        $retval = ""
        foreach( $line in $file ) {
            $ISP = $line.split(',')
            $retval = $retval + ',' + $ISP[0]
        }
    }
   
    return $retval.TrimStart(",")
}
# CreateISPList(".\database\Europe\Sweden\Västerbotten\Umeå")
# SetCity(".\database\Europe\Sweden\Västerbotten\Umeå\ISPs.txt")
# CreateDNSList( "Bredband2" )


