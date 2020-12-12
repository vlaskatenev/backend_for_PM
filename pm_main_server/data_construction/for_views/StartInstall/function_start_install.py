import requests
from services_main_server.ldap import connect_to_ldap_server, add_computer_in_ad
from services_main_server.requests_func import request_post, request_get
# from data_construction.models import LogsInstallationSoft, Soft
from django.utils import timezone


# {
#    "data": [dict_name, prog_id, comp_name],
#    "DistinguishedName": ['CN=COMP2,OU=comps,DC=contoso,DC=com']
# }
def request_to_start_install(data):
    """Формируем запрос для сервера functional_server для добавления компа в группу и формированя скриптов для установки софта"""
                
    response_object = request_post('http://functional-server:8000/functional/insert-work-data', data['data'])
    response_object['workStatusWithAD'] = add_computer_in_ad(connect_to_ldap_server(), data['DistinguishedName'])         
    return response_object


# get запрос для получения данных об завершенных установках
def insert_success_installed_data():
    from data_construction.models import LogsInstallationSoft, Soft

    response_object = request_get('http://functional-server:8000/functional/select-worked-data')

    if len(response_object["allWorkedData"]["data"]) != 0:
        for obj in response_object["allWorkedData"]["data"]:
            LogsInstallationSoft.objects.create(date_time=timezone.now(),
            startnumber=obj["id_install"],
            computer_name=obj["computer_name"],
            program_id=Soft.objects.get(pk=obj["program_id"]),
            events_id=obj["events_id"],
            result_work=False)

    return response_object
