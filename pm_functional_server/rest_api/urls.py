from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'functional/insert-work-data', views.InsertWorkData.as_view()),
    url(r'functional/select-work-data', views.SelectWorkData.as_view()),
]