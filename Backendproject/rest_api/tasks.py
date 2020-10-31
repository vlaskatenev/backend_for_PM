import json
from celery import shared_task
from core.startSshProcess import start_ssh_process, check_host


@shared_task
def start_command_to_task_manager(data):
    #ssh user@192.168.10.3 -i "/usr/src/id_rsa" 'C:\Setup\avarageAllProcessData.ps1'
    if check_host(data['hostIp']):
        command = f"ssh user@{data['hostIp']} -i ../id_rsa 'C:\Setup\{data['scriptName']}'"
        json_string = json.dumps(start_ssh_process(command))
        # пока не понимаю зачем использовать 2 раза json.loads, но так возвращается объект dict
        dict_obj = json.loads(json_string)
        dict_obj2 = json.loads(dict_obj)
        dict_obj2["resultRequest"] = True
        return dict_obj2
    else:
        return dict(resultRequest=False)