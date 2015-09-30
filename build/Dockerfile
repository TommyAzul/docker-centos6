# Dockerfile
FROM centos:6
MAINTAINER Tom Aoki <tomyaoki@gmail.com>


##
## local date change UTC to JST
##
RUN echo -e 'ZONE="Asia/Tokyo"\nUTC="false"\n' > /etc/sysconfig/clock
RUN cp -p /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN yum -y update
RUN echo 'export TERM=xterm' >> /root/.bashrc


RUN yum -y install yum-plugin-priorities

## epel
RUN rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

## remi
RUN rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

## rpmforge
RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt
RUN rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

## common RPM
RUN yum --enablerepo=rpmforge -y install sudo man man-pages vim passwd mlocate tar zip unzip p7zip bind-utils nkf util-linux-ng wget rsyslog stow openssh-clients patch git git-svn svn git-all lshw hdparm dmidecode tree ImageMagick
RUN yum reinstall --downloadonly -y man-pages
RUN rpm -Uvh --force /var/cache/yum/x86_64/6/base/packages/man-pages-*

RUN yum clean all

## stow base directory
RUN mkdir /usr/local/stow


