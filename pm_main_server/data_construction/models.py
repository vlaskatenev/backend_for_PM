from django.db import models


class LogsInstallationSoft(models.Model):
    """Основной лог установки софта"""
    
    date_time = models.DateTimeField()
    id_install = models.IntegerField(verbose_name='id_install')
    startnumber = models.IntegerField(verbose_name='startnumber')
    ComputerName = models.IntegerField(verbose_name='ComputerName')
    program_id = models.ForeignKey(Soft)
    EVENT_TYPES = (
        (1, 'Седан'),
        (2, 'Хэчбек'),
        (3, 'Универсал'),
        (4, 'Купе')
    )  
    events_id = models.IntegerField(verbose_name='events_id', choices=EVENT_TYPES)
    result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)


class Soft(models.Model):
    """Модель с параметрами софта необходимыми для установки программы"""

	proc_name = models.IntegerField(verbose_name='proc_name')
	short_program_name = models.IntegerField(verbose_name='short_program_name')
	proc_description = models.IntegerField(verbose_name='proc_description')
	program_name = models.IntegerField(verbose_name='program_name')
	program_file = models.IntegerField(verbose_name='program_file')
	key_string = models.IntegerField(verbose_name='zip')
	zip = models.IntegerField(verbose_name='ComputerName')
	archive = models.IntegerField(verbose_name='archive')
	distribute_name = models.IntegerField(verbose_name='distribute_name')
	program_shortcut = models.IntegerField(verbose_name='program_shortcut')
	drive_letter = models.IntegerField(verbose_name='drive_letter')
	path_to_setup = models.IntegerField(verbose_name='path_to_setup')
