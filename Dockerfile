FROM alpine:3.21

ARG TZ="Asia/Tokyo"
ARG php_ver="8.4.4-r0"
ARG admin_ver="1.9.240801"
ARG DIR="/opt/dbadmin"

ENV LANG="ja_JP.UTF-8"

WORKDIR ${DIR}

RUN set -x \
 && apk update && apk upgrade \
 && apk add --no-cache --virtual .build-deps curl tzdata \
 && \
 : "php" \
 && apk add --no-cache \
    php84=${php_ver} \
    php84-session=${php_ver} \
    php84-mysqli=${php_ver} \
 && \
 : "phpminiadmin" \
 && mkdir -p ${DIR} \
 && cd ${DIR} \
 && curl -L https://raw.githubusercontent.com/osalabs/phpminiadmin/refs/tags/v${admin_ver}/phpminiadmin.php -o index.php \
 && sed -i -e 's/ACCESS_PWD='\'\''/ACCESS_PWD=getenv("ACCESS_PWD")?:""/g' ./index.php \
 && sed -i -e 's/'\''user'\''=>"",/'\''user'\''=>getenv("DB_USER")?:"",/g' ./index.php \
 && sed -i -e 's/'\''pwd'\''=>"",/'\''pwd'\''=>getenv("DB_PASSWORD")?:"",/g' ./index.php \
 && sed -i -e 's/'\''db'\''=>"",/'\''db'\''=>getenv("DB_NAME")?:"",/g' ./index.php \
 && sed -i -e 's/'\''host'\''=>"",/'\''host'\''=>getenv("DB_HOST")?:"",/g' ./index.php \
 && sed -i -e 's/'\''port'\''=>"",/'\''port'\''=>getenv("DB_PORT")?:"3306",/g' ./index.php \
 && \
 : "permission" \
 && addgroup -S dbadmin \
 && adduser -S -G dbadmin dbadmin \
 && chown -R dbadmin:dbadmin ${DIR} \
 && chmod -R 755 ${DIR} \
 && \
 : "timezones" \
 && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
 && \
 : "end proccess" \
 && apk del -f .build-deps \
 && rm -rf /tmp/*

USER dbadmin

EXPOSE 8080

CMD [ "php", "-S", "[::]:8080" ]
