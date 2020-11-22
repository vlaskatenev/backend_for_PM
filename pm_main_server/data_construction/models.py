from django.db import models


class LogsInstallationSoft(models.Model):
    """
    Основной лог установки софта

    LogsInstallationSoft.objects.create(date_time=timezone.now(), 
    id_install=LogsInstallationSoft.objects.order_by('-pk')[0].id_install + 1, 
    startnumber=1, 
    computer_name='comp1', 
    program_id=Soft.objects.get(pk=1),
    events_id=5, 
    result_work=False)
    """
    
    date_time = models.DateTimeField()
    startnumber = models.IntegerField(verbose_name='startnumber')
    computer_name = models.CharField(verbose_name='computer_name', max_length=32)
    program_id = models.ForeignKey('Soft', on_delete=models.PROTECT, verbose_name='program_id')
    EVENT_TYPES = (
        (1, 'finded in AD'),
        (2, 'NOT finded in AD'),
        (3, 'have in computer'),
        (4, 'soft installed'),
        (5, 'work completed'),
        (6, 'task sent to functional_server')
    )
    events_id = models.IntegerField(verbose_name='events_id', choices=EVENT_TYPES)
    result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)


class Soft(models.Model):
    """
    Модель с параметрами софта необходимыми для установки программы.\n
    Soft.objects.create(proc_name='ChromeStandaloneSetup', \n
    short_program_name='GoogleChrome', \n
    proc_description='Google Update Setup', \n
    program_name='Google Chrome', \n
    program_file='ChromeStandaloneSetup.exe', \n
    key_string='', \n
    zip=False, \n
    archive='', \n
    distribute_name='ChromeStandaloneSetup.exe', \n
    program_shortcut='Google Chrome.lnk', \n
    drive_letter='C', \n
    path_to_setup='Setup')
    """
    
    proc_name = models.CharField(verbose_name='proc_name', max_length=128)
    short_program_name = models.CharField(verbose_name='short_program_name', max_length=128)
    proc_description = models.CharField(verbose_name='proc_description', max_length=128)
    program_name = models.CharField(verbose_name='program_name', max_length=128)
    program_file = models.CharField(verbose_name='program_file', max_length=128)
    key_string = models.CharField(verbose_name='key_string', max_length=128)
    zip = models.BooleanField(verbose_name='zip')
    archive = models.CharField(verbose_name='archive', max_length=128)
    distribute_name = models.CharField(verbose_name='distribute_name', max_length=128)
    program_shortcut = models.CharField(verbose_name='program_shortcut', max_length=128)
    drive_letter = models.CharField(verbose_name='drive_letter', max_length=128)
    path_to_setup = models.CharField(verbose_name='path_to_setup', max_length=128)



