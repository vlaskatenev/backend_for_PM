# Backend project for PM

The project is implemented as an API interface for working 
with [frontend_for_PM](https://github.com/vlaskatenev/frontend_for_PM). 

This is backend apps content is: 
- NGINX in Docker
- Django
- DRF
- Celery
- Flower
- MySQL

Requirements - Docker.

Spin up the containers:

```sh
$ docker-compose up -d --build
```

Import dump sql to MySQL in Docker container:

```sh
$ docker exec -i <id container> mysql -uroot -p1234 db_logs12 < mysql/dump_db_logs12.sql
```
