from django.http import JsonResponse
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from datetime import datetime
from .models import ResultWork
from rest_framework import generics
from .serializers import ResultWorkDetailSerializer


# example json for post method
# {
#     "date": "2020-11-5T21:35:48.118055Z",
#     "id_install": 255777,
#     "result_work": false
# }
class InsertWorkData(generics.CreateAPIView):
    permission_classes = (IsAuthenticated,)

    serializer_class = ResultWorkDetailSerializer


# get request for all data
class SelectWorkData(generics.ListCreateAPIView):
    permission_classes = (IsAuthenticated,)

    serializer_class = ResultWorkDetailSerializer

    queryset = ResultWork.objects.filter(id_install=255777)



