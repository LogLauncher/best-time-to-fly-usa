# Data

Information of the data used for the analyses.

## Raw data

URL                                                                     | Description                                                                   | Date
----------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ----------
<http://stat-computing.org/dataexpo/2009/the-data.html>                 | A list with most (if not all) of the flights made in the USA in 2008.         | 22.12.2017
<http://stat-computing.org/dataexpo/2009/supplemental-data.html>        | A list with most (if not all) of the airports in the USA.                     | 22.12.2017
<https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/legacy/> | A list with most (if not all) of the storms that occurred in the USA in 2008. | 11.01.2018
<https://github.com/jasonong/List-of-US-States/blob/master/states.csv>  | A list of the US states and their abbreviations.                              | 15.01.2018

## Instruction list

The airports (airports.csv) and states (states.csv) data did not need any treatment. So they could be used as is. The flights and storm data needs to be cleaned with the scripts provided.

## Study design

The data was collected by going to the respective sites and downloading the csv that was provided.

## Code book

### File flights_2008_cleaned.csv

Name              | Description
----------------- | -------------------------------------------------------------------------
Year              | 1987-2008
Month             | 1-12
DayofMonth        | 1-31
DayOfWeek         | 1 (Monday) - 7 (Sunday)
DepTime           | actual departure time (local, hhmm)
CRSDepTime        | scheduled departure time (local, hhmm)
ArrTime           | actual arrival time (local, hhmm)
CRSArrTime        | scheduled arrival time (local, hhmm)
UniqueCarrier     | unique carrier code
FlightNum         | flight number
TailNum           | plane tail number
ActualElapsedTime | in minutes
CRSElapsedTime    | in minutes
AirTime           | in minutes
ArrDelay          | arrival delay, in minutes
DepDelay          | departure delay, in minutes
Origin            | origin IATA airport code
Dest              | destination IATA airport code
Distance          | in miles
TaxiIn            | taxi in time, in minutes
TaxiOut           | taxi out time in minutes
Cancelled         | was the flight cancelled?
CancellationCode  | reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
Diverted          | 1 = yes, 0 = no
CarrierDelay      | in minutes
WeatherDelay      | in minutes
NASDelay          | in minutes
SecurityDelay     | in minutes
LateAircraftDelay | in minutes

### File airports.csv

Name    | Description
------- | -------------------------------------------
iata    | the international airport abbreviation code
airport | name of the airport
city    | in which airport is located
state   | in which airport is located
country | in which airport is located
lat     | latitude of the airport
long    | longitude of the airport

### File states.csv

Name         | Description
------------ | -------------------------
State        | name of the state
Abbreviation | abbreviation of the state

### File stormdata_2008_cleaned.csv

Name               | Description
------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BEGIN_YEARMONTH    | year and month (YYYYMM)
BEGIN_DAY          | day
BEGIN_TIME         | time
END_YEARMONTH      | year and month (YYYYMM)
END_DAY            | day
END_TIME           | time
EPISODE_ID         | ID assigned by NWS to denote the storm episode
EVENT_ID           | Primary database key field
STATE              | The state name where the event occurred
STATE_ABBR         | The state abbreviation where the event occurred
STATE_FIPS         | A unique number (State Federal Information Processing Standard) is assigned to the county by the National Institute for Standards and Technology (NIST)
YEAR               | Four digit year for the event in this record
MONTH_NAME         | Name of the month for the event in this record
EVENT_TYPE         | The chosen event name should be the one that most accurately describes the meteorological event leading to injuries, damage, etc. (Hail, Thunderstorm Wind, Snow, Ice, etc.)
CZ_TYPE            | Indicates whether the event happened in a (C) county/parish, (Z) zone or (M) marine
CZ_FIPS            | The county FIPS number is a unique number assigned to the county by the National Institute for Standards and Technology (NIST) or NWS Forecast Zone Number
CZ_NAME            | County/Parish, Zone or Marine Name assigned to the county FIPS number or NWS Forecast Zone
WFO                | National Weather Service Forecast Office's area of responsibility (County Warning Area) in which the event occurred
BEGIN_DATE_TIME    | date and time (MM/DD/YYYY 24 hour time AM/PM)
CZ_TIMEZONE        | Time Zone for the County/Parish, Zone or Marine Name
END_DATE_TIME      | date and time (MM/DD/YYYY 24 hour time AM/PM)
INJURIES_DIRECT    | The number of injuries directly related to the weather event
INJURIES_INDIRECT  | The number of injuries indirectly related to the weather event
DEATHS_DIRECT      | The number of deaths directly related to the weather event
DEATHS_INDIRECT    | The number of deaths indirectly related to the weather event
DAMAGE_PROPERTY    | The estimated amount of damage to property incurred by the weather event
DAMAGE_CROPS       | The estimated amount of damage to crops incurred by the weather event
SOURCE             | Source reporting the weather event
MAGNITUDE          | measured extent of the magnitude type ~ only used for wind speeds and hail size
MAGNITUDE_TYPE     | EG = Wind Estimated Gust; ES = Estimated Sustained Wind; MS = Measured Sustained Wind; MG = Measured Wind Gust (no magnitude is included for instances of hail)
FLOOD_CAUSE        | Reported or estimated cause of the flood
CATEGORY           | Unknown (During the time of downloading this particular file, NCDC has never seen anything provided within this field.)
TOR_F_SCALE        | Enhanced Fujita Scale describes the strength of the tornado based on the amount and type of damage caused by the tornado
TOR_LENGTH         | Length of the tornado or tornado segment while on the ground (minimal of tenths of miles)
TOR_WIDTH          | Width of the tornado or tornado segment while on the ground (in feet)
TOR_OTHER_WFO      | Indicates the continuation of a tornado segment as it crossed from one National Weather Service Forecast Office to another
TOR_OTHER_CZ_STATE | The two character representation for the state name of the continuing tornado segment as it crossed from one county or zone to another
TOR_OTHER_CZ_FIPS  | The FIPS number of the county entered by the continuing tornado segment as it crossed from one county to another
TOR_OTHER_CZ_NAME  | The FIPS name of the county entered by the continuing tornado segment as it crossed from one county to another
BEGIN_RANGE        | A hydro-meteorological event will be referenced, minimally, to the nearest tenth of a mile, to the geographical center of a particular village/city, airport, or inland lake
BEGIN_AZIMUTH      | 16-point compass direction from a particular village/city, airport, or inland lake
BEGIN_LOCATION     | center from which the range is calculated and the azimuth is determined
END_RANGE          | A hydro-meteorological event will be referenced, minimally, to the nearest tenth of a mile, to the geographical center of a particular village/city, airport, or inland lake
END_AZIMUTH        | 16-point compass direction from a particular village/city, airport, or inland lake
END_LOCATION       | center from which the range is calculated and the azimuth is determined
BEGIN_LAT          | The latitude where the event started
BEGIN_LON          | The longitude where the event started
END_LAT            | The latitude where the event ended
END_LON            | The longitude where the event ended
EPISODE_NARRATIVE  | The episode narrative depicting the general nature and overall activity of the episode
EVENT_NARRATIVE    | The event narrative provides more specific details of the individual event
LAST_MOD_DATE      | -
LAST_MOD_TIME      | -
LAST_CERT_DATE     | -
LAST_CERT_TIME     | -
LAST_MOD           | -
LAST_CERT          | -
ADDCORR_FLG        | -
ADDCORR_DATE       | -
