FROM	ubuntu:22.04
ARG     DEFAULT_USER
# avoid kb questions 
ARG	    DEBIAN_FRONTEND=noninteractive

#       python version
ARG     PY_VER=3.11

#       set timezone
ENV	    TZ=Europe/Helsinki
RUN	    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# basic dev SW
RUN	    apt-get -y update && apt-get -y install build-essential software-properties-common 

# basic tools
RUN	    apt-get -y install git nano vim unzip curl wget jq openssl libssl-dev procps file xz-utils
RUN     apt-get -y install ninja-build
RUN     apt-get -y install clang llvm

# python
RUN	    add-apt-repository ppa:deadsnakes/ppa && apt-get update
RUN	    apt-get -y install python${PY_VER} python${PY_VER}-dev
RUN	    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PY_VER} 1
#RUN	    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
#RUN	    update-alternatives --set python3 /usr/bin/python3.8


# cmake
RUN     curl -sSL https://github.com/Kitware/CMake/releases/download/v3.27.2/cmake-3.27.2-linux-x86_64.sh -o /tmp/cmake.sh
RUN     chmod a+x /tmp/cmake.sh && mkdir /usr/local/bin/cmake3.27
RUN     /tmp/cmake.sh --skip-license --prefix=/usr/local/bin/cmake3.27 && ln -s /usr/local/bin/cmake3.27/bin/* /usr/bin


# pip
RUN     apt-get -y install python3-distutils python3-virtualenv
#RUN     curl -sS https://bootstrap.pypa.io/get-pip.py | python3.8
RUN     curl -sS https://bootstrap.pypa.io/get-pip.py | python${PY_VER}

# emscripten
RUN   mkdir -p /opt/src \
        && cd /opt/src \ 
        && git clone https://github.com/emscripten-core/emsdk.git \
        && cd emsdk \
        && ./emsdk install latest \
        && chmod -R a+rwX ../emsdk 
       
# install sudo
RUN	    apt-get -y install sudo

# install me as a user
RUN	    useradd -ms /bin/bash $DEFAULT_USER
RUN	    addgroup docker
RUN     usermod -aG docker $DEFAULT_USER
RUN	    usermod -aG sudo $DEFAULT_USER
RUN	    echo "$DEFAULT_USER:docker" | chpasswd
RUN     echo 'pushd /opt/src/emsdk && ./emsdk install latest && ./emsdk activate latest && source ./emsdk_env.sh && popd' >> /home/${DEFAULT_USER}/.bashrc
RUN     echo 'export EM_CONFIG=$HOME/development/.emscripten' >> /home/${DEFAULT_USER}/.bashrc
RUN     echo 'if [ ! -f $HOME/development/.emscripten ]; then\n emcc --generate-config\nfi' >> /home/${DEFAULT_USER}/.bashrc



USER    $DEFAULT_USER

# start in bash
ENTRYPOINT cd && /bin/bash






