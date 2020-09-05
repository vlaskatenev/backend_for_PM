# Backend project on Django with DRF 

The project is implemented as an API interface for working with the PM project. 
This is backend apps. 

Spin up the containers:

```sh
$ docker-compose up -d --build
```

Open your browser to http://localhost:8081 to view the app or to http://localhost:5555 to view the Flower dashboard.

Trigger a new task:

```sh
$ curl -F type=0 http://localhost:8081/tasks/
```

Check the status:

```sh
$ curl http://localhost:8081/tasks/<TASK_ID>/
```
