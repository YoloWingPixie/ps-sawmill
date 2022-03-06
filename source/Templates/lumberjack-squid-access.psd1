@{
    Name = 'Squid-Access'
    Delimiter = '\s+'

    Fields = @{

        Field1 = @{
            Header = 'Time'
            DataType = 'time'
            Format = 'epoch-linux'
        }

        Field2 = @{
            Header = 'RequestTime'
            DataType = 'timespan'
            Format = 'milliseconds'
        }

        Field3 = @{
            Header = 'Host'
            DataType = 'string'
            Format = ''
        }

        Field4 = @{
            Header = 'ResultCode'
            DataType = 'string'
            Format = ''
        }

        Field5 = @{
            Header = 'Skip'
            DataType = 'int'
            Format = ''
        }

        Field6 = @{
            Header = 'HttpMethod'
            DataType = 'string'
            Format = ''
        }

        Field7 = @{
            Header = 'Url'
            DataType = 'string'
            Format = ''
        }

        Field8 = @{
            Header = 'HierarchyCode'
            DataType = 'string'
            Format = ''
            SpecialDelimiter = '\-\s+'
        }

        Field9 = @{
            Header = 'Destination'
            DataType = 'string'
            Format = ''
            SpecialDelimiter = '/'
        }
        
        Field10 = @{
            Header = 'ApplicationType'
            DataType = 'string'
            Format = ''
        }
    }
}