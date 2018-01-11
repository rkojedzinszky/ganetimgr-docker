
DEBUG = False
TEMPLATE_DEBUG = DEBUG

import socket, os

ALLOWED_HOSTS = [socket.gethostname()]

SECRET_KEY = os.urandom(32)

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/data/ganetimgr.db',
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
	'LOCATION': 'memcached:11211',
    }
}

NOVNC_PROXY = os.getenv('NOVNC_PROXY','vncauthproxy:8888')

BRANDING = {
    "SERVICE_PROVIDED_BY": {
        "NAME": os.getenv('BRANDING_NAME', "EXAMPLE"),
        "URL": os.getenv('BRANDING_URL', "//example.dot.com"),
        "SOCIAL_NETWORKS": []
    },
    "VIDEO": "", # iframe url
    "LOGO": "/static/ganetimgr/img/logo.png",
    "FAVICON": "/static/ganetimgr/img/favicon.ico",
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

del socket, os

try:
    from local_settings import *
except ImportError:
    pass
