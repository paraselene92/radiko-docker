#!/bin/sh

ls -la /.aws/

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

/usr/local/bin/rec_radiko_ts.sh -s ${STATION_NAME} -f ${DATE} -d ${LENGTH} -o ${FILENAME} -m ${USERNAME} -p ${PASSWORD}

#curl --max-time 5 169.254.170.2${AWS_CONTAINER_CREDENTIALS_RELATIVE_URI}

aws s3 cp --no-progress ${FILENAME} ${BUCKET_NAME}
presigned_url=$(aws s3 presign --expires-in 604800 ${BUCKET_NAME}$4"_"${DATE}".m4a")
presigned_url=`echo "$presigned_url" | sed -e s/'&'/'%26'/g -e s/'+'/'%2B'/g`

#cat - << __EOS__ >> message.json
PAYLOAD="payload={
  \"channel\": \"${SLACK_CHANNEL}\",
  \"username\": \"radio_dl_bot\",
  \"text\": \"${presigned_url}\"
}"
#__EOS__

curl -X POST ${SLACK_HOOK_URL} --data-urlencode "${PAYLOAD}"

