# Data

Information on the data used for the analyses.

## Raw data

URL                                                                     | Description                                                                   | Date
----------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ----------
<http://stat-computing.org/dataexpo/2009/the-data.html>                 | A list with most (if not all) of the flights made in the USA in 2008.         | 22.12.2017
<http://stat-computing.org/dataexpo/2009/supplemental-data.html>        | A list with most (if not all) of the airports in the USA.                     | 22.12.2017
<https://www1.ncdc.noaa.gov/pub/data/swdi/stormevents/csvfiles/legacy/> | A list with most (if not all) of the storms that occurred in the USA in 2008. | 11.01.2018
<https://github.com/jasonong/List-of-US-States/blob/master/states.csv>  | A list of the US states and their abbreviations.                              | 15.01.2018

## Processed data

Scripts          | Files generated
---------------- | --------------------------------------------------------------------------------------------------------
clean_flights.rb | - flights_2008_cleaned_3000000.csv, - flights_2008_cleaned_6000000.csv, - flights_2008_cleaned_final.csv
clean_storm.rb   | - stormdata_2008_cleaned.csv

## Study design

The data was collected by going to the respective sites and downloading the csv that was provided.

## Instruction list

The following section will walk you through different steps you will need to take to get the data from `raw` to `processed`.

### 1\. Getting the files

Most file are in this GitHub repository but some where to big and are located in the school share folder (COMMUN).<br>

1. Download or clone the Git repository.
2. Go to the following location `N:\COMMUN\ELEVE\INFO\SI-T2a\BI1\Struan_Forsyth\raw_data` and copy the file into the `raw` folder.

### 2\. Executing the scripts / Copying files

To execute the scripts you will need to have **Ruby** installed.

- [https://www.ruby-lang.org/en/documentation/installation/][f1e3ba67]

Once you have ruby installed open a command prompt, navigate to the `scripts` folder and run the following two scripts:

- `$ ruby clean_flights.rb`
- `$ ruby clean_storm.rb`

While the scripts are executing you can copy the following files from the `raw` folder to the `processed` folder.

- `states.csv`
- `airports.csv`

### 3\. Manual cleanup

Once all the scripts are finished and you have the 6 files in the `processed` folder, open them up in a text editor (**WARNING** some files contain a lot of data and might crash certain text editors (Cough...Atom). I personally recommend **Notepad++** as it is the one I used and it worked fine).<br>
In all the file that have them, remove the **Header**, then save and close the file.

### 4\. Import into MySQL database (wamp/phpMyAdmin)

In the scripts folder you'll find a **sql** file to create the database with the tables you'll need for importing the files.<br>
Create the database on your server and then proceed to import the different files into the correct tables.

In phpMyAdmin when importing the **flight** csv files, I would get a timeout. Luckily, phpMyAdmin allows you to resume importing from where you left off.<br>
When resuming an import remove from the URL the following part `&timeout_passed=1`. This helped me out with it crashing on the resumed import.

Once every thing is imported you will need to run the following query in your database:

Description: Gets all the possible date and state abbreviation from the storms and flights tables. It then inserts the result into a date_state table with a unique `id`.

```sql
INSERT INTO date_state
(SELECT (@cnt := @cnt + 1) AS id, b.*
FROM
(SELECT * FROM
((SELECT f.departure_date AS `date`, a.state_abbr FROM flights f
INNER JOIN airports a ON
a.iata = f.origin
WHERE (f.arr_delay + f.dep_delay) > 0
GROUP BY f.departure_date, a.state_abbr)
UNION
(SELECT f.departure_date AS `date`, a.state_abbr FROM flights f
INNER JOIN airports a ON
a.iata = f.dest
WHERE (f.arr_delay + f.dep_delay) > 0
GROUP BY f.departure_date, a.state_abbr)
UNION
(SELECT DISTINCT start_date AS `date`, state_abbr
FROM storms)
UNION
(SELECT DISTINCT end_date AS `date`, state_abbr
FROM storms)) t
GROUP BY `date`, state_abbr
ORDER BY `date`, state_abbr) b
CROSS JOIN (SELECT @cnt := 0) AS d);
```

Description: Gets all the flights with a delay and replaces the `date` with a date_state `id`. It then inserts the result into a flights_only_delay table.

```sql
INSERT INTO flights_only_delay
SELECT * FROM
((SELECT ds.id AS `fk_date_state`, f.arr_delay, f.dep_delay, f.origin, f.dest, f.weather_delay
FROM flights f
INNER JOIN airports a ON
a.iata = f.origin
INNER JOIN date_state ds ON
ds.`date` = f.departure_date AND ds.state_abbr = a.state_abbr
WHERE (f.arr_delay + f.dep_delay) > 0)
UNION
(SELECT ds.id AS `fk_date_state`, f.arr_delay, f.dep_delay, f.origin, f.dest, f.weather_delay
FROM flights f
INNER JOIN airports a ON
a.iata = f.dest
INNER JOIN date_state ds ON
ds.`date` = f.departure_date AND ds.state_abbr = a.state_abbr
WHERE (f.arr_delay + f.dep_delay) > 0)) a
```

### 5\. Importing into PowerBI

When selecting the type of data to import into the software, select **MySQL** and link to your database.<br>
When selecting the server and database name you'll need to selection **Advanced Options** (Option avancée) to be able to add a SQL query to load data.

There are three table you'll need to import:

- date_state
- flights_only_delay
- storms

You'll need to import the `storms` by it's self and add the following SQL query:<br>

Description: Adds the date_state `id` to the storms table. What is returned is `id` (id in date_state table) and `type` (type of storm)

```sql
(SELECT ds.id AS `fk_date_state`, s.type
FROM storms s
INNER JOIN date_state ds ON
ds.`date` = s.start_date AND ds.state_abbr = s.state_abbr)
UNION ALL
(SELECT ds.id AS `fk_date_state`, s.type
FROM storms s
INNER JOIN date_state ds ON
ds.`date` = s.end_date AND ds.state_abbr = s.state_abbr
WHERE s.start_date != s.end_date)
```

## Code book CSV files

The code book is for the cleaned data.<br>
The headers where removed so they could be imported into a MySQL server (wamp/phpMyAdmin, in my case).

### File flights_2008_cleaned_xxxx.csv

Name         | Description
------------ | -----------------------------
Date         | Date of flight (YYYY-mm-dd)
ArrDelay     | Arrival delay, in minutes
DepDelay     | Departure delay, in minutes
Origin       | Origin IATA airport code
Dest         | Destination IATA airport code
WeatherDelay | Weather delay, in minutes

### File airports.csv

Name    | Description
------- | ----------------------------------------------
iata    | The international airport abbreviation code
airport | Name of the airport
city    | City in which airport is located
state   | State abbreviation in which airport is located
country | Country in which airport is located
lat     | Latitude of the airport
long    | Longitude of the airport

### File states.csv

Name         | Description
------------ | -------------------------
State        | Name of the state
Abbreviation | Abbreviation of the state

### File stormdata_2008_cleaned.csv

Name            | Description
--------------- | ---------------------------------------------------------------------------------------------------------------
STATE           | The state name where the event occurred
EVENT_TYPE      | Describes the meteorological event leading to injuries, damage, etc. (Hail, Thunderstorm Wind, Snow, Ice, etc.)
BEGIN_DATE_TIME | Date at which the storm started (YYYY-mm-dd)
END_DATE_TIME   | Date at which the storm ended (YYYY-mm-dd)
STATE_ABBR      | The state abbreviation where the event occurred

## Code book database

### airports table

Name       | Description
---------- | ----------------------------------------------
iata       | The international airport abbreviation code
airport    | Name of the airport
city       | City in which airport is located
state_abbr | State abbreviation in which airport is located
country    | Country in which airport is located
lat        | Latitude of the airport
longitude  | Longitude of the airport

### date_state table

Name       | Description
---------- | ------------------------------------
id         | Unique identifier for the date_state
date       | Date (YYYY-mm-dd)
state_abbr | State abbreviation

### flights table

Name           | Description
-------------- | -----------------------------
departure_date | Date of flight (YYYY-mm-dd)
arr_delay      | Arrival delay, in minutes
dep_delay      | Departure delay, in minutes
origin         | Origin IATA airport code
dest           | Destination IATA airport code
weather_delay  | Weather delay, in minutes

### flights_only_delay table

Name          | Description
------------- | -----------------------------
fk_date_state | Id from the date_state table
arr_delay     | Arrival delay, in minutes
dep_delay     | Departure delay, in minutes
origin        | Origin IATA airport code
dest          | Destination IATA airport code
weather_delay | Weather delay, in minutes

### states table

Name | Description
---- | -------------------------
name | Name of the state
abbr | Abbreviation of the state

### storms table

Name       | Description
---------- | ---------------------------------------------------------------------------------------------------------------
state      | The state name where the event occurred
type       | Describes the meteorological event leading to injuries, damage, etc. (Hail, Thunderstorm Wind, Snow, Ice, etc.)
start_date | Date at which the storm started (YYYY-mm-dd)
end_date   | Date at which the storm ended (YYYY-mm-dd)
state_abbr | The state abbreviation where the event occurred

[f1e3ba67]: https://www.ruby-lang.org/en/documentation/installation/ "Ruby Installation"
