# エージェントシステム課題・講義資料

課題は 「Choreonoidの振り付けする」　もしくは　「Dockerでシミュレーションを動かす」のいずれかを提出してください

https://github.com/YoheiKakiuchi/robotsimulation-docker/blob/master/%E3%82%A8%E3%83%BC%E3%82%B8%E3%82%A7%E3%83%B3%E3%83%88%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A020190424_docker.pdf

# MainComponents

https://github.com/YoheiKakiuchi/robotsimulation-docker/tree/master/choreonoid_docker

# Install docker

## Install docker
https://docs.docker.com/install/linux/docker-ce/ubuntu/

~~~
$ sudo apt-get update

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

$ sudo apt-get install docker-ce docker-ce-cli containerd.io

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


## Install nvidia-docker
For using nvidia graphic card for OpenGL and GPU

https://github.com/NVIDIA/nvidia-docker

~~~
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda:9.0-base nvidia-smi
~~~


