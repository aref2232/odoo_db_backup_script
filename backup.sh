#!/bin/bash

# Exit script if command fails
# -u stops the script on unset variables
# -e stops the script on errors
# -o pipefail stops the script if a pipe fails
set -e

# Get script name
SCRIPT=$(basename "$0")

# Display Help
Help() {
  echo
  echo "$SCRIPT"
  echo
  echo "Description: Backup odoo database."
  echo "Syntax: $SCRIPT [-p|-d|-o|-h|help]"
  echo "Example: $SCRIPT -p secret -d odoo -o /tmp -h https://odoo.example.com"
  echo "options:"
  echo "  -p    Odoo master password. Defaults to \$ODOO_MASTER_PASSWORD env var."
  echo "  -d    Database name."
  echo "  -o    Output directory with or without name. Defaults to '/var/tmp'"
  echo "  -h    Odoo host. Defaults to 'http://localhost:8069'"
  echo "  help  Show $SCRIPT manual."
  echo
}

# Show help and exit
if [[ $1 == 'help' ]]; then
    Help
    exit
fi

# Process params
while getopts ":p: :d: :o: :h:" opt; do
  case $opt in
    h) ODOO_HOST="$OPTARG"
    ;;
    p) PASSWORD="$OPTARG"
    ;;
    d) DATABASE="$OPTARG"
    ;;
    o) OUTPUT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    Help
    exit;;
  esac
done

# Fallback to environment vars and default values
: ${PASSWORD:=${ODOO_MASTER_PASSWORD:='xyz-msa-ygyaa'}} # default master password
: ${OUTPUT:='/mnt/odoo_db_backup'}
: ${ODOO_HOST:='http://localhost:10017'} ## default odoo host address (this is for me you should change it)

# Verify variables
[[ -z "$DATABASE" ]] && { echo "Parameter -d|database is empty" ; exit 1; }
[[ -z "$OUTPUT" ]] && { echo "Parameter -d|dir is empty" ; exit 1; }
[[ -z "$ODOO_HOST" ]] && { echo "Parameter -h|host is empty" ; exit 1; }

# Check if dir var is file or folder
if [ "${OUTPUT: -4}" = ".zip" ];then
  DIR=`dirname "$OUTPUT"`
  FILE=`basename "$OUTPUT"`
else
  DIR=$OUTPUT
fi

# Ensure output directory exists
mkdir -p $DIR

# Ensure file name is set
if [ -z "$FILE" ];then
  FILE="$DATABASE.zip"
fi

# Set file path
FILEPATH="${DIR}/${FILE}"

echo "Backup database $DATABASE to $FILEPATH"

# Request backup with curl
curl -X POST \
  -F "master_pwd=$PASSWORD" \
  -F "name=$DATABASE" \
  -F "backup_format=zip" \
  -o "$FILEPATH" \
  "$ODOO_HOST/web/database/backup"

# Grep error if is html response
FILETYPE=$(file --mime-type -b "$FILEPATH")
if [[ "$FILETYPE" == 'text/html' ]]; then
  grep error "$FILEPATH"
fi

# Validate zip file
unzip -q -t "$FILEPATH"

# Notify if backup has finished
#echo "The Odoo backup has finished: $FILEPATH"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
mv $FILEPATH /mnt/odoo_db_backup/DB_$TIMESTAMP.zip
echo "/mnt/odoo_db_backup/DB_$TIMESTAMP.zip"
