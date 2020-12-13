from django.db import models


class ResultWork(models.Model):
    id_install = models.IntegerField(verbose_name='id_install')
    result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)
    computer_name = models.CharField(verbose_name='computer_name', default='none_name', max_length=32)
    distinguished_name = models.CharField(verbose_name='distinguished_name', default='none', max_length=200)
    program_name = models.CharField(verbose_name='program_name', default='none_name', max_length=32)
    program_id = models.IntegerField(verbose_name='program_id', default=0)
    events_id=models.IntegerField(verbose_name='events_id', default=10)
    status_code=models.BooleanField(verbose_name='status_code', default=False)


class ResultWorkForTaskManager(models.Model):
   id_install = models.IntegerField(verbose_name='id_install')
   result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)
