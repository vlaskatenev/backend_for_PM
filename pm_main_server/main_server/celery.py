import os

from celery import Celery


os.environ.setdefault("DJANGO_SETTINGS_MODULE", "main_server.settings")
app = Celery("main_server")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()

@app.task
def request_data():
  print('Hello World')


# выполнение каждые 30 секунд
app.conf.beat_schedule = {
    'add-every-30-seconds': {
        'task': 'request_data',
        'schedule': 30.0,
    },
}
app.conf.timezone = 'UTC'
