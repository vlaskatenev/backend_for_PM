#!/bin/sh

celery worker --app=functional-server --loglevel=info   > /dev/null 2>&1 & 
python3 manage.py runserver 0.0.0.0:8000