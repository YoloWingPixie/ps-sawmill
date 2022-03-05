function ConvertFrom-UnixEpoch {
    [CmdletBinding()]
    param (
        # Time in Epoch Unix Time
        [Parameter(Mandatory)]
        [int]
        $EpochTime
    )
    
    begin {
        
    }
    
    process {
        return ([System.DateTimeOffset]::FromUnixTimeSeconds($EpochTime)).DateTime
    }
    
    end {
        
    }
}

#Get the log file
$log = Get-Content 'C:\Users\zach\Downloads\squid_access.log'

#Import Schema
$schema = Import-PowerShellDataFile -Path .\Templates\lumberjack-squid-access.psd1
$Delimiter = ($schema.Delimiter).ToString()
$FieldCount = $schema.Fields.count

#Output object
[System.Collections.ArrayList]$logOutput = @()


for ($i = 0; $i -lt $log.Count; $i++) {


    $currentEntry = [PSCustomObject]@{
        ID = $i
    }

    $OffsetTrack = 0

    for ($j = 1; $j -le $FieldCount; $j++) {

        $FieldKey = "Field" + $j.ToString()
        $NextField = "Field" + ($j + 1).ToString()
        $Header = $schema.Fields.$FieldKey.Header
        $NextHeader = $schema.Fields.$NextField.Header
        $SpecialDelimiter = $schema.Fields.$FieldKey.SpecialDelimiter

        $split = ($log[$i] -split "$Delimiter")[$j - 1]

        switch ($schema.Fields.$FieldKey.DataType) {
            time {  

                if ($schema.Fields.$FieldKey.Format -eq 'epoch-linux') {
                    $split = ConvertFrom-UnixEpoch -EpochTime $split
                }

            }
            Default {}
        }

        $currentEntry | Add-Member -MemberType NoteProperty -Name $Header -Value $split
            
    }

    $logOutput.Add($currentEntry) 

}
