import json
from core.startSshProcess import start_ssh_process


# def start_command_to_task_manager(data):
#     host = data['hostIp']
#     script_name = data['scriptName']
#     #ssh user @ 192.168.0.2 - i "./id_rsa" 'C:\Setup\avarageAllProcessData.ps1'
#     command = f"ssh user@{host} -i '/usr/src/app/id_rsa' 'C:\Setup\{script_name}'"
#     return json.loads(start_ssh_process(command))
