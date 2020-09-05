import subprocess
from time import sleep
from importlib import import_module

# все модули прописанные в этом файле -  находятся в папке .\core
MySQLWrite = import_module("core.MySQLWrite").Mysql()


class Powershell:
    # функция только создает файл с именем значения переменной maxstartnumber
    # вызывается в функции refresh_status
    def create_file_sturtnumbder(self, maxstartnumber):
        path = ".\\rest_api\\config\\filesstartnumber\\" + str(maxstartnumber)
        # создание файла
        file = open(path, 'tw', encoding='utf-8')
        file.close()

    # Функция запускает в PowerShell скрипт _startInstall.ps1
    def powershell_start(self, computer, progarray1, wait_number):
        ipaddressHost = ""
        fullzapros = "SELECT MAX(startnumber) AS newstartnumber FROM main_log;"
        maxstartnumber = MySQLWrite.mysql_qery_one_string(fullzapros) + wait_number
        # начало цикла
        # запись в sql
        fieldsinmain_log = ""
        fields = ""
        events_id = "49"
        MySQLWrite.MySQLWrite(maxstartnumber, computer, ipaddressHost, fieldsinmain_log, fields, events_id)
        # переменная нужна для замерера уже запущенных процессов установки софта
        prog_array_temp = []

        for i in progarray1:
            prog_array_temp.append(i)
        progarray = "s".join(map(str, prog_array_temp))
        zapros = 'powershell.exe -noexit -ExecutionPolicy Bypass -File .\\rest_api\\config\\_startInstall.ps1 {} {} {}'
        subprocess.Popen(zapros.format(computer, progarray, maxstartnumber), shell=True,
                             stdout=subprocess.PIPE)

        # анализирует БД записано ли имя ПК, создание файла maxstartnumber не начнется пока эта первой записи не будет
        wait_startnumber = 0
        while wait_startnumber == 0:
            query = "SELECT EXISTS(SELECT events_id FROM main_log WHERE startnumber={} AND events_id=51);"
            query = query.format(maxstartnumber)
            wait_startnumber = MySQLWrite.mysql_qery_one_string(query)
            sleep(1)

        # создание файла maxstartnumber
        self.create_file_sturtnumbder(maxstartnumber)

