import requests

def request_post(url, obj):
    response = requests.post(url,
                   json={'data': obj},
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': 'Token 6845ceea30ebdfd038a0e45324c90d4003803ea8'
                })
    response_object = response.json()      
    return response_object


# get запрос для получения данных об завершенных установках
def request_get(url):
    response = requests.get(url,
                   headers={
                   'Content-Type': 'application/json',
                   'Authorization': 'Token 6845ceea30ebdfd038a0e45324c90d4003803ea8'
                })
    response_object = response.json()
    return response_object
