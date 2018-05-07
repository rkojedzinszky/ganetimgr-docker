FROM alpine
MAINTAINER Richard Kojedzinszky <krichy@nmdps.net>

ENV GANETIMGR_VERSION=master

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
        supervisor \
	nginx \
	beanstalkd \
	uwsgi-python \
	uwsgi-cheaper_busyness \
	openssl \
	python \
	py-yaml \
	py-gevent \
	py-setproctitle \
	py-curl \
	py-requests

# install additional python modules
RUN apk --no-cache add -t .build-deps \
        make gcc libc-dev python2-dev libffi-dev openssl-dev py-pip && \
    pip install --no-cache-dir --no-compile -U \
        'django<1.9' 'django-registration-redux<2' paramiko python-daemon \
	recaptcha-client ipaddr beautifulsoup4 beanstalkc python-memcached \
	jsonfield \
	&& \
    apk del .build-deps

# Add static files
ADD assets/ /

# Finalize configuration
RUN cp ganetimgr/settings.py.dist ganetimgr/settings.py && \
    ( \
        echo "" && \
	echo "from docker_settings import *" \
    ) >> ganetimgr/settings.py && \
    ln -s /data/local_settings.py local_settings.py && \
    python manage.py collectstatic --noinput -l

# Prepare data directory
RUN mkdir /data && adduser -D -H -h $APP_HOME $APP_USER
VOLUME /data

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 80
