def to_select_program_id_from_log(id):
    return f"SELECT DISTINCT program_name FROM main_log WHERE startnumber={id} AND program_name IS NOT NULL"


def to_select_shortprogramname(id):
    return f"SELECT shortprogramname FROM program_var WHERE var_id={id}"


# делаем запрос о статусе установки программы
def to_status_install(id_install, i):
    return "WITH \n \
                              tablle AS \n\
                              -- Если софт установлен \n \
                              (SELECT \n \
                              IFNULL((SELECT DISTINCT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + "\n \
                              AND \n \
                              EXISTS (SELECT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " AND events_id = 2 LIMIT 1) \n \
                              AND \n \
                              (EXISTS (SELECT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " AND events_id = 8 LIMIT 1) \n \
                              OR \n\
                              EXISTS (SELECT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " AND events_id = 9 LIMIT 1))), 0) statusss \n\
                              UNION ALL \n\
                              -- было установлено \n\
                              SELECT \n\
                              IFNULL((SELECT DISTINCT 4 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " \n\
                              AND \n\
                              NOT EXISTS (SELECT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " AND events_id = 2 LIMIT 1) \n\
                              AND \n\
                              (EXISTS (SELECT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " AND events_id = 8 LIMIT 1) \
                              OR \n\
                              EXISTS (SELECT 1 FROM main_log WHERE startnumber = " + str(
                id_install) + " AND program_name = " + str(i) + " AND events_id = 9 LIMIT 1))), 0)) \n\
                              SELECT SUM(statusss) FROM tablle"


def query_log_history_detail(id):
    return f"SELECT  CONCAT(IFNULL(main_log.date_time, ''), ' ', \
             IFNULL(main_log.ComputerName, ''), ' ', \
             IFNULL(program_var.programname, ''), ' ', \
             IFNULL(script_files.script_name, ''), ' ', \
             IFNULL(events.events_name, '')) AS name \
             FROM main_log LEFT JOIN program_var \
             ON main_log.program_name = program_var.var_id LEFT JOIN events \
             ON main_log.events_id = events.events_id LEFT JOIN script_files \
             ON main_log.script_id = script_files.script_id \
             WHERE startnumber={id};"


# считаем время работы
def to_time_worked(id):
    return f"SELECT \
             ROUND(((SELECT UNIX_TIMESTAMP(date_time) AS seconds \
             FROM main_log WHERE startnumber={id} ORDER BY main_id DESC LIMIT 1) - \
             (SELECT UNIX_TIMESTAMP(date_time) AS seconds \
             FROM main_log WHERE startnumber={id} ORDER BY main_id LIMIT 1))/60) as 'time'"