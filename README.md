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
