#!/bin/sh

retries=5

while :; do
	python manage.py migrate
	if [ $? -eq 0 -o $retries -eq 0 ] ; then
		break
	fi
	retries=$((retries - 1))
	echo "* $(date) Database migration failed, will retry $retries times"
	sleep 5
done

if [ $retries -eq 0 ]; then
	echo "* Database migration failed"
	exit 1
fi

exec "$@"
