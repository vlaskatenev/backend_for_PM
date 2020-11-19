from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.Manually.as_view()),
    url(r'^history$', views.History.as_view()),
    # url(r'^running_process$', views.RunningProcess.as_view()),
    url(r'^show-programm-list$', views.ShowProgrammList.as_view()),
    url(r'^start-install$', views.StartInstall.as_view()),
    url(r'^history-detail$', views.HistoryDetail.as_view()),
]