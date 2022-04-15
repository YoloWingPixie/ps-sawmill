@{
    Name = 'Default'
    Author = 'Monad'

    Delimiter = ' '


<# 
    Field Template:
    #Fields MUST use the naming convention Field# 
    #SpecialDelimiter attribute is optional

        Field# = @{
            Header = 'Name'
            DataType = 'type'
            Format = 'format'
            SpecialDelimiter = ''
        }


    DataTypes:
    
    - time
        For fields that hold time or date values.

        Formats:
            - epoch-linux

    - string
        For fields that hold string data. This field should generally be used for all data that should not have math operations performed on it.

    - int
        For fields that hold data such as performance metrics that should have math operations performed on it.

    CaptureMode
        0 - Extract from string
        1 - Split by delimiter

#>
    
    Fields = @{

        Field1 = @{
            Header = 'To'
            DataType = 'String'
            Format = ''
            CaptureMode = 1
            SpecialDelimiter = '|'
        }

        Field2 = @{
            Header = 'From'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
            SpecialDelimiter = '|'
        }

        Field3 = @{
            Header = 'CC'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
            SpecialDelimiter = '|'
        }

        Field4 = @{
            Header = 'BCC'
            DataType = 'string'
            Format = ''
            CaptureMode = 1
            SpecialDelimiter = '|'
        }
    }
}