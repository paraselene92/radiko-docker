import os
import sys
import json
from urllib.request import urlopen, Request
from urllib.error import URLError, HTTPError


class Postslack:
    print("Post Slack")

    def __init__(self, url, color):
        self.slack_urls = os.environ["SLACK_HOOK_URL"]
        self.slack_channel = os.environ.get("SLACK_CHANNEL", "")

        ## todo argv[1]存在確認
        self.url = url
        self.color = color
        return

    def postslack(self):
        slack_message = {
             "attachments": [
                 {
                     "color": self.color,
                     "title": "Radio",
                     "fields": [
                         {
                             "title": "s3_url",
                             "value": self.url,
                         }
                     ],
                     "footer": "from AWS ECS",
                     "mrkdwn_in": ["fields"],
                 }
             ]
         }
    
        try:
            req = Request(self.slack_urls, json.dumps(slack_message).encode("utf-8"))
            res = urlopen(req)
            res.read()
            print("Posted.")
        except HTTPError as e:
            print("request failed:", e.code, e.reason)
        except URLError as e:
            print("Server connection failed:", e.reason)


if __name__ == '__main__':
     post = Postslack(sys.argv[1], "#59db8f")
     post.postslack()

