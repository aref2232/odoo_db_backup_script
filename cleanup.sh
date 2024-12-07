#!/bin/bash

# Define the folder containing the backup files
BACKUP_FOLDER="/mnt/odoo_db_backup"

# Remove old backup files
remove_old_backups() {
    # Loop through the files in the backup folder
    for file in "$BACKUP_FOLDER"/*.zip; do
        # Extract the date from the filename
        filename=$(basename "$file")
        date_str=$(echo "$filename" | cut -d '_' -f 2)
        file_date=$(date -d "$date_str" +%s)
        
        # Calculate the date 7 days ago
        seven_days_ago=$(date -d '7 days ago' +%s)
        
        # Check if the file is older than 7 days
        if [ "$file_date" -lt "$seven_days_ago" ]; then
            # Keep only the latest backup file for each day
            day=$(date -d "@$file_date" '+%Y-%m-%d')
            latest_backup=$(ls "$BACKUP_FOLDER"/Egyptian-Danish_"$day"_*.zip | sort | tail -n1)
            rm "$file" 2>/dev/null
            # Keep only the latest backup file for each day
            for backup in "$BACKUP_FOLDER"/Egyptian-Danish_"$day"_*.zip; do
                if [ "$backup" != "$latest_backup" ]; then
                    rm "$backup" 2>/dev/null
                fi
            done
        fi
    done
}

# Run the function to remove old backup files
remove_old_backups
