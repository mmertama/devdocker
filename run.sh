#!/bin/bash

set -e

BUILD=0
MODE="gui"
ENGINE=1
DOCKER_USER=$USER
IMAGE_NAME=$(basename "$(pwd)")


if [[ $DOCKER_USER == "root" ]]; then
	DOCKER_USER=$SUDO_USER
fi

while (( "$#" )); do
	if [[ $1 == "cli" ]]; then
		MODE="cli"	
	fi
	if [[ $1 == "gui" ]]; then
		MODE="gui"	
	fi
	if [[ $1 == "build" ]]; then
		BUILD=1	
	fi
	if [[ $1 == "engine" ]]; then
		ENGINE=1	
	fi
	if [[ $1 == "desktop" ]]; then
		ENGINE=0	
	fi
	shift
done

SHARE=$(pwd)/development
SHARED=/home/$DOCKER_USER/$(basename $SHARE)
echo share "$SHARE" as "$SHARED"

if (( $ENGINE == 0)); then
	echo "WARNING:  For Docker Desktop the shared folder has to have a+rw permissions"
	if [[ $MODE == "gui" ]]; then
		echo "ERROR: For Docker Desktop the GUI is not working (TODO, I havent found a way - not even x11docker is not supporting - maybe not possoble)"
		exit 1
	fi	
fi	

if (( $BUILD )); then
	if [[ $MODE == "cli" ]]; then
		pushd cli
	fi

	if [[ $MODE == "gui" ]]; then
		pushd gui
	fi

	echo set user as $DOCKER_USER

	if (( $ENGINE )); then
		sudo docker buildx build --build-arg DEFAULT_USER=$DOCKER_USER -t $IMAGE_NAME:$MODE .
	else
		docker build --build-arg DEFAULT_USER=$DOCKER_USER -t $IMAGE_NAME:$MODE .
	fi	
	popd
fi

#dock_gid=1024
#dock_g_name=$(getent group "$dock_gid" | cut -d: -f1)

#if [ -z "$dock_g_name" ]; then
#    	sudo addgroup --gid 1024  dock_dev
#fi

#if ! groups "$USER" | grep &>/dev/null "\bdock_dev\b"; then
#	sudo usermod -aG dock_dev $USER
#fi


mkdir -p development
#if [[ $(stat -c %g development) != "$dock_gid" ]]; then
#    	sudo chown :docker development
#fi

#if [[ $USER!="root" ]]; then
#	dev_p=$(stat -c '%a' development)
#	chmod a+rw development
#fi	

#MYADDR=$(ip route get 8.8.8.8 | sed -n '/src/{s/.*src *\([^ ]*\).*/\1/p;q}')
#x11docker --name devdocker -v $(pwd)/development:/home/$USER/development  devdocker
#xhost +
#docker run -it --rm --user $(id -u):$(id -g) --name devdocker --volume $(pwd)/development:/home/$USER/development devdocker
#docker run -it --rm -v $HOME/.Xauthority:$HOME/.Xauthority --net=host -e DISPLAY=$MYADDR$DISPLAY --name devdocker --volume $(pwd)/development:/home/$USER/development  devdocker

if [[ $MODE == "gui" ]]; then
	docker run --privileged -it --rm --name $IMAGE_NAME-$MODE --volume $SHARE:$SHARED -v $HOME/.Xauthority:$HOME/.Xauthority --net=host -e DISPLAY=$DISPLAY $IMAGE_NAME:$MODE
	# x11docker --desktop --debug --hostdisplay --size=1280x1024 devdocker_$MODE:basic
	#--name devdocker_$MODE -v $(pwd)/development:/home/$USER/development devdocker_$MODE
fi

if [[ $MODE == "cli" ]]; then
	docker run -it --rm --name $IMAGE_NAME-$MODE --volume $SHARE:$SHARED $IMAGE_NAME:$MODE
fi

#docker exec --user root devdocker chown :dock_dev /home/$USER/development
#docker exec --user root devdocker chgrp dock_dev /home/$USER/development
#xhost -

#if [[ $USER!="root" ]]; then
#	chmod $dev_p development
#fi

#docker exec -it devdocker lsattr /home/markus/development
#docker attach devdocker
#docker stop devdocker
#docker rm -f devdocker
