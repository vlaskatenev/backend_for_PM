import os

from celery import Celery


os.environ.setdefault("DJANGO_SETTINGS_MODULE", "functional-server.settings")
app = Celery("functional-server")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()

# выполнение каждые 30 секунд
app.conf.beat_schedule = {
    'add-every-30-seconds': {
        'task': 'tasks.add',
        'schedule': 30.0,
    },
}
app.conf.timezone = 'UTC'
