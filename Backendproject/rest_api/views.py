from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_api.for_views.Global.pure_functions_global_api import create_context_log
from rest_api.for_views.HistoryDetail.pure_functions_historydetail import create_object_history_detail
from rest_api.for_views.StartInstall.function_start_install import start_install
from rest_api.for_views.pure_functions_history import choise_install
from rest_api.for_views.Manually.manually_pure_functions import create_object_manually
from rest_api.for_views.pure_functions_runningprocess import to_install_id_listdir
from .tasks import start_command_to_task_manager


class History(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        # форматирование даты в нужный формат
        return Response(create_context_log(choise_install(request.data['data'])))


class HistoryDetail(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(create_object_history_detail(request.data['data']))


class RunningProcess(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        # форматирование даты в нужный формат
        id_install = to_install_id_listdir()
        return Response(create_context_log(id_install))


class Manually(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(create_object_manually(request.data['compName']))


class StartInstall(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(start_install(request.data['data']))


# Example request for StartCommandTaskManager:
# {
#    "hostIp": "192.168.0.2",
#    "scriptName": "avarageAllProcessData.ps1"
# }
class StartCommandTaskManager(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        task = start_command_to_task_manager.delay(request.data)
        return JsonResponse({"task_id": task.id}, status=202)
