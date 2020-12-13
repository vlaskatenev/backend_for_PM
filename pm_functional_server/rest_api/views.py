from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import ResultWork
from rest_framework import generics
from .tasks import get_data_for_task_manager, export_information_process
from celery.result import AsyncResult
from django.conf import settings
from django.db.models import Q


# Example request for InsertWorkData
# {"data": [{"data": [{
#     "program_name": "Google Chrome",
#     "events_id": "50",
#     "program_id": 1
#   }, {
#     "program_name": "Google Chrome2",
#     "events_id": "50",
#     "program_id": 1
#   }],
#     "id_install": 255789,
#     "result_work": false,
#     "computer_name": "COMP3"
# }]}
class InsertWorkData(generics.CreateAPIView):
    """Добавляем задание в слушателя и записываем его в БД"""
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        for obj in request.data["data"]:
            for programm in obj["data"]:
                ResultWork.objects.create(id_install=obj["id_install"],
                    result_work=obj["result_work"],
                    computer_name=obj["computer_name"],
                    distinguished_name=obj["DistinguishedName"],
                    program_name=programm["program_name"],
                    program_id=programm["program_id"],
                    events_id=programm["events_id"]
                    )

            settings.OBSERVER.attach(obj)

        return JsonResponse({"observers": settings.OBSERVER._observers}, status=200)


# Example request for InsertWorkDataFromClient
# {
#     "id_install": 255822,
#     "result_work": true
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

        return Response(data_from_db)


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


