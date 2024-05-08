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

PLATFORM=$(uname)
UNIX=1
if [[ ! "$PLATFORM" == 'Linux' ||  "$PLATFORM" == 'FreeBSD' ]]; then
	echo "Not a *NIX, falls to Desktop Docker with cli"
	ENGINE=0
	MODE="cli"
	UNIX=0
fi

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

mkdir -p development

if [[ $MODE == "gui" ]]; then
	docker run --privileged -it --rm --name $IMAGE_NAME-$MODE --volume $SHARE:$SHARED -v $HOME/.Xauthority:$HOME/.Xauthority --net=host -e DISPLAY=$DISPLAY $IMAGE_NAME:$MODE
fi

if [[ $MODE == "cli" ]]; then
	docker run -it --rm --name $IMAGE_NAME-$MODE --volume $SHARE:$SHARED $IMAGE_NAME:$MODE
fi

