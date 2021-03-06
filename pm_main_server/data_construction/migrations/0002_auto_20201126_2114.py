# Generated by Django 3.1.3 on 2020-11-26 21:14

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data_construction', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='logsinstallationsoft',
            name='id_install',
        ),
        migrations.AlterField(
            model_name='logsinstallationsoft',
            name='events_id',
            field=models.IntegerField(choices=[(1, 'finded in AD'), (2, 'NOT finded in AD'), (3, 'have in computer'), (4, 'soft installed'), (5, 'work completed'), (6, 'task sent to functional_server')], verbose_name='events_id'),
        ),
    ]
