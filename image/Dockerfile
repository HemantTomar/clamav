FROM ubuntu:impish-20220128
USER root
ENV TZ=Asia/Kolkata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# clamav: for the virus scanner
# cron: for running periodicaly scanning
# gettext-base: for having envsubst command
# rsync: for SCAN_ONLY_NEW_FILES feature
#ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt -y upgrade && apt install -y cron clamav gettext-base rsync

COPY conf/* /etc/clamav/
# update virus database a first time
VOLUME /var/lib/clamav/
RUN freshclam -F

# script for running clamav scanning
COPY do-clamscan.sh /scripts/do-clamscan.sh

# template for crontabs
COPY tasks.tmpl /etc/cron.d/tasks.tmpl


COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
