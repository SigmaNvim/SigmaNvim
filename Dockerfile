FROM ubuntu:latest
ENV DOCKER_RUN=true
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install neovim git lua5.3
WORKDIR /sigma
COPY quick_start.lua /sigma
ENTRYPOINT ["lua", "/sigma/quick_start.lua"]

