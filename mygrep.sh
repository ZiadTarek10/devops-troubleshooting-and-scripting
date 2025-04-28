#! /bin/bash


if [ $1 == "--help" ]; then # the $1 is the first argument
    echo "The use of this is : $0 <word or pattern> <file-name>" # the $0 is the name of the script
    exit 0
fi

if [ $# -lt 2 ]; then # if the number of arguments is less than 2
    echo "Error: not enough arguments use --help for help"
    exit 1
fi

show_line_numbers=false
invert=false

while [[ "$1" == -* ]]; do
    case "$1" in
        *n*) show_line_numbers=true ;;
        *v*) invert=true ;;
        *) echo "Invalid option: $1"; break ;;
    esac
    shift
done


string=$1
file=$2

if [ ! -f $file ]; then
   echo " $file does not exist."
   exit 1
fi

if [[ -z "$string" ]]; then
    echo "Missing search string!"
    exit 1
fi

line_number=0

# Read the file line by line
while IFS= read -r line; do
    ((line_number++))

    # Check if the line matches the search string (case insensitive)
    if echo "$line" | grep -i -q "$search_string"; then
        match=true
    else
        match=false
    fi

    # Invert match if needed
    if [ "$invert" == true ]; then
        match=false
    fi

    # Output result based on the options
    if [ "$match" == true ]; then
        if [ "$show_line_numbers" == true ]; then
            echo "$line_number:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"