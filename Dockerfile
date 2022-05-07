FROM python:3.9.6-alpine3.14

WORKDIR /
RUN mkdir -p /.aws

WORKDIR /work

# https://unix.stackexchange.com/questions/206540/date-d-command-fails-on-docker-alpine-linux-container
RUN apk add --update coreutils && rm -rf /var/cache/apk/*
RUN apk add jq curl ffmpeg libxml2-utils wget
RUN wget -o - https://raw.githubusercontent.com/uru2/rec_radiko_ts/master/rec_radiko_ts.sh &&\
  mv /work/rec_radiko_ts.sh /usr/local/bin/. &&\
  chmod a+x /usr/local/bin/rec_radiko_ts.sh &&\
  mkdir -p /out

ADD ./rap.sh /usr/local/bin/.
RUN chmod a+x /usr/local/bin/rap.sh

RUN pip3 install awscli --upgrade
ENV PATH $PATH:/usr/local/lib/python3.7/site-packages/awscli

ENV TZ Asia/Tokyo

WORKDIR /out

ENTRYPOINT ["/bin/sh", "/usr/local/bin/rap.sh"]

