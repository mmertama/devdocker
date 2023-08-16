# devdocker
Docker containers for software development

Usage:
* Install a Docker engine (Docker Desktop is not working with gui apps as we speak)
* Clone (or copy) devdocker - possibly rename (the docker image name is based on folder name, i.e. default devdocker).
* $ ./run.sh [cli|gui] build  - cli for command line only, gui for Ui.
* First time may take long (and asks createntials for docker).
* Afterwards build is optional (needed only if Dockerfiles are modified).
* run.sh maps a _development_ folder into Docker container (devdocker/development is created). That is for persistent data.
* The container opens and ther in your homefolder you can find a _development_ folder.
* E.g.
```bash
    $ ./run.sh gui build  
    $ cd development
    $ git clone https://github.com/mmertama/Gempyre.git
    $ cd Gempyre
    $ ./linux_install.sh 
```
