# This settings file is used to provide most settings
# through environment variables

import socket
import os

DEBUG = os.getenv('DEBUG') is not None
TEMPLATE_DEBUG = DEBUG

ALLOWED_HOSTS = ['*'] if DEBUG else os.getenv('ALLOWED_HOSTS', '').split(',')

# Change SECRET_KEY to a random value
SECRET_KEY = os.getenv('SECRET_KEY', 'change-this')

DATABASES = {
    'default': {
        # postgresql db with schema support
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DBNAME', 'ganetimgr'),
        'HOST': os.getenv('DBHOST', 'postgres'),
        'USER': os.getenv('DBUSER', 'ganetimgr'),
        'PASSWORD': os.getenv('DBPASSWORD', 'ganetimgr'),
        # 'SCHEMA': '',

        'CONN_MAX_AGE': None if os.getenv('DBCONNMAXAGE') == '' else int(os.getenv('DBCONNMAXAGE', '0')),
    }
}

MEMCACHED_HOST = os.getenv('MEMCACHED_HOST', 'memcached')
MEMCACHED_PORT = os.getenv('MEMCACHED_PORT', '11211')

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.PyMemcacheCache',
        'LOCATION': '{}:{}'.format(MEMCACHED_HOST, MEMCACHED_PORT),
    }
}

NOVNC_PROXY = os.getenv('NOVNC_PROXY', 'vncauthproxy:8888')
NOVNC_PROXY_AUTH_USER = os.getenv('NOVNC_PROXY_AUTH_USER', 'novnc')
NOVNC_PROXY_AUTH_PASSWORD = os.getenv('NOVNC_PROXY_AUTH_PASSWORD', 'novnc')
NOVNC_JWE_SECRET = os.getenv('NOVNC_JWE_SECRET')
NOVNC_JWE_TOKEN_EXPIRY = int(os.getenv('NOVNC_JWE_TOKEN_EXPIRY', 5))
NOVNC_PROXY_BASE = os.getenv('NOVNC_PROXY_BASE', 'novnc/')
NOVNC_JWE_SERVER_PASSWORD = os.getenv('NOVNC_JWE_SERVER_PASSWORD', '')

BRANDING = {
    "SERVICE_PROVIDED_BY": {
        "NAME": os.getenv('BRANDING_NAME', "EXAMPLE"),
        "URL": os.getenv('BRANDING_URL', "//example.dot.com"),
        "SOCIAL_NETWORKS": []
    },
    "VIDEO": "",  # iframe url
    "LOGO": os.getenv('BRANDING_LOGO_PATH', "/static/ganetimgr/img/logo.png"),
    "FAVICON": os.getenv('BRANDING_FAVICON_PATH', "/static/ganetimgr/img/favicon.ico"),
    "MOTTO": "virtual private servers",
    "FOOTER_ICONS_IFRAME": False,
    # show the administrative contact
    # option when creating a new vm
    "SHOW_ADMINISTRATIVE_FORM": False,
    "SHOW_ORGANIZATION_FORM": False,
    "TITLE": "ganetimgr",
    # RSS Feed for the login page
    "FEED_URL": "",
    # Analytics script path. See 'templates/includes/analytics.html.dist'
    "ANALYTICS_FILE_PATH": ""
}

#########################
#                       #
#      Beanstalkd       #
#                       #
#########################
BEANSTALKD_HOST = os.getenv('BEANSTALKD_HOST', 'beanstalkd')
BEANSTALKD_PORT = int(os.getenv('BEANSTALKD_PORT', 11300))

del socket, os

try:
    from local_settings import *
except ImportError:
    pass
