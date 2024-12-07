#!/bin/bash

# Define local and remote paths
LOCAL_DIR=/mnt/odoo_db_backup
REMOTE_DIR=onedrive:odoo_DB_backup

# Run the sync command
rclone sync $LOCAL_DIR $REMOTE_DIR --delete-after --log-file ~/onedrive_sync.log --log-level INFO

# Optional: To remove files that are deleted locally from OneDrive, add the --delete-after flag
# rclone sync $LOCAL_DIR $REMOTE_DIR --delete-after --log-file ~/onedrive_sync.log --log-level INFO

