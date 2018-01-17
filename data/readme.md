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

The following section will walk you through different steps you will need to take to get the data from `raw` to `processed`.

### 1\. Getting the files

Most file are in this GitHub repository but some where to big and are located in the school share folder (COMMUN).<br>

1. Download or clone the Git repository.
2. Got the following location `N:\COMMUN\ELEVE\INFO\SI-T2a\BI1\Struan_Forsyth\raw_data` and copy the file into the `raw` folder.

### 2\. Executing the scripts / Copying files

To execute the scripts you will need to have **Ruby** installed.

- [https://www.ruby-lang.org/en/documentation/installation/][f1e3ba67]

Once you have ruby installed open a command prompt, navigate to the `scripts` folder and run the following two scripts:

- `$ ruby clean_flights.rb`
- `$ ruby clean_storm.rb`

The `clean_flights.rb` script will generate 3 **csv** files:`flights_2008_cleaned_3000000`, `flights_2008_cleaned_6000000` and `flights_2008_cleaned_final`.<br>
The `clean_storms.rb` script will generate 1 **csv** file: `stormdata_2008_cleaned`.

While the scripts are executing you can copy the following files from the `raw` folder to the `processed` folder.

- `states.csv`
- `airports.csv`

### 3\. Final cleanup

Once all the scripts are finished and you have the 6 files in the `processed` folder, open them up in a text editor (**WARNING** some files contain a lot of data and might crash certain text editors (Cough...Atom). I personally recommend **Notepad++** as it is the one I used and it worked fine).<br>
In all the file that have them, remove the **Header** then save and close the file.

### 4\. Import into MySQL database (wamp/phpMyAdmin)

In the scripts folder you'll find a sql file to create a database with the table you'll need for importing the files.<br>
Create the database on your server and then proceed to import the different files into the correct tables.

In phpMyAdmin when importing the **flight** csv files I would get a timeout. Luckily phpMyAdmin allows you to resume importing from where you left off.<br>
When resuming an import remove from the URL the following part `&timeout_passed=1`. This helped me out with it crashing on the resume import.

### 5\. Importing into PowerBI

When selecting the type of data to import into the software, select **MySQL**. Doing this will allow you to create a query when getting the data.

## Study design

The data was collected by going to the respective sites and downloading the csv that was provided.

## Code book

The code book is for the cleaned data.<br>
The headers where removed so they could be imported into a MySQL server (wamp/phpMyAdmin, in my case).

### File flights_2008_cleaned_xxxx.csv

Name         | Description
------------ | -----------------------------
Date         | date of flight
ArrDelay     | arrival delay, in minutes
DepDelay     | departure delay, in minutes
Origin       | origin IATA airport code
Dest         | destination IATA airport code
WeatherDelay | in minutes

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

Name            | Description
--------------- | ---------------------------------------------------------------------------------------------------------------
STATE           | The state name where the event occurred
EVENT_TYPE      | describes the meteorological event leading to injuries, damage, etc. (Hail, Thunderstorm Wind, Snow, Ice, etc.)
BEGIN_DATE_TIME | date
END_DATE_TIME   | date
STATE_ABBR      | The state abbreviation where the event occurred

[f1e3ba67]: https://www.ruby-lang.org/en/documentation/installation/ "Ruby Installation"
