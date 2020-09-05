from rest_api.for_views.Manually.manually_sql_variables import query_programname_from_program_var, \
    query_var_id_from_program_var
from core import MySQLWrite


def choice_program():
    # значения для этих двух массивов будут браться из SQL
    # смотрим значение у кажой программы programname и добавляем его в список prog_name
    prog_name = MySQLWrite.Mysql().mysql_query_array(query_programname_from_program_var)
    # формируем список программ в окне Установить софт
    prog_id = MySQLWrite.Mysql().mysql_query_array(query_var_id_from_program_var)
    dict = {}
    for n in range(len(prog_id)):
        dict[prog_id[n]] = prog_name[n]
    return prog_id, dict


def create_object_manually(comp_name):
    comp_name_array = [comp_name]
    prog_id, dict_name = choice_program()
    return dict(data=[
        {
            'dict': dict_name
        },
        {
            'prog_id': prog_id
        },
        {
            'comp_name1': comp_name_array
        }
    ]
    )
