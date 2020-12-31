from ldap3 import Server, Connection, MODIFY_ADD, MODIFY_DELETE
from services_main_server.Access.access_data import username_ad, password_user_ad, server_ad, \
server_ad_ip
from services_main_server.variables import ou_from_ad_group, ou_in_ad_with_computers


def connect_to_ldap_server():
    """Cоединяюсь с LDAP сервером"""
    server = Server(server_ad_ip)
    conn = Connection(server, user=f"{username_ad}@{server_ad}", password=password_user_ad)
    if conn.bind():
        return conn 
    return False

# [CN=COMP3,OU=comps,DC=npr,DC=nornick,DC=ru]
def add_computer_in_ad(conn, array_distinguished_name):
    """Добавляем компьютер в группу AD"""
    result = conn.modify(
                ou_from_ad_group,
                {
                    'member': [(
                        MODIFY_ADD,
                        array_distinguished_name)
                            ]})
    return result


def delete_computer_in_ad(conn, array_distinguished_name):
    """Добавляем компьютер в группу AD"""
    result = conn.modify(
                ou_from_ad_group,
                {
                    'member': [(
                        MODIFY_DELETE,
                        array_distinguished_name)
                            ]})
    return result


def find_computer_in_ad(computer_name: str) -> bool:
    """Проверка есть ли компьютер в AD по имени или его нет в AD"""
    conn = connect_to_ldap_server()
    if conn:
        return conn.search(
            search_base=ou_in_ad_with_computers,
            search_filter=f'(Name={computer_name})',
            search_scope='SUBTREE',
            attributes = ['member'])
    return False


def create_ps1_script_for_client(obj):
    """Создаем скрипт ps1 для клиента"""
    from data_construction.models import Soft
    from services_main_server.pure_functions import create_file_ps1, create_object_for_powershell
    import json

    conn = connect_to_ldap_server()
    if conn:
        # создаем словари внутри списка с параметрами софта для установки
        programm_list = [json.loads(
            json.dumps(dict(data=list(Soft.objects.filter(pk=i).values())))
            ) for i in obj["program_id"]]

        obj_powershell = create_object_for_powershell(programm_list[0]['data'])
        # создаем скрипты PS1 для каждого компьютера
        for i in range(len(obj["computer_name"])):
            create_file_ps1(obj_powershell, obj["computer_name"][i], obj['idInstall'][i])
        return add_computer_in_ad(conn, obj['distinguishedName'])
    return False
