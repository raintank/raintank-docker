raintank-docker
===============

To provision a full stack using docker:

- install docker - https://docs.docker.com/installation/#installation
- install docker-compose - http://docs.docker.com/compose/install/
- clone this git repo.
- cd in the dir and run './build_all.sh'.  This will build all of the raintank images.
- alteratively, run './build_all.sh rebuild' to force a rebuild of all raintank images (but keeping base images such as ubuntu etc)
- to run as production, user docker-compose to run the containers

for your convenience, here is the appropriate code (tested on ubuntu 14.04)

```
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

git clone git@github.com:raintank/raintank-docker.git
cd raintank-docker
./build_all.sh
docker-compose -f fig-dev.yaml -d  # TODO what command here?
```

- connect to your new install in a broswer using at http://your.ip.address/.  The default user is 'admin' and the default password is 'admin'


Screen based Dev environment
================
- follow instructions above upto build_all.sh.
- run `./setup_dev.sh` to download all of the raintank components.  The script will launch a docker container and clone the git repositories of all of the raintank components.  Once the script has completed, the docker host server will have a /opt/raintank directory that will have all of the raintank code and dependencies installed.
- run `./launch_dev.sh` to start up all of the docker containers.  This script will start the containers in interactive mode, attached to a screen session.  Instead of using the code baked into the image, the container will instead execute what is installed in /opt/raintank on the docker host.  As all containers are sharing the same /opt/raintank directory, any changes made to the /opt/raintank/* code while inside a container will be visible in all other containers.
- attach to the screen session with 'screen -r raintank'.  To navigate between all of the screen windows press 'CTRL-a then "' (double quote).  This will provide the list of windows running, use the arrow keys to select the desired window then press enter.

You can now connect to the install per the instructions above.
