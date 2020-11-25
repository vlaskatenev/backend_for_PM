import json
import requests
from celery import shared_task
from celery import Task
from pm_main_server.data_construction.serializers import ResultWorkDetailSerializer
from django.conf import settings


@shared_task
class MyTaskClass(Task):

    def run(self, *args, **kwargs):
        # скачаваем данные с сервера functional-server
        response = requests.get('http://functional-server:8000/functional/export-data-information-process',
                   headers={
                   'Content-Type': 'text/plain',
                   'Authorization': 'Token 6845ceea30ebdfd038a0e45324c90d4003803ea8'
                })
		settings.TASK_ID_LIST.append(response.json())		
        # return response.json()


@shared_task
class MyTaskClass2(Task):

    def run(self, *args, **kwargs):
       
        # скачаваем данные с сервера functional-server и записываем в БД main_server
        array_status = map(check_response, settings.TASK_ID_LIST)
		if array_status[0]:
			settings.TASK_ID_LIST.remove(task_id) for task_id in settings.TASK_ID_LIST
        


def check_response(task_id) -> None:
    task_result = AsyncResult(task_id)
    
    if type(task_result.result) == dict:
        # записываем данные в БД
		for obj in task_result.result:
			ResultWorkDetailSerializer.objects.create(date_time=timezone.now(),
											startnumber=obj['id_install'],
											computer_name=obj['computer_name'],
											program_id=Soft.objects.get(pk=obj['program_id']),
											events_id=6,
											result_work=obj['result_work'])
        return True
    return False
