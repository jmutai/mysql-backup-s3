# mysql-backup-s3

This is a repository for a bash script to backup MySQL databases to s3.

The script is easy to use. Just modify the following variables defibed at the top.


```
DB_USER="root"
DB_PASSWORD=""
DB_HOST="localhost"
date_format=`date +%a`
db_dir="/tmp/databases/$date_format"
sync_dir="/tmp/databases"
dest_backup_file="/tmp/cloudstack-databases-$date_format.tgz"
log_file="/var/log/s3"
s3_bucket="s3://s3-bucket-name"
```
Once all is modified, run the script.

```
$ bash mysql-backup-s3.sh
```
