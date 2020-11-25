from django.db import models


class ResultWork(models.Model):
    id_install = models.IntegerField(verbose_name='id_install')
    result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)
    computer_name = models.CharField(verbose_name='computer_name', default='none_name', max_length=32)
    program_name = models.CharField(verbose_name='program_name', default='none_name', max_length=32)
    events_id=models.IntegerField(verbose_name='events_id', default=10)


class ResultWorkForTaskManager(models.Model):
   id_install = models.IntegerField(verbose_name='id_install')
   result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)
