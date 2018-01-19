require "CSV"

# Paths to the files
flight_file_path = "../../data/raw/flights_2008.csv"
final_path = "../../data/processed/flights_2008_cleaned"

# Function to that will clean a row (combin columns, remove columns and format columns)
def clean_rows(input_path, output_path)
    # Inform the user
    puts "This could take some time. Combining columns. Please wait..."

    # Variable for the final csv
    final = Array.new

    # Open the file
    data = File.open(input_path)

    # Iterate over each line of the file
    data.each_with_index do |line, index|
        # Seperate the line on "," into an array
        columns = line.gsub(/\"|\\n/, "").split(",")

        # Check if it's the first line
        date = (index == 0) ? "Date" : Date.parse("#{columns[2]}.#{columns[1]}.#{columns[0]}").strftime('%Y-%m-%d')

        # Delete unwanted columns
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(4)
        columns.delete_at(4)
        columns.delete_at(4)
        columns.delete_at(4)
        columns.delete_at(4)
        columns.delete_at(4)
        columns.delete_at(4)
        columns.delete_at(5)
        columns.delete_at(5)
        columns.delete_at(5)

        # Unify delay
        weather_delay = columns[4].gsub(/NA/, "0")
        arrival_delay = columns[0].gsub(/NA/, "0")
        departure_delay = columns[1].gsub(/NA/, "0")
        columns.delete_at(4)
        columns.delete_at(0)
        columns.delete_at(0)

        # Insert the columns
        columns.insert(0, departure_delay)
        columns.insert(0, arrival_delay)
        columns.insert(4, weather_delay)
        columns.insert(0, date)

        # Add the row to the final csv
        final << columns.join(",")

        # Needed to seperate into multiple files for importing into phpMyAdmin
        if index % 3000000 == 0 && index != 0
            # Create the file
            puts "Writing to file, index #{index}..."
            File.open("#{output_path}_#{index}.csv", 'w') do |f|
                f.write(final.join("\n"))
            end
            # Clear array for the next file
            final = []
        end

    end

    # Close the connection to the file
    data.close

    # Return last entries
    final
end

# Call the function
last_flights = clean_rows(flight_file_path, final_path)

# Write the last flights to a file
puts "Writing to file, last entries..."
File.open("#{final_path}_final.csv", 'w') do |f|
    f.write(last_flights.join("\n"))
end
