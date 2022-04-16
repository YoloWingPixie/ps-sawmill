# Sawmill
Powershell module to process text logs into Powershell Objects

# Date Types

Data Types are formatting keywords declared in a schema file that Sawmill will use to determine what text processing needs to be done on a field.

```powershell
        Field1 = @{
            Header = 'Time'
            DataType = 'Time'
            Format = 'epoch-linux'
        }
```

Data types can also have a format. A format is the display format of the field within the text log, not the output format.

## Time

Outputs in DateTime: 1650120606 -> Saturday, April 16, 2022 2:50:06 PM

This is a .NET/Powershell DateTime object, so it's display format can be changed later on the fly using its builtin methods.


Formats:
### epoch-linux

Converts time from epoch-linux to DateTime

### Date

Converts time from yyyy-MM-dd format to DateTime

### DateMask
***NOT IMPLEMENTED YET***

Declare an arbitrary mask for date which Read-SmLog will interpret and convert time from the mask to DateTime:

    - yyyy-MM-dd              = 1990-06-15

    - yyyyMMdd                = 19900615

    - yy-MM-dd                = 90-06-15

    - yyyy-MM-dd.HH:MM:ss:mmm = 1990-06-15.12:42:25.924


## Percent

No format. Strips % from the field and converts float percents to 0 - 100:

    - 0.09    = 9
    - 0.91    = 91
    - 9%      = 9    
