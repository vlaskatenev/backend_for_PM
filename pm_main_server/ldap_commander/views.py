import json
import requests
from django.http import JsonResponse
from celery.result import AsyncResult
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from services_main_server.ldap import connect_to_ldap_server, add_computer_in_ad, to_dicts_programms
from services_main_server.pure_functions import create_object_for_powershell, create_file_ps1


# {
#     "ad_tree": "OU=comps,DC=pre,DC=contoso,DC=com"
# }
class AllComputersFromAD(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        # формируем список имен ПК в OU. Начало
        # соединяюсь с сервером
        
        conn = connect_to_ldap_server()
        if conn:
            ad_tree = request.data['ad_tree']
            # читаю список компов с атрибутом Name
            conn.search(ad_tree, '(objectClass=computer)', attributes=['Name', "DistinguishedName"])

            # создаем список для имен пк, форматируем и добавляем в список
            array_comp_from_ad = [str(name_pc['Name']).replace("Name: ", "") for name_pc in conn.entries]
            array_comp_from_ad.reverse()
            array_distinguished_name = [str(distinguished_name['DistinguishedName']).replace("DistinguishedName: ", "") for distinguished_name in conn.entries]
            array_distinguished_name.reverse()
            # формируем список имен ПК в OU. Конец
            return JsonResponse({"data": {"computerName": array_comp_from_ad, "DistinguishedName": array_distinguished_name, "workStatusWithAD": bool(conn)}}, status=200)
        return JsonResponse({"data": "Refused connection to AD", "workStatusWithAD": bool(conn)}, status=412)


# {
#     "computerName": "comp2"
# }
class FindComputerInAD(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        conn = connect_to_ldap_server()
        if conn:
            return conn.search(
                search_base='OU=comps,DC=pre,DC=contoso,DC=com',
                search_filter=f'(Name={request.data["computerName"]})', 
                search_scope='SUBTREE', 
                attributes = ['member'])
        return conn


# {
#     "DistinguishedName": ["CN=COMP3,OU=comps,DC=npr,DC=nornick,DC=ru"],
#     "programmId": [1],
#     "computerName": ["COMP3"]
# }
class AddComputerInADGroup(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        from data_construction.models import Soft
        from services_main_server.ldap import connect_to_ldap_server
        conn = connect_to_ldap_server()
        if conn:
            # создаем словари внутри списка с параметрами софта для установки
            programm_list = [json.loads(
                json.dumps(dict(data=list(Soft.objects.filter(pk=i).values())))
                ) for i in request.data['programmId']]

            obj_powershell = create_object_for_powershell(programm_list[0]['data'])
            # создаем скрипты PS1 для каждого компьютера
            for computer_name in request.data['computerName']:
                create_file_ps1(obj_powershell, computer_name, id_install)
            # return add_computer_in_ad(conn, request.data['DistinguishedName'])
            return JsonResponse({"data": add_computer_in_ad(conn, request.data['DistinguishedName'])}, status=412)
        return JsonResponse({"data": "You are have problem this viwed parametr DistinguishedName"}, status=412)

