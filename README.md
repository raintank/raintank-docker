raintank-docker screen based dev environment
============================================

To provision a full dev stack using docker:

- install docker - https://docs.docker.com/installation/#installation
- install docker-compose - http://docs.docker.com/compose/install/
- clone this git repo.
- cd in the dir and run './build_all.sh'.  This will build all of the raintank images.
- alteratively, run './build_all.sh rebuild' to force a rebuild of all raintank images (but keeping base images such as ubuntu etc)
- you can use custom versions of required code by going into raintank_code, removing a dir like grafana and making a symlink like `ln -s </path/to/grafana> .`
  In this case, make sure to add a `.notouch` file so that setup_dev.sh doesn't try to manage the code there.
- run `./setup_dev.sh` to download all of the raintank components.  The script will launch a docker container and clone the git repositories of all of the raintank components.  Once the script has completed, the docker host server will have a /opt/raintank directory that will have all of the raintank code and dependencies installed.
- run `./launch_dev.sh` to start up all of the docker containers.  This script will start the containers in interactive mode, attached to a screen session.  Instead of using the code baked into the image, the container will instead execute what is installed in /opt/raintank on the docker host.  As all containers are sharing the same /opt/raintank directory, any changes made to the /opt/raintank/* code while inside a container will be visible in all other containers.
- attach to the screen session with 'screen -r raintank'.  To navigate between all of the screen windows press 'CTRL-a then "' (double quote).  This will provide the list of windows running, use the arrow keys to select the desired window then press enter.


for your convenience, this code may be all you need (tested on ubuntu 14.04)

```
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

git clone git@github.com:raintank/raintank-docker.git
cd raintank-docker
./build_all.sh
./setup.sh
./launch_dev.sh
```

- connect to your new install in a broswer using at http://localhost/.  The default user is 'admin' and the default password is 'admin'


Switching branches
==================
in a new raintank-docker branch, you can just run `/build_all.sh`, which updates the "latest" images.
If your latest images have been overridden by being in a different branch, `./restore_branch_images.sh` will sync up the latest tags to the images you last generated on this branch.
