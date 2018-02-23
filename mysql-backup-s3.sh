#!/bin/bash

# Define bavkup variables
DB_USER=""
DB_PASSWORD=""
DB_HOST="localhost"
date_format=`date +%a`
db_dir="/tmp/databases/$date_format"
sync_dir="/tmp/databases"
dest_backup_file="/tmp/databases-$date_format.tgz"
log_file="/var/log/s3"
s3_bucket="s3://s3-bucket-name"
email_notification="email-address"

# create log file
if [ ! -e $log_file ]; then
    touch $log_file
fi

# Create database backups dir
if [ ! -d $db_dir ]; then
    mkdir -p $db_dir
fi

# Get a list of all databases -- Except mysql and schema dbs

databases=`mysql -u $DB_USER -h $DB_HOST -p$DB_PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

# Dump all databases

for db in $databases; do
    if [[ "$db" != "information_schema"  ]] && [[ "$db" != "performance_schema"  ]] && [[ "$db" != "mysql"  ]] && [[ "$db" != _*  ]] ; then
        echo "Dumping database: $db"
        mysqldump -u $DB_USER -h $DB_HOST -p$DB_PASSWORD --databases $db > $db_dir/$db-$date_format.sql
    fi
done


# Generate compressed file of backup dir

echo "Compressing databases before upload.."
tar -zcvf $dest_backup_file -C $db_dir . &>> $log_file

# Copy compressed file to s3

echo "Backing up databases to s3.."
aws s3 cp $dest_backup_file  ${s3_bucket} &>> $log_file


# Send email when successful - Optional
# Uncomment this section if you don't need email notification upon completion

if [[ $? -eq '0' ]]; then
    echo "Backup successful"
    rm -rf $db_dir
    echo "" > /tmp/success
    echo "DB backups to s3 successful" >> /tmp/success
    echo "" >> /tmp/success
    aws s3 ls ${s3_bucket} | tee -a  /tmp/success
    mail -s "Database backups to s3" $email_notification < /tmp/success
    exit 0
fi
