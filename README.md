# Agent System Assignment / エージェントシステム課題 (2017)

## 課題 (Assignment)
詳細は、工学部2号館 3階 機械事務室前に掲示

### 課題説明
https://github.com/YoheiKakiuchi/robotsimulation-docker/wiki/files/agent_system_2017_assignment.pdf

# Install docker

### Install docker
https://docs.docker.com/engine/installation/linux/ubuntu/

~~~
$ sudo apt-get update

$ sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

$ sudo apt-key fingerprint 0EBFCD88

$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

$ sudo apt-get update

$ sudo apt-get install docker-ce

$ sudo gpasswd -a $USER docker
~~~

### not needed but ...
~~~
$ sudo reboot
~~~

### docker test
~~~
$ docker run hello-world
~~~

# Install nvidia docker
https://github.com/NVIDIA/nvidia-docker

## Reference for using ROS
- http://wiki.ros.org/docker/Tutorials/Docker
- http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration
- http://wiki.ros.org/docker/Tutorials/GUI

### Install nvidia-docker and nvidia-docker-plugin
~~~
$ sudo apt-get install nvidia-modprobe
$ wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
$ sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
$ sudo gpasswd -a $USER nvidia-docker
$ sudo reboot
~~~

### not needed but ...
~~~
$ sudo reboot
~~~

### test nvida-docker using nvidia-smi
~~~
$ nvidia-docker run --name=nvtest nvidia/cuda nvidia-smi
$ nvidia-docker rm nvtest
~~~

### uninstall nvidia-docker
~~~
$ docker volume prune
$ docker rmi nvidia/cuda
$ docker rmi $(docker images | grep '<none>' | awk '{print$3}')
$ docker rm $(docker ps -aq)
$ sudo apt-get purge nvidia-modprobe
$ sudo apt-get purge nvidia-docker
$ sudo groupdel nvidia-docker
$ sudo rm -rf /var/lib/nvidia-docker
$ sudo reboot
~~~

# Using choreonoid
### Clone repository
~~~
git clone https://github.com/YoheiKakiuchi/robotsimulation-docker.git
~~~

### Downlowd image
~~~
docker pull yoheikakiuchi/choreonoidsim
~~~

### Run simulation (choreonoid)
~~~
$ cd robotsimulation-docker/choreonoid_docker
$ ./run.sh
## this equals to './run.sh rtmlaunch hrpsys_choreonoid_tutorials jaxon_jvrc_choreonoid.launch'
~~~

### Advanced: Building the image by yourself
~~~
$ git clone https://github.com/YoheiKakiuchi/robotsimulation-docker.git ## this repository
$ cd robotsimulation-docker/choreonoid_docker
$ ./build.sh
~~~

