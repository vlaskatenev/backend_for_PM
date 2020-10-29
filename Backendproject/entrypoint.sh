#!/bin/sh

# python manage.py flush --no-input
python3 manage.py migrate
python3 manage.py collectstatic --no-input --clear
python3 manage.py runserver 0.0.0.0:8000

exec "$@"
