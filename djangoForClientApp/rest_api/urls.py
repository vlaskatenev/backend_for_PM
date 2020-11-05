from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'forclient/insert-work-data', views.InsertWorkData.as_view()),
    url(r'forclient/select-work-data', views.SelectWorkData.as_view()),
]