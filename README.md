Database Backup and OneDrive Sync Scripts
Overview

This repository contains scripts designed to:

    Back up a database to a local path.
    Optionally sync those backups to OneDrive using rclone.

Included Scripts:

    backup.sh: Backs up a specified database to a local directory.
    cleanup.sh: Removes old backups based on retention policies.
    sync_onedrive.sh: Syncs the local backup directory to OneDrive.

Getting Started

    Clone the Repository

    git clone https://github.com/yourusername/your-repo.git
    cd your-repo

    Edit the Scripts
        Update the following parameters:
            Save Location: Modify the directory where backups will be saved.
            Database Credentials: Update DB-NAME, DB-PASS, and http://127.0.0.1:8069 in backup.sh.
            Rclone Configuration: Ensure sync_onedrive.sh points to the correct OneDrive remote and directory.

Usage

    Schedule Automated Backups Use crontab to automate the process:

crontab -e

Add the Following Lines:

###############
0 12 * * * /opt/db_backup/cleanup.sh
0 * * * * /opt/db_backup/backup.sh -d DB-NAME -h http://127.0.0.1:8069 -p DB-PASS
2 * * * * /home/ubuntu/sync_onedrive.sh
###############

Explanation:

    cleanup.sh: Runs daily at 12:00 PM to clean up old backups.
    backup.sh: Runs hourly to back up the database.
    sync_onedrive.sh: Runs hourly at 2 minutes past the hour to sync backups to OneDrive.

Test the Scripts Run the scripts manually to ensure they work as expected:

    ./backup.sh -d DB-NAME -h http://127.0.0.1:8069 -p DB-PASS
    ./sync_onedrive.sh

Dependencies

    pg_dump: Required for the backup.sh script to create database backups.
    gzip: Used to compress backup files.
    rclone: Used to sync backups with OneDrive. Installation Guide.

Customization

    Backup Location: Update the save directory in the backup.sh and sync_onedrive.sh scripts.
    Database Credentials defaults: Modify the database name, password, and host URL in backup.sh.
    Retention Policy: Adjust the cleanup.sh script to change how long backups are kept.

License

This repository is open-source. Feel free to modify and use it for personal or commercial purposes.
