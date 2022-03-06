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

    Mode
        0 - Extract from string
        1 - Split by delimiter

#>
    
    Fields = @{

        Field1 = @{
            Header = 'Time'
            DataType = 'time'
            Format = 'epoch-linux'
            Mode = 1
        }

        Field2 = @{
            Header = 'Host'
            DataType = 'string'
            Format = ''
            Mode = 1
        }

        Field3 = @{
            Header = 'ID'
            DataType = 'string'
            Format = ''
            Mode = 1
        }

        Field4 = @{
            Header = 'Message'
            DataType = 'string'
            Format = ''
            Mode = 1
        }
    }
}