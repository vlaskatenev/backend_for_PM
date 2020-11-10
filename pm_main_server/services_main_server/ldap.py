from importlib import import_module
from ldap3 import Server, Connection
from services_main_server.Access.access_data import username_ad, password_user_ad, server_ad, \
server_ad_ip


def connect_to_ldap_server():
    """формируем список имен ПК в OU. Cоединяюсь с сервером"""
    server = Server(server_ad_ip)
    conn = Connection(server, user=f"{username_ad}@{server_ad}", password=password_user_ad)
    if conn.bind(): 
        return conn  
    return False