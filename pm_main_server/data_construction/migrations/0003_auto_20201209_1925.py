# Generated by Django 3.1.3 on 2020-12-09 19:25

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('data_construction', '0002_auto_20201126_2114'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='soft',
            name='archive',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='distribute_name',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='drive_letter',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='path_to_setup',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='proc_description',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='proc_name',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='program_name',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='program_shortcut',
        ),
        migrations.RemoveField(
            model_name='soft',
            name='zip',
        ),
        migrations.AddField(
            model_name='soft',
            name='soft_display_name',
            field=models.CharField(default='none', max_length=128, verbose_name='soft_display_name'),
        ),
        migrations.AddField(
            model_name='soft',
            name='url_to_programm_file',
            field=models.CharField(default='none', max_length=128, verbose_name='url_to_programm_file'),
        ),
        migrations.AlterField(
            model_name='soft',
            name='key_string',
            field=models.CharField(default='none', max_length=128, verbose_name='key_string'),
        ),
        migrations.AlterField(
            model_name='soft',
            name='program_file',
            field=models.CharField(default='none', max_length=128, verbose_name='program_file'),
        ),
        migrations.AlterField(
            model_name='soft',
            name='short_program_name',
            field=models.CharField(default='none', max_length=128, verbose_name='short_program_name'),
        ),
    ]
