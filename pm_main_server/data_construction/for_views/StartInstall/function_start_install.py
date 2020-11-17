import requests

# from services_main_server import OLD_powershell as powershell


# def create_object_start_install(status):
#     return "Установка началась, Choice program " + str(status)


def start_install(data: list):
    """Формируем запрос для сервера functional_server для добавления компа в группу и формированя скриптов для установки софта"""
    requests.post('http://functional-server:8000/functional/create-scripts-for-client',
                   data={'data': data},
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': 'Token 6845ceea30ebdfd038a0e45324c90d4003803ea8'
                })
    response = requests.json()
    return response
