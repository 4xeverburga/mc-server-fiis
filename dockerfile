FROM amazonlinux:latest

WORKDIR /app
COPY minecraft-config/ ./
COPY plugins/ plugins/

RUN yum install -y wget
RUN yum install -y udev
RUN yum install -y java-22-amazon-corretto-headless 
# minecraft v1.21
# RUN wget https://piston-data.mojang.com/v1/objects/450698d1863ab5180c25d7c804ef0fe6369dd1ba/server.jar
# v1.21 paper
RUN wget https://api.papermc.io/v2/projects/paper/versions/1.21/builds/123/downloads/paper-1.21-123.jar

EXPOSE 25565
# bash last command
CMD []