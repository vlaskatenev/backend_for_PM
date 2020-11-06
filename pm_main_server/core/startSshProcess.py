import subprocess


# for python 3.6.8
def start_ssh_process(command):
    result = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    return (result.communicate()[0]).decode('utf-8')

def check_host(host_ip):
    array_check = [
        f"ping -c 1 {host_ip} &> /dev/null; echo $?",
        f"nc -zv {host_ip} 22 &> /dev/null; echo $?",
        f"ssh user@{host_ip} -i ../id_rsa exit &> /dev/null; echo $?"
    ]
    for check in array_check:
        result = start_ssh_process(check)
        if result == '255\n':
            return False
    return True