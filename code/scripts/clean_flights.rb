# Paths to the files
flight_file_path = "../../data/raw/flight_2008.csv"
final_path = "../../data/processed/flights_2008_cleaned.csv"

# Function to combine the columns
def combine_columns(input_path, output_path)
    # Inform the user
    puts "This could take some time. Combining columns. Please wait..."

    # Variable for the final csv
    final = Array.new

    # Open the file
    data = File.open(input_path)

    # Iterate over each line of the file
    data.each_with_index do |line, index|
        # Seperate the line on "," into an array
        columns = line.split(",")

        # Check if it's the first line
        date = (index == 0) ? "Date" : "#{columns[2]}.#{columns[1]}.#{columns[0]}"

        # Delete the columns that are being combined
        columns.delete_at(0)
        columns.delete_at(0)
        columns.delete_at(0)

        # Insert the combined column
        columns.insert(0, date)

        # Add the row to the final csv
        final << columns.join(",")
    end

    # Close the connection to the file
    data.close

    # Create the final file
    File.open(output_path, "w") {|f| f.write(final.join())}
end

# Call the function
combine_columns(flight_file_path, final_path)
