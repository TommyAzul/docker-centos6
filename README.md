# docker-centos6

docker settings for Windows 7+.


#### Which daemon services?

* Apache-2.2
* MySQL-5.6
* PHP-5.3
* PHP-5.4
* PHP-5.6
* Tomcat-7


#### About docker version

* [docker-toolbox-1.8.2](https://www.docker.com/toolbox)
  * docker
  * docker-machine
* [Oracle Virtualbox-5.0.4](https://www.virtualbox.org/)
* [docker-composer-1.4.1](https://docs.docker.com/compose/install/)

As you see, docker-compposer isn't supported Windows OS yet, so install in docker Tiny Linux.




## Installation

First, you need install [docker-toolbox](https://www.docker.com/toolbox) and make sure install docker, docker-machine, Windows Git and Oracle Virtualbox.

Default virtual machine installation path is at %HOMEPATH%, but I need install Virtualbox image and docker machine at "D:\VM\centos\machine". You can skip this if you don't need change the path.

Now, open cmd command line and type this.

    set MACHINE_STORAGE_PATH=D:\VM\centos\machine


#### 1. Create Virtual Machine

You need replace the below ipaddress if it doesn't same.

Open Virtualbox Manager and look at "File > Preferences > Network > Host-only Networks > VirtualBox Host-Only Ethernet Adapter > IPv4 Address".

    docker-machine create -d virtualbox --virtualbox-cpu-count "2" --virtualbox-memory "2048" --virtualbox-hostonly-cidr "192.168.56.1/24" centos6
    docker-machine ls


#### 2. Start Virtual Machine

    docker-machine start centos6

And type this command and setup virtual machine connection from windows.

    docker-machine env centos6 --shell cmd

Then you see copy and paset message on your cmd. For example:

    set DOCKER_TLS_VERIFY=1
    set DOCKER_HOST=tcp://192.168.56.101:2376
    set DOCKER_CERT_PATH=D:\VM\centos\machine\machines\centos6
    set DOCKER_MACHINE_NAME=centos6


#### 3. Login Virtual Machine (Tiny Linux)

    docker-machine ssh centos6


#### 4. Install docker-compose

    sudo curl -L -o /var/lib/boot2docker/docker-compose https://github.com/docker/compose/releases/download/1.4.1/docker-compose-Linux-x86_64
    sudo chmod 755 /var/lib/boot2docker/docker-compose
    cat << EOL | sudo tee /var/lib/boot2docker/bootlocal.sh
    #!/bin/sh
    
    if [ -x /var/lib/boot2docker/docker-compose -a ! -e /usr/local/bin/docker-compose ]; then
        ln -s /var/lib/boot2docker/docker-compose /usr/local/bin/docker-compose
    fi
    
    EOL
    sudo chmod 755 /var/lib/boot2docker/bootlocal.sh
    sudo ln -s /var/lib/boot2docker/docker-compose /usr/local/bin/docker-compose
    
    docker-compose --version




## Settings

To Share configs and my project files host and docker container, you need to create shared folders on Virtualbox, first. And secondly, mount on virtual machine Tiny Linux with owner and permission. Finally, you can mount on docker container when you start docker.

    Windows <--> Tiny Linux <--> Docker Container


#### 1. VirtualBox share setting

Open cmd command line, type the follow lines.

    docker-machine stop centos6
    
    cd %VBOX_MSI_INSTALL_PATH%

    # for apache user and 644 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6\apache"     --name "apache"     --automount

    # for apache user and 755 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6\apache-bin" --name "apache-bin" --automount

    # for mysql user and 644 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6\mysql"      --name "mysql"      --automount

    # for root user and 644 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6\root"       --name "root"       --automount

    # for root user and 755 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6\root-bin"   --name "root-bin"   --automount

    # for tomcat user and 644 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6\tomcat"     --name "tomcat"     --automount

    # for docker user and 644 permission
    VBoxManage sharedfolder add centos6 --hostpath "D:\VM\centos\6.6"            --name "centos6"    --automount

    # to enable create symbolic link in docker container
    VBoxManage setextradata centos6 VBoxInternal2/SharedFoldersEnableSymlinksCreate/apache 1
    VBoxManage setextradata centos6 VBoxInternal2/SharedFoldersEnableSymlinksCreate/apache-bin 1
    VBoxManage setextradata centos6 VBoxInternal2/SharedFoldersEnableSymlinksCreate/mysql 1
    VBoxManage setextradata centos6 VBoxInternal2/SharedFoldersEnableSymlinksCreate/root 1
    VBoxManage setextradata centos6 VBoxInternal2/SharedFoldersEnableSymlinksCreate/root-bin 1
    VBoxManage setextradata centos6 VBoxInternal2/SharedFoldersEnableSymlinksCreate/tomcat 1

    VBoxManage getextradata centos6 enumerate


#### 2. Mount on Tiny Linux

Now, start virtual machine and longin Tiny Linux.

    docker-machine start centos6
    docker-machine ssh centos6

Once you did the follow lines, it will mount on Tiny Linux automatically next time.

    cat << EOL | sudo tee /var/lib/boot2docker/bootsync.sh
    #!/bin/sh
    
    [ -d /mnt/mysql ] || sudo mkdir -p /mnt/mysql
    sudo mount -t vboxsf -o defaults,uid=27,gid=27,dmode=755,fmode=644 "mysql" /mnt/mysql
    
    [ -d /mnt/apache ] || sudo mkdir -p /mnt/apache
    sudo mount -t vboxsf -o defaults,uid=48,gid=48,dmode=755,fmode=644 "apache" /mnt/apache
    
    [ -d /mnt/root ] || sudo mkdir -p /mnt/root
    sudo mount -t vboxsf -o defaults,uid=0,gid=0,dmode=755,fmode=644 "root" /mnt/root
    
    [ -d /mnt/tomcat ] || sudo mkdir -p /mnt/tomcat
    sudo mount -t vboxsf -o defaults,uid=91,gid=91,dmode=755,fmode=644 "tomcat" /mnt/tomcat
    
    [ -d /mnt/centos6 ] || sudo mkdir -p /mnt/centos6
    sudo mount -t vboxsf -o defaults,uid=1000,gid=50,dmode=755,fmode=644 "centos6" /mnt/centos6
    
    [ -d /mnt/root-bin ] || sudo mkdir -p /mnt/root-bin
    sudo mount -t vboxsf -o defaults,uid=0,gid=0,dmode=755,fmode=755 "root-bin" /mnt/root-bin
    
    [ -d /mnt/apache-bin ] || sudo mkdir -p /mnt/apache-bin
    sudo mount -t vboxsf -o defaults,uid=48,gid=48,dmode=755,fmode=755 "apache-bin" /mnt/apache-bin
    
    EOL
    sudo chmod 755 /var/lib/boot2docker/bootsync.sh
    sudo /var/lib/boot2docker/bootsync.sh




## Setup Docker


#### 1. Create base image

First, create docker base docker image, you can adjust RPM packages from "Dockerfile". Docker build document is [here](https://docs.docker.com/reference/commandline/build/).

    # the path placed docker-compose.yml
    cd /mnt/centos6
    
    cp -f build/* .
    docker build -t centos6/dev:1.0 .
    


#### 2. Create LAMP image (PHP 5.3)

    docker-compose -p centos6 -f docker-compose-apache22-php53.yml up -d
    docker-compose -p centos6 -f docker-compose-apache22-php53.yml stop
    docker-compose -p centos6 -f docker-compose-apache22-php53.yml rm

Or

    docker-compose -p centos6 -f docker-compose-apache22-php53.yml build mysql56
    docker-compose -p centos6 -f docker-compose-apache22-php53.yml build php53

Docker basic commands here. Check created docker images.

    # To check image.
    docker images
    
    # To check running container.
    docker ps -a
    
    # To stop running containers.
    docker stop mysql56 php53
    
    # To delete containers.
    docker rm mysql56 php53


#### 3. Create LAMP image (PHP 5.4)

    docker-compose -p centos6 -f docker-compose-apache22-php54.yml build php54


#### 4. Create LAMP image (PHP 5.6)

    docker-compose -p centos6 -f docker-compose-apache22-php56.yml build php56


#### 5. Create Tomcat 7 image

    docker-compose -p centos6 -f docker-compose-tomcat7-jdk7.yml build tomcat7


#### 6. Check created images

    docker images

Images are as like these.

    REPOSITORY          TAG
    centos6_tomcat7     latest
    centos6_php56       latest
    centos6_php54       latest
    centos6_php53       latest
    centos6_mysql56     latest
    centos6/dev         1.0
    centos              6


#### 7. Start docker

Cleanup docker build files.

    cd /mnt/centos6
    rm -f docker-compose-* Dockerfile Dockerfile-* config_db.sh

And start LAMP (Apache-2.2, MySQL-5.6 PHP-5.6) server.

    cp -f build/docker-compose-apache22-php56.yml ./docker-compose.yml
    docker-compose up -d
    docker ps -a


#### 8. Login docker container

Before start container, you need run VirtualBox as Administrator or otherwise you can not create symbolic link at mounted shared folders in docker container.

    exit (or Ctrl+d)
    docker-machine stop centos6

Open cmd command line as Administrator.

    docker-machine start centos6
    docker-machine ssh centos6
    
    docker exec -it php56 bash




## How to start docker container after setup docker and startup windows.

Open cmd command line as Administrator.

    set MACHINE_STORAGE_PATH=D:\VM\centos\machine
    docker-machine start centos6
    docker-machine env centos6 --shell cmd
    
    ## copy and paste env
    
    docker-machine ssh centos6

In the Tiny Linux command prompt.

    cd /mnt/centos6
    docker-compose up -d
    docker ps -a

If you need login to docker container,

    docker exec -it php56 bash
    # Or
    docker exec -it mysql56 bash




## docker, docker-compose commands help


#### check container

    docker-compose ps
    docker ps
    docker ps -a


#### check logs

    docker-compose logs
    docker-compose logs ContainerId,,,
    docker logs ContainerId,,,


#### check build history

    docker-compose history Repository:Tag


#### stop container

    docker-compose stop
    docker-compose stop ContainerId,,,
    docker stop ContainerId,,,


#### delete container

    docker-compose rm
    docker-compose rm ContainerId,,,
    docker rm ContainerId,,,


#### create and start container

    cd BuildDir(the path placed docker-compose.yml)
    docker-compose up -d
    docker-compose -p ProjectName up -d
    docker-compose -p ProjectName up -d ContainerName
    docker-compose -p ProjectName -f DockerComposeYamlfileName up -d


#### login to container

    docker exec -it ContainerName bash
    docker attach ContainerName


#### rebuild container when you change docker-compose.yml

    docker-compose build --no-cache
    docker-compose -p ProjectName build ServiceName
    docker-compose -p ProjectName -f docker-compose-file-name.yml build ServiceName --no-cache
    docker build -t Repository:Tag .


#### custom docker image

    docker pull centos:6

    cd /mnt/centos6
    docker build -t centos6/dev:1.0 .
    docker images

    docker run -d -it -p LocalPort:ExternalPort --hostname HostName --name ContainerName centos:6 /bin/bash
    docker run -d -it --name ContainerName centos:6 /bin/bash


#### start container from image

    docker run -d -it -p 80:80 -p 443:443 --name php dev:1.0
    docker run -d -it --hostname dev.localhost -p 80:80 -p 443:443 -v /path/to/host:/path/to/container --name php54 dev:php54
    docker ps -a


#### create custom image from container

    docker commit -m "test1" ContainerId contos6/dev:1.0


#### import, export docker

Nolonger available to startup with "docker-compose up -d" if it's exported from container into a file.

    docker export ContainerId > /path/to/host/ExportFileName.tar
    cat /path/to/host/exportFileName.tar | docker import - DockerImageName(Repository:Tag, ie centos6_php54:latest)

If you need use docker-compose, it's better to export from "docker save DOCKER_IMAGE".

    docker save Repository:Tag > /path/to/host/ExportFileName.tar
    cat /path/to/host/exportFileName.tar | docker import - DockerImageName(Repository:Tag, ie centos6_php54:latest)

