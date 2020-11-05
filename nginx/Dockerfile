# pull official base image
FROM ubuntu:18.04

RUN apt update && apt install -y nginx
RUN mkdir /usr/src/scripts
RUN mkdir /usr/src/dicstributes
COPY ./default /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
