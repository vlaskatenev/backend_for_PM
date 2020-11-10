from datetime import datetime

from data_construction.for_views.Global.sql_pure_functions_global_api import query_startnumber_on_date
from services_main_server import MySQLWrite


def choise_install(date_from_form):
    date_str = datetime.strptime(date_from_form, '%Y-%m-%d').strftime('%Y%m%d')
    id_install = to_query_check_day(date_str)
    return id_install


def to_query_check_day(check_day):
    query = query_startnumber_on_date(check_day)
    startnumbers = MySQLWrite.Mysql().mysql_query_array(query)
    return startnumbers