from services_main_server.MySQLWrite import read_sql_string, read_sql_array
from data_construction.for_views.Global.sql_pure_functions_global_api import to_compname_by_id, query_log_information, \
    to_start_install_date_time, to_select_program_name


def create_context_log(id_install):
    # формируем массивы для context

    dict_name = [read_sql_string(to_compname_by_id(i)) for i in id_install]
    dict_status = [read_sql_string(query_log_information(i)) for i in id_install]
    dict_date = [read_sql_string(to_start_install_date_time(i)) for i in id_install]
    prog_name = [", ".join(read_sql_array(to_select_program_name(i))) for i in id_install]

    return dict(
        data=[{
            'computerName': dict_name[i],
            'status': dict_status[i],
            'button': '',
            'date': dict_date[i],
            'id': id_install[i]
        } for i in range(len(id_install))]
    )
