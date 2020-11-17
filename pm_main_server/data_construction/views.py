import json
import requests
from django.http import JsonResponse
from celery.result import AsyncResult
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from data_construction.for_views.Global.pure_functions_global_api import create_context_log
from data_construction.for_views.HistoryDetail.pure_functions_historydetail import create_object_history_detail
from data_construction.for_views.StartInstall.function_start_install import request_json_to_functional_server
from data_construction.for_views.pure_functions_history import choise_install
from data_construction.for_views.Manually.manually_pure_functions import create_object_to_choose_programm
import data_construction.for_views.pure_functions_runningprocess


class History(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        # форматирование даты в нужный формат
        return Response(create_context_log(choise_install(request.data['data'])))


class HistoryDetail(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(create_object_history_detail(request.data['data']))


# class RunningProcess(APIView):
#     permission_classes = (IsAuthenticated,)

#     def post(self, request):
#         # форматирование даты в нужный формат
#         id_install = to_install_id_listdir()
#         return Response(create_context_log(id_install))

# {
#    "compNameList": ['comp1']
# }
class Manually(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(create_object_to_choose_programm(request.data['compNameList']))

# {
#    "data": [dict_name, prog_id, comp_name]
# }
class StartInstall(APIView):
    """отправляем запрос со списком ПК и софта на functional_server"""

    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(request_json_to_functional_server(request.data['data']))
