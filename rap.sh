#!/bin/sh

if [ $6 -eq 0 ]; then
  DAY=$(date -d yesterday +%Y%m%d)
else
  DAY=$(date +%Y%m%d)
fi 

STATION_NAME=$1
DATE=${DAY}$2
LENGTH=$3
FILENAME="/out/"$4"_"${DATE}".m4a"
BUCKET_NAME=$5

echo ${DATE}

/usr/local/bin/rec_radiko_ts.sh -s ${STATION_NAME} -f ${DATE} -d ${LENGTH} -o ${FILENAME} -m ${USERNAME} -p ${PASSWORD}

aws s3 cp --no-progress ${FILENAME} ${BUCKET_NAME}

