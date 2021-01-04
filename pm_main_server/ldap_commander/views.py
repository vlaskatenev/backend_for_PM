import json
import requests
from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from services_main_server.ldap import connect_to_ldap_server
from services_main_server.variables import ou_in_ad_with_computers


# Example request for AllComputersFromAD
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


# Example request for FindComputerInAD
# {
#     "computerName": "comp2"
# }
class FindComputerInAD(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        conn = connect_to_ldap_server()
        if conn:
            member_from_ad= conn.search(
                search_base=ou_in_ad_with_computers,
                search_filter=f'(Name={request.data["computerName"]})', 
                search_scope='SUBTREE',
                attributes=['member', 'Name', "DistinguishedName"])
                # создаем список для имен пк, форматируем и добавляем в список
            array_comp_from_ad = [str(name_pc['Name']).replace("Name: ", "") for name_pc in conn.entries]
            array_comp_from_ad.reverse()
            array_distinguished_name = [str(distinguished_name['DistinguishedName']).replace("DistinguishedName: ", "") for distinguished_name in conn.entries]
            array_distinguished_name.reverse()
            return JsonResponse({"data": {"adMember": member_from_ad, "computerName": array_comp_from_ad, "DistinguishedName": array_distinguished_name, "workStatusWithAD": bool(conn)}}, status=200)  
        return JsonResponse({"data": bool(conn)})
