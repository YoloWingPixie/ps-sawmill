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
    }
    
    process {
        
        for ($i = 0; $i -lt $logContent.Count; $i++) {
            [int]$percent = ($i / $log.Count) * 100
            Write-Progress -Activity "Ingesting $LogPath" -Status ("Processing $i of" + $logContent.Count) -PercentComplete $percent


            #Initialize the current log row's object and set ID.
            $currentEntry = [PSCustomObject]@{
                ID = $i
            }
        
            for ($j = 1; $j -le $FieldCount; $j++) {
        
                $FieldKey = "Field" + $j.ToString()
                $NextField = "Field" + ($j + 1).ToString()
                $Header = $schema.Fields.$FieldKey.Header
                $NextHeader = $schema.Fields.$NextField.Header
                $SpecialDelimiter = $schema.Fields.$FieldKey.SpecialDelimiter
                $NextSpecialDelimiter = $schema.Fields.$NextField.SpecialDelimiter
                $Mode = $schema.Fields.$FieldKey
        

                switch ($Mode) {
                    0 { condition }
                    1 {

                    }
                }

                #Split handling for fields that have special delimiters

                if ($SpecialDelimiter) {
        
                    #Get the last split to ensure we are looking at the correct part of the log
                    $split = ($logContent[$i] -split "$Delimiter",($j-1))[-1]
        
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
                    
                    $split = ($logContent[$i] -split "$Delimiter")[$j - 1]
        
                }

                #Format Data
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
        
            
            #Output the current row object to the return array
            $logOutput.Add($currentEntry) | Out-Null
        
        }

    }
    
    end {

        return ,$logOutput

    }
}