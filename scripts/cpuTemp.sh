#!/usr/bin/env bash

for name_file in /sys/class/hwmon/hwmon*/name; do
    read -r name <"$name_file"
    if [ "$name" = "coretemp" ]; then
        # Get the path to temp1_input in the same directory
        read -r temp <"${name_file%name}temp1_input"
        echo "$temp"
        break # Exit once found to save time
    fi
done
