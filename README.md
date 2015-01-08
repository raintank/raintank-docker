raintank-docker
===============

To provision a full stack using docker:

- install docker
- install fig. http://www.fig.sh/install.html
- clone this git repo.
- cd in the dir and run 'sh build_all.sh'.  This will build all of the raintank images.
- use fig to launch all of the containers. You need to pass the public IP of you docker host in the RAINTANK_siteUrl variable so that things work.
eg. if the IP of your docker host is 192.168.1.1, then run:

RAINTANK_siteUrl="http://192.168.1.1" fig up

- connect to your new install in a broswer using the siteUrl you specified.  The default user is 'admin@localhost' and the default password is 'password'


Screen based Dev environment
================
- install docker
- clone this git repo.
- cd in the dir and run 'sh build_all.sh'.  This will build all of the raintank images.
- run 'bash -c ./setup_dev.sh' to download all of the raintank components.  The script will launch a docker container and clone the git repositories of all of the raintank components.  Once the script has completed, the docker host server will have a /opt/raintank directory that will have all of the raintank code and dependencies installed.
- run 'sh launch_dev.sh' to start up all of the docker containers.  This script will start the containers in interactive mode, attached to a screen session.  Instead of using the code baked into the image, the container will instead execute what is installed in /opt/raintank on the docker host.  As all containers are sharing the same /opt/raintank directory, any changes made to the /opt/raintank/* code while inside a container will be visible in all other containers.
- attach to the screen session with 'screen -r raintank'.  To navigate between all of the screen windows press 'CTRL-a then "' (double quote).  This will provide the list of windows running, use the arrow keys to select the desired window then press enter.

You can now browse to your docker hosts public IP address and log into the raintank app.
