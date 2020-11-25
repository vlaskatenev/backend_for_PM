# сериализатор подключается к БД, выгружает данные, преобразует их в JSON
# и отдает в качестве ответа на запрос

from rest_framework import serializers
from .models import ResultWork, ResultWorkForTaskManager


class ResultWorkDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResultWork
        fields = '__all__'


class ResultWorkForTaskManagerDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = ResultWorkForTaskManager
        fields = '__all__'
