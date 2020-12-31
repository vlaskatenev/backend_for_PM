from data_construction.for_views.Manually.manually_sql_variables import query_programname_from_program_var, \
    query_var_id_from_program_var
from services_main_server import MySQLWrite


def choice_program_from_db():
    # значения для этих двух массивов будут браться из SQL
    # смотрим значение у кажой программы programname и добавляем его в список prog_name
    prog_name = MySQLWrite.Mysql().mysql_query_array(query_programname_from_program_var)
    # формируем список программ в окне Установить софт
    prog_id = MySQLWrite.Mysql().mysql_query_array(query_var_id_from_program_var)
    object_programm_and_id = {}
    for n in range(len(prog_id)):
        object_programm_and_id[prog_id[n]] = prog_name[n]
    return prog_id, object_programm_and_id


def create_object_to_choose_programm() -> dict:   
    
    # После выбора ПК из списка или ввода его вручную вызывается эта функция.
    # Формирует список программ - dict_name, номер программы в БД - prog_id и список компьютеров 
    # (в интерфейсе необходим для дальнейшей передачи в виде аргумента для старта установки)
    
    prog_id, dict_name = choice_program_from_db()
    return dict(data=[dict_name])
