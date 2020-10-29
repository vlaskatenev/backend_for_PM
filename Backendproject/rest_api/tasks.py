import json

from celery import shared_task
from core.startSshProcess import start_ssh_process


@shared_task()
def start_command_to_task_manager(data):
    #ssh user @ 192.168.0.2 - i "./id_rsa" 'C:\Setup\avarageAllProcessData.ps1'
    command = f"ssh user@{data['hostIp']} -i '/usr/src/app/id_rsa' 'C:\Setup\{data['scriptName']}'"
    return json.loads(start_ssh_process(command))
