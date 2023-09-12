FROM ghcr.io/euronetzrt/django:3.18.0

LABEL org.opencontainers.image.authors "Richard Kojedzinszky <richard@kojedz.in>"

ENV GANETIMGR_VERSION=master

ENV APP_HOME=/srv/ganetimgr APP_USER=ganetimgr

# extract sources
RUN apk --no-cache add -t .install-deps git && \
    mkdir -p ${APP_HOME} && cd ${APP_HOME}/.. && \
    git clone --depth 1 -b ${GANETIMGR_VERSION} https://github.com/rkojedzinszky/ganetimgr ganetimgr && \
    cd ganetimgr && git submodule init && git submodule update && find . -type d -name .git -print0 | xargs -r0 rm -rf && \
    apk del .install-deps

WORKDIR ${APP_HOME}

# install packages
RUN apk --no-cache add \
    uwsgi-python3 \
    py3-psycopg2 py3-gevent py3-curl py3-cryptography py3-pynacl py3-bcrypt \
    py3-setproctitle py3-paramiko py3-ipaddr py3-beautifulsoup4 py3-requests py3-yaml \
    py3-simplejson

# install additional python modules
RUN pip install --no-cache-dir --no-compile supervisor pymemcache \
    -r requirements.txt

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

# Create user & home directory
RUN adduser -D -H -h $APP_HOME $APP_USER

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]

ENV UWSGI_THREADS=4

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
