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
$log = Get-Content 'C:\Users\ZacharyMaynard\Downloads\squid_access.log'

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
        $NextSpecialDelimiter = $schema.Fields.$NextField.SpecialDelimiter

        #Split handling for fields that have special delimiters
        if ($SpecialDelimiter) {

            #Get the last split to ensure we are looking at the correct part of the log
            $split = ($log[$i] -split "$Delimiter",($j-1))[-1]

            #Split by the special delimiter
            $split = ($split -split "$SpecialDelimiter",2)[-1]

            #Now lookahead and split by the next delimiter
            if ($NextSpecialDelimiter) {
                $split = ($split -split "$NextSpecialDelimiter",2)[0]
            }

            else {
                $split = ($split -split "$Delimiter",2)[0]
            }
        }

        #Split handling for fields that use the normal delimiter
        else {
            
            $split = ($log[$i] -split "$Delimiter")[$j - 1]

        }

        switch ($schema.Fields.$FieldKey.DataType) {
            time {  

                if ($schema.Fields.$FieldKey.Format -eq 'epoch-linux') {
                    $split = ConvertFrom-UnixEpoch -EpochTime $split
                }
                
            }
            Default {}
        }

        if ($Header -ne 'Skip') {
            $currentEntry | Add-Member -MemberType NoteProperty -Name $Header -Value $split 
        }
            
    }

    $logOutput.Add($currentEntry) | Out-Null

}
