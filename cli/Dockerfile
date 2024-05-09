FROM	ubuntu:22.04
ARG     DEFAULT_USER
# avoid kb questions 
ARG	    DEBIAN_FRONTEND=noninteractive

#       set timezone
ENV	    TZ=Europe/Helsinki
RUN	    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# basic dev SW
RUN	    apt-get -y update && apt-get -y install build-essential software-properties-common 

# basic tools
RUN	    apt-get -y install git nano vim unzip curl wget jq openssl libssl-dev procps file xz-utils
RUN     apt-get -y install ninja-build


# python
#       python version
ARG     PY_VER=3.12
ARG     SYS_PY_VER=3.10
RUN	    add-apt-repository ppa:deadsnakes/ppa && apt-get update
RUN	    apt-get -y install python${PY_VER} python${PY_VER}-dev
RUN	    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PY_VER} 1
RUN	    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${SYS_PY_VER} 2
RUN	    update-alternatives --set python3 /usr/bin/python${SYS_PY_VER}


# cmake
RUN     curl -sSL https://github.com/Kitware/CMake/releases/download/v3.27.2/cmake-3.27.2-linux-x86_64.sh -o /tmp/cmake.sh
RUN     chmod a+x /tmp/cmake.sh && mkdir /usr/local/bin/cmake3.27
RUN     /tmp/cmake.sh --skip-license --prefix=/usr/local/bin/cmake3.27 && ln -s /usr/local/bin/cmake3.27/bin/* /usr/bin


# pip
RUN     apt-get -y install python3-distutils python3-virtualenv
RUN     curl -sS https://bootstrap.pypa.io/get-pip.py | python${SYS_PY_VER}
RUN     curl -sS https://bootstrap.pypa.io/get-pip.py | python${PY_VER}

# clang
ARG     CLANG_VER=19
RUN     wget https://apt.llvm.org/llvm.sh
RUN     chmod u+x llvm.sh && ./llvm.sh ${CLANG_VER} && rm llvm.sh


# emscripten
RUN      apt-get -y install emscripten

# install sudo
RUN	    apt-get -y install sudo

# install me as a user
RUN	    useradd -ms /bin/bash $DEFAULT_USER
RUN	    addgroup docker
RUN     usermod -aG docker $DEFAULT_USER
RUN	    usermod -aG sudo $DEFAULT_USER
RUN	    echo "$DEFAULT_USER:docker" | chpasswd


RUN     echo 'export PATH=/usr/lib/llvm-19/bin:$PATH' >> /home/${DEFAULT_USER}/.bashrc
RUN     echo 'export LLVM_ROOT=/usr/lib/llvm-19/bin'  >> /home/${DEFAULT_USER}/.bashrc

USER    $DEFAULT_USER

# start in bash
ENTRYPOINT cd && /bin/bash






