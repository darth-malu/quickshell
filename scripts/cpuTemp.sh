#!/usr/bin/env bash

# mapfile -t names_hwmon < <(cat /sys/class/hwmon/*/name)
mapfile -t hwmon_directories < <(ls /sys/class/hwmon)

for dir in "${hwmon_directories[@]}"; do
    SYS_DIR="/sys/class/hwmon/$dir"
    if [ "$(cat "$SYS_DIR/name")" = "coretemp" ]; then
        cat "$SYS_DIR/temp1_input"
    fi
done

# Get all Dir in sys/class/hwmon
# Check if each dir/name mateches 'coretemp' | 'carthage'
# if match cat temp1_input (to solve conflict)
