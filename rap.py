import sys
import subprocess
from presign import create_presign_url
from post_slack import Postslack

## subprocess で rap.sh を起動する。
## 引数を全部渡す。
try:
    subprocess.run("./rap.sh", sys.argv[1])
except:
    print("err")

## boto3 で s3 presign url を取得
## module にきるかな
s3_url = create_presign_url("Bucketname", "filename", "3600")

## slackに通知する
## module 化済
post = Postslack(s3_url, "#59db8f")
post.postslack()

