Ganetimgr dockerized
====================

A simple docker container for running [grnet/ganetimgr](//github.com/grnet/ganetimgr).

Starting
--------

Use the sample compose script to start:

```bash
# docker-compose up
```

For the first time create a user:
```bash
# docker exec -it <container> python manage.py createsuperuser
```

After it, you can login at http://localhost:8080/, and use you freshly installed ganetimgr.

Additional configuration can be done through environment variables in compose file, or creating
a local_settings.py at ${DATA}/ganetimgr/data:/data setting any setting for ganetimgr.

See [default settings](//github.com/grnet/ganetimgr/blob/master/ganetimgr/settings.py.dist).
