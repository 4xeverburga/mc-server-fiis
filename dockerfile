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

# world dir will be a volume
RUN mkdir world
# here I will store the passky passwords file i need to bind
RUN mkdir -p plugins/Passky 

# source of scripts for this image
COPY scripts/container/ ./scripts/

RUN apt-get update
RUN bash ./scripts/image-creation/dependencies.bash
RUN bash ./scripts/image-creation/setup-stats-and-supervision.bash

# minecraft v1.21
# v1.21 paper
RUN wget -O server.jar https://api.papermc.io/v2/projects/paper/versions/1.21.1/builds/57/downloads/paper-1.21.1-57.jar

EXPOSE 25565

