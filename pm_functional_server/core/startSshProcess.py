import subprocess


# for python 3.6.8
def start_process_on_device(command: str) -> str:
    """ The function starts a process in the OS using python """
    result = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    return (result.communicate()[0]).decode('utf-8')

def check_host(host_ip: str) -> bool:
    """ 
        The function checks the availability of the device by ping,
        open port 22 and makes a test input by ssh
    """
    array_check = [
        f"ping -c 1 {host_ip} &> /dev/null; echo $?",
        f"nc -zv {host_ip} 22 &> /dev/null; echo $?",
        f"ssh user@{host_ip} -i /usr/src/id_rsa exit &> /dev/null; echo $?"
    ]
    for check in array_check:
        result = start_process_on_device(check)
        if result != '0\n':
            return False
    return True