import os
import django
from celery import Celery
# from django.conf import settings
from data_construction.for_views.StartInstall.function_start_install import insert_success_installed_data


os.environ.setdefault("DJANGO_SETTINGS_MODULE", "main_server.settings")
django.setup()
app = Celery("main_server")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()


@app.task
def request_data():
  return insert_success_installed_data()


# выполнение каждые 10 секунд
app.conf.beat_schedule = {
    'add-every-30-seconds': {
        'task': 'main_server.celery.request_data',
        'schedule': 10.0,
    },
}
app.conf.timezone = 'UTC'
