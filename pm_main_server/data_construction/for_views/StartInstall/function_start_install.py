import requests
from services_main_server.ldap import connect_to_ldap_server, add_computer_in_ad, delete_computer_in_ad
from services_main_server.requests_func import request_post, request_get
from django.utils import timezone
from services_main_server.variables import url_insert_work_data



def request_to_start_install(data):
    """Формируем запрос для сервера functional_server для добавления компа в группу и формированя скриптов для установки софта"""
                
    response_object = request_post(url_insert_work_data, data['data'])
    conn = connect_to_ldap_server()
    if conn:
        response_object['workStatusWithAD'] = add_computer_in_ad(conn, data['DistinguishedName'])         
    return response_object


def insert_success_installed_data():
    """Выполняем запрос к functional_server для выгрузки завершенных задач"""
    # Корректно работает с Celery если импорт сделать исключительно локальный
    from data_construction.models import LogsInstallationSoft, Soft
    from services_main_server.variables import url_select_worked_data

    response_object = request_get(url_select_worked_data)

    if len(response_object["data"]):
        conn = connect_to_ldap_server()
        for obj in response_object["data"]:
            LogsInstallationSoft.objects.create(date_time=timezone.now(),
            startnumber=obj["id_install"],
            computer_name=obj["computer_name"],
            program_id=Soft.objects.get(pk=obj["program_id"]),
            events_id=obj["events_id"],
            result_work=True)
            if conn:
                delete_computer_in_ad(conn, [obj['distinguished_name']])
    return response_object
