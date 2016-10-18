raintank-docker screen based dev environment
============================================

This stack runs a development stack, using every component used at raintank
(minus [Grafana.net](http://grafana.net)),
that is:

* [Grafana](http://grafana.org) (of course) at http://localhost:3000
* [WorldPing](https://grafana.net/plugins/raintank-worldping-app)
* the backend: [metrictank](https://github.com/raintank/metrictank), eventtank, Kafka, rabbitmq, graphite-api, Cassandra, ElasticSearch, Mysql, taskAgent, taskServer, tsdbgw, [carbon-relay-ng](https://github.com/graphite-ng/carbon-relay-ng)
* monitoring and utiltities: collectd, graphite, statsdaemon, graphitewatcher, benchmark/load test tools, kafkamanager and kafkaoffsetmonitor.

This is a whole lot of stuff because this stack covers every possible flavour of deployment plus extra tools which may be useful, but often not.  
In practice you'll probably only use a fraction and that's OK.
In the future we may create different scripts to launch different, more minimal versions of the stack. But for now, this approach works well enough.

To provision a full dev stack using docker
===========================================

- [install docker](https://docs.docker.com/installation/#installation)
- [install docker-compose](http://docs.docker.com/compose/install/) - We require >= 1.7
- clone this git repo.
- cd in the dir and run `./build_all.sh`.  This will build all of the needed raintank images.  
  Some of the images such as metrictank are built automatically via with github commit hooks and will be pulled in automatically via [dockerhub](https://hub.docker.com/u/raintank/).
- you can run `./build_all.sh rebuild` to force a rebuild of the images (but keeping base images such as ubuntu etc)
- you can use custom versions of required code by going into `code`, removing a dir like grafana and making a symlink like `ln -s </path/to/your-code-dir> .`
  In this case, make sure to add a `.notouch` file so that `setup_dev.sh` doesn't try to manage the code there.
- run `./setup_dev.sh` to download all of the components.  The script will launch a docker container and clone the git repositories of all of the needed components.  Once the script has completed, the docker host server will have a `code` directory that will have all of the required code and dependencies installed.
- run `./launch_dev.sh` to start up all of the docker containers.  This script will start the containers and corresponding screen sessions.  Instead of using the code baked into the image, the container will instead execute what is installed in `code` on the docker host.  As all containers are sharing the same /opt/raintank directory, any changes made to the /opt/raintank/* code while inside a container will be visible in all other containers.

for your convenience, this code may be all you need (tested on ubuntu 14.04) to get the stack up.

```
curl -sSL https://get.docker.com/ubuntu/ | sudo sh
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

git clone git@github.com:raintank/raintank-docker.git
cd raintank-docker
./build_all.sh
./setup_dev.sh
./launch_dev.sh
```

- You can log into Grafana at http://localhost:3000/.  The default user is 'admin' and the default password is 'admin'
- enable the worldping app through the grafana menu, under 'Plugins' and then 'Apps' tab, using key `changeme`. This imports the dashboards, sets up the metrictank datasource, and activates a worldping plugin which you can play with.  But often all we use it for is the side-effect of having the `raintank` datasource be created, which queries metrictank (through graphite-api).  So if you want to store data in metrictank and visualize it, just enable WorldPing to have the datasource.
- logs will be in the `logs` directory.
- You can attach to the screen session with 'screen -r raintank'.  To navigate between all of the screen windows press 'CTRL-a then "' (double quote).  This will provide the list of windows running, use the arrow keys to select the desired window then press enter.
- to shut the stack down again, run `./stop_dev.sh`

When stuff goes wrong
=====================

* If you get errors like `Unsupported config option for services service: 'graphiteMetrictank'` then your docker-compose is too old. Make sure you have >= 1.7
* If you get vague i/o errors make sure you have enough diskspace, check the log of the docker daemon, and try upgrading docker.
* You can see running containers with `docker ps`.  It's important that no containers are running when you run launch_dev.sh, using stop_dev.sh should achieve this.
* If `./launch_dev.sh` keeps on emitting the following messages without end:
```
waiting for all xx containers to run...
waiting for all xx containers to run...
(...)
```

Then run `docker ps -a` to identify which containers failed.  You will see something like:
```
(...)
960f23654203      raintank/eventtank        "/start.sh -config /e"   About a minute ago   Up About a minute           0.0.0.0:6062->6060/tcp    raintank_eventtank_1
feb682f3a24a      raintank/metrictank       "/usr/bin/metrictank_"   About a minute ago   Exited (1) 54 seconds ago                             raintank_metrictank_1
386a2ee9fbe2      raintank/task-server      "/start.sh --config /"   About a minute ago   Up About a minute           0.0.0.0:8082->80/tcp      raintank_taskServer_1
(...)
```
Look for all the containers which exited, in the first column you can see their container id's.  (note, this listing may also include old containers which have exited hours or days ago, which are not relevant.  Be sure to start at the top and work your way down and look at the status column to see what's relevant.

Then, for the containers that failed, run `docker logs <container-id from first column>` this should help explain what failed.  If it doesn't, please post the output of this command as well as `docker ps -a` in a github issue.


Switching branches
==================
in a new raintank-docker branch, you can just run `/build_all.sh`, which updates the "latest" images.
If your latest images have been overridden by being in a different branch, `./restore_branch_images.sh` will sync up the latest tags to the images you last generated on this branch.


