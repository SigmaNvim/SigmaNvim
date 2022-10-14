FROM ubuntu:22.04
WORKDIR /sigma
ENV DOCKER_RUN=true
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install git lua5.3 ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
RUN git clone --branch release-0.8 https://github.com/neovim/neovim
WORKDIR /sigma/neovim
RUN make CMAKE_BUILD_TYPE=RelWithDebInfo && make install
RUN DEBIAN_FRONTEND=noninteractive apt-get -qq install ripgrep
COPY quick_start.lua /sigma
WORKDIR /root
CMD ["lua", "/sigma/quick_start.lua"]
