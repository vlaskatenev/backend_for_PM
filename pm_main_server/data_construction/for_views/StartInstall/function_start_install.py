import requests
from django.http import JsonResponse

def request_json_to_functional_server(data: list) -> dict:
    """Формируем запрос для сервера functional_server для добавления компа в группу и формированя скриптов для установки софта"""
    response = requests.post('http://functional-server:8000/functional/create-scripts-for-client',
                   json={'data': data},
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': 'Token 6845ceea30ebdfd038a0e45324c90d4003803ea8'
                })
    return response.json()
