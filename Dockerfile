FROM ubuntu:latest
ENV DOCKER_RUN=true
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install git lua5.3 ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
RUN git clone --branch release-0.8 https://github.com/neovim/neovim
RUN cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
RUN cd neovim && make install
WORKDIR /sigma
COPY quick_start.lua /sigma
# ENTRYPOINT ["lua /sigma/quick_start.lua"]

