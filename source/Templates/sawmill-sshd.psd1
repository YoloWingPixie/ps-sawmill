@{
    Name = 'sshd'
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

#>
    
    Fields = @{

        Field1 = @{
            Header = 'Time'
            DataType = 'time'
            Format = 'mask-Mmm-dd-HH:MM:ss'
        }

        Field2 = @{
            Header = 'Host'
            DataType = 'string'
            Format = ''
        }

        Field3 = @{
            Header = 'Daemon'
            DataType = 'string'
            Format = ''
        }

        Field4 = @{
            Header = 'Message'
            DataType = 'string'
            Format = ''
        }
    }
}