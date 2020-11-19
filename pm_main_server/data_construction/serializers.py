# сериализатор подключается к БД, выгружает данные, преобразует их в JSON
# и отдает в качестве ответа на запрос

from rest_framework import serializers
from .models import LogsInstallationSoft


class ResultWorkDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = LogsInstallationSoft
        fields = '__all__'
