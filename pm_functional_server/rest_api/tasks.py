import json
from celery import shared_task
from core.startSshProcess import start_process_on_device, check_host


@shared_task
def get_data_for_task_manager(data: dict) -> dict:
    """ We receive data to form a state about the operation of a remote device.
    Example: ssh user@192.168.10.3 -i /usr/src/id_rsa 'C:\\Setup\\avarageAllProcessData.ps1' """
    if check_host(data['hostIp']):
        command = f"ssh user@{data['hostIp']} -i ../id_rsa 'C:\Setup\{data['scriptName']}'"
        dict_from_device = check_response_from_device(start_process_on_device(command))
        if dict_from_device["stringFromDevice"] == "correct": 
            dict_from_device["resultRequest"] = True
            return dict_from_device
    return dict(resultRequest=False)


def check_response_from_device(response: str) -> dict:
    string_response = response.strip()
    if string_response[0] == '{' and  string_response[-1] == '}':
        json_string = json.dumps(string_response)
        # пока не понимаю зачем использовать 2 раза json.loads, но так возвращается объект dict
        dict_obj = json.loads(json_string)
        dict_obj2 = json.loads(dict_obj)
        dict_obj2["stringFromDevice"] = "correct"
        return dict_obj2
    return dict(stringFromDevice='incorrect')
