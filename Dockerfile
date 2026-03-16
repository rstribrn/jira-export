FROM php:7.4-cli-alpine

RUN set -ex \
 && echo "http://mirror1.hs-esslingen.de/pub/Mirrors/alpine/latest-stable/main" > /etc/apk/repositories \
 && apk update \
 && apk upgrade --available \
 && rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/cache/apk/*

RUN apk add --no-cache \
    curl \
    openssl \
    ca-certificates

ADD bin/ /opt/jira-export/bin/
ADD data/ /opt/jira-export/data/
ADD vendor/ /opt/jira-export/vendor/
ADD www/.htaccess /opt/jira-export/www/.htaccess

VOLUME ["/opt/jira-export/www/"]

CMD ["php","/opt/jira-export/bin/export-html.php"]
