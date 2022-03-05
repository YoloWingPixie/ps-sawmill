@{
    Name = 'Default'
    Delimiter = ' '

    Fields = @{

        Field1 = @{
            Header = 'Time'
            DataType = 'time'
            Format = 'epoch-linux'
        }

        Field2 = @{
            Header = 'Host'
            DataType = 'string'
            Format = ''
        }

        Field3 = @{
            Header = 'ID'
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