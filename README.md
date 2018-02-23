# Backup MySQL databases to Amazon S3

This is a repository for a bash script to backup MySQL databases to s3.

## Prerequisites

- Python
- Pip
- awscli tools
- mail command for email notification

For a detailed guide on how to Install and Configure all prerequisites, visit:

https://computingforgeeks.com/backup-mysql-databases-amazon-s3/

The script is easy to use. Just modify the following variables defined at the top.


```
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
```

For email support, you need `mail` command working. On CentOS install mailx package:

```
$ sudo yum -y install mailx
```

On Ubuntu install mailutils package.

```
$ sudo apt-get -y install mailutils
```

Once all is modified, run the script.

```
$ bash mysql-backup-s3.sh
```
