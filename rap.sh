#!/bin/bash

if [ $6 -eq 0 ]; then
  DAY=$(date -d '-1 day' +%Y%m%d)
else
  DAY=$(date +%Y%m%d)
fi 

STATION_NAME=$1
DATE=${DAY}$2
LENGTH=$3
FILENAME="/out/"$4"_"${DATE}".m4a"
BUCKET_NAME=$5

/usr/local/bin/rec_radiko_ts.sh -s ${STATION_NAME} -f ${DATE} -d ${LENGTH} -o ${FILENAME} -m ${USERNAME} -p ${PASSWORD}

if [ $? -ne 0 ]; then
  echo "録音に失敗しました"
  exit 1
fi

aws s3 cp --no-progress ${FILENAME} ${BUCKET_NAME}

if [ $? -ne 0 ]; then
  echo "アップロードに失敗しました"
  exit 1
fi

upload_text="おはようございます！新しいラジオ番組がアップロードされました！\n番組名: "$4"_"${DATE}".m4a"

PAYLOAD="payload={
  \"channel\": \"${SLACK_CHANNEL}\",
  \"username\": \"radio_dl_bot\",
  \"text\": \"${upload_text}\"
}"

curl -X POST ${SLACK_HOOK_URL} --data-urlencode "${PAYLOAD}"

if [ $? -ne 0 ]; then
  echo "Slack通知に失敗しました"
  exit 1
fi
