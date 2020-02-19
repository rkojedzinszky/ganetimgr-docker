FROM alpine

MAINTAINER Richard Kojedzinszky <richard@kojedz.in>

ENV GANETIMGR_VERSION=novnc-jwe

ENV APP_HOME=/srv/ganetimgr APP_USER=ganetimgr

# extract sources
RUN apk --no-cache add -t .install-deps curl tar && \
    mkdir -p ${APP_HOME} && cd ${APP_HOME} && \
    curl -sL https://github.com/rkojedzinszky/ganetimgr/archive/${GANETIMGR_VERSION}.tar.gz | \
    tar xzvf - --strip-components=1 && \
    apk del .install-deps

WORKDIR ${APP_HOME}

# install packages
RUN apk --no-cache add \
	nginx \
	uwsgi-python3 \
	uwsgi-cheaper_busyness \
	openssl \
	libcurl \
	python3 py3-psycopg2 && \
	ln -sf python3 /usr/bin/python && ln -sf pip3 /usr/bin/pip

# install additional python modules
RUN apk --no-cache add -t .build-deps \
        make gcc libc-dev python3-dev libffi-dev openssl-dev curl-dev && \
    pip install --no-cache-dir --no-compile supervisor python-memcached \
    -r requirements.txt && \
    apk del .build-deps

# Add static files
ADD assets/ /

# Finalize configuration
RUN cp ganetimgr/settings.py.dist ganetimgr/settings.py && \
    ( \
        echo "" && \
	echo "from environment_settings import *" \
    ) >> ganetimgr/settings.py && \
    ln -s /data/local_settings.py local_settings.py && \
    python manage.py collectstatic --noinput -l

# Prepare data directory
RUN mkdir /data && adduser -D -H -h $APP_HOME $APP_USER

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 8080 8088
