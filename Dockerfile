FROM python:3.12-slim-bookworm

WORKDIR /
RUN mkdir -p /.aws

WORKDIR /work

RUN apt-get update && apt-get install -y jq curl ffmpeg libxml2-utils wget tzdata &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget -O /usr/local/bin/rec_radiko_ts.sh https://raw.githubusercontent.com/uru2/rec_radiko_ts/refs/tags/v2.2.2/rec_radiko_ts.sh &&\
  chmod a+x /usr/local/bin/rec_radiko_ts.sh &&\
  mkdir -p /out

ADD ./rap.sh /usr/local/bin/.
RUN chmod a+x /usr/local/bin/rap.sh

RUN pip3 install awscli --upgrade

ENV TZ Asia/Tokyo

WORKDIR /out

ENTRYPOINT ["/bin/sh", "/usr/local/bin/rap.sh"]

