@{
    Name = 'Squid-Access'
    Delimiter = '\s+'

    Fields = @{

        Field1 = @{
            Header = 'Time'
            DataType = 'time'
            Format = 'epoch-linux'
            CaptureMode = 1
        }

        Field2 = @{
            Header = 'RequestTime'
            DataType = 'timespan'
            Format = 'milliseconds'
            CaptureMode = 1
        }

        Field3 = @{
            Header = 'Host'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
        }

        Field4 = @{
            Header = 'ResultCode'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
        }

        Field5 = @{
            Header = 'Skip'
            DataType = 'int'
            Format = ''
            CaptureMode = 1
        }

        Field6 = @{
            Header = 'HttpMethod'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
        }

        Field7 = @{
            Header = 'Url'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
        }

        Field8 = @{
            Header = 'HierarchyCode'
            DataType = 'string'
            Format = ''
            SpecialDelimiter = '\-\s+'
            CaptureMode = 1
        }

        Field9 = @{
            Header = 'Destination'
            DataType = 'string'
            Format = ''
            SpecialDelimiter = '/'
            CaptureMode = 1
        }
        
        Field10 = @{
            Header = 'ApplicationType'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
        }
    }
}