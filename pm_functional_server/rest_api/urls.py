from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'functional/insert-work-data$', views.InsertWorkData.as_view()),
    url(r'functional/select-work-data$', views.SelectWorkData.as_view()),
    url(r'functional/start-command-tm$', views.StartCommandTaskManager.as_view()),
    url(r'functional/get-status-process$', views.GetStatusCelery.as_view()),
    url(r'functional/create-scripts-for-client$', views.CreateScriptsForClient.as_view()),
]