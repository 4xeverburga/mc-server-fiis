# centos is dead :C
# paper server uses at least java sdk 17
# eclipse build will give us at least java 21 / ubuntu
# i'll use python for some scripts. If there's a dependency conflict you can blame me here
ARG ARCH=amd64
# stage 1
FROM --platform=linux/${ARCH} eclipse-temurin:latest

WORKDIR /app
COPY minecraft-config/ ./
COPY plugins/ plugins/
COPY world/ world/
# source of scripts for this image
COPY scripts/container /app

RUN apt update

# tools
RUN apt install -y wget

# mc server dependencies
RUN apt install -y udev

# NOTE: exact version is not that important
# python from apt
RUN apt install python-is-python3

RUN apt install sqlite3

# minecraft v1.21
# v1.21 paper
RUN wget -O server.jar https://api.papermc.io/v2/projects/paper/versions/1.21/builds/123/downloads/paper-1.21-123.jar

EXPOSE 25565

