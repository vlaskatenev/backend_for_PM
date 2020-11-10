import mysql.connector

from services_main_server.Access.access_data import user_val, password_val, database_val


class Mysql:
    def __init__(self):
        self.user_val, self.password_val, self.database_val = user_val, password_val, database_val
        self.host = 'db-main'
        self.port = '3306'

    # переменные для доступа в MySQL БД. Возвращает эти переменные чтобы их можно было спользовать в других функциях
    # имя пользователя, пароль и имя БД меняется только в этой функции. В других местах менять не нужно
    def connect_values_mysql(self):
        return self.user_val, self.password_val, self.database_val

    # функция принимает аргументы указанные в скобках.
    # функция ничего не выводит, только записывает значения которые находятся в скобках функции в базу данных
    def MySQLWrite(self, maxstartnumber, ComputerName, ipaddressHost, fieldsinmain_log, fields, events_id):
        maxstartnumber1 = maxstartnumber
        ComputerName1 = ComputerName
        ipaddressHost1 = ipaddressHost
        fieldsinmain_log1 = fieldsinmain_log
        fields1 = fields
        events_id1 = events_id

        cnx = mysql.connector.connect(host=self.host, port=self.port, user=self.user_val, password=self.password_val,
                                      database=self.database_val)
        cursor = cnx.cursor()
        zapros = "INSERT INTO main_log (startnumber, date_time, ComputerName, ipaddresshost, {} events_id) \
        VALUES ('{}', NOW(3), '{}', '{}', {} '{}')"
        query = zapros.format(fieldsinmain_log1, maxstartnumber1, ComputerName1, ipaddressHost1, fields1, events_id1)
        cursor.execute(query)
        cnx.commit()

    # выводит произвольный запрос (какой присвоен переменной query)
    def mysql_qery_one_string(self, query):
        cnx = mysql.connector.connect(host=self.host, port=self.port, user=self.user_val, password=self.password_val,
                                      database=self.database_val)
        cursor = cnx.cursor()
        cursor.execute(query)
        for var_id in cursor:
            string = var_id[0]
        return string

    # выполняет произвольный запрос (какой присвоен переменной query), возвращает массив из количества
    # возвращенных строк. Использовать только для запросов где результат будет состоять из больше чем 1 значение
    def mysql_query_array(self, query):
        cnx = mysql.connector.connect(host=self.host, port=self.port, user=self.user_val, password=self.password_val,
                                      database=self.database_val)
        cursor = cnx.cursor()
        cursor.execute(query)
        array = []
        for var_id in cursor:
            array.append(var_id[0])

        return array

    def mysql_insert_qery_one_string(self, query):
        cnx = mysql.connector.connect(host=self.host, port=self.port, user=self.user_val, password=self.password_val,
                                      database=self.database_val)
        cursor = cnx.cursor()
        cursor.execute(query)
        cnx.commit()


def read_sql_string(query):
    return Mysql().mysql_qery_one_string(query)


def read_sql_array(query):
    return Mysql().mysql_query_array(query)
