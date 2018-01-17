require "CSV"

flight_file_path = "../../data/raw/flights_2008.csv"
final_path = "../../data/processed/flights_2008_cleaned.csv"

columns_to_remove = [
    "Year",
    "Month",
    "DayofMonth",
    "DayOfWeek",
    "DepTime",
    "CRSDepTime",
    "ArrTime",
    "CRSArrTime",
    "UniqueCarrier",
    "FlightNum",
    "TailNum",
    "ActualElapsedTime",
    "CRSElapsedTime",
    "AirTime",
    "Distance",
    "TaxiIn",
    "TaxiOut",
    "Cancelled",
    "CancellationCode",
    "Diverted",
    "CarrierDelay",
    "NASDelay",
    "SecurityDelay",
    "LateAircraftDelay",
]

puts "Reading flights..."
flights = CSV.read(flight_file_path, :headers => true)

def remove_columns(table, columns_to_remove)
    puts "Removing columns..."
    columns_to_remove.each do |column|
        table.delete(column)
    end
    table
end

def combine_date(table)
    puts "Combining dates..."
    table.each do |row|
        date = Date.parse("#{row['DayofMonth']}.#{row['Month']}.#{row['Year']}")
        puts date
        row["Date"] = date.strftime('%Y-%m-%d')
    end
    table
end

def remove_columns(table, columns_to_remove)
    puts "Removing columns..."
    columns_to_remove.each do |column|
        table.delete(column)
    end
    table
end

flights = combine_date(flights)
flights = remove_columns(flights, storm_columns_to_remove)

File.open(final_path, 'w') do |f|
    f.write(flights.to_csv)
end

# @flights = CSV.read(flight_file_path, :headers => true)
# puts @flights[0]
