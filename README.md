# Sawmill
Powershell module to process text logs into Powershell Objects

# Date Types

## Time

Formats:
### epoch-linux

Converts time from epoch-linux to DateTime

### Date

Converts time from any time to yyyy-MM-dd mask.

### DateMask
***NOT IMPLEMENTED YET***

Declare an arbitrary mask for date which Read-SmLog will interpret and convert time to the mask values:

    - yyyy-MM-dd              = 1990-06-15

    - yyyyMMdd                = 19900615

    - yy-MM-dd                = 90-06-15

    - yyyy-MM-dd.HH:MM:ss:mmm = 1990-06-15.12:42:25.924


## Percent

No format. Strips % from the field and converts float percents to 0 - 100:

    - 0.09    = 9
    - 0.91    = 91
    - 9%      = 9    
