import json
import requests
from celery.result import AsyncResult
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from data_construction.for_views.Global.pure_functions_global_api import create_context_log
from data_construction.for_views.HistoryDetail.pure_functions_historydetail import create_object_history_detail
from data_construction.for_views.StartInstall.function_start_install import request_json_to_functional_server
from data_construction.for_views.pure_functions_history import choise_install
from data_construction.for_views.Manually.manually_pure_functions import create_object_to_choose_programm
from services_main_server.ldap import find_computer_in_ad
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
class ShowProgrammList(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        return Response(create_object_to_choose_programm(request.data['compNameList']))


# {
#    "data": [dict_name, prog_id, comp_name],
#    "DistinguishedName": ['CN=COMP2,OU=comps,DC=contoso,DC=com'],
#    "methodInputnamePc": True
# }
class StartInstall(APIView):
    """отправляем запрос со списком ПК и софта на functional_server"""
    permission_classes = (IsAuthenticated,)

    def post(self, request):

        # записываем событие в таблицу LogsInstallationSoft
        from data_construction.models import LogsInstallationSoft, Soft
        from django.utils import timezone
        for comp_name in request.data["data"][2]:
            for prog_id in request.data["data"][1]:
                LogsInstallationSoft.objects.create(date_time=timezone.now(),
                startnumber=LogsInstallationSoft.objects.last().startnumber + 1,
                computer_name=comp_name,
                program_id=Soft.objects.get(pk=prog_id),
                events_id=6,
                result_work=False)


        if request.data["methodInputnamePc"]:
            request.data["data"][2] = check_computer_name_list(request.data["data"][2])
        return Response(request_json_to_functional_server(request.data))


def check_computer_name_list(computr_name_list):
        array = []
        for computer_name in computr_name_list:
            if find_computer_in_ad(computer_name):
                array.append(computer_name)
        return array
