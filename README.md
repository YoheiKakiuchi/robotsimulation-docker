# install docker_test

## install docker and nvidia-docker

install docker and install nvidia-docker (described later in this document)

reference
- http://wiki.ros.org/docker/Tutorials/Docker
- http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration
- http://wiki.ros.org/docker/Tutorials/GUI

## building choreonoid
~~~
$ git clone https://github.com/YoheiKakiuchi/docker_tests.git
$ cd docker_tests/choreonoid_docker
$ ./build.sh
~~~

## run choreonoid
~~~
$ xhost +local:root ### warning it is not safe, you can revert by `xhost -local:root` after using choreonoid
$ ./run.sh
~~~

## install docker
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

## nvidia docker
https://github.com/NVIDIA/nvidia-docker

### Install nvidia-docker and nvidia-docker-plugin
~~~
$ wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
$ sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb
$ sudo gpasswd -a $USER nvidia-docker
~~~

### not needed but ...
~~~
$ sudo reboot
~~~

### Test nvida-docker using nvidia-smi
~~~
$ nvidia-docker run --rm nvidia/cuda nvidia-smi
~~~
