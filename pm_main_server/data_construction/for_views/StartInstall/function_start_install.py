import requests
from services_main_server.ldap import connect_to_ldap_server, add_computer_in_ad

# {
#    "data": [dict_name, prog_id, comp_name],
#    "DistinguishedName": ['CN=COMP2,OU=comps,DC=contoso,DC=com']
# }
def request_json_to_functional_server(data):
    """Формируем запрос для сервера functional_server для добавления компа в группу и формированя скриптов для установки софта"""
    response = requests.post('http://functional-server:8000/functional/create-scripts-for-client',
                   json={'data': data['data']},
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': 'Token 6845ceea30ebdfd038a0e45324c90d4003803ea8'
                })
    response_object = response.json()
    response_object['workStatusWithAD'] = add_computer_in_ad(connect_to_ldap_server(), data['DistinguishedName'])         
    return response_object
