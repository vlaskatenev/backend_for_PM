from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import ResultWork
from rest_framework import generics
from .serializers import ResultWorkDetailSerializer
from .tasks import get_data_for_task_manager
from celery.result import AsyncResult
from django.conf import settings

# method for client PC and WEB main server
# example json for post method
# {
#     "id_install": 255777,
#     "result_work": false
# }
class InsertWorkData(generics.CreateAPIView):
    """Добавляем задание в слушателя и записываем его в БД"""
    permission_classes = (IsAuthenticated,)

    serializer_class = ResultWorkDetailSerializer

    def post(self, request):
        task = get_data_for_task_manager.delay(request.data)
        ResultWorkDetailSerializer.objects.create(id_install=request.data["id_install"], result_work=request.data["result_work"])

        settings.OBSERVER.attach(request.data)

        return JsonResponse({"task_id": task.id}, status=202)


# {
#     "id_install": 255777,
#     "result_work": True
# }
class InsertWorkDataFromClient(generics.CreateAPIView):
    """Клиент уведомляет слушателя, вносим запись в БД, изменяем состояние слушателя и удаляем объект клиента из массива слушателя при занчении resultWork = True"""
    permission_classes = (IsAuthenticated,)

    serializer_class = ResultWorkDetailSerializer

    def post(self, request):
        ResultWorkDetailSerializer.objects.create(id_install=request.data["id_install"], result_work=request.data["result_work"])
        
        if request.data["resultWork"]:
            settings.OBSERVER.notify(request.data)
            settings.OBSERVER.detach(request.data)

        return JsonResponse({"task": request.data}, status=200)







# method ONLY web main server
# get request for all data
class SelectWorkData(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,)

    serializer_class = ResultWorkDetailSerializer

    queryset = ResultWork.objects.filter(id_install=255777)



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


# {
#    "data": [['Chrome', 'Notepad'], [1, 2], ['comp1']]
# }
class CreateScriptsForClient(APIView):
    """
    создаем скрипты для клиента
    example request: 
    {
    "data": [['Chrome', 'Notepad'], [1, 2], ['comp1']]
    }
    """

    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(dict(requestFromServer=request.data['data'], statusOk="OK"))



