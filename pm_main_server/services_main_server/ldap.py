from importlib import import_module
from ldap3 import Server, Connection, MODIFY_ADD, MODIFY_DELETE
from services_main_server.Access.access_data import username_ad, password_user_ad, server_ad, \
server_ad_ip


def connect_to_ldap_server():
    """Cоединяюсь с LDAP сервером"""
    server = Server(server_ad_ip)
    conn = Connection(server, user=f"{username_ad}@{server_ad}", password=password_user_ad)
    if conn.bind():
        return conn 
    return False


def add_computer_in_ad(conn, array_distinguished_name):
    """Добавляем компьютер в группу AD"""
    result = conn.modify(
                'CN=forpm,OU=allgroup,DC=npr,DC=nornick,DC=ru',
                {
                    'member': [(
                        MODIFY_ADD, 
                        array_distinguished_name)
                            ]})
    return result