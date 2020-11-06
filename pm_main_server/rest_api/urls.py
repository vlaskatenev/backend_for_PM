from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^$', views.Manually.as_view()),
    url(r'^history$', views.History.as_view()),
    url(r'^running_process$', views.RunningProcess.as_view()),
    url(r'^manually$', views.Manually.as_view()),
    url(r'^choice_programm/program$', views.StartInstall.as_view()),
    url(r'^history-detail$', views.HistoryDetail.as_view()),
    url(r'^start-command-tm$', views.StartCommandTaskManager.as_view()),
    url(r'^get-status-process$', views.GetStatusCelery.as_view()),

]