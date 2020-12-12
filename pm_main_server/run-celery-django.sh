#!/bin/sh

celery worker --app=main_server > /dev/null 2>&1 & 
celery -A main_server beat -l debug --loglevel=info > /dev/null 2>&1 & 
python3 manage.py runserver 0.0.0.0:8000