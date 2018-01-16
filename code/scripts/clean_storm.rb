# Paths to the files
storm_file_path = "../../data/raw/stormdata_2008.csv"
state_file_path = "../../data/raw/states.csv"
final_path = "../../data/processed/stormdata_2008_cleaned.csv"

@states = Array.new # Global vaiable with the states

# Function to convert the states csv file to an array
def states_to_array(input_path)
    # Open the file
    data = File.open(input_path)

    # Iterate over each line of the file
    data.each_with_index do |line, index|

        # Skip the first line
        next if index == 0

        # 1. Remove " and \n 2. Convert the line to an array 3. Add it to the states array
        @states << line.gsub(/\"|\n/, '').split(",")
    end

    # Close the connection to the file
    data.close
end

# Function
def clean_file(input_path, output_path)
    # Inform the user
    puts "This could take some time. Removing unwanted chars. Please wait..."

    # Variable for the final csv
    final = Array.new

    # Open the file
    data = File.open(input_path)

    # Iterate over each line of the file
    data.each_with_index do |line, index|
        # Seperate the line on "," into an array
        columns = line.split(",")

        # Skip if the column n°8 is empty
        next if columns[8] == nil

        # Add new header if first line
        if index == 0

            # Add the new header
            columns.insert(9, "STATE_ABBR")

        # Add normal line if not first line
        else

            # Check if the are columns
            if columns.class != nil

                # Skip if the event type is a "Drought"
                next if columns[12].capitalize == "Drought"

                # Tidy up the date columns
                date = columns[17].to_s.gsub(/(\d{1,2})[\.|\/|\-](\d{1,2})[\.|\/|\-](\d{2,4})(.*)/, '\1.\2.\3') # Tidy
                columns.delete_at(17)                                                                           # Remove current
                columns.insert(17, date)                                                                        # Insert new value
                date = columns[19].to_s.gsub(/(\d{1,2})[\.|\/|\-](\d{1,2})[\.|\/|\-](\d{2,4})(.*)/, '\1.\2.\3') # Tidy
                columns.delete_at(19)                                                                           # Remove current
                columns.insert(19, date)                                                                        # Insert new value

                # Add the new state abbreviation column
                state = columns[8].capitalize                           # Get the state
                match = @states.find { |s| s[0].capitalize == state }   # Find the abbreviation
                next if match == nil                                    # Skip if the abbreviation was not found
                columns.insert(9, match[1])                             # Insert value

            end

        end

        # Add the row to the final csv
        final << columns.join(",")

    end
    # Close the connection to the file
    data.close

    # Create the final file
    File.open(output_path, "w") {|f| f.write(final.join())}
end

# Call the functions
states_to_array(state_file_path)
clean_file(storm_file_path, final_path)
