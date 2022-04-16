function Read-SmLog {
    [CmdletBinding()]
    param (
        # The Text Log File to ingest
        [Parameter(Mandatory)]
        [ValidateScript({
            if ( -Not ($_ | Test-Path)) {
                throw "File path provided is not valid"
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The file path provided is a directory. Please use the full path to the log file"
            }
            return $true
        })]
        [string]
        $LogPath,

        # The path to the schema file to use to process the log.
        [Parameter(Mandatory)]
        [ValidateScript({
            if ( -Not ($_ | Test-Path)) {
                throw "File path provided is not valid"
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The file path provided is a directory. Please use the full path to the schema file"
            }
            if($_ -notmatch "(\.psd1)"){
                throw "The file specified in the path argument must be a .psd1 (Powershell Data) file"
            }
            return $true
        })]
        [string]
        $SchemaPath
    )
    
    begin {
        
        #Get the log file
        $logContent = Get-Content $LogPath

        #Import Schema
        $schema = Import-PowerShellDataFile -Path $SchemaPath
        $Delimiter = ($schema.Delimiter).ToString()
        $FieldCount = $schema.Fields.count

        #Output object
        [System.Collections.ArrayList]$logOutput = @()


        function Get-FieldByDelimiter {
            param (
                $SpecialDelimiter,
                $Delimiter,
                $LogLine,
                $NextSpecialDelimiter,
                $Field,
                $FieldCount
            )

            $split = $LogLine

            #Split handling for fields that use a special delimiter
            if ($SpecialDelimiter) {
        
                #Get the last split to ensure we are looking at the correct part of the log, unless beginning of log.
                if ($Field -ne 1) {
                    $split = ($LogLine -split "$Delimiter",($j-1))[-1]                   
                }
    
                #Split by the special delimiter
                $split = ($split -split "$SpecialDelimiter",2)[-1]
    
                #Now lookahead and split by the next delimiter, unless on final field
                if ($Field -ne $FieldCount) {

                    if ($NextSpecialDelimiter) {
                        $split = ($split -split "$NextSpecialDelimiter",2)[0]
                    }
                    else {   
                        $split = ($split -split "$Delimiter",2)[0]
                    }  
                }
            }
            #Split handling for fields that use the normal delimiter
            else {
                if ($Field -ne $FieldCount) {
                    $split = ($LogLine -split "$Delimiter")[$j - 1]
                }
            }
            return $split 
        }

        function Get-FieldByRegex {
            param (
                $LogLine
            )
        }

        #Wrapper for ::FromUnixTimeSeconds to DateTime
        function ConvertFrom-UnixEpoch {
            [CmdletBinding()]
            param (
                # Time in Epoch Unix Time
                [Parameter(Mandatory)]
                [int]
                $EpochTime
            )
            process {
                return ([System.DateTimeOffset]::FromUnixTimeSeconds($EpochTime)).DateTime
            }  
        }


    }
    
    process {

        #Write-Progress Variables
        #Write-Progress is designed to update at only whole percents of completion for performance. 
        #$progressUpdate is equal to 1 of 100 equal counts of log lines.
        #In the for loop, we count up from 0 to $progressUpdate. When hit, Write-Progress runs and the counter resets to 0.
        #Updating Write-Progess in every loop increases script runtime by an order of magnitude
        $totalDone=1
        $finalCount = $logContent.count
        $progressUpdate = [math]::floor($finalCount / 100)
        $progressCheck = $progressUpdate+1
        
        for ($i = 0; $i -lt $logContent.Count; $i++) {

            #Write-Progress Loop
            $totalDone += 1
            if ($progressCheck -gt $progressUpdate){
                Write-Progress -Activity "$totalDone out of $finalCount completed" -PercentComplete (($totalDone / $finalCount) * 100)
                $progressCheck = 0
            }
            $progressCheck += 1
            
            #Initialize the current log row's object and set ID.
            $currentEntry = [PSCustomObject]@{
                ID = $i
            }
        
            #Inner loop to process each field of the log row.
            for ($j = 1; $j -le $FieldCount; $j++) {
        
                $FieldKey = "Field" + $j.ToString()
                $NextField = "Field" + ($j + 1).ToString()
                $Header = $schema.Fields.$FieldKey.Header
                $NextHeader = $schema.Fields.$NextField.Header
                $SpecialDelimiter = $schema.Fields.$FieldKey.SpecialDelimiter
                $NextSpecialDelimiter = $schema.Fields.$NextField.SpecialDelimiter
                $Mode = $schema.Fields.$FieldKey.CaptureMode
                $Trim = $schema.Fields.$FieldKey.Trim
        
                #Mode used to split the delimiter.
                # 0 - Regex
                # 1 - Delimiter
                # 2 - Synthetic Lookup
                switch ($Mode) {
                    0 {  
                        #Not Implemented yet
                    }
                    1 {
                        $split = Get-FieldByDelimiter -Field $j -SpecialDelimiter $SpecialDelimiter -Delimiter $Delimiter -LogLine $logContent[$i] -NextSpecialDelimiter $NextSpecialDelimiter -FieldCount $FieldCount
                    }
                    2 {
                        #Not Implemented yet
                    }
                }

                #Format Data
                #This should probably be a separate function for maintainability
                switch ($schema.Fields.$FieldKey.DataType) {
                    time {  
                        #   epoch-linux
                        if ($schema.Fields.$FieldKey.Format -eq 'epoch-linux') {
                            $split = ConvertFrom-UnixEpoch -EpochTime $split
                        }
                        #   Date
                        if ($schema.Fields.$FieldKey.Format -eq 'Date') {
                            $split = Get-Date $split -Format 'yyyy-MM-dd'
                        }
                        
                    }
                    percent {
                        $split = $split.Trim('%')
                    }
                    Default {}
                }

                #And finally complete trim operation on the field if it exists
                $split = $split.Trim($Trim)
        
                if ($Header -ne 'Skip') {
                    $currentEntry | Add-Member -MemberType NoteProperty -Name $Header -Value $split 
                }
                    
            }
        
            #Output the current row object to the output arraylist
            $logOutput.Add($currentEntry) | Out-Null
        
        }

    }
    
    end {
        return ,$logOutput
    }
}