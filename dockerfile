# centos is dead :C
# NOTE: the host machine uses arm64
# java 21 / ubuntu
FROM --platform=linux/amd64 amd64/eclipse-temurin:latest

WORKDIR /app
COPY minecraft-config/ ./
COPY plugins/ plugins/

RUN apt update
RUN apt install -y wget
RUN apt install -y udev
# minecraft v1.21
# RUN wget https://piston-data.mojang.com/v1/objects/450698d1863ab5180c25d7c804ef0fe6369dd1ba/server.jar
# v1.21 paper
RUN wget https://api.papermc.io/v2/projects/paper/versions/1.21/builds/123/downloads/paper-1.21-123.jar

EXPOSE 25565
# we will config this in the host machine
CMD []