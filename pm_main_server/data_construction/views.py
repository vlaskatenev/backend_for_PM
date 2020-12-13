import json
import requests
from celery.result import AsyncResult
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from data_construction.for_views.Global.pure_functions_global_api import create_context_log
from data_construction.for_views.HistoryDetail.pure_functions_historydetail import create_object_history_detail
from data_construction.for_views.StartInstall.function_start_install import request_to_start_install
from data_construction.for_views.pure_functions_history import choise_install
from data_construction.for_views.Manually.manually_pure_functions import create_object_to_choose_programm
from services_main_server.ldap import find_computer_in_ad, create_ps1_script_for_client
# import data_construction.for_views.pure_functions_runningprocess
from data_construction.models import LogsInstallationSoft, Soft
from django.utils import timezone


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


# Example request to StartInstall
# {
#      "program_name": ["notepad"],
#      "program_id": [1],
#      "DistinguishedName": [
#          "CN=COMP3,OU=comps,DC=npr,DC=nornick,DC=ru"
#      ],
#     "methodInputnamePc": false,
#     "computer_name": ["COMP3"]
# }
class StartInstall(APIView):
    """отправляем запрос со списком ПК и софта на functional_server"""
    permission_classes = (IsAuthenticated,)

    def post(self, request):

        # записываем событие в таблицу LogsInstallationSoft
        id_install_array = []
        for comp_name in request.data["computer_name"]:
            id_install = LogsInstallationSoft.objects.last().startnumber + 1
            id_install_array.append(id_install)
            for prog_id in request.data["program_id"]:
                LogsInstallationSoft.objects.create(date_time=timezone.now(),
                startnumber=id_install,
                computer_name=comp_name,
                program_id=Soft.objects.get(pk=prog_id),
                events_id=6,
                result_work=False)
        if request.data["methodInputnamePc"]:
            request.data["computer_name"] = check_computer_name_list_in_ad(request.data["computer_name"])
        request.data["idInstall"] = id_install_array

        create_ps1_script_for_client(request.data)

        object_for_start_install = create_object_to_insert_functional_server(request.data)

        return Response(request_to_start_install(object_for_start_install))


# Example request to create_object_to_insert_functional_server
# {
#      "program_name": ["notepad"],
#      "program_id": [1],
#      "DistinguishedName": [
#          "CN=COMP3,OU=comps,DC=npr,DC=nornick,DC=ru", "CN=COMP2,OU=comps,DC=npr,DC=nornick,DC=ru"
#      ],
#     "methodInputnamePc": false,
#     "computer_name": ["COMP3", "COMP2"],
#     "idInstall": 1
# }
def create_object_to_insert_functional_server(data):
    """Формируем словарь для запроса на сервер functional-server"""

    data_list = [dict(data=[dict(
            program_name=data["program_name"][i],
            events_id=1,
            program_id=data["program_id"][i]
        ) for i in range(len(data["program_id"]))],
        id_install=data["idInstall"][index],
        result_work=False,
        computer_name=data["computer_name"][index],
        DistinguishedName=data["DistinguishedName"][index]
    ) for index in range(len(data["computer_name"]))]
    return dict(data=data_list,
        DistinguishedName=data["DistinguishedName"])
  

def check_computer_name_list_in_ad(computr_name_list):
        array = []
        for computer_name in computr_name_list:
            if find_computer_in_ad(computer_name):
                array.append(computer_name)
        return array
