import threading

from core import OLD_powershell as powershell


def create_object_start_install(status):
    return "Установка началась, Choice program " + str(status)


def start_install(data):
    comp_add = data[1]
    progarray = data[0]
    wait_number = 1
    print('progarray', progarray)
    for computer in comp_add:
        # вызываем функцию powershell из файла OLD_powershell.py
        threading.Thread(target=powershell.Powershell().powershell_start, args=[computer, progarray, wait_number]).start()
        wait_number += 1
    print("Установка началась, Choice program " + str(progarray))
    return create_object_start_install(progarray)
