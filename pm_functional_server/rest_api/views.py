from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from .models import ResultWork
from rest_framework import generics
from .serializers import ResultWorkDetailSerializer
from .tasks import get_data_for_task_manager
from celery.result import AsyncResult


# method for client PC and WEB main server
# example json for post method
# {
#     "date": "2020-11-5T21:35:48.118055Z",
#     "id_install": 255777,
#     "result_work": false
# }
class InsertWorkData(generics.CreateAPIView):
    permission_classes = (IsAuthenticated,)

    serializer_class = ResultWorkDetailSerializer


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

