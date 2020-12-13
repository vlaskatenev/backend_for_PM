from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^list-computers$', views.AllComputersFromAD.as_view()),
    # url(r'^add-computer-in-ad-group$', views.AddComputerInADGroup.as_view()),
]