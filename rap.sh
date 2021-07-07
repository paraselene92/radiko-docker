#!/bin/bash

/usr/local/bin/rec_radiko_ts.sh -s $1 -f $2 -d $3 -o "/out/test.m4a" -m $4 -p $5

echo $(which aws)

aws s3 cp --no-progress "/out/test.m4a" "s3://test-bucket/"

