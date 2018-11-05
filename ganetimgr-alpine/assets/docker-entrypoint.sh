#!/bin/sh

conditional_link()
{
	# create a link from src to dst only if src exists
	local src="$1" dst="$2"

	if [ -f "$src" ]; then
		rm -f "$dst"
		ln -s "$src" "$dst"
	fi
}

chown -R $APP_USER: /data

# Fix for favicon and logo
conditional_link /data/favicon.ico ${APP_HOME}/static/ganetimgr/img/favicon.ico
conditional_link /data/logo.png ${APP_HOME}/static/ganetimgr/img/logo.png

trials=6

while [ $trials -gt 0 ]; do
	trials=$((trials - 1))
	su -c "python manage.py migrate" $APP_USER
	if [ $? -eq 0 -o $trials -eq 0 ] ; then
		break
	fi
	echo "* $(date) Database migration failed, will retry $trials times"
	sleep 5
done

if [ $trials -eq 0 ]; then
	echo "* Database migration failed"
fi

exec "$@"
