require "CSV"

# Paths to the files
storm_file_path = "../../data/raw/stormdata_2008.csv"
state_file_path = "../../data/raw/states.csv"
final_path = "../../data/processed/stormdata_2008_cleaned.csv"
inter_path = "../../data/processed/date_state.csv"

# The columns to remove from the storms file
columns_to_remove = [
    "BEGIN_YEARMONTH",
    "BEGIN_DAY",
    "BEGIN_TIME",
    "END_YEARMONTH",
    "END_DAY",
    "END_TIME",
    "EPISODE_ID",
    "EVENT_ID",
    "STATE_FIPS",
    "YEAR",
    "MONTH_NAME",
    "CZ_TYPE",
    "CZ_FIPS",
    "CZ_NAME",
    "WFO",
    "CZ_TIMEZONE",
    "INJURIES_DIRECT",
    "INJURIES_INDIRECT",
    "DEATHS_DIRECT",
    "DEATHS_INDIRECT",
    "DAMAGE_PROPERTY",
    "DAMAGE_CROPS",
    "SOURCE",
    "MAGNITUDE",
    "MAGNITUDE_TYPE",
    "FLOOD_CAUSE",
    "CATEGORY",
    "TOR_F_SCALE",
    "TOR_LENGTH",
    "TOR_WIDTH",
    "TOR_OTHER_WFO",
    "TOR_OTHER_CZ_STATE",
    "TOR_OTHER_CZ_FIPS",
    "TOR_OTHER_CZ_NAME",
    "BEGIN_RANGE",
    "BEGIN_AZIMUTH",
    "BEGIN_LOCATION",
    "END_RANGE",
    "END_AZIMUTH",
    "END_LOCATION",
    "BEGIN_LAT",
    "BEGIN_LON",
    "END_LAT",
    "END_LON",
    "EPISODE_NARRATIVE",
    "EVENT_NARRATIVE",
    "LAST_MOD_DATE",
    "LAST_MOD_TIME",
    "LAST_CERT_DATE",
    "LAST_CERT_TIME",
    "LAST_MOD",
    "LAST_CERT",
    "ADDCORR_FLG",
    "ADDCORR_DATE",
]

# The date columns that need formated
date_columns_to_clean = [
    "BEGIN_DATE_TIME",
    "END_DATE_TIME",
]

# The rows that need removed
words_to_remove = [
    "Drought",
    "Avalanche",
    "Astronomical Low Tide",
    "Coastal Flood",
    "Landslide",
    "Rip Current",
    "Seiche",
    "Sleet",
    "Storm Surge/Tide",
    "Tropical Depression",
]

# Import the csv files
puts "Reading states..."
states = CSV.read(state_file_path, :headers => true)
puts "Reading storms..."
storms = CSV.read(storm_file_path, :headers => true)

# Function that removes unwanted columns
def remove_columns(table, columns_to_remove)
    # Informe the user
    puts "Removing columns..."

    # Iterate over the columns to remove
    columns_to_remove.each do |column|
        # Remove that columns
        table.delete(column)
    end
    # Return the table
    table
end

# Function that adds the state abbreviation to the file
def add_state_addr(states, table)
    # Informe the user
    puts "Adding column..."

    # Iterate over each row of the storms table
    table.by_row().each_with_index do |row, index|
        # Find the row in the states table that corresponds
        state_row = states.find {|state| state["State"].capitalize == row["STATE"].capitalize}

        # Check if a state was found
        if state_row != nil
            # Add the abbreviation to the storms table
            row["STATE_ABBR"] = state_row["Abbreviation"]
        else
            # Remove the row if no state was found
            row.delete(index)
        end
    end

    # Delete the row if there is no state abbreviation
    table.delete_if do |row|
        row["STATE_ABBR"] == nil
    end

    # Return the table
    table
end

# Function that deletes the rows containing specific words in a column
def delete_rows(table, words)
    # Informe the user
    puts "Deleteing rows..."
    words.each do |word|
        # Informe the user
        puts "Deleteing rows with #{word}..."

        # Delete the row if it finds the word
        table.delete_if do |row|
            row["EVENT_TYPE"] == word
        end
    end

    # Return the table
    table
end

# Function to format the dates
def clean_dates(table, columns)
    # Informe the user
    puts "Cleaning dates..."

    # Iterate over the storms table
    table.each do |row|
        # Iterate over the date columns
        columns.each do |column|
            # Format and replace the date
            date = row[column].to_s.gsub(/(\d{1,2})[\.|\/|\-](\d{1,2})[\.|\/|\-](\d{2,4})(.*)/, '\2.\1.\3')
            date = Date.parse(date)
            row[column] = date.strftime('%d.%m.%Y')
        end
    end

    # Return the table
    table
end

# Call all the functions
storms = remove_columns(storms, columns_to_remove)
storms = delete_rows(storms, words_to_remove)
storms = add_state_addr(states, storms)
storms = clean_dates(storms, date_columns_to_clean)

# Informe the user
puts "Creating the file..."
# Create the cleand file with the data
File.open(final_path, 'w') do |f|
    f.write(storms.to_csv)
end
