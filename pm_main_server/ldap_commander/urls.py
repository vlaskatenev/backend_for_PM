from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^list-computers$', views.AllComputersFromAD.as_view()),
    url(r'^find-computer-in-ad$', views.FindComputerInAD.as_view()),
]