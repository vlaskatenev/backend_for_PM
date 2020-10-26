import subprocess


# for python 3.6.8
def start_ssh_process(command):
    result = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
    return result.communicate()[0].decode('utf-8')

