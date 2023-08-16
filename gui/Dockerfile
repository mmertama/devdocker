FROM    ubuntu:20.04
ARG     DEFAULT_USER
 
#       python version, MUST be 3.8 for ubuntu 20.04!
ARG     PY_VER=3.8

#       set timezone
ENV	    TZ=Europe/Helsinki
RUN	    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# basic dev SW
RUN	    apt-get -y update && apt-get -y install build-essential software-properties-common 

# basic tools
RUN	    apt-get -y install git nano vim unzip curl wget jq openssl libssl-dev procps file xz-utils

# X 11 apps
RUN     apt-get install -y x11-apps

# cmake
RUN     curl -sSL https://github.com/Kitware/CMake/releases/download/v3.27.2/cmake-3.27.2-linux-x86_64.sh -o /tmp/cmake.sh
RUN     chmod a+x /tmp/cmake.sh && mkdir /usr/local/bin/cmake3.27
RUN     /tmp/cmake.sh --skip-license --prefix=/usr/local/bin/cmake3.27 && ln -s /usr/local/bin/cmake3.27/bin/* /usr/bin

## python from sources
# RUN   apt-get -y install curl xz-utils libffi-dev zlib1g-dev 
# RUN   mkdir -p /opt/src \
#    && cd /opt/src \ 
#    && curl -sSL https://www.python.org/ftp/python/3.11.4/Python-3.11.4.tar.xz -o /opt/src/py_src.tar.xz \
#    && tar -xf py_src.tar.xz \
#    && cd Python-3.11.4 \
#    && ./configure --enable-optimizations --disable-test-modules \
#    && make altinstall 

# latest python from pre-built
#RUN	    add-apt-repository ppa:deadsnakes/ppa && apt-get update
#RUN	    apt-get -y install python${PY_VER} python${PY_VER}-dev

# install python
RUN	    apt-get -y install python3-pip python3-distutils python3-apt python${PY_VER}-distutils

# python ver
#RUN	    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PY_VER} 1
#RUN	    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
#RUN	    update-alternatives --set python3 /usr/bin/python3.8

# pip
#RUN     curl -sS https://bootstrap.pypa.io/get-pip.py | python${PY_VER}
RUN     curl -sS https://bootstrap.pypa.io/get-pip.py | python3

# for pywebview and websockets (Gempyre convenience)

RUN apt-get -y install libgl1-mesa-dev libnss3 libxcomposite-dev libxdamage1 libfontconfig1 libxrender1 libxrandr2 libxcursor-dev \ 
libxi6 libgconf-2-4 libxtst6 libxkbcommon-x11-0
RUN apt-get install -y libcanberra-gtk-module libcanberra-gtk3-module
RUN pip install pyqt5 pyqtwebengine pywebview[qt]

RUN apt-get install -y python3-gi python3-gi-cairo gir1.2-gtk-3.0 gir1.2-webkit2-4.0

RUN     pip install websockets
RUN     pip install setuptools


# For Qt Installer
RUN apt-get install -y libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-shape0 libxcb-xinerama0

# Gempyre-Python using scikit-build for pip
RUN pip install scikit-build


# install sudo
RUN	    apt-get -y install sudo

# homebrew
#RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# default DISPLAY
ENV     DISPLAY=:0

# install me as a user
RUN	useradd -ms /bin/bash $DEFAULT_USER
RUN	addgroup docker
RUN usermod -aG docker $DEFAULT_USER
RUN	usermod -aG sudo $DEFAULT_USER
RUN	echo "$DEFAULT_USER:docker" | chpasswd


USER    $DEFAULT_USER
ENTRYPOINT cd && /bin/bash





