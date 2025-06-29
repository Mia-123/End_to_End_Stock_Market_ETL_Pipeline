#!/bin/sh

# NAME=$1
# FOLDER=$2

# mkdir $FOLDER
# cd $FOLDER
# touch test.txt
# echo "Hello $NAME" >> test.txt

cd /opt/spark/work-dir

echo "creating table..."

python3 ./stockETL/delta_tables/create_bronze_layer.py

# Tail the log file to keep the container running
tail -f /var/log/cron.log