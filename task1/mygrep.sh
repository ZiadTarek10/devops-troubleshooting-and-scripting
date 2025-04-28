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

while getopts ":nv" flag; do
    case "${flag}" in
        n) show_line_numbers=true ;;
        v) invert=true ;;
        *) echo "Invalid option: -$OPTARG" >&2
           exit 1 ;;
    esac
done

shift $((OPTIND - 1)) 

string=$1
file=$2

if [ -z "$string" ]; then
    echo "Missing search string!"
    exit 1
fi

if [ ! -f "$file" ]; then
   echo " string does not exist."
   exit 1
fi


line_number=0

# Read file line-by-line
while IFS= read -r line; do
    ((line_number++))

    if echo "$line" | grep -i -q "$string"; then
        match=true
    else
        match=false
    fi

    if [ "$invert" == true ]; then
        if [ "$match" == true ]; then
            match=false
        else
            match=true
        fi
    fi

    if [ "$match" == true ]; then
        if [ "$show_line_numbers" == true ]; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi
done < "$file"