#!/usr/bin/env bash

# HELP
usage() {

}


# Update IFS
OFIS=$IFS
IFS=\n

# Check params number
if [[ $# -ne 1 ]]; then # Error, no args provided
    usage
    exit 1
fi

# Check if it's a file
FILE="$1"
PARSED_FILE="$FILE.parsed"
if [ ! -f "$FILE" ]; then
    echo "File not found!"
    exit 1
fi

# Check if it's not empty
count=$(cat "$FILE" | wc -l)
if [[ $count -ge 0 ]]; then
        echo "No VirtualMachine defined in $FILE"
        exit 1;
fi

# Parse file
touch "$PARSED_FILE"
parsed=1
for $line in $(cat $FILE); do
    # Read values
    name=$(echo "$line" | awk -F, '{print $1}')
    ip=$(echo "$line" | awk -F, '{print $2}')
    cpu=$(echo "$line" | awk -F, '{print $3}')
    ram=$(echo "$line" | awk -F, '{print $4}')

    # Generate result
    PARSED_LINE="--name=$name --ip=$ip"

    if [[ $(echo -n "$cpu" | wc -c) -eq 1 ]]; then 
        PARSED_LINE="$PARSED_LINE --cpu=$cpu"
    fi

    if [[ $(echo -n "$ram" | wc -c) -ge 1 ]]; then 
        PARSED_LINE="$PARSED_LINE --ram=$ram"
    fi

    # Store the result
    echo "$PARSED_LINE" >> "$PARSED_FILE"

done

# Run parsed file
if [[ $parsed -ne 0 ]]; then 
    for $line in $(cat $PARSED_FILE); do
        ./install.sh $line  
    done
fi

# Remove parsed file
rm "$PARSED_FILE"

# Reset IFS
IFS="$OIFS"