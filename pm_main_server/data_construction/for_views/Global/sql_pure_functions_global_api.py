def to_compname_by_id(number):
    return f"SELECT DISTINCT ComputerName FROM main_log  \
             WHERE startnumber={number} AND ComputerName IS NOT NULL LIMIT 1;"


def query_log_information(id):
    return f"SELECT CONCAT(IFNULL(program_var.programname, ''), ' ', \
             IFNULL(script_files.script_name, ''), ' ', \
             IFNULL(events.events_name, '')) AS name from main_log LEFT JOIN program_var \
             ON main_log.program_name = program_var.var_id LEFT JOIN events \
             ON main_log.events_id = events.events_id LEFT JOIN script_files \
             ON main_log.script_id = script_files.script_id WHERE startnumber = {id} \
             ORDER BY main_log.main_id DESC LIMIT 1;"


def to_start_install_date_time(id):
    return f"SELECT DATE_FORMAT(date_time,GET_FORMAT(DATETIME,'ISO')) FROM main_log \
             WHERE startnumber={id} ORDER BY main_id LIMIT 1;"


# формируем статус по каждой программе
def to_select_program_name(id):
    return f"SELECT DISTINCT b.programname FROM main_log a JOIN program_var b \
            ON a.program_name = b.var_id \
            WHERE a.startnumber={id} AND a.program_name IS NOT NULL"


def query_startnumber_on_date(date):
    return f"select distinct startnumber from main_log \
             WHERE date_time > '{date}' \
             AND date_time < (SELECT DATE_ADD('{date}', INTERVAL 1 DAY));"
