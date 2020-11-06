from django.db import models


class ResultWork(models.Model):
    # unique=True запись должна быть уникальная
    # verbose_name='Vin' имя пол в БД
    date = models.DateTimeField()
    id_install = models.IntegerField(verbose_name='id_install')
    result_work = models.BooleanField(verbose_name='result_work', default=False, null=False, blank=False)
