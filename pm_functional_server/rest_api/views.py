from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import ResultWork
from rest_framework import generics
from .serializers import ResultWorkForTaskManagerDetailSerializer
from .models import ResultWorkForTaskManager
from .tasks import get_data_for_task_manager, export_information_process
from celery.result import AsyncResult
from django.conf import settings
from django.db.models import Q


# запись данных в БД об старте установки и добавление слушателя в массив
# {"data": [{
#     "program_name": "Google Chrome",
#     "events_id": "50"
#   }],
#     "id_install": 255777,
#     "result_work": False,
#     "computer_name": "COMP3"
# }
class InsertWorkData(generics.CreateAPIView):
    """Добавляем задание в слушателя и записываем его в БД"""
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        for obj in request.data["data"]:
            ResultWork.objects.create(id_install=request.data["id_install"],
                result_work=request.data["result_work"],
                computer_name=request.data["computer_name"],
                program_name=obj["program_name"],
                events_id=obj["events_id"]
                )

        settings.OBSERVER.attach(request.data)

        return JsonResponse({"observers": settings.OBSERVER._observers}, status=200)


# лог по одной установке, каждый объект в массиве  - информация по каждой программе установленной на клиенте
# {"data": [{
#     "program_name": "Google Chrome",
#     "events_id": "50"
#   }],
#     "id_install": 255777,
#     "result_work": True,
#     "computer_name": "COMP3"
# }
class InsertWorkDataFromClient(generics.CreateAPIView):
    """Клиент уведомляет слушателя, вносим запись в БД, изменяем состояние слушателя и удаляем объект клиента из массива слушателя при занчении resultWork = True"""
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        worked_data = ResultWork.objects.filter(id_install=request.data["id_install"])
        for model in worked_data:
            model.result_work=request.data["result_work"]
            model.save()
        
        if request.data["result_work"]:
            settings.OBSERVER.notify(request.data)
            settings.OBSERVER.detach(request.data)

        return JsonResponse({"task": request.data, "observers": settings.OBSERVER._observers}, status=200)


# method ONLY web main_server
# get request for all data
class SelectWorkedData(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        import json
        all_worked_data = ResultWork.objects.filter(Q(result_work=True) & Q(status_code=False))
        data_from_db = json.loads(json.dumps(dict(data=list(all_worked_data.values()))))
        for model in all_worked_data:
            model.status_code=True
            model.save()

        return JsonResponse({"allWorkedData": data_from_db}, status=200)


# Example request for StartCommandTaskManager:
# {
#    "hostIp": "192.168.0.2",
#    "scriptName": "avarageAllProcessData.ps1"
# }
class StartCommandTaskManager(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        task = get_data_for_task_manager.delay(request.data)
        return JsonResponse({"task_id": task.id}, status=202)


# Example request for GetStatusCelery:
# {
#     "idProcess": "60410a3f-c489-4fe9-8815-5d844e7424cc"
# }
class GetStatusCelery(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        task_id = request.data["idProcess"]
        task_result = AsyncResult(task_id)
        return Response(dict(
            task_id=task_id,
            task_status=task_result.status,
            task_result=task_result.result
        ))


class StartExportInformationProcess(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        task = export_information_process.delay()
        return JsonResponse({"task_id": task.id}, status=202)


