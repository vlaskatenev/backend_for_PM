from core.MySQLWrite import read_sql_array, read_sql_string
from rest_api.for_views.Global.sql_pure_functions_global_api import to_compname_by_id, \
    to_start_install_date_time
from rest_api.for_views.HistoryDetail.sql_pure_functions__historydetail import \
    to_select_program_id_from_log, to_time_worked, to_status_install, query_log_history_detail, \
    to_select_shortprogramname
from rest_api.for_views.HistoryDetail.variables_historydetail import status_dict


def create_object_history_detail(id_install):
    programm = read_sql_array(to_select_program_id_from_log(id_install))

    return dict(
        data=[
            {
                'id_install': id_install,
                'programm': programm,
                'computername': read_sql_string(to_compname_by_id(id_install)),
                'date_start': read_sql_string(to_start_install_date_time(id_install)),
                'install_time': read_sql_string(to_time_worked(id_install)),
                'status': {i: status_dict[read_sql_string(to_status_install(id_install, i))] for i in programm}
            },
            {
                'events_array': read_sql_array(query_log_history_detail(id_install))
            },
            {
                'prog_name_dict': {i: read_sql_string(to_select_shortprogramname(i)) for i in programm}
            }
        ]
    )