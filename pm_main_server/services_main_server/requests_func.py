import requests
from services_main_server.variables import authorization_token

def request_post(url, obj):
    response = requests.post(url,
                   json={'data': obj},
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': authorization_token
                })
    response_object = response.json()      
    return response_object


# get запрос для получения данных об завершенных установках
def request_get(url):
    response = requests.get(url,
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': authorization_token
                })
    response_object = response.json()
    return response_object
