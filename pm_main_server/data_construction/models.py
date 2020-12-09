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
    Soft.objects.create(short_program_name='notepad', \n
    soft_display_name='Notepad++ (64-bit x64)', \n
    program_file='npp.7.9.1.Installer.x64.exe', \n
    key_string='/S', \n
    url_to_programm_file='http://192.168.10.1:8081/scripts/npp.7.9.1.Installer.x64.exe')
    """

    short_program_name = models.CharField(verbose_name='short_program_name', default='none', max_length=128)
    soft_display_name = models.CharField(verbose_name='soft_display_name', default='none', max_length=128)
    program_file = models.CharField(verbose_name='program_file', default='none', max_length=128)
    key_string = models.CharField(verbose_name='key_string', default='none', max_length=128)
    url_to_programm_file = models.CharField(verbose_name='url_to_programm_file', default='none', max_length=128)




