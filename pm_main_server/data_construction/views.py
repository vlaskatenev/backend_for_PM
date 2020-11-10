import json
import requests
from django.http import JsonResponse
from celery.result import AsyncResult
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from data_construction.for_views.Global.pure_functions_global_api import create_context_log
from data_construction.for_views.HistoryDetail.pure_functions_historydetail import create_object_history_detail
# from ldap_commander.for_views.StartInstall.function_start_install import start_install
from data_construction.for_views.pure_functions_history import choise_install
from data_construction.for_views.Manually.manually_pure_functions import create_object_manually
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


# class StartInstall(APIView):
#     permission_classes = (IsAuthenticated,)

#     def post(self, request):
#         return Response(start_install(request.data['data']))


