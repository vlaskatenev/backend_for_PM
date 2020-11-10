from django import template
import datetime

register = template.Library()


# tag for visuallized program name from SQL and dictonary
@register.simple_tag(name='name_program')
def name_program(dict, i):
    return dict[i]


@register.simple_tag(name='current_date')
def current_date():
    now = datetime.datetime.now()
    return '20200101' #now.strftime("%Y%d%m")



